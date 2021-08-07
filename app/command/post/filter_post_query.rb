class Post
  class FilterPostQuery < ApplicationStruct
    attribute :filter,       Types::Any
    attribute :page_request, (Types::PageRequest.default { Pagination::PageRequest.new(1, 20).freeze })
    attribute :sort,         (Types::Sort | Sort::WebSupport::Sort)
  end
end