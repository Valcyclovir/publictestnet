#!/bin/bash

source /root/.env

messages=""
hourlypubs=""

check_status() {
  status=$(systemctl is-active otnode)
  if [[ "$status" != "active" ]]; then
    messages+=" $HOSTNAME: Otnode service is not active."
  fi
}

check_storage() {
  usage=$(df -h --output=pcent / | tail -n 1 | tr -d '[:space:]')
  percent="${usage%%%}"
  if [[ $percent -ge $MAX_STORAGE_PERCENT ]]; then
    messages+=" $HOSTNAME: Storage usage is $usage full."
  fi
}

check_wins() {
  WIN=$(journalctl -u otnode --since "1 hour ago" | grep -E "submitCommitCommand.*epoch: 0" | wc -l)
  ATTEMPTS=$(journalctl -u otnode --since "1 hour ago" | grep "Service agreement bid:" | wc -l)
  hourlypubs+=" $HOSTNAME won $WIN/$ATTEMPTS attempts"
}

check_error() {
  logs=$(journalctl -u otnode --since '1 hour ago' | grep 'ERROR')
  if [[ -n "$logs" ]]; then
    systemctl restart otnode
    messages+=" Otnode service has been restarted. ERROR has been detected on $HOSTNAME: $logs"
  fi
}

telegram_message() {
  curl -s -X POST "https://api.telegram.org/bot$BOT_ID/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$1" >/dev/null
}

check_status
check_storage
check_error
check_wins

telegram_message "$messages"
telegram_message "$hourlypubs"