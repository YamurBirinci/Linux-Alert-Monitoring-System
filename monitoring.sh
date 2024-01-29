#!/bin/bash_

export ALERT_BOT_TOKEN="" 
export CHAT_ID=""

CPU_THRESHOLD=94
MEMORY THRESHOLD=95
DISK THRESHOLD=98

function cpu_stressing {
  echo "STRESSING CPU"
  stress --cpu 2 &
}

function memory_stressing {
  echo "STRESSING MEMORY"
  stress --vm 8 &
}

function disk_stressing {
  echo "STRESSING DISK"
  stress --hdd 4 -hdd-bytes 256G &
}

while true; do

  LOADING CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  LOADING MEMORY=$(free -m | awk 'NR==2{print $3*100/$2}')
  LOADING_DISK=$(df -h/ | awk 'NR==2 {printf "%s\t\t", $5}' | tr -d '%[:space:]')


  if (($(echo "$LOADING_CPU > $CPU_THRESHOLD" | bc -1))); then
    curl -s -X POST https://api.telegram.org/bot$ALERT_BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="CPU Threshold exceeded. Threshold-94. CPU usage=$LOADING_CPU"
  fi

  if (($(echo "$LOADING MEMORY > $MEMORY_THRESHOLD" | bc -1))); then
    curl -s -X POST https://api.telegram.org/bot$ALERT_BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="Memory Threshold exceeded. Threshold=95. Memory usage=$LOADING_MEMORY"
  fi

  if (($(echo "$LOADING_DISK > $DISK_THRESHOLD" | bc -1))); then
    curl -s -X POST https://api.telegram.org/bot$ALERT_BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="Disk Threshold exceeded. Threshold-98. Disk usage=$LOADING_DISK"
  fi

  echo ""
  echo "CPU    :  $LOADING_CPU"
  echo "MEMORY :  $LOADING_MEMORY"
  echo "DISK   :  $LOADING_DISK"

  sleep 10

done
