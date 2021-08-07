module Dry
  module Parser
    module Types
      class EnumType < BaseType
        def get_field_type_class_name
          @constrained_type.name
        end

        def to_swagger
          super.merge({ enum: @constrained_type.values })
        end
      end
    end
  end
end