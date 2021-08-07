require 'util/application_struct'

module Posts
  module Domain
    class Post
      class UpdateCommand < ApplicationStruct
        attribute :id, Types::Integer
        attribute :title, Types::String
        attribute :body, Types::String
      end
    end
  end
end