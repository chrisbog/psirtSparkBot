#! /usr/bin/env bash

echo "This script will install your bot on a Mantl Sandbox"


echo "Setting Environment Variables..."
. set_env.sh


echo
echo "Your bot will be deployed based on the 'latest' tag of Docker Container at: "
echo "    https://hub.docker.com/r/$docker_username/$bot_name/"


cp sample_marathon_app_def.json $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/DOCKERUSER/$docker_username/g" $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/DOCKERREPO/$docker_repo/g" $docker_username-$bot_name-sandbox.json

sed -i "" -e "s/USERNAME/$docker_username/g" $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/BOTNAME/$bot_name/g" $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/CLIENTID/$client_id/g" $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/CLIENTSECRET/$client_secret/g" $docker_username-$bot_name-sandbox.json
#sed -i "" -e "s/BOTEMAIL/$bot_email/g" $docker_username-$bot_name-sandbox.json
#sed -i "" -e "s/BOTTOKEN/$bot_token/g" $docker_username-$bot_name-sandbox.json
sed -i "" -e "s/APPDOMAIN/$mantl_domain/g" $docker_username-$bot_name-sandbox.json

if [ $TAG != "" ]
then
    sed -i "" -e "s/latest/$TAG/g" $docker_username-$bot_name-sandbox.json
fi


echo " "
echo "***************************************************"
echo "Installing the Bot as  $docker_username/$bot_name"
curl -k -X POST -u $mantl_user:$mantl_password https://$control_address:8080/v2/apps \
-H "Content-type: application/json" \
-d @$docker_username-$bot_name-sandbox.json \
| python -m json.tool

echo "***************************************************"
echo

echo "Bot Installed"
echo

##############################################################
# Check if BOT is up

BOT_URL="http://$docker_username-$bot_name.$mantl_domain"

echo "Checking if Bot is up.  This should take 2-3 minutes."
HTTP_STATUS=$(curl -sL -w "%{http_code}" "$BOT_URL/health" -o /dev/null)
#echo "HTTP Status: $HTTP_STATUS"
while [ $HTTP_STATUS -ne 200 ]
do
    echo "Bot not up yet, checking again in 30 seconds. "
    sleep 30
    HTTP_STATUS=$(curl -sL -w "%{http_code}" "$BOT_URL/health" -o /dev/null)
    #echo "HTTP Status: $HTTP_STATUS"
done
echo

echo "Bot is up.  Configuring Spark."
echo "Bot Configuration: "
curl -X POST $BOT_URL/config \
    -d "{\"SPARK_BOT_TOKEN\": \"$bot_token\", \"SPARK_BOT_EMAIL\": \"$bot_email\"}"
echo
echo

echo "Your bot is deployed to "
echo
echo "http://$docker_username-$bot_name.$mantl_domain/"
echo
echo "You should be able to send a message to yourself from the bot by using this call"
echo
echo "curl http://$docker_username-$bot_name.$mantl_domain/hello/<YOUR EMAIL ADDRESS>"
echo
echo "You can also watch the progress from the GUI at: "
echo
echo "https://$control_address/marathon"
echo
