FROM debian:11-slim

### Add a label pointing to our repository:
LABEL org.opencontainers.image.source="https://github.com/xoros-repo/xoros-builder"

### Set the github runner version:
ARG GITHUB_RUNNER_VERSION="2.291.1"

### Enable 'contrib' apt repo:
RUN sed -r -i 's/^deb(.*)$/deb\1 contrib/g' /etc/apt/sources.list

### Update the base packages and add a non-sudo user:
RUN apt-get update -y \
    && apt-get upgrade -y \
    && useradd -m builder

WORKDIR /home/builder
ENV GITHUB_RUNNER_DIR=/home/builder/actions-runner
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=GMT

ENV BUILDER_TOOLS_PACKAGES="\
    build-essential \
    chrpath cpio curl \
    diffstat \
    file \
    gawk git-core \
    locales lz4 \
    python3 python3-venv python3-dev python3-pip \
    rclone repo \
    socat \
    texinfo \
    unzip \
    wget \
    xterm \
    zstd \
"

ENV BUILDER_LIBRARIES_PACKAGES="\
    libssl-dev \
    libffi-dev \
    gcc-multilib \
    libsdl1.2-dev \
"

### Install packages:
RUN apt-get install -q -y --no-install-recommends \
    ${BUILDER_TOOLS_PACKAGES} ${BUILDER_LIBRARIES_PACKAGES}

### Update the locales to UTF-8:
RUN locale-gen "en_US.UTF-8" \
    && dpkg-reconfigure locales
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

### Download and unzip the github actions runner:
RUN mkdir -p "${GITHUB_RUNNER_DIR}" \
    && cd "${GITHUB_RUNNER_DIR}" \
    && wget -nv "https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz" \
    && tar xzf "./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz"

### Install runner additional dependencies:
RUN chown -R builder ~builder \
    && ${GITHUB_RUNNER_DIR}/bin/installdependencies.sh

### Copy over the docker scripts:
COPY scripts/ /usr/bin/

### Make sure scripts are executable:
RUN chmod +x /usr/bin/*.sh

### Create cache dir:
RUN mkdir -p cache \
    && chown -R builder:builder cache

### Set default user to 'builder':
USER builder
