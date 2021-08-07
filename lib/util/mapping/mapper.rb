require_relative 'map_definition'

module Mapping
  class Mapper
    class_attribute :definitions,   default: {}

    def self.mapping_definition(for_class:, &block)
      definition = MapDefinition.new(for_class)

      definitions[for_class] = definition
      definition.instance_eval(&block) if block_given?
    end

    def self.import_definitions(from:)
      self.definitions = from.definitions.merge(definitions)
    end

    def map_into(source, target)
      definitions.fetch(target).call(source)
    end
  end
end
