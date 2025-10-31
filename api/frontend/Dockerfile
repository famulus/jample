# frontend/Dockerfile
FROM node:20-alpine

WORKDIR /usr/src/app

# Install deps separately for better caching
COPY package*.json ./
RUN npm ci || npm install

# Bring in the rest (overridden by the bind mount in dev)
COPY . .

# Dev server is started by compose `command`