# UNSUPPORTED TYPES: SYMBOL, CLASS, NilClass, Array, HASH
# FOR NESTED OBJECTS, DEFINE AS DTO, FOR ARRAY, DEFINE AS Types::Array.of(DTO)

module Dry
  module Parser
    class SwaggerDocumentationConverter
      attr_accessor :class_converter

      def initialize
        self.class_converter = ClassConverter.new
      end

      def call(dto)
        documentation = generate_fields_documentation(dto.schema)
        { :type => :object, :properties => documentation[:properties], :required => documentation[:required]}
      end

      def generate_fields_documentation(dto_schema)
        documentation = { properties: {}, required: [] }
        dto_schema.name_key_map.each do |name, schema_key_object|
          documentation[:properties][name] = generate_field_properties(schema_key_object.type)
          documentation[:required] << name unless schema_key_object.type.optional?
        end
        documentation
      end

      def generate_field_properties(constrained_type)
        if is_required_nested_dto?(constrained_type)
          fields = generate_fields_documentation(constrained_type.schema)
          { :type => :object, :properties => fields[:properties], :required => fields[:required] }
        elsif is_optional_nested_dto?(constrained_type)
          fields = generate_fields_documentation(constrained_type.right.schema)
          { :type => :object, :properties => fields[:properties], :required => fields[:required], :nullable => true }
        elsif is_array_of_dto?(constrained_type)
          fields = generate_fields_documentation(constrained_type.member.schema)
          { :type => :array, :items => {:type => :object, :properties => fields[:properties], :required => fields[:required] } }
        elsif is_optional_array_of_dto(constrained_type)
          fields = generate_fields_documentation(constrained_type.right.member.schema)
          { :type => :array, :items => {:type => :object, :properties => fields[:properties], :required => fields[:required], :nullable => true } }
        else
          class_converter.call(constrained_type).to_swagger
        end
      end

      # required nested DTOs are returned as Dry::Type::Constrained, type field returns the nested DTO
      def is_required_nested_dto?(constrained_type)
        constrained_type.class.name == "Class"
      end
      # Optional nested DTOs are returned as Dry::Type::Sum::Constrained, type field has left and right rules, left rule
      # is always NilClass, right rule returns the nested DTO
      def is_optional_nested_dto?(constrained_type)
        constrained_type.respond_to?(:right) && constrained_type.right.class.name == "Class"
      end
      # This is for fields that are Types::Array.of(NestedDTO), it is returned as Dry::Type::Sum::Constrained, we can
      # get the nested DTO by calling the member method, which would return a Dry::Types::Constrained
      def is_array_of_dto?(constrained_type)
        constrained_type.name == "Array"
      end

      def is_optional_array_of_dto(constrained_type)
        constrained_type.respond_to?(:right) && constrained_type.right.name == 'Array' && constrained_type.right.member.class.name == "Class"
      end
    end
  end
end
