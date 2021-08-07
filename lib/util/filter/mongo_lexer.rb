require_relative 'tokens'
require_relative 'nodes'
require 'util/errors/application_error'

module Filter
  class LexerError < ApplicationError
    def error
      self.class.name.underscore.downcase
    end

    def code
      Http::STATUS_BAD_REQUEST
    end
  end

  InvalidOperatorError = Class.new(LexerError)
  InvalidConjunctionError = Class.new(LexerError)

  class MongoLexer
    TOKEN_LITERALS = {
      'gte'            => GreaterThanOrEqualToken,
      'gt'             => GreaterThanToken,
      'lt'             => LessThanToken,
      'lte'            => LessThanEqualNode,
      'eq'             => EqualToken,
      'in'             => InToken,
      'matches'        => StringContainsToken,
      'array_contains' => ArrayContainsToken,
      'neq'            => NotEqualsToken,
      'scan'           => ScanToken,
      'and'            => AndToken,
      'or'             => OrToken
    }.with_indifferent_access.freeze

    class Node
      attr_reader :tokens, :branched

      def initialize(tokens, branched = false)
        self.tokens   = tokens.to_a
        self.branched = branched
      end

      def pop
        tokens.pop
      end

      def peek
        tokens.last
      end

      def empty?
        tokens.empty?
      end

      def split
        self.branched = true
        Node.new(pop.last.first)
      end

      private

      attr_writer :tokens, :branched
    end

    def initialize(array)
      self.tokens = [Node.new(and: array)]
    end

    def next_token
      return NilToken.new if tokens.empty?
      tokens.pop while tokens.last.empty? && !tokens.last.branched

      node = tokens.last

      if node.empty?
        tokens.pop
        EndGroupToken.new
      else
        wrap_raw_token(node)
      end
    end

    private

    attr_accessor :tokens

    def wrap_raw_token(node)
      raw_token = node.peek
      symbol = raw_token.first

      if symbol.to_sym == :or || symbol.to_sym == :and
        #tokens << Node.new(raw_token.last.first)
        new_node = node.split
        tokens << Node.new([], true) unless node.empty?
        tokens << new_node
        wrap_connective_token(symbol)
      else
        node.pop
        wrap_filter_token(raw_token)
      end
    end

    def wrap_filter_token(raw_token)
      symbol = raw_token.first
      FilterToken.new(
        symbol,
        raw_token.last.map { |(operator, value)| TOKEN_LITERALS.fetch(operator).new(value) }
      )
    rescue KeyError => e
      raise InvalidOperatorError.new("Unknown operator: #{e.key}")
    end

    def wrap_connective_token(symbol)
      TOKEN_LITERALS.fetch(symbol.to_s).new(symbol)
    rescue KeyError => e
      raise InvalidConjunctionError.new("Unknown conjunction: #{e.key}")
    end
  end
end
