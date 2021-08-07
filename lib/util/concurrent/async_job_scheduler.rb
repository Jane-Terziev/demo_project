class AsyncJobScheduler
  def initialize(executor_service:)
    self.executor_service  = executor_service
  end

  def schedule(callable, delay: 0.seconds)
    ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
      future = Concurrent::Promises.delay_on(executor_service) do
        Rails.application.executor.wrap do
          sleep(delay)
          callable.call
        end
      end

      future.on_rejection_using(executor_service) { |reason| puts reason }.touch
    end
  end

  private

  attr_accessor :executor_service
end
