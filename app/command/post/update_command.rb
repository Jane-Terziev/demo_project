require 'util/application_struct'

class Post
  class UpdateCommand < ApplicationStruct
    attribute :id, Types::Integer
    attribute :title, Types::String
    attribute :body, Types::String
  end
end