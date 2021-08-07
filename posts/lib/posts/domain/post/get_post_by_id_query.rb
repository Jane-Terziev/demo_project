module Posts
  module Domain
    class Post
      class GetPostByIdQuery < ApplicationStruct
        attribute :id, Types::Integer
      end
    end
  end
end