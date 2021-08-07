class QueryCacheKeyGenerator
  def call(query)
    builder = QueryCacheKeyBuilder.for_query(query.class)

    query.attributes.each do |name, value|
      builder.with_property(name, value)
    end

    builder.build
  end
end
