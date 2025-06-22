#!/bin/sh

## simple status ##

# network.
net() {
  read -r lan_state </sys/class/net/enp6s5/operstate
  read -r wlan_state </sys/class/net/wlp5s0/operstate

  echo "> lan ($lan_state)
   > wifi ($wlan_state)"
}

# mails.
mail() {
  COUNT_1=$(ls ~/.mail/disroot/INBOX/new | wc -l)
  COUNT_2=$(ls ~/.mail/cock/INBOX/new | wc -l)

  echo "> @disroot.org ($COUNT_1)
   > @cocaine.ninja ($COUNT_2)"
}

# battery.
bat() {
  read -r STATUS </sys/class/power_supply/BAT0/status
  read -r LEVEL </sys/class/power_supply/BAT0/capacity

  if [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
    echo "+$LEVEL%"
  else
    echo "-$LEVEL%"
  fi
}

# memory.
mem() {
  memtotal=$(awk '/MemTotal/ {print $2/1024}' /proc/meminfo)
  memavailable=$(awk '/MemAvailable/ {print $2/1024}' /proc/meminfo)
  swaptotal=$(awk '/SwapTotal/ {print $2/1024}' /proc/meminfo)
  swapfree=$(awk '/SwapFree/ {print $2/1024}' /proc/meminfo)
  ram=$(echo "(($memtotal-$memavailable)*100)/$memtotal" | bc)
  swap=$(echo "(($swaptotal-$swapfree)*100)/$swaptotal" | bc)

  echo "> ram ($ram%)
   > swp ($swap%)"
}

# podcast.
ytp() {
  podcast=$(ls ~/Descargas/ytdl | grep -v trash | wc -l)
  echo "$podcast"
}

## output ##
cat <<EOF

 [B] attery:
   $(bat)
 ---------------
 [N] etwork:
   $(net)
 -----------------
 [M] emory:
   $(mem)
 ---------------------
 [M] ails:
   $(mail)
 -------------------------
 [P] odcast:
   $(ytp)

EOF
