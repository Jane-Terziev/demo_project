require 'util/optional'

class CacheManager
  DEFAULT_CACHE_EXPIRATION = 20.minutes

  def initialize(cache_store:)
    self.cache_store = cache_store
  end

  def fetch(cache_key)
    Optional.of_nullable(cache_store.fetch(cache_key))
  end

  def put(cache_key, value, expires_in: nil)
    cache_store.write(cache_key, value, expires_in: Optional.of_nullable(expires_in).or_else(DEFAULT_CACHE_EXPIRATION))
  end

  # TODO: This is assuming a redis-backed cache store!!
  def delete_matched(partial_cache_key)
    cache_store.delete_matched("*#{partial_cache_key}*")
  end

  private

  attr_accessor :cache_store
end
