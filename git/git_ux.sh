#!/usr/bin/env bash
# git-ux.sh — 깔끔한 Git Graph 유지를 위한 원라이너 유틸
# 사용법: ./git-ux.sh <cmd> [옵션...]
# 필수 도구: git, (권장) fzf, (옵션) delta, diff-so-fancy, bat, diffnav 등
# 안전장치: 대부분 --ff-only, --autostash, --rebase 등 무손실/정돈 옵션 우선

set -euo pipefail

CMD="${1:-help}"
shift || true

# 공통 메시지/옵션 (함수 대신 변수만 사용)
FZF=${FZF:-fzf}
PAGER=${PAGER:-less -R}
GIT_GRAPH="--graph --decorate --pretty=format:'%C(yellow)%h%Creset %Cgreen%ad%Creset %C(auto)%d%Creset %s %C(blue)<%an>%Creset' --date=short --abbrev-commit"

if ! command -v git >/dev/null 2>&1; then
  echo "git not found"
  exit 1
fi

case "$CMD" in
help | -h | --help)
  cat <<'USAGE'
git-ux.sh — subcommands (30+)

  GRAPH & CLEAN
  1) lg                  : 현재 브랜치 로그 그래프(간결)
  2) lg-all              : 전체 브랜치 로그 그래프
  3) graph-churn         : 최근 변경 파일 상위 20개
  4) clean-merged        : 현재 브랜치에 머지된 로컬 브랜치 안전 삭제
  5) prune-remote        : 원격 추적 브랜치/리모트 깨끗이 정리

  FETCH/PULL/PUSH
  6) fetch-all           : 모든 리모트 fetch --prune
  7) pull-rebase         : 현재 브랜치 안전 풀(리베이스, 자동스태시)
  8) push-safe           : 현재 브랜치 push --force-with-lease 방지용 기본
  9) set-upstream        : 현재 브랜치를 origin에 최초 push + upstream 설정
 10) push-lease          : 안전 강제 갱신(push --force-with-lease)

  RESET / REVERT
 11) reset-soft          : 커밋 소프트 리셋(기본 HEAD~1 또는 인자 지정)
 12) reset-mixed         : 믹스트 리셋(스테이징 해제)
 13) reset-hard-pick     : fzf로 커밋 선택해 하드 리셋(주의)
 14) revert-range        : fzf로 커밋 범위 선택해 되돌리기
 15) reflog-browse       : 리플로그 확인 후 특정 상태로 체크아웃

  STASH
 16) stash-wip           : WIP 스태시(메시지 자동)
 17) stash-pick-pop      : fzf로 스태시 골라 pop
 18) stash-keep          : 스태시 저장하되 워킹디렉 유지(-k)
 19) stash-diff          : 스태시 항목과의 diff 탐색

  REBASE / FIXUP / ONTO
 20) rebase-onto-pick    : fzf로 기준/대상 선택해 rebase --onto
 21) rebase-autosquash   : fixup!/squash! 자동 정리(rebase -i --autosquash)
 22) reword-last         : 마지막 커밋 메시지만 수정(amend --only)

  SQUASH MERGE
 23) squash-merge        : 선택한 브랜치를 현재에 --squash 머지(히스토리 깔끔)
 24) squash-last-n       : 마지막 N개 커밋을 하나로 압축(amend 체인)

  WORKTREE
 25) wt-add              : 새 작업트리 추가(fzf로 브랜치/경로 지정)
 26) wt-prune            : 존재하지 않는 작업트리 정리(prune)
 27) wt-list             : 작업트리 목록

  CHERRY-PICK / SPLIT
 28) pick-range          : 두 커밋 선택해 범위 체리픽(앞/뒤 자동 정렬)
 29) split-last          : 마지막 커밋을 단계적으로 쪼개기(reset --soft)

  DIFF & BLAME
 30) diff-pick2          : (참고 예시) 두 브랜치 선택해 diff 후 diffnav로 탐색
 31) blame-pick-file     : 파일 선택→ 라인 단위 블레임 탐색(인터랙티브)

  RESTORE / CHECKOUT
 32) restore-from        : 다른 브랜치/커밋에서 파일 복구(파일 선택)
 33) switch-pick         : 브랜치 선택해 전환

  TAG / RELEASE
 34) tag-annotate        : 주석 태그 생성/푸시
 35) move-tag            : 태그 위치 이동(로컬+원격 덮어쓰기)

  MISC
 36) author-fix          : 최근 커밋의 author/committer 정보 수정
 37) bisect-run          : fzf로 good/bad 지정 후 자동 bisect 런
 38) gc-vacuum           : 저장소 청소(git gc) + 원격 프루닝
 39) untracked-clean     : 추적 안 되는 파일 깔끔히 정리(주의)

예: ./git-ux.sh squash-merge
USAGE
  ;;

# -------------------------
# GRAPH & CLEAN
# -------------------------
lg)
  # 1) 간결한 그래프 로그
  #   - 네비게이션에 용이, 그래프 정돈 상태 점검
  git log $GIT_GRAPH -n 50 | ${PAGER}
  ;;

lg-all)
  # 2) 전체 브랜치 그래프
  git log --all $GIT_GRAPH | ${PAGER}
  ;;

graph-churn)
  # 3) 최근 변경 파일 상위 20 — 리팩터링/스플릿 후보 파악
  git log --since="3 months ago" --name-only --pretty=format: |
    grep -v '^\s*$' | sort | uniq -c | sort -rn | head -20 | ${PAGER}
  ;;

clean-merged)
  # 4) 현재 브랜치에 완전히 머지된 로컬 브랜치 안전 삭제
  #   - main/master/current 에 합쳐진 브랜치만 지움
  BASE=$(git symbolic-ref --short HEAD)
  git branch --merged "$BASE" | grep -vE "^\*|^($BASE|main|master|develop)$" | xargs -r git branch -d
  ;;

prune-remote)
  # 5) 원격 추적 브랜치 정리 + 리모트 프루닝
  git fetch --all --prune
  git remote prune origin || true
  ;;

# -------------------------
# FETCH/PULL/PUSH
# -------------------------
fetch-all)
  # 6) 모든 리모트 fetch --prune
  git fetch --all --prune
  ;;

pull-rebase)
  # 7) 안전 풀: rebase + autostash + ff-only
  git pull --rebase --autostash --ff-only
  ;;

push-safe)
  # 8) 기본 push (업스트림 있으면 --force-with-lease 방지)
  git push --porcelain
  ;;

set-upstream)
  # 9) 최초 push + upstream 설정
  BR=$(git symbolic-ref --short HEAD)
  git push -u origin "$BR"
  ;;

push-lease)
  # 10) 안전 강제 갱신: force-with-lease (상대 변경 보호)
  BR=$(git symbolic-ref --short HEAD)
  git push --force-with-lease origin "$BR"
  ;;

# -------------------------
# RESET / REVERT
# -------------------------
reset-soft)
  # 11) 소프트 리셋(HEAD만 이동, 워킹/인덱스 유지)
  # 사용: ./git-ux.sh reset-soft [<target>]; 기본은 HEAD~1
  git reset --soft "${1:-HEAD~1}"
  ;;

reset-mixed)
  # 12) 믹스트 리셋(인덱스 해제, 워킹 유지)
  git reset --mixed "${1:-HEAD~1}"
  ;;

reset-hard-pick)
  # 13) fzf로 커밋 선택 → 하드 리셋 (주의!)
  if command -v "$FZF" >/dev/null; then
    TARGET=$(git log --oneline | $FZF --prompt='reset --hard to > ' | awk '{print $1}')
    [ -n "${TARGET:-}" ] && git reset --hard "$TARGET"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

revert-range)
  # 14) 커밋 범위 되돌리기 (두 개 선택 → 앞뒤 정렬 후 revert -n)
  if command -v "$FZF" >/dev/null; then
    SEL=$(git log --oneline | $FZF -m --height=60% --prompt='pick 2 (old..new) > ')
    A=$(echo "$SEL" | tail -n1 | awk '{print $1}')
    B=$(echo "$SEL" | head -n1 | awk '{print $1}')
    [ -n "${A:-}" ] && [ -n "${B:-}" ] && git revert -n "${B}..${A}"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

reflog-browse)
  # 15) reflog에서 상태 선택 → 체크아웃
  if command -v "$FZF" >/dev/null; then
    T=$(git reflog --date=local | $FZF --prompt='reflog checkout > ' | awk '{print $1}')
    [ -n "${T:-}" ] && git checkout "$T"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

# -------------------------
# STASH
# -------------------------
stash-wip)
  # 16) 빠른 WIP 스태시
  git stash push -u -m "WIP $(date +%F_%T)"
  ;;

stash-pick-pop)
  # 17) 스태시 고르고 pop
  if command -v "$FZF" >/dev/null; then
    S=$(git stash list | $FZF --prompt='stash pop > ' | cut -d: -f1)
    [ -n "${S:-}" ] && git stash pop "$S"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

stash-keep)
  # 18) 워킹 보존(-k) 스태시
  git stash push -k -m "KEEP $(date +%F_%T)"
  ;;

stash-diff)
  # 19) 스태시와의 차이 비교
  if command -v "$FZF" >/dev/null; then
    S=$(git stash list | $FZF --prompt='stash diff > ' | cut -d: -f1)
    [ -n "${S:-}" ] && git stash show -p "$S" | ${PAGER}
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

# -------------------------
# REBASE / FIXUP / ONTO
# -------------------------
rebase-onto-pick)
  # 20) rebase --onto: (newbase, upstream, topic) 순서 선택
  #   - 그래프 재정렬에 핵심. 혼잡한 분기 라인 깔끔화
  if command -v "$FZF" >/dev/null; then
    echo "[1/3] pick new base"
    NB=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | $FZF --prompt='new base > ')
    echo "[2/3] pick upstream (stop point)"
    UP=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | $FZF --prompt='upstream > ')
    echo "[3/3] pick topic branch to move"
    TP=$(git for-each-ref --format='%(refname:short)' refs/heads | sort -u | $FZF --prompt='topic > ')
    [ -n "${NB:-}" ] && [ -n "${UP:-}" ] && [ -n "${TP:-}" ] && git rebase --onto "$NB" "$UP" "$TP"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

rebase-autosquash)
  # 21) fixup!/squash! 자동 정리
  git rebase -i --rebase-merges --autosquash "${1:-HEAD~20}"
  ;;

reword-last)
  # 22) 마지막 커밋 메시지만 수정(내용은 그대로)
  git commit --amend --only --no-edit -m "${*:-"fix: reword last commit"}"
  ;;

# -------------------------
# SQUASH MERGE
# -------------------------
squash-merge)
  # 23) 선택한 브랜치를 현재 브랜치에 --squash 머지 후 단일 커밋
  if command -v "$FZF" >/dev/null; then
    BR=$(git for-each-ref --format='%(refname:short)' refs/heads | sort -u | $FZF --prompt='squash from > ')
    [ -z "${BR:-}" ] && exit 0
    git merge --squash "$BR"
    git commit -m "squash: merge ${BR} into $(git rev-parse --abbrev-ref HEAD)"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

squash-last-n)
  # 24) 마지막 N개 커밋을 하나로 압축
  N="${1:-3}"
  git reset --soft "HEAD~${N}"
  git commit -m "squash: compress last ${N} commits"
  ;;

# -------------------------
# WORKTREE
# -------------------------
wt-add)
  # 25) 작업트리 추가: 브랜치/경로 선택
  if command -v "$FZF" >/dev/null; then
    BR=$(git for-each-ref --format='%(refname:short)' refs/heads | sort -u | $FZF --prompt='worktree branch > ')
    [ -z "${BR:-}" ] && exit 0
    DIR="${1:-./wt-${BR}}"
    git worktree add "$DIR" "$BR"
    echo "added worktree: $DIR"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

wt-prune)
  # 26) 작업트리 정리
  git worktree prune
  ;;

wt-list)
  # 27) 작업트리 목록
  git worktree list
  ;;

# -------------------------
# CHERRY-PICK / SPLIT
# -------------------------
pick-range)
  # 28) 두 커밋 선택 → 범위 체리픽(오래된→최신 정렬)
  if command -v "$FZF" >/dev/null; then
    SEL=$(git log --oneline | $FZF -m --height=60% --prompt='pick 2 (old..new) > ')
    A=$(echo "$SEL" | tail -n1 | awk '{print $1}')
    B=$(echo "$SEL" | head -n1 | awk '{print $1}')
    [ -n "${A:-}" ] && [ -n "${B:-}" ] && git cherry-pick "${B}..${A}"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

split-last)
  # 29) 마지막 커밋을 쪼개기(소프트 리셋 후 파일 단위 add/commit)
  git reset --soft HEAD~1
  echo "Now stage chunks/files separately, then commit in pieces."
  ;;

# -------------------------
# DIFF & BLAME
# -------------------------
diff-pick2)
  # 30) (요청 예시 참고) 두 브랜치/헤드를 골라 diff → diffnav로 탐색
  if command -v "$FZF" >/dev/null; then
    REFSEL=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u |
      $FZF -m --height=60% --reverse --prompt='Pick 2 > ')
    A=$(echo "$REFSEL" | head -n1)
    B=$(echo "$REFSEL" | tail -n1)
    [ -n "${A:-}" ] && [ -n "${B:-}" ] && git diff "$A" "$B" | diffnav
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

blame-pick-file)
  # 31) 파일 선택 → blame(라인 히스토리 탐색)
  if command -v "$FZF" >/dev/null; then
    FILE=$(git ls-files | $FZF --prompt='blame file > ')
    [ -n "${FILE:-}" ] && git blame -w -C -C --date=short "$FILE" | ${PAGER}
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

# -------------------------
# RESTORE / CHECKOUT
# -------------------------
restore-from)
  # 32) 다른 브랜치/커밋에서 파일 복구 (브랜치/파일 모두 선택)
  if command -v "$FZF" >/dev/null; then
    SRC=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | $FZF --prompt='from ref > ')
    FILE=$(git ls-tree -r --name-only "$SRC" | $FZF --prompt='pick file > ')
    [ -n "${SRC:-}" ] && [ -n "${FILE:-}" ] && git checkout "$SRC" -- "$FILE"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

switch-pick)
  # 33) 브랜치 선택 전환
  if command -v "$FZF" >/dev/null; then
    BR=$(git for-each-ref --format='%(refname:short)' refs/heads | sort -u | $FZF --prompt='switch > ')
    [ -n "${BR:-}" ] && git switch "$BR"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

# -------------------------
# TAG / RELEASE
# -------------------------
tag-annotate)
  # 34) 주석 태그 생성 후 push
  TAG="${1:-v$(date +%Y.%m.%d)}"
  MSG="${2:-Release ${TAG}}"
  git tag -a "$TAG" -m "$MSG"
  git push origin "$TAG"
  ;;

move-tag)
  # 35) 태그 이동(로컬+원격 업데이트) — 실수 정정용
  TAG="${1:?usage: move-tag <tag> [<target=HEAD>]}"
  TARGET="${2:-HEAD}"
  git tag -f "$TAG" "$TARGET"
  git push -f origin "refs/tags/$TAG"
  ;;

# -------------------------
# MISC
# -------------------------
author-fix)
  # 36) 최근 커밋의 author/committer 교정
  # 사용: ./git-ux.sh author-fix "New Name" "new@email"
  NAME="${1:?new name}"
  EMAIL="${2:?new email}"
  GIT_COMMITTER_NAME="$NAME" GIT_COMMITTER_EMAIL="$EMAIL" \
    GIT_AUTHOR_NAME="$NAME" GIT_AUTHOR_EMAIL="$EMAIL" \
    git commit --amend --no-edit --reset-author
  ;;

bisect-run)
  # 37) 바이섹트: bad/good 커밋 선택 후 테스트 스크립트 실행
  # 사용: ./git-ux.sh bisect-run ./test.sh
  TEST="${1:?provide test script}"
  if command -v "$FZF" >/dev/null; then
    BAD=$(git log --oneline | $FZF --prompt='pick BAD > ' | awk '{print $1}')
    GOOD=$(git log --oneline | $FZF --prompt='pick GOOD > ' | awk '{print $1}')
    git bisect start "$BAD" "$GOOD"
    git bisect run "$TEST" || true
    git bisect reset
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

gc-vacuum)
  # 38) 저장소 청소 + 원격 프루닝
  git gc --aggressive --prune=now
  git fetch --all --prune
  ;;

untracked-clean)
  # 39) 추적 안 되는 파일/디렉토리 청소(주의!)
  git clean -xfd
  ;;

*)
  echo "Unknown command: $CMD (help to list)"
  exit 1
  ;;

# -------------------------
# HUNK (부분 스테이징/폐기/적용)
# -------------------------
hunk-stage)
  # 40) 부분 스테이징: hunks를 골라 인덱스에 올림
  #   - 안전하게 작은 커밋을 만들기 위한 기본기
  git add -p
  ;;

hunk-unstage)
  # 41) 부분 언스테이징: 인덱스→워킹으로 되돌림(파일은 그대로)
  git reset -p
  ;;

hunk-discard)
  # 42) 부분 폐기: 워킹 디렉토리의 변경 일부를 폐기(주의!)
  #   - 되돌릴 수 없으니 커밋/스태시가 필요하면 먼저 하세요.
  git restore -p .
  ;;

hunk-file-pick)
  # 43) 파일 선택 후 각 파일에 대해 add -p
  if command -v "$FZF" >/dev/null; then
    git ls-files -m -o --exclude-standard | $FZF -m --prompt='add -p files > ' |
      xargs -r -I{} sh -c 'git add -p -- "{}"'
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

hunk-commit-partial)
  # 44) add -p → 메시지 받아 부분 커밋
  MSG="${*:-"partial: commit selected hunks"}"
  git add -p
  git commit -m "$MSG"
  ;;

hunk-show)
  # 45) 현재 변경의 hunk 단위 diff를 페이저로 탐색
  #   - delta/diff-so-fancy가 있으면 자동 컬러 하이라이트
  if command -v delta >/dev/null; then
    git diff | delta | ${PAGER}
  elif command -v diff-so-fancy >/dev/null; then
    git diff | diff-so-fancy | ${PAGER}
  else
    git diff | ${PAGER}
  fi
  ;;

hunk-apply-from)
  # 46) 다른 ref의 특정 파일에서 변경 패치를 추출해 현재 워킹에 적용
  #    예) ref와 파일을 fzf로 고른 뒤, 'git diff ref -- file | git apply -p0'
  if command -v "$FZF" >/dev/null; then
    SRC=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | $FZF --prompt='from ref > ')
    [ -z "${SRC:-}" ] && exit 0
    FILE=$(git ls-tree -r --name-only "$SRC" | $FZF --prompt='pick file > ')
    [ -z "${FILE:-}" ] && exit 0
    git diff "$SRC" -- "$FILE" | git apply -p0
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

hunk-copy-file)
  # 47) 다른 ref의 파일 전체를 현재 워킹으로 복구(부분 아님, 파일 단위 스냅샷)
  if command -v "$FZF" >/dev/null; then
    SRC=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | $FZF --prompt='from ref > ')
    [ -z "${SRC:-}" ] && exit 0
    FILE=$(git ls-tree -r --name-only "$SRC" | $FZF --prompt='pick file > ')
    [ -z "${FILE:-}" ] && exit 0
    git checkout "$SRC" -- "$FILE"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

hunk-split-file)
  # 48) 한 파일의 큰 변경을 여러 커밋으로 쪼개는 가이드
  #   - 파일별 스플릿: add -p 로 일부만 스테이징 → 커밋 → 반복
  echo "Tip:"
  echo "  1) git add -p <file>  # 일부만 스테이징"
  echo "  2) git commit -m 'part 1'"
  echo "  3) git add -p <file>  # 다음 hunk"
  echo "  4) git commit -m 'part 2' (반복)"
  ;;

# -------------------------
# SUBMODULE
# -------------------------
sm-init)
  # 49) .gitmodules 기준으로 submodule 초기화
  git submodule init
  ;;

sm-update)
  # 50) 서브모듈 업데이트(최초 클론 포함) 재귀적으로
  git submodule update --init --recursive
  ;;

sm-update-remote)
  # 51) 추적 브랜치를 따라 원격 최신 커밋으로 갱신
  git submodule update --init --remote --recursive
  ;;

sm-add)
  # 52) 서브모듈 추가: 사용법  sm-add <url> <path> [branch]
  URL="${1:?usage: sm-add <url> <path> [branch]}"
  PATH_SM="${2:?path}"
  BR="${3:-main}"
  git submodule add -b "$BR" "$URL" "$PATH_SM"
  git commit -m "chore(submodule): add ${PATH_SM} (${BR})"
  ;;

sm-set-branch)
  # 53) fzf로 모듈 선택 → 추적 브랜치 설정(.gitmodules) → sync
  if command -v "$FZF" >/dev/null; then
    # submodule.<name>.path 목록에서 선택
    NAMEPATH=$(git config -f .gitmodules --name-only --get-regexp path |
      while read -r n; do
        p=$(git config -f .gitmodules --get "$n")
        echo "$n $p"
      done |
      $FZF --prompt='pick submodule > ')
    [ -z "${NAMEPATH:-}" ] && exit 0
    NAME=$(echo "$NAMEPATH" | awk '{print $1}' | sed 's/\.path$//') # submodule.<name>
    PATH_SM=$(echo "$NAMEPATH" | awk '{print $2}')
    BR="${1:-main}"
    git config -f .gitmodules "${NAME}.branch" "$BR"
    git submodule sync --recursive
    echo "Set ${NAME}.branch=$BR for path=$PATH_SM"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;

sm-foreach-status)
  # 54) 각 서브모듈 상태 요약
  git submodule foreach 'echo "== $name =="; git status -sb; echo'
  ;;

sm-foreach-pull)
  # 55) 모든 서브모듈 최신화(fetch/pull rebase, 실패 무시)
  git submodule foreach 'git fetch --all --prune; git pull --rebase --autostash --ff-only || true'
  ;;

sm-foreach-branch)
  # 56) 모든 서브모듈을 지정 브랜치로 스위치
  #    사용: sm-foreach-branch <branch>
  BR="${1:?usage: sm-foreach-branch <branch>}"
  git submodule foreach "git switch ${BR} || git checkout -b ${BR}"
  ;;

sm-sync)
  # 57) .gitmodules와 로컬 설정 동기화
  git submodule sync --recursive
  ;;

sm-absorbgitdirs)
  # 58) 서브모듈 .git 디렉토리 흡수(저장소 구조 정리)
  git submodule absorbgitdirs --all
  ;;

sm-deinit)
  # 59) fzf로 선택한 서브모듈 완전 제거(주의: 워킹트리/인덱스/설정 반영)
  #    - git submodule deinit -f <path> && rm -rf <path> && git rm -f <path>
  if command -v "$FZF" >/dev/null; then
    PICK=$(git config -f .gitmodules --get-regexp path 2>/dev/null | awk '{print $2}' |
      $FZF -m --prompt='deinit paths > ')
    [ -z "${PICK:-}" ] && exit 0
    echo "$PICK" | while read -r P; do
      git submodule deinit -f "$P" || true
      rm -rf "$P"
      git rm -f "$P" || true
    done
    git commit -m "chore(submodule): deinit/remove selected modules"
  else
    echo "fzf not found"
    exit 1
  fi
  ;;
esac

# HUNK (부분 스테이징/폐기/적용)
# 40) hunk-stage          : git add -p (부분 스테이징 인터랙티브)
# 41) hunk-unstage        : git reset -p (인덱스에서 부분 언스테이징)
# 42) hunk-discard        : git restore -p . (워킹 변경 부분 폐기, 주의)
# 43) hunk-file-pick      : fzf로 파일 골라 각 파일에 대해 add -p
# 44) hunk-commit-partial : add -p 후 메시지 입력 받아 부분 커밋
# 45) hunk-show           : 현재 변경의 hunk 단위 diff 보기(페이저)
# 46) hunk-apply-from     : 다른 ref의 특정 파일 diff를 패치로 적용
# 47) hunk-copy-file      : 다른 ref의 파일 내용을 그대로 가져오기(부분 복구)
# 48) hunk-split-file     : 한 파일의 변경을 여러 커밋으로 쪼개기 가이드
#
# SUBMODULE
# 49) sm-init             : submodule init (gitmodules 기준으로 준비)
# 50) sm-update           : submodule update --init --recursive
# 51) sm-update-remote    : submodule update --init --remote --recursive
# 52) sm-add              : 서브모듈 추가 (사용: sm-add <url> <path> [branch])
# 53) sm-set-branch       : fzf로 모듈 골라 추적 branch 설정 후 sync
# 54) sm-foreach-status   : 각 서브모듈의 status -sb
# 55) sm-foreach-pull     : 각 서브모듈 fetch/pull --rebase --ff-only
# 56) sm-foreach-branch   : 모든 서브모듈을 지정 branch로 전환
# 57) sm-sync             : .gitmodules 변경을 로컬 설정에 동기화
# 58) sm-absorbgitdirs    : 서브모듈 .git 디렉토리 흡수(구조 정리)
# 59) sm-deinit           : fzf로 고른 서브모듈 deinit + 제거(주의)
