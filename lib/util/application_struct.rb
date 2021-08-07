require 'util/caching/cacheable'

class ApplicationStruct < Dry::Struct
  transform_keys(&:to_sym)

  transform_types do |type|
    if type.default?
      type.constructor do |value|
        value.nil? ? Dry::Types::Undefined : value
      end
    else
      type
    end
  end

  def ==(other)
    attributes == other.attributes
  end

  alias eql? ==

  def hash
    attributes.hash
  end

  def cache_key
    attributes.each.inject('') do |cache_key, (name, value)|
      cache_key.concat("#{name}/#{value.hash}/")
    end
  end
end
