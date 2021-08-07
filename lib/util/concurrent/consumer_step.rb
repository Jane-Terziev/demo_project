require_relative 'abstract_pipeline_step'

class ConsumerStep < AbstractPipelineStep
  def initialize(task, executor_service:, queue:, thread_factory:, task_wrapper:, previous_step:, name:, count: 1)
    self.executor_service = executor_service
    self.queue            = queue
    self.thread_factory   = thread_factory
    self.task_wrapper     = task_wrapper
    self.task             = task
    self.name             = name
    self.count            = count
    self.previous_step    = previous_step
  end

  private

  attr_accessor :previous_step, :queue

  def wrap_block
    task_wrapper.new(queue, task, name, previous_step)
  end
end
