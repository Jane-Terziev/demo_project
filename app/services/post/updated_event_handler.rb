class Post
  class UpdatedEventHandler < AsyncEventHandler
    def call(event)
      puts 'UPDATED EVENT CALLED'
    end
  end
end