require_relative 'sort'

module Sort
  class SortFormatter
    VALID_REGEX = /\A((\w+)((\.)?(\w+))?)+\z/.freeze

    def self.from_query_string(query_string)
      sort_params = query_string.split(',')
      Sort.new(Hash[sort_params.map(&method(:format))])
    end

    def self.format(parameter)
      direction = 'ASC'
      sorting_attribute = parameter
      if parameter.start_with?('-')
        direction = 'DESC'
        sorting_attribute = parameter[1..-1]
      end
      raise ApiError::InvalidRequest, "Invalid sort parameter: #{parameter}" unless VALID_REGEX.match?(sorting_attribute)

      [sorting_attribute, direction]
    end
  end
end
