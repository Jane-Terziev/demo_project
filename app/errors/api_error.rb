require 'http/status_codes'
require 'util/errors/application_error'

module ApiError
  class RecordNotFound < ApplicationError
    def message
      @message || { value: 'Record not found' }
    end

    def error
      @error || 'record_not_found'
    end

    def code
      Http::STATUS_NOT_FOUND
    end
  end

  class InvalidRequest < ApplicationError
    def message
      @message || { value: 'Invalid Request' }
    end

    def error
      @error || 'invalid_request'
    end

    def code
      Http::STATUS_BAD_REQUEST
    end
  end

  class InvalidParameters < InvalidRequest
    def message
      @message || { value: 'Invalid parameters sent' }
    end

    def error
      @error || 'invalid_parameter'
    end
  end

  class MissingParameters < InvalidRequest
    def message
      @message || { value: 'Missing parameters' }
    end

    def error
      @error || 'missing_parameters'
    end
  end

  class InvalidQueryParameters < InvalidParameters
    def message
      { value: 'Invalid query parameters sent' }
    end

    def error
      @error || 'invalid_query_parameters'
    end
  end

  class InvalidOperator < InvalidParameters
    def initialize(operator)
      @operator = operator
    end

    def message
      { value: "Invalid operator sent '#{@operator}'" }
    end
  end

  class InvalidQuery < InvalidRequest
    def initialize(query_error)
      @query_error = query_error
    end

    def message
      { value: "Invalid Query #{@query_error}" }
    end
  end
end
