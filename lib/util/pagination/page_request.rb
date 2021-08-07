require_relative '../optional'

module Pagination
  class PageRequest
    attr_reader :page, :size

    # TODO: consider adding validations for page & size (must be larger than 0)
    def initialize(page, size)
      self.page = page
      self.size = size
    end

    # Pages are indexed starting from 1
    def offset
      (page - 1) * size
    end

    # TODO: implement in subclasses
    def sort
      {}
    end

    def to_optional
      Optional.of(self)
    end

    def ==(other)
      page == other.page && size == other.size
    end

    alias eql? ==

    def hash
      [page, size].hash
    end

    private

    attr_writer :page, :size
  end
end
