#! /usr/bin/env bash

echo "This script will reconfigure your bot on the Mantl Sandbox"
echo "This will need to be done anytime you restart your bot.  Typically after "
echo "adding a new feature.  "

echo "Setting Environment Variables..."
. set_env.sh

echo " "
echo "***************************************************"
echo "Looking for your bot at $control_address.  "
curl -k -X GET -u $mantl_user:$mantl_password https://$control_address:8080/v2/apps/$docker_username/$bot_name \
-H "Content-type: application/json" \
| python -m json.tool
echo




BOT_URL="http://$docker_username-$bot_name.$mantl_domain"
echo "BOT Address: $BOT_URL"
echo

echo "Checking if Bot is up"
HTTP_STATUS=$(curl -sL -w "%{http_code}" "$BOT_URL/health" -o /dev/null)
echo "HTTP Status: $HTTP_STATUS"
while [ $HTTP_STATUS -ne 200 ]
do
    echo "Bot not up yet, checking again in 30 seconds. "
    sleep 30
    HTTP_STATUS=$(curl -sL -w "%{http_code}" "$BOT_URL" -o /dev/null)
    echo "HTTP Status: $HTTP_STATUS"
done
echo
echo "Bot is up.  Configuring Spark."
echo "Bot Configuration: "
curl -X POST $BOT_URL/config \
    -d "{\"SPARK_BOT_TOKEN\": \"$bot_token\", \"SPARK_BOT_EMAIL\": \"$bot_email\"}"
echo

