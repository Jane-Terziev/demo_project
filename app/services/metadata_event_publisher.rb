require 'util/optional'

class MetadataEventPublisher
  include DemoProject::Import[
            client:                  'events.client',
            current_user_repository: 'identity.current_user_repository'
          ]

  def publish(event)
    user_id = Optional.of_nullable(current_user_repository.authenticated_identity).map(&:id).or_else(nil)
    client.with_metadata({ user_id: user_id }) do
      client.publish(event)
    end
  end

  def publish_all(events)
    events.each { |event| publish(event) }
  end

  def subscribe(subscriber, to:)
    client.subscribe(subscriber, to: to)
  end

  def mapper
    client.send(:mapper)
  end
end
