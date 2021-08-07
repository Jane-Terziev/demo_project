class CompactingJsonSerializer
  def serialize(object)
    rejector = lambda do |*args|
      value = args.last
      value.delete_if(&rejector) if value.respond_to?(:delete_if)
      (value.kind_of?(Hash) && value.empty? || value.nil?)
    end

    object.as_json.delete_if(&rejector)
  end
end
