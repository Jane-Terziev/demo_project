require 'util/integration_event'

class Comment
  class CreatedEvent < IntegrationEvent
    def post_id
      data[:post_id]
    end

    def post_title
      data[:post_title]
    end

    def comment_title
      data[:comment_title]
    end

    def comment_body
      data[:comment_body]
    end
  end
end