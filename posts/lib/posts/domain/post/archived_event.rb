require 'util/integration_event'

module Posts
  module Domain
    class Post
      class ArchivedEvent < IntegrationEvent
        def id
          data[:id]
        end

        def title
          data[:title]
        end
      end
    end
  end
end