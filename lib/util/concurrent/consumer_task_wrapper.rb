require_relative 'abstract_task_wrapper'

class ConsumerTaskWrapper < AbstractTaskWrapper
  def initialize(queue, task, name, previous_step)
    self.queue     = queue
    self.consumer  = task
    self.name      = name
    self.previous_step = previous_step
  end

  private

  attr_accessor :queue, :consumer, :previous_step

  def do_work
    value = pop_value
    consumer.call(value)
    value
  end

  def pop_value
    Timeout.timeout(2.seconds) { queue.pop }
  rescue Timeout::Error
    retry unless previous_step.finished?
    throw :done
  end
end
