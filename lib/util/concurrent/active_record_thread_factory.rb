class ActiveRecordThreadFactory
  def call(task)
    Rails.application.executor.wrap do
      task.call
    end
  end
end
