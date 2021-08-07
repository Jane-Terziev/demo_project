require_relative '../../../app/services/application_service'

class SimpleLookupTableService < ApplicationService
  def initialize(lookup_table_repository:, transaction_template:)
    self.lookup_table_repository = lookup_table_repository
    self.transaction_template    = transaction_template
  end

  def create(body)
    transaction_template.transaction { lookup_table_repository.create!(body) }
  end

  def destroy(id)
    transaction_template.transaction { lookup_table_repository.find(id).destroy! }
  end

  def filter_page(filter, pageable, sort)
    lookup_table_repository.filter_page(filter, pageable, sort)
  end

  private

  attr_accessor :lookup_table_repository, :transaction_template
end
