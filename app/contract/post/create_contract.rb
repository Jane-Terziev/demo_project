require 'util/application_contract'

class Post
  class CreateContract < ApplicationContract
    params do
      required(:title).value(
          :str?,
          :filled?,
          min_size?: Post::MIN_TITLE_LENGTH,
          max_size?: Post::MAX_TITLE_LENGTH
      )

      required(:body).value(:str?, :filled?, max_size?: Post::MAX_BODY_LENGTH)
    end

    def validated_classes
      [Post, nil]
    end
  end
end