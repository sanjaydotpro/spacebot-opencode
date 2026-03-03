FROM ghcr.io/spacedriveapp/spacebot:latest

# install Node.js and npm
RUN apt-get update \
    && apt-get install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# install the OpenCode CLI globally
RUN npm install -g opencode-ai@latest

# ensure opencode is on PATH
ENV PATH="/usr/local/bin:${PATH}"

# verify installation
RUN opencode --version