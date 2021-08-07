module Crypto
  class Token
    attr_reader :value, :expire_at

    def self.from_jwt(jwt)
      new(jwt[:jti], jwt[:exp])
    end

    def initialize(value, expire_at)
      self.value = value
      self.expire_at = expire_at
    end

    def expired?
      Time.now.to_i > expire_at.to_i
    end

    def ==(other)
      value == other.value && expire_at == other.expire_at
    end

    alias eql? ==

    def hash
      [value, expire_at].hash
    end

    def to_s
      value
    end

    private

    attr_writer :value, :expire_at
  end
end
