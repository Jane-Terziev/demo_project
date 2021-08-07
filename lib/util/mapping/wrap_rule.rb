require_relative 'map_rule'

module Mapping
  class WrapRule < MapRule
    attr_reader :extractors

    def initialize(definition, extractors)
      super(definition)

      if !extractors.kind_of?(Hash)
        self.extractors = extractors.inject({}) do |map, extractor|
          map.tap { |it| it[extractor] = extractor }
        end
      else
        self.extractors = extractors
      end
    end

    def call(source)
      table = extractors.inject({}) do |raw_table, (extractor, target)|
        raw_table.tap { |it| it[target] = extractor.to_proc.call(source) }
      end

      OpenStruct.new(table)
    end

    private

    attr_writer :extractors
  end
end
