require_relative 'synchronized_mapper_wrapper'

class SynchronizedExpandingMapperWrapper < SynchronizedMapperWrapper
  def push_value(value)
    if value.respond_to?(:each)
      value.each do |item|
        producing_queue << item
      end
    else
      super
    end
  end
end
