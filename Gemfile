source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3.6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Background task processing (consider using AMQP as a substitute)
gem 'sidekiq', '~> 6'
gem 'sidekiq-failures'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0'

# OAuth2 provider (needed for client credentials flow)
gem 'doorkeeper', '~> 5.2'

# Request parameter validation
gem 'dry-validation', '~> 1.3'

gem 'dry-struct', '~> 1.0'

gem 'dry-system', '0.17.0'

gem 'dry-system-rails', '~> 0.3'

gem 'httparty', '~> 0.17'

gem 'rails_event_store', '~> 0.42'

# Swagger documentation
gem 'rswag-api', '~> 2.2'
gem 'rswag-ui',  '~> 2.2'

gem 'jwt', '~> 2.2'

gem 'scenic-mysql_adapter', '~> 1'

# Supplies TimeOfDay class that includes parsing, strftime, comparison, and arithmetic.
gem 'tod'

gem 'composite_primary_keys', '~> 12.0'
gem 'kaminari'
gem 'rack-dev-mark'
gem 'sidekiq-scheduler'

# Sitemap
gem 'sitemap_generator'
gem 'store_base_sti_class'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails',             '~> 2'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'ruby_jard'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'rspec-activemodel-mocks',  '~> 1.1'
  gem 'rspec-rails',              '~> 5.0.1'
  gem 'rswag-specs',              '~> 2.2'
  gem 'shoulda-matchers',         '~> 4.5.1'
  gem 'bullet'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubycritic', '~> 4.2'
  gem 'letter_opener_web'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rubocop-rails', require: false
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
