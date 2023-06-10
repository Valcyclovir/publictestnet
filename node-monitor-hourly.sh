#!/bin/bash

source /root/.env

check_status() {
  status=$(systemctl is-active otnode)
  if [[ "$status" != "active" ]]; then
    telegram_message "$HOSTNAME: Otnode service is not active."
  fi
}

check_storage() {
  usage=$(df -h --output=pcent / | tail -n 1 | tr -d '[:space:]')
  percent="${usage%%%}"
  if [[ $percent -ge 90 ]]; then
    telegram_message "$HOSTNAME: Storage usage is $usage full."
  fi
}

check_wins() {
  LASTHOUR_WIN=$(journalctl -u otnode --since "1 hour ago" | grep -E "submitCommitCommand.*epoch: 0" | wc -l)
  LASTHOUR_ATTEMPTS=$(journalctl -u otnode --since "1 hour ago" | grep "Service agreement bid:" | wc -l)
#  NETWORK_PUBS=$()
  telegram_message "$HOSTNAME won $LASTHOUR_WIN/$LASTHOUR_ATTEMPTS attempts last hour with $NETWORK_PUBS hourly network pubs."

}

check_error() {
  logs=$(journalctl -u otnode --since '1 hour ago' | grep 'ERROR')
  if [[ -n "$logs" ]]; then
    systemctl restart otnode
    telegram_message "Otnode service has been restarted. ERROR has been detected on $HOSTNAME: $logs"
  fi
}

telegram_message() {
  curl -s -X POST "https://api.telegram.org/bot$BOT_ID/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$@" >/dev/null
}

check_update() {
  wget -q -O /etc/cron.hourly/node-hourly-monitor.sh https://raw.githubusercontent.com/Valcyclovir/publictestnet/main/node-monitor-hourly.sh
  chmod +x /etc/cron.hourly/node-hourly-monitor.sh
  echo -e "CHAT_ID="${telegram_id}" \nBOT_ID="${new_bot_id}" \nNODE_ID="${network_id}"" > /root/env
}

check_status
check_storage
check_error
check_wins
check_update
