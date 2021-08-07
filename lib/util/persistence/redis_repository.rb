class RedisRepository
  def initialize(client:)
    self.client = client
  end

  # TODO: potentially warn users if they call a read method from within a transaction block
  # as all commands are executed on the server at once when committed.
  def transaction
    begin
      client.multi
      yield
    ensure
      client.exec
    end
  end

  def watch(key)
    client.watch(key) do
      result = yield
      client.unwatch
      result
    end
  end

  def find(key)
    Optional.of_nullable(client.get(key)).map { |it| deserialize(it) }
  end

  def ttl(key)
    Optional.of(client.ttl(key)).filter { |it| it >= 0 }
  end

  private

  def serialize(record)
    record.to_yaml
  end

  def deserialize(serialized)
    YAML.load(serialized)
  end

  attr_accessor :client
end
