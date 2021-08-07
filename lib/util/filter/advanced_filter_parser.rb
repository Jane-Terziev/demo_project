require_relative 'arel_visitor'
require_relative 'mongo_lexer'
require_relative 'mongo_parser'

module Filter
  class AdvancedFilterParser
    def self.from_query_params(table, query_params)
      return ArelFilter.empty if query_params.blank?

      ArelFilter.new(
        ArelVisitor
        .for_model(table)
        .tap { |it| it.visit(MongoParser.new(MongoLexer.new(query_params)).parse) }
        .send(:collector),
        table.arel_table
      )
    end
  end
end
