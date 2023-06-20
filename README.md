# publictestnet

#### This is not for production. Test at your own risk.

node-monitor-hourly.sh helps monitor your node hourly: 
- checks if otnode.service is active
- checks storage space
- checks your pub wins
- checks for errors and restart node
- sends notifications for the above to your TG bot

## Installation
Insert the script into your node server /etc/cron.hourly directory
```
wget -q -O /etc/cron.hourly/node-hourly-monitor.sh https://raw.githubusercontent.com/Valcyclovir/publictestnet/main/node-monitor-hourly.sh 
```
Set permissions
```
chmod +x /etc/cron.hourly/node-hourly-monitor.sh
```
Create .env file
```
mkdir /root/.env
```
Enter your infos
To get your telegram_id, type /getid to [@myidbot](https://t.me/myidbot)
To get your bot_id, follow the instructions on [@botfather](https://t.me/botfather)
Replace <telegram_id> and <bot_id> with their respective values
```
echo -e "CHAT_ID="<telegram_id>" \nBOT_ID="<bot_id>"" > /root/.env
```
To test your script at any time, run the following
```
./etc/cron.hourly/node-hourly-monitor.sh
```
