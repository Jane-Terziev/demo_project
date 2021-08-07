module Pagination
  class UncountedPage < Page
    def initialize(content, page_request)
      self.content      = content
      self.page_request = page_request
      self.total = nil
    end

    def total_pages
      nil
    end

    def has_next?
      elements == size
    end
  end
end
