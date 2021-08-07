module Sort
  class Sort
    attr_reader :sort_params

    def self.empty
      new({})
    end

    def initialize(params)
      self.sort_params = params
    end

    def to_query
      sort_params
    end

    def ==(other)
      sort_params == other.sort_params
    end

    alias eql? ==

    def hash
      sort_params.hash
    end

    def empty?
      sort_params.empty?
    end

    def to_s
      sort_params.map { |key, value| "#{key} #{value}" }.join(',')
    end

    private

    attr_writer :sort_params
  end
end
