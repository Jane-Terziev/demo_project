module Dry
  module Parser
    module Types
      class SumType < BaseType
        def get_field_type_class_name
          @constrained_type.right.name
        end
      end
    end
  end
end