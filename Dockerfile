FROM ubuntu:18.04

# Add a label pointing to our repository
LABEL org.opencontainers.image.source="https://github.com/xoros-repo/xoros-builder"

# set the github runner version
ARG GITHUB_RUNNER_VERSION="2.291.1"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m builder

WORKDIR /home/builder
ENV GITHUB_RUNNER_DIR=/home/builder/actions-runner

ENV PACKAGES="curl \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    gawk \
    wget \
    git-core \
    diffstat \
    unzip \
    texinfo \
    gcc-multilib \
    chrpath \
    socat \
    libsdl1.2-dev \
    xterm \
    cpio \
    file \
    locales \
    "

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN TZ=GMT DEBIAN_FRONTEND=noninteractive \
    apt-get install -q -y --no-install-recommends ${PACKAGES}

# Update the locales to UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# cd into the user directory, download and unzip the github actions runner
RUN mkdir -p "${GITHUB_RUNNER_DIR}" \
    && cd "${GITHUB_RUNNER_DIR}" \
    && wget -nv "https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz" \
    && tar xzf "./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz"

# install some additional dependencies
RUN chown -R builder ~builder \
    && ${GITHUB_RUNNER_DIR}/bin/installdependencies.sh

# copy over the docker scripts
COPY scripts/ /usr/bin/

# make sure scripts are executable
RUN chmod +x /usr/bin/*.sh

RUN mkdir -p cache \
    && chown -R builder:builder cache

### Install rclone (https://rclone.org/#about)
RUN curl https://rclone.org/install.sh | bash

# since the config and run script for actions are not allowed to be run by root,
# set the user to "builder" so all subsequent commands are run as the builder user
USER builder
