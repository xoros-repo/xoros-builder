FROM ghcr.io/xoros-repo/xoros-builder:latest

# Add a label pointing to our repository
LABEL org.opencontainers.image.source="https://github.com/xoros-repo/xoros-builder/github-runner"

# set the github runner version
ARG RUNNER_VERSION="2.291.1"

ENV RUNNER_DIR=/home/builder/actions-runner

# cd into the user directory, download and unzip the github actions runner
RUN mkdir -p "${RUNNER_DIR}" && cd "${RUNNER_DIR}" \
    && wget -nv "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    && tar xzf "./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# install some additional dependencies
RUN chown -R builder ~builder && ${RUNNER_DIR}/bin/installdependencies.sh

# copy over the docker scripts
COPY scripts /usr/bin/

# make sure scripts are executable
RUN chmod +x /usr/bin/*.sh

# set the entrypoint to the entrypoint.sh script
ENTRYPOINT ["entrypoint.sh"]
