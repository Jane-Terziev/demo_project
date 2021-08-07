require_relative 'abstract_task_wrapper'

class ProducerTaskWrapper < AbstractTaskWrapper
  def initialize(producing_queue, task, name)
    self.producing_queue = producing_queue
    self.task            = task
    self.name            = name
  end

  private

  attr_accessor :producing_queue

  def do_work
    value = task.call
    producing_queue << value
    value
  end
end
