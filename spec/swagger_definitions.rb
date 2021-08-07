module SwaggerDefinitions
  SWAGGER_DOCS_PARSER = Dry::Parser::SwaggerDocumentationConverter.new

  def swagger_definitions
    {
        constraint_violation_error: constraint_violation_error,
        record_not_found_error:     record_not_found_error,
        list_posts:                 list_posts_def,
        post_details:               post_details_def
    }
  end

  def uncounted_pagination_properties(items)
    {
        type: :object, properties: {
        timestamp:     { type: :string, format: :datetime },
        num_pages:     { type: :integer, minimum: 1, 'x-nullable': true },
        current_page:  { type: :integer, minimum: 1 },
        last_page:     { type: :boolean },
        next_page:     { type: :integer, 'x-nullable': true },
        previous_page: { type: :integer, 'x-nullable': true },
        items: items
    }, required: %i[timestamp current_page last_page items]
    }
  end

  def pagination_properties(items)
    {
        type: :object, properties: {
        timestamp:     { type: :string, format: :datetime },
        num_pages:     { type: :integer, minimum: 1 },
        current_page:  { type: :integer, minimum: 1 },
        total_count:   { type: :integer, minimum: 0 },
        last_page:     { type: :boolean },
        next_page:     { type: :integer, 'x-nullable': true },
        previous_page: { type: :integer, 'x-nullable': true },
        items: items
      }, required: %i[timestamp num_pages current_page total_count last_page items]
    }
  end

  def list_posts_def
    pagination_properties(
        {
            type: :array, items: SWAGGER_DOCS_PARSER.call(Posts::App::ReadModel::Mappers::ListPostMapper::PostDTO)
        }
    )
  end

  def post_details_def
    SWAGGER_DOCS_PARSER.call(Posts::App::ReadModel::Mappers::PostDetailsMapper::PostDTO)
  end
end

