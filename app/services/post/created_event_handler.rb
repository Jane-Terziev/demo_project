class Post
  class CreatedEventHandler < AsyncEventHandler
    def call(event)
      puts 'CREATED EVENT CALLED'
    end
  end
end