require 'util/application_struct'

class Post
  class CreateCommand < ApplicationStruct
    attribute :title, Types::String
    attribute :body, Types::String
  end
end