require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JampleApi
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 8.1
    config.load_defaults 8.1

    # Zeitwerk autoloading configuration
    # Ignores non-Ruby subdirectories inside lib/
    config.autoload_lib(ignore: %w[assets tasks])

    # Set application-wide configuration here.
    # These can be overridden per-environment in config/environments/*
    #
    # Example:
    # config.time_zone = "UTC"
    # config.eager_load_paths << Rails.root.join("extras")

    # API-only mode: minimal middleware stack and generators
    config.api_only = true
    config.generators { |g| g.orm :active_record, primary_key_type: :uuid }
    # Optional: ensure CORS middleware runs early if you use rack-cors
    config.middleware.insert_before 0, Rack::Cors if defined?(Rack::Cors)
  end
end