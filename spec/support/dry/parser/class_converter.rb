module Dry
  module Parser
    class ClassConverter
      CLASS_MAPPER = {
          'Dry::Types::Constrained'            => 'Dry::Parser::Types::PrimitiveType',
          'Dry::Types::Constructor'            => 'Dry::Parser::Types::PrimitiveType',
          'Dry::Types::Constrained::Coercible' => 'Dry::Parser::Types::PrimitiveType',
          'Dry::Types::Nominal'                => 'Dry::Parser::Types::PrimitiveType',
          'Dry::Types::Sum::Constrained'       => 'Dry::Parser::Types::SumType',
          'Dry::Types::Sum'                    => 'Dry::Parser::Types::SumType',
          'Dry::Types::Enum'                   => 'Dry::Parser::Types::EnumType'
      }

      def call(constrained_type)
        CLASS_MAPPER.fetch(constrained_type.class.name).constantize.new(constrained_type)
      end
    end
  end
end
