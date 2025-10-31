require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load application code on boot.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Ensure credentials are available (uncomment when your secrets are set up in prod).
  # This protects encrypted credentials and any encrypted files.
  # config.require_master_key = true

  # In Docker (without a front proxy serving assets), allow Rails to serve public files
  # when RAILS_SERVE_STATIC_FILES is set (e.g., in your container env).
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # If you host assets on a CDN/reverse proxy, set:
  # config.asset_host = "https://assets.example.com"

  # Use SSL in production (HSTS and secure cookies).
  config.force_ssl = true

  # Log to STDOUT by default (12-factor style).
  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = ::Logger::Formatter.new
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  # Prepend request ID to logs.
  config.log_tags = [:request_id]

  # Default log level (can be overridden via env).
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Caching (pick a real cache in production if needed; e.g., Redis).
  # config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"] }

  # Active Job backend (choose one and set adapter/env if you use jobs).
  # config.active_job.queue_adapter = :solid_queue
  # config.active_job.queue_name_prefix = "jample_api_production"

  # Active Storage service
  config.active_storage.service = :local
  # For cloud storage, switch to :amazon / :google / :azure and configure credentials.

  # Mailer
  config.action_mailer.perform_caching = false
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.default_url_options = { host: ENV["APP_HOST"], protocol: "https" }

  # I18n
  config.i18n.fallbacks = true

  # Don’t log deprecations in production.
  config.active_support.report_deprecations = false

  # Don’t dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Optional hardening for host header:
  # config.hosts = [
  #   "example.com",
  #   /.*\.example\.com/
  # ]
  # Skip DNS rebinding protection for health checks:
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end