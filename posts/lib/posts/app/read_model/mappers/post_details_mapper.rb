require 'util/mapping/mapper'

module Posts
  module App
    module ReadModel
      module Mappers
        class PostDetailsMapper < ::Mapping::Mapper
          class PostDTO < PostDto
            attribute :comments, Types::Array.of(CommentDto)
          end

          mapping_definition(for_class: PostDTO) do
            mapping_rule(property: :comments, into: CommentDto)
          end

          def call(source)
            map_into(source, PostDTO)
          end
        end
      end
    end
  end
end
