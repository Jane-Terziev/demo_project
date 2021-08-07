class SimpleThreadFactory
  def call(task)
    task.call
  end
end
