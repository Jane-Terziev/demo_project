class DefaultCacheKeyGenerator
  def call(object)
    Digest::SHA1.hexdigest(object.to_json)
  end
end
