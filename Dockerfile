############################
# Stage: Build OpenCode
############################
ARG SPACEBOT_VERSION=latest
FROM ghcr.io/spacedriveapp/spacebot:${SPACEBOT_VERSION} AS build

# Install Node + npm (needed to install OpenCode)
RUN apt-get update \
    && apt-get install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode CLI at a specific version (pin for reproducibility)
ARG OPENCODE_VERSION=latest
RUN npm install -g opencode-ai@"${OPENCODE_VERSION}"

############################
# Stage: Final Image
############################
ARG SPACEBOT_VERSION=latest
FROM ghcr.io/spacedriveapp/spacebot:${SPACEBOT_VERSION}

# Copy Node + npm from build stage
COPY --from=build /usr/bin/node /usr/bin/node
COPY --from=build /usr/bin/npm /usr/bin/npm

# Copy OpenCode CLI and its node_modules
COPY --from=build /usr/lib/node_modules/opencode-ai /usr/lib/node_modules/opencode-ai
COPY --from=build /usr/local/bin/opencode /usr/local/bin/opencode

# Ensure the opencode binary is on PATH
ENV PATH="/usr/local/bin:${PATH}"

# Optional: verify installation at build time
RUN opencode --version

# Entrypoint continues to be Spacebot’s default