class ActiveRecordCacheKeyGenerator
  def call(record)
    record.cache_key_with_version
  end
end
