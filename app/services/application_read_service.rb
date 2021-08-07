require 'util/mapping/page_mapper'

class ApplicationReadService
  include DemoProject::Import[transaction_template: 'persistence.transaction_template']

  def self.call(*args, &block)
    new.call(*args, &block)
  end

  def map_with(page:, mapper:)
    Mapping::PageMapper.map_with(
        page,
        mapper
    )
  end

  def map_into(source:, mapper:)
    mapper.call(source)
  end
end
