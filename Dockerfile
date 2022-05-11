FROM ubuntu:18.04

# Add a label pointing to our repository
LABEL org.opencontainers.image.source="https://github.com/xoros-repo/xoros-builder"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m builder

WORKDIR /home/builder

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

USER builder

