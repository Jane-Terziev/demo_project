DemoProject::Container.boot(:events) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'concurrent', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end

    Dir[File.join(Rails.root, 'lib', 'util', 'events', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end

  start do
    executor_service = Concurrent::ThreadPoolExecutor.new(
        min_threads:     1,
        max_threads:     (ENV['BACKGROUND_THREADS'] || 5).to_i,
        max_queue:       ENV['BACKGROUND_TASK_POOL_SIZE'].to_i,
        fallback_policy: :caller_runs
    )
    async_job_scheduler = AsyncJobScheduler.new(executor_service: executor_service)
    mapper          = ToYAMLEventMapper.new
    event_scheduler = AsyncThreadEventScheduler.new(
        job_scheduler:      async_job_scheduler,
        event_deserializer: mapper
    )

    register('concurrent.executor_service',    executor_service)
    register('concurrent.async_job_scheduler', async_job_scheduler)
    register('concurrent.pipeline_builder_factory', PipelineBuilderFactory.new(executor_service, SimpleThreadFactory.new))

    register('events.client', RailsEventStore::Client.new(
        repository: NoOpEventRepository.new,
        mapper:     mapper,
        dispatcher: RubyEventStore::ComposedDispatcher.new(
            RailsEventStore::ImmediateAsyncDispatcher.new(scheduler: ActiveJobEventScheduler.new),
            RailsEventStore::ImmediateAsyncDispatcher.new(scheduler: event_scheduler)
        )
    ))
  end
end
