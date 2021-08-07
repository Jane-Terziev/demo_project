require_relative 'stats'

module RateLimit
  ThrottlingError = Class.new(StandardError)
  RateLimitExceededError = Class.new(ThrottlingError)

  class CountingRateLimiter
    def initialize(repository:, quota:)
      self.repository = repository
      self.quota      = quota
    end

    def rate_limit(action, identifier)
      repository.watch(repository.key(action, identifier)) do
        stats = get_rate_limit_data(action, identifier)
        stats.filter(&:over_limit?).if_present { raise RateLimitExceededError }
        result = yield
        register_invocation(action, identifier)
        OpenStruct.new(
          result: result,
          rate_limit_stats: stats.map { |it|
            Stats.new(invocations: it.invocations + 1, remaining: it.remaining - 1, reset_at: it.reset_at)
          }.or_else(nil)
        )
      end
    end

    private

    def register_invocation(action, identifier)
      repository.increment(identifier, action)
    rescue StandardError => e
      Rails.logger.error e
    end

    def get_rate_limit_data(action, identifier)
      invocations = repository.get_invocations(identifier, action, quota)
      Optional.of(
        Stats.new(
          invocations: invocations,
          remaining: quota.limit - invocations,
          reset_at: repository.time_to_reset(identifier, action).map { |it| (Time.now + it.seconds).to_i }.or_else(nil)
        )
      )
    rescue StandardError => e
      Rails.logger.error e
      Optional.empty
    end

    attr_accessor :repository, :quota
  end
end
