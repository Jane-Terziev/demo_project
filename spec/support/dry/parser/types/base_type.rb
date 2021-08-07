module Dry
  module Parser
    module Types
      class BaseType
        def initialize(constrained_type)
          @constrained_type = constrained_type
        end

        def to_swagger
          field_type = ::Dry::Parser::SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(get_field_type_class_name)
          field_type[:nullable] = true if @constrained_type.optional?
          field_type
        end
      end
    end
  end
end