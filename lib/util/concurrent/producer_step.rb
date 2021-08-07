require_relative 'abstract_pipeline_step'
require_relative 'task_rate'

class ProducerStep < AbstractPipelineStep
  def initialize(task, executor_service:, producing_queue:, thread_factory:, wrapper_factory:, name:, count:)
    self.executor_service = executor_service
    self.producing_queue  = producing_queue
    self.thread_factory   = thread_factory
    self.task             = task
    self.name             = name
    self.task_wrapper     = wrapper_factory
    self.count            = count
  end

  private

  attr_accessor :producing_queue

  def wrap_block
    task_wrapper.new(producing_queue, task, name)
  end
end
