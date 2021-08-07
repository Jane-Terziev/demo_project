require 'util/pagination/page'
require 'util/pagination/uncounted_page'
require 'util/optional'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.next_id
    next_value_statement = <<~SQL
      SELECT AUTO_INCREMENT
      FROM information_schema.tables
      WHERE table_schema="#{connection.current_database}" AND table_name="#{table_name}"
    SQL

    next_value = connection.select_all(next_value_statement).to_a.first['AUTO_INCREMENT']

    update_value = <<~SQL
      ALTER TABLE #{table_name} AUTO_INCREMENT = #{next_value + 1}
    SQL

    connection.execute(update_value)
    next_value
  end

  def self.find_by_id(id)
    Optional.of_nullable(find_by(primary_key => id))
  end

  def self.get_by_id(id)
    find_by_id(id).or_else_raise { ApiError::RecordNotFound.new("Cannot find #{name.demodulize} with id: #{id}") }
  end

  def self.find_all_by_id(ids)
    where(primary_key => ids).to_a
  end

  def self.filter_by(filter_by)
    where(sanitize_sql(Filter::AdvancedFilterParser.from_query_params(self, filter_by).to_query))
  end

  def self.filter_page(filter, pageable, sort)
    filtered = filter_by(filter).order(sort.to_query)
    paginate(filtered, pageable)
  end

  def self.paginate(result_set, page_request)
    Pagination::Page.new(paginate_with_offset(result_set, page_request).to_a, page_request, result_set.count)
  end

  def self.uncounted_paginate(result_set, page_request)
    Pagination::UncountedPage.new(paginate_with_offset(result_set, page_request).to_a, page_request)
  end

  def self.paginate_with_offset(result_set, page_request)
    result_set.offset(page_request.offset).limit(page_request.size)
  end

  def self.save(record)
    record.tap(&:save)
  end

  def self.save!(record)
    record.tap(&:save!)
  end

  def self.delete!(record)
    record.tap(&:destroy!)
  end
end
