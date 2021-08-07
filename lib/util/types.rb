require 'util/pagination/page_request'
require 'util/sort/sort'
require 'util/sort/sort_formatter'
require 'util/optional'
require 'util/html_sanitizer'

module Types
  include Dry::Types()

  class URI
    attr_reader :value

    def self.empty
      new('')
    end

    def initialize(string)
      self.value = URI(string)
    end

    def to_s
      value.to_s
    end

    def ==(other)
      to_s == other.to_s
    end

    alias eql? ==

    def hash
      value.hash
    end

    private

    attr_writer :value
  end

  Email             = Types::String.constructor(&:downcase).constrained(format: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/i)
  StrippedString    = Types::String.constructor(&:strip)

  DateTime = Types::DateTime.constructor(&:to_datetime)
  Date = Types::Date.constructor(&:to_date)

  PageRequest = Types.Instance(Pagination::PageRequest)
  Sort        = Types.Instance(Sort::Sort)

  Set = Types.Constructor(::Set) { |array| array.to_set }
  HtmlSafeString = Types.Constructor(String) { |string| HtmlSanitizer.sanitize(string).gsub(/\s/, '<br />') }
end
