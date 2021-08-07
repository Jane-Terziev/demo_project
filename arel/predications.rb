require 'arel'
require_relative 'nodes/full_text_match'
require_relative 'visitors/my_sql'

module Arel
  module Predications
    def text_scan(value, opts = nil)
      Nodes::FullTextMatch.new(self, value, opts)
    end
  end
end
