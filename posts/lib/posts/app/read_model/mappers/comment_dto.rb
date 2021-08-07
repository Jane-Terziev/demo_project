require 'util/application_read_struct'

module Posts
  module App
    module ReadModel
      module Mappers
        class CommentDto < ApplicationReadStruct
          attribute :id, Types::Integer
          attribute :title, Types::String
          attribute :body, Types::String
          attribute :created_at, Types::DateTime
          attribute :updated_at, Types::DateTime
        end
      end
    end
  end
end