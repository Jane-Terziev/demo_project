module Dry
  module Parser
    module Types
      class PrimitiveType < BaseType
        def get_field_type_class_name
          @constrained_type.name
        end
      end
    end
  end
end