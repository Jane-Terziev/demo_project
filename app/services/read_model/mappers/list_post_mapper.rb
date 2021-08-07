require 'util/mapping/mapper'

module ReadModel
  module Mappers
    class ListPostMapper < ::Mapping::Mapper
      class PostDTO < PostDto
        attribute :number_of_comments, Types::Integer
      end

      mapping_definition(for_class: PostDTO)

      def call(source)
        map_into(source, PostDTO)
      end
    end
  end
end