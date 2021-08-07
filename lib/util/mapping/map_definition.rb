require 'util/optional'
require_relative 'transformation_rule'
require_relative 'proc_mapping_rule'
require_relative 'simple_map_rule'
require_relative 'wrap_rule'
require_relative 'mapper'

module Mapping
  class MapDefinition
    attr_reader :klass, :rules, :nested_definitions

    DefinitionError = Class.new(StandardError)

    def initialize(klass, rules = Hash.new { |h, k| h[k] = {} }, nested_definitions = Hash.new { |h, k| h[k] = {} })
      self.klass = klass
      self.rules = rules
      self.nested_definitions = nested_definitions
    end

    def mapping_rule(property:, as: nil, into: nil, &block)
      rule = Optional
               .of_nullable(as)
               .map { |it| ProcMappingRule.new(self, it) }
               .or_else_get { SimpleMapRule.new(self, property) }

      if block_given?
        raise DefinitionError, 'must provide a class if defining a nested mapping rule' unless into
      end

      if into
        nested = NestedMapDefinition.new(into, rule)
        nested.instance_eval(&block) if block_given?
        nested_definitions[property] = nested
      else
        rules[property] = rule
      end
    end

    def wrapping_rule(property:, wrap:, into:, &block)
      rule = WrapRule.new(self, wrap)

      if block_given?
        raise DefinitionError, 'must provide a class if defining a nested mapping rule' unless into
      end

      if into
        nested = NestedMapDefinition.new(into, rule)
        nested.instance_eval(&block) if block_given?
        nested_definitions[property] = nested
      else
        rules[property] = rule
      end
    end

    def call(source)
      map_into(source, klass)
    end

    def map_into(source, target)
      Optional
        .of_nullable(source)
        .map { |it| it.respond_to?(:each) ? it.map { |one| map_one(one, target) } : map_one(it, target) }
        .or_else(nil)
    end

    def rule_for_property(property)
      nested_definitions.fetch(property, rules.fetch(property, SimpleMapRule.new(self, property)))
    end

    private

    # def map_one(source, target)
    #   target.new(*target.members.map do |property|
    #     rule_for_property(property).call(source)
    #   end)
    # end

    def map_one(source, target)
      target.new(
        target
          .attribute_names
          .inject({}) do |hash, attribute_name|
          hash[attribute_name] = rule_for_property(attribute_name).call(source)
          hash
        end
      )
    end

    attr_writer :klass, :rules, :nested_definitions
  end

  class NestedMapDefinition < MapDefinition
    def initialize(klass, rule)
      existing_definition = Mapper.definitions[klass]
      existing_definition ? super(klass, existing_definition.rules, existing_definition.nested_definitions) : super(klass)
      self.transformation_rule = TransformationRule.new(self, klass, rule)
    end

    def call(source)
      transformation_rule.call(source)
    end

    private

    attr_accessor :transformation_rule
  end
end
