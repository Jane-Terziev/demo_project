require_relative 'token'

module Crypto
  class TokenDecoder
    def initialize(token_parser:)
      self.token_parser = token_parser
    end

    def decode(token)
      Token.from_jwt(token_parser.new(token).decode)
    end

    private

    attr_accessor :token_parser
  end
end
