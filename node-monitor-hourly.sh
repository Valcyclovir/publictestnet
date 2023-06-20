#!/bin/bash

source /root/.env

messages=""

check_status() {
  status=$(systemctl is-active otnode)
  if [[ "$status" != "active" ]]; then
    messages+=" $HOSTNAME: Otnode service is not active."
  fi
}

check_storage() {
  usage=$(df -h --output=pcent / | tail -n 1 | tr -d '[:space:]')
  percent="${usage%%%}"
  if [[ $percent -ge 90 ]]; then
    messages+=" $HOSTNAME: Storage usage is $usage full."
  fi
}

check_wins() {
  WIN=$(journalctl -u otnode --since "1 hour ago" | grep -E "submitCommitCommand.*epoch: 0" | wc -l)
  ATTEMPTS=$(journalctl -u otnode --since "1 hour ago" | grep "Service agreement bid:" | wc -l)
  CHECK_STUCK=$(journalctl -u otnode --since "3 hour ago" | grep -E "submitCommitCommand.*epoch: 0" | wc -l)
##  NETWORK_PUBS=$()
  messages+=" $HOSTNAME won $WIN/$ATTEMPTS attempts"
##  if [[ $CHECK_STUCK -eq 0 && $NETWORK_PUBS -gt 50 ]]; then
##    systemctl restart otnode
##    messages+=" $HOSTNAME has not won any pubs in the last 3 hours with pubs on the network. Otnode restarted."
##  fi
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
