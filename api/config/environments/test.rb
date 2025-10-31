require "active_support/core_ext/integer/time"

# The test environment is used exclusively for running your application's test suite.
# It is a scratch space: the test database is wiped and recreated between test runs.

Rails.application.configure do
  # Settings here take precedence over those in config/application.rb.

  # Files aren’t reloaded between requests in test.
  config.enable_reloading = false

  # Eager load only when running in CI to catch load-time errors early.
  config.eager_load = ENV["CI"].present?

  # Serve static files with simple caching for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Full error reports, no caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Render exception templates for rescuable exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable CSRF protection for tests.
  config.action_controller.allow_forgery_protection = false

  # Use the temporary test storage service.
  config.active_storage.service = :test

  # Mailer setup for tests.
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # Deprecations
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise when a before_action references a missing method.
  config.action_controller.raise_on_missing_callback_actions = true

  # Uncomment for stricter i18n or helpful view annotations:
  # config.i18n.raise_on_missing_translations = true
  # config.action_view.annotate_rendered_view_with_filenames = true
end