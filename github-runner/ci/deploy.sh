#!/bin/sh

### check if script is being run from project directory
if [ ! -f "docker-compose.yml" ]; then
  echo "Please run this script from your project directory."
  echo "Example: ci/deploy.sh"
  exit
fi

### turn down the deployment stack if script has "down" argument
if [ "${1}" = "down" ]; then
  echo "Getting stack down:"
  docker-compose --env-file .env down
  exit
fi

### run detached if argument is "detach"
if [ "${1}" = "detach" ]; then
  echo "Will run stack detached:"
  OPT=-d
fi

### force build if argument is "rebuild"
if [ "${1}" = "rebuild" ]; then
  echo "Will run stack detached:"
  OPT=--build
fi

echo "Building new docker image:"
docker-compose build

echo "Deploying/redeploying services:"
docker-compose --env-file .env up ${OPT} --force-recreate --remove-orphans
