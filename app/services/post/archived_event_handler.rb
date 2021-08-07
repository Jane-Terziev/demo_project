class Post
  class ArchivedEventHandler < AsyncEventHandler
    def call(event)
      puts 'ARCHIVED EVENT CALLED'
    end
  end
end