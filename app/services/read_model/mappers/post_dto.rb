require 'util/application_read_struct'
require 'util/types'

module ReadModel
  module Mappers
    class PostDto < ApplicationReadStruct
      attribute :id, Types::Integer
      attribute :title, Types::String
      attribute :body, Types::String
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
    end
  end
end