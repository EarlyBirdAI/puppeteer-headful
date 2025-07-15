FROM node:lts-bullseye

LABEL "com.github.actions.name"="Puppeteer Headful"
LABEL "com.github.actions.description"="A GitHub Action / Docker image for Puppeteer, the Headful Chrome Node API"
LABEL "com.github.actions.icon"="layout"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/EarlyBirdAI/puppeteer-headful"
LABEL "homepage"="https://github.com/EarlyBirdAI/puppeteer-headful"
LABEL "maintainer"="Your Name <you@example.com>"

RUN apt-get update \
     && apt-get install -y --no-install-recommends \
     ca-certificates \
     apt-transport-https \
     gnupg \
     lsb-release \
     wget \
     xvfb \
     libgconf-2-4 \
     libnss3 \
     libx11-xcb1 \
     libxcomposite1 \
     libxcursor1 \
     libxdamage1 \
     libxi6 \
     libxtst6 \
     libatk1.0-0 \
     libcups2 \
     libxrandr2 \
     libxss1 \
     libasound2 \
     libatk-bridge2.0-0 \
     libgtk-3-0 \
     libdbus-1-3 \
     libgbm1 \
     fonts-liberation \
     libappindicator3-1 \
     libsecret-1-0 \
     && wget -qO- https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" \
     > /etc/apt/sources.list.d/google-chrome.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends google-chrome-stable \
     && rm -rf /var/lib/apt/lists/*

# Prevent Puppeteer from downloading its own Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

COPY README.md /
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
