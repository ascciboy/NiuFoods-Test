# config/initializers/redis_metrics.rb
require "redis"

begin
  $redis_metrics = Redis.new(
    url: ENV.fetch("REDIS_METRICS_URL") { "redis://redis:6379/1" },
    timeout: 1,
    reconnect_attempts: 1
  )
rescue => e
  Rails.logger.warn "Redis Metrics no disponible: #{e.message}"
  $redis_metrics = nil
end
