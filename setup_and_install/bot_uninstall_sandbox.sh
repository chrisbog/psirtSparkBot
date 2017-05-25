#! /usr/bin/env bash

echo "This script will uninstall  your bot on a Mantl Sandbox"

echo "Setting Environment Variables..."
. set_env.sh

curl -k -X GET -u $mantl_user:$mantl_password https://$control_address:8080/v2/apps/$docker_username/$bot_name \
-H "Content-type: application/json" | python -m json.tool


echo
echo "Uninstalling the bot at $docker_username/$bot_name"
curl -k -X DELETE -u $mantl_user:$mantl_password https://$control_address:8080/v2/apps/$docker_username/$bot_name \
-H "Content-type: application/json"
echo

