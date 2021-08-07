class SimpleContainerRegistry < Dry::Container::Registry
  def call(container, key, item, options)
    super(container, key, item, memoize: options.fetch(:memoize_test, false))
  end
end
