require_relative 'counting_rate_limiter'

module RateLimit
  class LimiterFactory
    def initialize(repository:)
      self.repository = repository
    end

    def counting_limiter(quota)
      CountingRateLimiter.new(repository: repository, quota: quota)
    end

    private

    attr_accessor :repository
  end
end
