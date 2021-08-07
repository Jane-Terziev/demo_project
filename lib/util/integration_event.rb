class IntegrationEvent < RailsEventStore::Event
  def ==(other)
    data == other.data && self.class == other.class
  end

  alias eql? ==

  def hash
    data.hash
  end
end
