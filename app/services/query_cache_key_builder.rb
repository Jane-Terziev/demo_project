require 'util/caching/cache_key_builder'
require 'util/caching/default_cache_key_generator'

class QueryCacheKeyBuilder < CacheKeyBuilder
  def self.for_query(query, key_generator = DefaultCacheKeyGenerator.new)
    new(query, key_generator)
  end

  def initialize(query, key_generator)
    self.cache_key     = query.name.dup
    self.key_generator = key_generator
    self.parameters    = query.attribute_names.each_with_object({}) do |attribute, hash|
      hash[attribute]  = WILDCARD
    end
  end

  def for_method(_method_name)
    raise NotImplementedError, 'Cannot use this method when building up a cache key for queries'
  end
end
