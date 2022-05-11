#!/bin/sh

### check if script is being run from project directory
if [ ! -f "docker-compose.yml" ]; then
  echo "Please run this script from your project directory."
  echo "Example: ci/build.sh"
  exit
fi

set -x

PACKAGE_NAME=ghcr.io/xoros-repo/xoros-builder
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git log -1 --pretty=format:"%h")

docker build . \
  --tag="${PACKAGE_NAME:-unknown}" \
  --build-arg GIT_BRANCH="${GIT_BRANCH}" \
  --build-arg GIT_COMMIT="${GIT_COMMIT}"
