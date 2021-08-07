require 'simplecov'
SimpleCov.start do
  add_filter %w[config]
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'
require 'dry/container/stub'
require 'util/events/event_subscription_manager'
require 'util/events/no_op_event_repository'

require 'rake'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Dotenv.overload ".env.test.local"

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include(RequestUtilities::JsonHelpers, type: :request)
  config.include(ActiveSupport::Testing::TimeHelpers)
  config.include(ActionCable::TestHelper)

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  DemoProject::Container.enable_stubs!


  config.before :suite do
    @event_client = RailsEventStore::Client.new(
        repository: NoOpEventRepository.new,
        dispatcher: RubyEventStore::Dispatcher.new
    )
    DemoProject::Container.stub('events.client', @event_client)
    DemoProject::Container.stub('concurrent.async_job_scheduler', ImmediateJobScheduler.new)
    @event_publisher = DemoProject::Container.resolve('events.publisher')
    DemoProject::Container.stub('events.publisher', @event_publisher)
    EventSubscriptionManager.new.call(@event_publisher)
  end

  config.before :each do
    @event_publisher = DemoProject::Container.resolve('events.publisher')
    DemoProject::Container.stub('persistence.transaction_template', TestTransactionTemplate.new)
  end

  config.after :each do
    DemoProject::Container.each_key do |key|
      DemoProject::Container.unstub(key) unless key == 'events.publisher' || key == 'concurrent.async_job_scheduler'
    end
  end

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end