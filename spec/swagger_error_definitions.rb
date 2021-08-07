module SwaggerErrorDefinitions
  def default_error_json
    {
      type: :object, properties: {
        message: { type: :object },
        error:   { type: :string },
        code:    { type: :integer }
      },
      required: %w[message error code]
    }
  end

  def record_not_found_error
    {
      type: :object, properties: {
        message: { type: :object },
        error:   { type: :string, enum: %w[record_not_found] },
        code:    { type: :integer, enum: [Http::STATUS_NOT_FOUND] }
      },
      required: %w[message error code]
    }
  end

  def constraint_violation_error
    {
      type: :object, properties: {
        message: { type: :object },
        error:   { type: :string,  enum: %w[constraint_violation] },
        code:    { type: :integer, enum: [Http::STATUS_UNPROCESSABLE_ENTITY] }
      },
      required: %w[message error code]
    }
  end

  def invalid_parameters_error
    {
      type: :object, properties: {
        message: { type: :object },
        error:   { type: :string,  enum: %w[invalid_parameter invalid_query_parameters] },
        code:    { type: :integer, enum: [Http::STATUS_BAD_REQUEST] }
      },
      required: %w[message error code]
    }
  end

  def invalid_request_error
    {
      type: :object, properties: {
        message: { type: :object },
        error:   { type: :string,  enum: %w[invalid_request job_offer_archived] },
        code:    { type: :integer, enum: [Http::STATUS_BAD_REQUEST] }
      },
      required: %w[message error code]
    }
  end
end
