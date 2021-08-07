require_relative 'abstract_filter'

module Filter
  class ArelFilter < AbstractFilter
    attr_reader :arel_expression, :arel_table

    def self.empty
      new
    end

    def initialize(arel_expression = nil, arel_table = nil)
      self.arel_expression = arel_expression
      self.arel_table      = arel_table
    end

    def to_query
      empty? ? '' : arel_expression.to_sql
    end

    def to_json(*_args)
      to_s
    end

    def empty?
      arel_expression.nil?
    end

    def ==(other)
      arel_expression == other.arel_expression
    end

    def hash
      arel_expression.hash
    end

    private

    attr_writer :arel_expression, :arel_table
  end
end
