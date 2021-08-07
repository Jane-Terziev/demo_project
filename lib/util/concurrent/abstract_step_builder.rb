class AbstractStepBuilder
  def initialize(task, pipeline_builder, executor_service, default_thread_factory, default_task_wrapper, step_factory)
    self.task             = task
    self.pipeline_builder = pipeline_builder
    self.executor_service = executor_service
    self._thread_factory  = default_thread_factory
    self._task_wrapper    = default_task_wrapper
    self.step_factory     = step_factory
    self._instances       = 1
    self.queue_size       = 1000
  end

  def instances(count)
    self._instances = count
    self
  end

  def queue(size)
    self.queue_size = size
    self
  end

  def thread_factory(factory)
    self._thread_factory = factory
    self
  end

  def task_wrapper(wrapper)
    self._task_wrapper = wrapper
    self
  end

  def and
    add_step
    pipeline_builder
  end

  def build
    add_step
    pipeline_builder.build
  end

  private

  attr_accessor :task, :pipeline_builder, :executor_service, :_thread_factory, :_task_wrapper, :step_factory, :_instances,
                :queue_size

  def add_step
    pipeline_builder.send(:steps) << build_step
  end

  def build_step
    raise NotImplementedError
  end
end
