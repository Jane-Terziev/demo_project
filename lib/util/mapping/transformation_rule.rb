require 'util/optional'
require_relative 'map_rule'

module Mapping
  class TransformationRule < MapRule
    def initialize(definition, nested_class, rule)
      super(definition)
      self.nested_class = nested_class
      self.wrapped_rule = rule
    end

    def call(source)
      Optional
        .of_nullable(source)
        .map { definition.map_into(wrapped_rule.call(source), nested_class) }
        .or_else(nil)
    end

    private

    attr_accessor :nested_class, :wrapped_rule
  end
end
