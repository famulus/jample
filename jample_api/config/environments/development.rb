require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings here take precedence over those in config/application.rb.

  # In development, reload code on every request.
  config.enable_reloading = true
  config.eager_load = false

  # Full error reports + server timing
  config.consider_all_requests_local = true
  config.server_timing = true

  # Caching toggle: `bin/rails dev:cache`
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
    # Helpful log noise only when caching is on
    config.action_controller.enable_fragment_cache_logging = true
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Active Storage (kept; harmless even for API-only)
  config.active_storage.service = :local

  # Mailer (dev-friendly defaults)
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Deprecations (Rails 8 keeps these APIs)
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # DB / job logging
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_job.verbose_enqueue_logs = true

  # Strict callbacks (you had this; still valid)
  config.action_controller.raise_on_missing_callback_actions = true

  # ---- File watching (Docker-friendly) ----
  # Default: evented watcher (fast when host fs sends events)
  # If Docker Desktop misses events, set LISTEN_GEM_USE_POLLING=1 to force polling.
  if ENV["LISTEN_GEM_USE_POLLING"] == "1"
    config.file_watcher = ActiveSupport::FileUpdateChecker
  else
    config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  end

  # You can also disable Spring/Bootsnap during tricky reload sessions:
  # ENV["DISABLE_SPRING"] = "1"
  # ENV["DISABLE_BOOTSNAP"] = "1"
end