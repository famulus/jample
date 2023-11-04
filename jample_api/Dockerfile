# Use the official Ruby image as a parent image
FROM ruby:2.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory in the container
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Install the Ruby gems
RUN bundle install

# Copy the main application
COPY . /myapp

# Expose the port the app runs on
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
