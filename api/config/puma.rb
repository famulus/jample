# Puma can serve each request in a thread from an internal thread pool.
# The `threads` setting takes two numbers: a minimum and maximum.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }.to_i
threads min_threads_count, max_threads_count

# Port & environment
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# In development under Docker, give extra time for boots/debugging
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Opt into clustered mode by setting WEB_CONCURRENCY (e.g., 2 or 3).
# Keep single-process by default (safest for API dev & consoles).
if (wc = ENV["WEB_CONCURRENCY"]) && wc.to_i > 0
  workers wc.to_i
  preload_app!
end

# Allow puma to be restarted by `bin/rails restart`
plugin :tmp_restart