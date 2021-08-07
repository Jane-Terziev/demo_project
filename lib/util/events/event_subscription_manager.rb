class EventSubscriptionManager
  def call(event_publisher)
    event_publisher.subscribe(::Post::CreatedEventHandler,  to:  [::Post::CreatedEvent])
    event_publisher.subscribe(::Post::UpdatedEventHandler,  to:  [::Post::UpdatedEvent])
    event_publisher.subscribe(::Post::ArchivedEventHandler, to:  [::Post::ArchivedEvent])
  end
end
