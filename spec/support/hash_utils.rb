def recursive_keys(hash)
  hash.each_with_object([]) do |(k, v), keys|
    keys << k
    keys.concat(recursive_keys(v)) if v.is_a?(Hash)
  end
end

def deep_open_struct_to_hash(object)
  object.each_pair.with_object({}) do |(key, value), hash|
    hash[key] = value.is_a?(OpenStruct) ? deep_open_struct_to_hash(value) : value
  end
end
