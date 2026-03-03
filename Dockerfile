############################
# Base: Spacebot with browser support
############################
ARG SPACEBOT_VERSION=latest
FROM ghcr.io/spacedriveapp/spacebot:${SPACEBOT_VERSION}

# Install Node + npm so we can install OpenCode
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    # Browser dependencies (re-install spacebot’s Chromium prerequisites)
    ca-certificates \
    zip \
    curl \
    unzip \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxrandr2 \
    libxfixes3 \
    libxshmfence1 \
    libxrender1 \
    libxcb1 \
    libcups2 \
    libdbus-1-3 \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode CLI globally (pin version if desired)
ARG OPENCODE_VERSION=latest
RUN --mount=type=cache,target=/root/.npm \
    npm install -g opencode-ai@"${OPENCODE_VERSION}"

# Add npm’s global bin folder explicitly to PATH
ENV PATH="/usr/local/bin:${PATH}"

# Verify OpenCode binary
RUN opencode --version