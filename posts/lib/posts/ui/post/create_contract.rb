require 'util/application_contract'

module Posts
  module Ui
    module Post
      class CreateContract < ApplicationContract
        params do
          required(:title).value(
              :str?,
              :filled?,
              min_size?: ::Posts::Domain::Post::MIN_TITLE_LENGTH,
              max_size?: ::Posts::Domain::Post::MAX_TITLE_LENGTH
          )

          required(:body).value(:str?, :filled?, max_size?: ::Posts::Domain::Post::MAX_BODY_LENGTH)
        end

        def validated_classes
          [Post, nil]
        end
      end
    end
  end
end