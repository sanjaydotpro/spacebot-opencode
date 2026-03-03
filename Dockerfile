############################
# Build Stage: install opencode
############################
ARG SPACEBOT_VERSION=latest
FROM ghcr.io/spacedriveapp/spacebot:${SPACEBOT_VERSION} AS build

# Install Node + npm so we can install OpenCode
RUN apt-get update \
    && apt-get install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode CLI globally
ARG OPENCODE_VERSION=latest
RUN npm install -g opencode-ai@"${OPENCODE_VERSION}"

############################
# Final Stage: runtime image
############################
ARG SPACEBOT_VERSION=latest
FROM ghcr.io/spacedriveapp/spacebot:${SPACEBOT_VERSION}

# Copy Node + npm from build stage
COPY --from=build /usr/bin/node /usr/bin/node
COPY --from=build /usr/bin/npm /usr/bin/npm

# Copy OpenCode CLI and its dependencies
COPY --from=build /usr/local/lib/node_modules/opencode-ai /usr/local/lib/node_modules/opencode-ai
COPY --from=build /usr/local/bin/opencode /usr/local/bin/opencode

# Ensure opencode is on PATH
ENV PATH="/usr/local/bin:${PATH}"

# Optional: verify installation
RUN opencode --version