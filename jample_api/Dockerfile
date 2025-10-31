# Dockerfile (excerpt)
FROM ruby:3.3

# OS deps: node, postgres client, aubio, python, audio decoders
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs postgresql-client \
    python3 python3-pip \
    aubio-tools python3-aubio \
    ffmpeg libsndfile1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

# gem install steps (keep your current pattern)
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]