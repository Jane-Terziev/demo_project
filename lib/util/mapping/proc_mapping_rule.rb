require 'util/optional'
require_relative 'map_rule'

module Mapping
  class ProcMappingRule < MapRule
    def initialize(definition, mapper)
      super(definition)
      self.mapper = mapper.to_proc
    end

    def call(source)
      res = mapper.call(source)

      case res
      when Optional
        res.or_else(nil)
      else
        res
      end
    end

    private

    attr_accessor :mapper
  end
end
