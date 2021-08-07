class AbstractPipelineStep
  def start
    tasks       = Array.new(count) { post_task }
    self.future = Concurrent::Promises.zip_futures_on(executor_service, *tasks)
  end

  alias call start

  def future
    Optional.of_nullable(@future)
  end

  def finished?
    future.map { |it| it.fulfilled? || it.rejected? }.or_else(false)
  end

  private

  def post_task
    Concurrent::Promises
      .future_on(executor_service) { thread_factory.call(wrap_block) }
      .on_rejection_using(executor_service) { |error| Rails.logger.error "#{error.message}\n#{error.backtrace}" }
  end

  attr_accessor :executor_service, :thread_factory, :task, :name, :task_wrapper, :count
  attr_writer :future
end
