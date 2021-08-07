require 'util/application_struct'

module Posts
  module Domain
    class Post
      class CreateCommand < ApplicationStruct
        attribute :title, Types::String
        attribute :body, Types::String
      end
    end
  end
end