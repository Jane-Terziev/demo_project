require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
Bundler.require(*Rails.groups)

module DemoProject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.action_cable.mount_path = '/websocket'
    config.action_cable.url = [/ws:\/\/*/, /wss:\/\/*/]

    config.api_only = true

    config.active_job.queue_adapter = :sidekiq

    # IMPORT MODULES HERE
    # config.paths.add 'auth/lib', load_path: true, autoload: true
    config.paths.add 'posts/lib', load_path: true, autoload: true
    config.autoload_paths += %W[#{config.root}/lib]

    config.logger           = ActiveSupport::Logger.new(File.join(Rails.root, 'log', "#{Rails.env}.log"))
    config.logger.formatter = config.log_formatter
    config.log_tags         = %i[subdomain uuid]
    config.logger           = ActiveSupport::TaggedLogging.new(config.logger)

    config.active_record.schema_format = :sql

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    ActiveRecord::Base.store_base_sti_class = false
  end
end
