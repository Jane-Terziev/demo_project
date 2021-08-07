require 'util/types'
require 'util/optional'
require_relative 'page_request'

module Pagination
  module WebSupport
    PageRequest = Types.Constructor(Pagination::PageRequest) do |values|
      Optional
        .of_nullable(values)
        .map { |it| it[:page] && it[:page_size] ? Pagination::PageRequest.new(values[:page].to_i, values[:page_size].to_i) : nil }
        .or_else(nil)
    end
  end
end
