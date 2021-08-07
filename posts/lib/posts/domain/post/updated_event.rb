require 'util/integration_event'

module Posts
  module Domain
    class Post
      class UpdatedEvent < IntegrationEvent
        def id
          data[:id]
        end

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