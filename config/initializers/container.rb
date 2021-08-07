Dir[File.join(Rails.root, 'lib', 'util', 'injection', '*.rb')].each do |file|
  require File.join(File.dirname(file), File.basename(file, File.extname(file)))
end

Dry::System::Rails.container do
  # Turn off memoization in tests
  config.registry = Rails.env.test? ? SimpleContainerRegistry.new : Dry::Container::Registry.new

  # Repositories
  register('identity.current_user_repository', Identity::SecurityContext)
  register('post_repository',                  Post)
  register('read_model.post_repository',       ReadModel::Post)

  register('post_service',            memoize: true) { PostService.new }
  register('read_model.post_service', memoize: true) { ReadModel::PostService.new }

  # event publisher, depends on current user repository
  register('events.publisher') { MetadataEventPublisher.new }
end