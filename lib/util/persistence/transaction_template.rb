class TransactionTemplate
  attr_accessor :requires_new, :isolation, :joinable

  def initialize(requires_new: nil, isolation: nil, joinable: true)
    self.requires_new = requires_new
    self.isolation = isolation
    self.joinable = joinable
  end

  def transaction(requires_new: self.requires_new, isolation: self.isolation, joinable: self.joinable)
    ActiveRecord::Base.transaction(requires_new: requires_new, isolation: isolation, joinable: joinable) { yield }
  end
end
