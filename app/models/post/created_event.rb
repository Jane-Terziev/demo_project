require 'util/integration_event'

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