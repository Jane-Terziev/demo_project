module Cacheable
  extend ActiveSupport::Concern

  class_methods do
    def cache(method, cache_manager: nil, cache_duration: nil, cache_key_generator: nil)
      alias_method "uncached_#{method}", method

      define_method(method) do |*args, &block|
        method_definition = method("uncached_#{method}")
        method_parameters = method_definition.parameters.map(&:last)
        key_generator     = Optional.of_nullable(cache_key_generator).map(&:new).or_else(DefaultCacheKeyGenerator.new)

        key_builder = CacheKeyBuilder.for_class(self.class, key_generator).for_method(method)
        method_parameters.each_with_index do |parameter, index|
          key_builder.with_parameter(parameter, args[index])
        end

        cache_key = key_builder.build
        manager   = Optional.of_nullable(cache_manager).or_else(DemoProject::Container.resolve('util.cache_manager'))

        manager.fetch(cache_key).or_else_get do
          result = send("uncached_#{method}", *args, &block)
          manager.put(cache_key, result, expires_in: cache_duration)
          result
        end
      end
    end
  end
end
