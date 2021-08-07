require 'util/persistence/redis_repository'

module RateLimit
  class RedisInvocationRepository < RedisRepository
    NAMESPACE = 'rate_limit'

    def get_invocations(identifier, action, quota = nil)
      k = key(identifier, action)
      find(k)
        .or_else_get do
        client.setex(k, Optional.of_nullable(quota).map(&:duration).or_else(-1), 0)
        0
      end
    end

    def increment(identifier, action)
      k = key(identifier, action)
      client.incr(k)
    end

    def time_to_reset(identifier, action)
      ttl(key(identifier, action))
    end

    def key(identifier, action)
      [NAMESPACE, identifier, action].join(':')
    end

    private

    def serialize(count)
      count.to_s
    end

    def deserialize(count)
      count.to_i
    end
  end
end
