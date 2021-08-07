module Posts
  module Ui
    module Post
      class ArchivedEventHandler < AsyncEventHandler
        def call(event)
          puts 'ARCHIVED EVENT CALLED'
        end
      end
    end
  end
end