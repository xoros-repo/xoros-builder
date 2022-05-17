#!/bin/bash

if [ -z ${GITHUB_RUNNER_TOKEN+x} ]; then
  echo "GITHUB_RUNNER_TOKEN variable is not set. Aborting..."
  exit 1
fi

if [ -z ${GITHUB_RUNNER_REPO+x} ]; then
  echo "GITHUB_RUNNER_REPO variable is not set. Aborting..."
  exit 1
fi

if [ -z ${GITHUB_RUNNER_DIR+x} ]; then
  echo "GITHUB_RUNNER_DIR variable is not set. Aborting..."
  exit 1
fi

cd "${GITHUB_RUNNER_DIR}" || exit

./config.sh --url "https://github.com/${GITHUB_RUNNER_REPO}" --token "${GITHUB_RUNNER_TOKEN}" --labels yocto,x64,linux

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${GITHUB_RUNNER_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
