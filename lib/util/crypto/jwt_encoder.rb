require 'jwt'

module Crypto
  class JWTEncoder
    ALGORITHM = 'RS256'.freeze

    def initialize(key_pair_path, issuer:, audience:)
      self.key_pair = OpenSSL::PKey::RSA.new(File.read(key_pair_path))
      self.issuer   = issuer
      self.audience = audience
    end

    def call(token)
      payload = { sub: token.value, exp: token.expire_at.to_i, iss: issuer, iat: Time.now.to_i, aud: [issuer] }
      JWT.encode payload, key_pair, ALGORITHM, { algorithm: ALGORITHM }
    end

    def from_jwt(jwt)
      JWT.decode jwt, key_pair.public_key, true, { aud: issuer, algorithm: ALGORITHM, verify_iat: true, verify_aud: true }
    end

    private

    attr_accessor :key_pair, :issuer, :audience
  end
end
