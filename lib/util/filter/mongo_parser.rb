require_relative 'nodes'
require_relative 'tokens'
require_relative 'mongo_lexer'
require 'http/status_codes'

module Filter
  class ParserError < ApplicationError
    def error
      self.class.name.underscore.downcase
    end

    def code
      Http::STATUS_BAD_REQUEST
    end
  end

  SyntaxError = Class.new(ParserError)

  class MongoParser
    OPERATOR_MAPPINGS = {
      GreaterThanOrEqualToken => GreaterThanEqualNode,
      GreaterThanToken        => GreaterThanNode,
      LessThanToken           => LessThanNode,
      LessThanEqualNode       => LessThanEqualNode,
      EqualToken              => EqualNode,
      InToken                 => InNode,
      StringContainsToken     => StringContainsNode,
      ArrayContainsToken      => ArrayContainsNode,
      NotEqualsToken          => NotEqualNode,
      ScanToken               => FullTextScanNode
    }

    def initialize(lexer)
      self.lexer = lexer
      self.current_token = self.lexer.next_token
    end

    def parse
      expression
    end

    private

    def eat(token_type)
      raise SyntaxError.new "Wrong syntax: expected #{token_type}, found: #{current_token.value}(#{current_token.type})" unless current_token.is_a?(token_type)
      self.current_token = lexer.next_token
    end

    def filter
      token = current_token
      eat(FilterToken)
      parse_filter_token(token)
    end

    def filter_group
      nodes = []

      until current_token.is_a?(EndGroupToken)
        token = current_token

        if token.is_a?(FilterToken)
          nodes << filter
        else
          nodes << expression
        end
      end

      eat(EndGroupToken)
      nodes
    end

    def expression
      token = current_token
      eat(ConnectiveToken)
      nodes = filter_group
      injector =
        case token
        when OrToken
          OrNode
        else
          AndNode
        end

      GroupedNode.new(nodes.inject { |accumulator, node| injector.new(accumulator, node) })
    end
    
    attr_accessor :current_token, :lexer

    def parse_filter_token(token)
      nodes = token.operators.map do |operator|
        OPERATOR_MAPPINGS.fetch(operator.type).new(token.field, operator.value)
      end

      nodes.inject { |accumulator, node| AndNode.new(accumulator, node) }
    rescue KeyError => e
      raise InvalidOperatorError.new("Unknown operator: #{e.key}")
    end
  end
end
