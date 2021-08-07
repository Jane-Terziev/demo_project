require 'util/optional'

class ApplicationError < StandardError
  attr_reader :error, :message, :code

  def initialize(message = nil, error = nil, code = nil)
    self.message = Optional.of_nullable(message).map { |it| { value: it } }.or_else({})
    self.error = error
    self.code  = code
  end

  def as_json(_options = {})
    {
      message: message,
      error:   error.downcase,
      code:    code
    }
  end

  private

  attr_writer :error, :message, :code
end
