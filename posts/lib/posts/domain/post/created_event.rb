require 'util/integration_event'

module Posts
  module Domain
    class Post
      class CreatedEvent < IntegrationEvent
        def title
          data[:title]
        end

        def body
          data[:body]
        end
      end
    end
  end
end