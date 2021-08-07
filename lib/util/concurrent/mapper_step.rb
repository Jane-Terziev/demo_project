require_relative 'abstract_pipeline_step'
require_relative 'synchronized_mapper_wrapper'

class MapperStep < AbstractPipelineStep
  def initialize(task, executor_service:, consuming_queue:, producing_queue:, thread_factory:, wrapper:, previous_task:, name:, count:)
    self.executor_service = executor_service
    self.consuming_queue = consuming_queue
    self.producing_queue = producing_queue
    self.thread_factory  = thread_factory
    self.task            = task
    self.previous_task   = previous_task
    self.task_lock       = Mutex.new
    self.name            = name
    self.task_wrapper    = wrapper
    self.count           = count
  end

  private

  attr_accessor :consuming_queue, :producing_queue, :previous_task, :task_lock

  def wrap_block
    task_wrapper.new(consuming_queue, producing_queue, task, previous_task, task_lock, name)
  end
end
