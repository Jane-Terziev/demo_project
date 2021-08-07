require_relative '../../lib/util/retriable'

class ApplicationService
  include DemoProject::Import[transaction_template: 'persistence.transaction_template']
  include Retriable

  def self.call(*args, &block)
    new.call(*args, &block)
  end
end
