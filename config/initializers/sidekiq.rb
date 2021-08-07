require 'sidekiq/web'

redis_conn = -> { Redis.new(url: ENV['REDIS_SIDEKIQ_URL']) }

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 12, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 12, &redis_conn)
end
