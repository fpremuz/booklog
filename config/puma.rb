# Puma configuration for Docker / production

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

environment ENV.fetch("RAILS_ENV", "production")

# Remove SSL — Docker will serve plain HTTP
# ssl_bind '0.0.0.0', '3000', {
#   key: "/path/to/server.key",
#   cert: "/path/to/server.crt"
# }

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Optional: PID file (used by Docker to detect process)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Optional: if you use Solid Queue
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]