require 'util/injection/active_job_strategy'

Dry::AutoInject::Strategies.register('active_job', Dry::AutoInject::Strategies::ActiveJobStrategy)
