require_relative 'default_cache_key_generator'

class CacheKeyBuilder
  SEPARATOR = '/'
  WILDCARD = '*'

  def self.for_class(klass, key_generator = DefaultCacheKeyGenerator.new)
    new(klass, key_generator)
  end

  def initialize(klass, key_generator)
    self.cache_key     = klass.name.dup
    self.key_generator = key_generator
    self.parameters    = Hash.new
  end

  def for_method(method_name)
    cache_key.concat("#{SEPARATOR}uncached_#{method_name}")
    self
  end

  def with_parameter(parameter_name, parameter)
    parameters[parameter_name] = key_generator.call(parameter)
    self
  end

  alias with_property with_parameter

  def build
    key = cache_key.dup
    parameters.each do |parameter_name, parameter_value|
      key.concat("#{SEPARATOR}#{parameter_name}#{SEPARATOR}#{parameter_value}")
    end

    key
  end

  private

  attr_accessor :cache_key, :key_generator, :parameters
end
