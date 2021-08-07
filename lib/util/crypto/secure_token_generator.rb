module Crypto
  class SecureTokenGenerator
    ALGORITHM = 'HS256'

    def call(expire_at)
      Token.new(SecureRandom.hex(16), expire_at)
    end

    def encode(payload)
      JWT.encode(payload, ENV['TOKEN_SECRET_KEY'], ALGORITHM)
    end

    def encode_token(expire_at)
      token = call(expire_at)
      encode(jti: token.value, exp: token.expire_at.to_i)
    end
  end
end
