module Mapping
  class MapRule
    attr_reader :definition

    def initialize(definition)
      self.definition = definition
    end

    private

    attr_writer :definition
  end
end
