module Posts
  module Ui
    module Post
      class UpdatedEventHandler < AsyncEventHandler
        def call(event)
          puts 'UPDATED EVENT CALLED'
        end
      end
    end
  end
end