#!/usr/bin/bash

CODE="Code"
CODE_INSIDERS="Code - Insiders"

# Path to the projects.json file (vscode alefragnani project manager)
SRC=~/.config/"$CODE_INSIDERS"/User/globalStorage/alefragnani.project-manager/projects.json

prj=$(jq -r "sort_by(.name) | .[].name" "$SRC" |
  wofi -dmenu -p "vscode project" \
    --style /home/jinheonyoon/.config/wofi/transparent.css)

# If there was a selection, find its path from the src file and launch vscode.
if [ -n "$prj" ]; then
  prjpath=$(jq -r --arg prj "$prj" '.[] | select(.name==$prj) | .rootPath' "$SRC")
  echo "Opening $prj in $CODE_INSIDERS"
  echo "prjpath: $prjpath"
  code-insiders "$prjpath"
fi
