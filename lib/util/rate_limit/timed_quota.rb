module RateLimit
  class TimedQuota
    attr_reader :invocations, :period

    def initialize(invocations:, in_period_of:)
      self.invocations = invocations
      self.period      = in_period_of
    end

    alias limit invocations
    alias duration period

    private

    attr_writer :invocations, :period
  end
end
