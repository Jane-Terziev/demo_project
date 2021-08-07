class PipelineBuilderFactory
  def initialize(executor_service, default_thread_factory)
    self.executor_service = executor_service
    self.default_thread_factory = default_thread_factory
  end

  def new_builder(pipeline_name)
    PipelineBuilder.new(executor_service, default_thread_factory, pipeline_name)
  end

  private

  attr_accessor :executor_service, :default_thread_factory
end
