# publictestnet

#### This is not for production. Test at your own risk.

node-monitor-hourly.sh helps monitor your node hourly: 
- checks if otnode.service is active
- checks storage space
- checks your pub wins
- checks for errors and restart node
- sends notifications for the above to your TG bot

## Installation
Log in to your node and run the following
```
wget -q -O /etc/cron.hourly/nodehourlymonitor https://raw.githubusercontent.com/Valcyclovir/publictestnet/main/nodemonitorhourly 
```
Set permissions
```
chmod +x /etc/cron.hourly/nodehourlymonitor
```
To get your telegram_id, type /getid to [@myidbot](https://t.me/myidbot)

To get your bot_id, follow the instructions on [@botfather](https://t.me/botfather)
Replace <telegram_id> and <bot_id> with their respective values
```
echo -e "CHAT_ID="<telegram_id>" \nBOT_ID="<bot_id>"" > /root/.env
```
To test your script at any time, run the following
```
bash /etc/cron.hourly/nodehourlymonitor
```
Your script will run hourly in the background automatically.
