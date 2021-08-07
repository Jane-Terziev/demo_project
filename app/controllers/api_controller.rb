require 'util/optional'
require 'util/pagination/web_support'
require 'util/filter/composite_filters'
require 'util/filter/advanced_filter_parser'
require 'util/sort/web_support'
require 'util/sort/sort'
require 'util/errors/application_error'
require 'util/rate_limit/counting_rate_limiter'

class ApiController < ActionController::API
  include DemoProject::Import[
              validator:     'util.contract_validator',
          ]

  # Error handling
  rescue_from ApplicationError do |error|
    render json: error.as_json, status: error.code
  end
  rescue_from(ActiveRecord::RecordNotFound) do |ex|
    render_error(ex.message, 'record_not_found', 404)
  end
  rescue_from(ActiveRecord::RecordInvalid) do |ex|
    render_error(ex.message, 'record_invalid', 400)
  end
  rescue_from(ActionController::ParameterMissing) do |ex|
    render_error(ex.message, 'bad_request', 422)
  end
  rescue_from(RateLimit::ThrottlingError) do |ex|
    render_error(ex.message, 'rate_limit_reached', 429)
  end

  def render_error(message, error, code)
    msg = Optional.of_nullable(message).map { |it| { value: it } }.or_else({})
    render json: { message: msg, error: error, code: code }, status: code
  end

  # Helper method
  def render_success(status = :ok, location = nil)
    render json: as_json(data: {}, message: 'success', status: Http::STATUS_OK), status: status, location: location
  end

  def as_json(data:, message:, status:)
    {
        data:    data,
        message: message,
        code:    status
    }
  end

  def page_params
    params.permit(:page, :page_size)
  end

  def sort_params
    params.permit(:sort)
  end

  def page_request
    Optional.of(page_params.to_h)
        .filter { |it| !it.empty? }
        .map    { |it| Pagination::WebSupport::PageRequest[it] }
        .or_else(nil)
  end

  def filter
    Optional
        .of_nullable(params.to_unsafe_h['filters'])
        .or_else([])
  end

  def sort
    Optional.of(sort_params.to_h)
        .filter { |it| !it.empty? }
        .map    { |it| Sort::WebSupport::Sort[it] }
        .or_else(Sort::Sort.empty)
  end
end
