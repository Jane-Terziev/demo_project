module Posts
  module Ui
    module Post
      class CreatedEventHandler < AsyncEventHandler
        def call(event)
          puts 'CREATED EVENT CALLED'
        end
      end
    end
  end
end