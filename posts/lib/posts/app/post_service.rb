module Posts
  module App
    class PostService < ApplicationService
      include DemoProject::Import[
                  post_repository: 'posts.domain.post_repository',
                  event_publisher: 'events.publisher'
              ]

      def create_post(command)
        post = transaction_template.transaction do
          Optional.of_nullable(post_repository.create_new(title: command.title, body: command.body))
              .and_then { |it| post_repository.save!(it) }
              .get
        end

        event_publisher.publish_all(post.domain_events)
      end

      def update_post(command)
        post = transaction_template.transaction do
          post_repository.find_by_id(command.id)
              .and_then { |it| it.update_post(title: command.title, body: command.body) }
              .and_then { |it| post_repository.save!(it) }
              .or_else_raise { ApiError::RecordNotFound }
        end

        event_publisher.publish_all(post.domain_events)
      end

      def archive_post(id)
        post = transaction_template.transaction do
          post_repository.find_by_id(id)
              .and_then { |it| it.archive }
              .and_then { |it| post_repository.save!(it) }
              .or_else_raise { ApiError::RecordNotFound }
        end

        event_publisher.publish_all(post.domain_events)
      end
    end
  end
end