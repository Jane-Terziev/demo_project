require_relative 'proc_mapping_rule'

module Mapping
  class SimpleMapRule < ProcMappingRule
    def initialize(definition, property_name)
      super(definition, property_name)
    end
  end
end
