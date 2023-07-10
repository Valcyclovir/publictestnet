#!/bin/bash

source /etc/othub/config

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
  NODE_STATS=$(curl -s "https://api.othub.io/otp/views/v_nodes_stats_last?api_key=$API_KEY&nodeId=$NODE_ID")
  ATTEMPTS=$(echo "$NODE_STATS" | jq -r '.[0].pubsCommited')
  WIN=$(echo "$NODE_STATS" | jq -r '.[0].pubsCommited1stEpochOnly')
  
  NETWORKPUBS=$(curl -s "https://api.othub.io/otp/views/v_pubs_stats_last?api_key=$API_KEY" | jq -r '.[0].totalPubs')
  
  hourlypubs+=" $HOSTNAME won $WIN/$ATTEMPTS attempts with $NETWORKPUBS network pubs"
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