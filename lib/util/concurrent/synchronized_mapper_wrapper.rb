require_relative 'abstract_task_wrapper'

class SynchronizedMapperWrapper < AbstractTaskWrapper
  def self.wrap(consuming_queue, producing_queue, mapper, previous_task, lock, name, step)
    new(consuming_queue, producing_queue, mapper, previous_task, lock, name, step)
  end

  def initialize(consuming_queue, producing_queue, mapper, previous_task, lock, name)
    self.consuming_queue  = consuming_queue
    self.producing_queue  = producing_queue
    self.mapper           = mapper
    self.previous_task    = previous_task
    self.lock             = lock
    self.name             = name
  end

  private

  def do_work
    value = mapper.call(pop_value)
    after_pop(value)
    push_value(value)
    value
  end

  def check_for_more_work
    throw :done if previous_task.finished? && consuming_queue.empty?
  end

  def pop_value
    begin
      Timeout.timeout(2.seconds) { consuming_queue.pop }
    rescue Timeout::Error
      retry unless previous_task.finished?
      throw :done
    end
  end

  def after_pop(_); end

  def push_value(value)
    producing_queue << value
  end

  attr_accessor :consuming_queue, :producing_queue, :mapper, :previous_task, :lock, :name
end
