class Pipeline
  attr_reader :name, :id

  def initialize(executor_service, steps, name)
    self.executor_service = executor_service
    self.steps            = steps
    self.future           = nil
    self.name             = name
  end

  def start
    self.future = Concurrent::Promises.zip_futures_on(executor_service, *steps.map(&:call))
  end

  private

  def future
    Optional.of_nullable(@future)
  end

  attr_accessor :executor_service, :steps
  attr_writer :future, :name
end
