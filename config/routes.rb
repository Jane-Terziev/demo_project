require 'versionable'
require 'sidekiq/web'

ActionDispatch::Routing::Mapper.include Versionable

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    api_version version: :v1, options: { defaults: { format: :json } }, default: true do
      resources :posts, controller: '/posts/ui/posts'
    end
  end
end

