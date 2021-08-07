require_relative 'mapper_step'
require_relative 'synchronized_mapper_wrapper'
require_relative 'producer_task_wrapper'
require_relative 'producer_step'
require_relative 'consumer_step'
require_relative 'consumer_task_wrapper'

class PipelineBuilder
  def initialize(executor_service, default_thread_factory, pipeline_name)
    self.executor_service = executor_service
    self.steps            = []
    self.last_queue       = nil
    self.default_thread_factory = default_thread_factory
    self.pipeline_name          = pipeline_name
  end

  def producer(task, queue_size: 1000, instances: 1, task_wrapper: ProducerTaskWrapper, thread_factory: default_thread_factory)
    steps << ProducerStep.new(
      task, executor_service: executor_service, producing_queue: last_queue.or_else_get { new_queue(queue_size) },
      thread_factory: thread_factory,
      wrapper_factory: task_wrapper,
      name: "producer-#{steps.count}",
      count: instances
    )
    self
  end

  def mapper(task, queue_size: 1000, instances: 1, task_wrapper: SynchronizedMapperWrapper, thread_factory: default_thread_factory)
    steps << MapperStep.new(
      task,
      executor_service: executor_service, consuming_queue: last_queue.get, producing_queue: new_queue(queue_size),
      thread_factory: thread_factory, wrapper: task_wrapper,
      previous_task: steps.last, name: "mapper-#{steps.count}", count: instances
    )
    self
  end

  def consumer(task, queue_size: 1000, instances: 1, task_wrapper: ConsumerTaskWrapper, thread_factory: default_thread_factory)
    steps << ConsumerStep.new(
      task,
      executor_service: executor_service, queue: last_queue.or_else_get { new_queue(queue_size) },
      thread_factory: thread_factory, previous_step: steps.last, name: "consumer-#{steps.count}", count: instances,
      task_wrapper: task_wrapper
    )
    self
  end

  def build
    Pipeline.new(executor_service, steps, pipeline_name)
  end

  private

  attr_accessor :executor_service, :steps, :default_thread_factory, :pipeline_name
  attr_writer :last_queue

  def last_queue
    Optional.of_nullable(@last_queue)
  end

  def new_queue(size)
    self.last_queue = SizedQueue.new(size)
  end
end
