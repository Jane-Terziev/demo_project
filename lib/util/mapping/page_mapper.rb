require_relative 'mapper'

module Mapping
  class PageMapper < Mapper
    class PageDTO < ApplicationStruct
      attribute :timestamp, Types::DateTime.optional
      attribute :num_pages, Types::Integer.optional
      attribute :current_page, Types::Integer
      attribute :total_count, Types::Integer.optional
      attribute :last_page, Types::Bool
      attribute :next_page, Types::Integer.optional
      attribute :previous_page, Types::Integer.optional
      attribute :items, Types::Array
    end

    mapping_definition(for_class: PageDTO) do
      mapping_rule(property: :timestamp, as: ->(_) { DateTime.now })
      mapping_rule(property: :num_pages, as: :total_pages)
      mapping_rule(property: :current_page, as: :page_number)
      mapping_rule(property: :total_count, as: :total)
      mapping_rule(property: :last_page, as: :last?)
      mapping_rule(property: :next_page, as: :next_page)
      mapping_rule(property: :previous_page, as: :previous_page)
      mapping_rule(property: :items, as: ->(page) { page.instance_variable_get("@items") } )
    end

    def call(page)
      map_into(page, PageDTO)
    end

    def self.map_with(page, item_mapper)
      page.instance_variable_set(:@items, item_mapper.call(page.content))
      dto = new.call(page)
      dto
    end
  end
end
