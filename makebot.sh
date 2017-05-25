#/bin/sh

echo "Building the Bot and publishing it on Docker and Installing On Mantl"
. setup_and_install/set_env.sh

docker build -t $DOCKER_USER/$BOT_REPO:latest .
docker push $DOCKER_USER/$BOT_REPO:latest

cd setup_and_install

echo "Installing the New Bot"
./bot_install_sandbox.sh
cd ..
