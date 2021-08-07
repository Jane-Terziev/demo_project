DemoProject::Container.boot(:posts) do |app|
  start do
    app.register('posts.domain.post_repository',            Posts::Domain::Post)
    app.register('posts.domain.read_model.post_repository', Posts::Domain::ReadModel::Post)

    app.register('posts.app.post_service',            memoize: true) { Posts::App::PostService.new }
    app.register('posts.app.read_model.post_service', memoize: true) { Posts::App::ReadModel::PostService.new }

    event_publisher = app['events.publisher']

    event_publisher.subscribe(Posts::Ui::Post::CreatedEventHandler,  to:  [Posts::Domain::Post::CreatedEvent])
    event_publisher.subscribe(Posts::Ui::Post::UpdatedEventHandler,  to:  [Posts::Domain::Post::UpdatedEvent])
    event_publisher.subscribe(Posts::Ui::Post::ArchivedEventHandler, to:  [Posts::Domain::Post::ArchivedEvent])
  end
end