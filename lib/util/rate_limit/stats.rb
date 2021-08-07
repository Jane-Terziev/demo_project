require 'util/application_struct'

module RateLimit
  class Stats < ApplicationStruct
    attribute :invocations, Types::Integer
    attribute :remaining, Types::Integer
    attribute :reset_at, Types::Integer

    def over_limit?
      remaining.zero?
    end
  end
end
