module Pagination
  class Page
    attr_reader :content, :page_request, :total

    def initialize(content, page_request, total)
      self.content      = content
      self.page_request = page_request
      self.total        = page_request.to_optional
                            .filter { |_| !content.empty? }
                            .filter { |it| it.offset + it.size > total }
                            .map    { |it| it.offset + content.size }
                            .or_else(total)
    end

    def size
      page_request.size
    end

    def elements
      content.size
    end

    def total_pages
      elements == 0 ? 1 : (total.to_f / size.to_f).ceil
    end

    def page_number
      page_request.page
    end

    def has_next?
      page_number < total_pages
    end

    def has_previous?
      page_number > 1
    end

    def last?
      !has_next?
    end

    def first?
      !has_previous?
    end

    def next_page
      page_number + 1 unless last?
    end

    def previous_page
      page_number - 1 unless first?
    end

    def as_json(options = {})
      {
        timestamp:     DateTime.now,
        num_pages:     total_pages,
        current_page:  page_number,
        total_count:   total,
        last_page:     last?,
        next_page:     next_page,
        previous_page: previous_page,
        items:         content.as_json(options)
      }
    end

    private

    attr_writer :content, :page_request, :total
  end
end
