# Dockerfile
FROM ruby:3.4.7

# Optional: speed up bundler a bit
ENV BUNDLE_JOBS=4 BUNDLE_RETRY=3

# OS deps: build tools for native gems, Postgres headers, Node (for JS runtime),
# Python + aubio tools, audio decoders/codecs
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential pkg-config \
    libpq-dev postgresql-client \
    nodejs \
    python3 python3-pip \
    aubio-tools python3-aubio \
    ffmpeg libsndfile1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

# Install gems with proper caching
COPY Gemfile Gemfile.lock ./
RUN bundle install



# Bring in the app
COPY . .
COPY bin/docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]


# frontend/Dockerfile
FROM node:20-alpine

WORKDIR /usr/src/app

# Install deps separately for cache
COPY package*.json ./
RUN npm ci || npm install

# Bring in source (in dev the bind mount will override)
COPY . .

# Vite dev server (or CRA dev server) is started by compose `command`