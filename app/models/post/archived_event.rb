require 'util/integration_event'

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