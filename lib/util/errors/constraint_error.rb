require_relative 'application_error'
require 'http/status_codes'

class ConstraintError < ApplicationError
  attr_reader :constraint_violations, :toplevel_class_name, :class_names

  def initialize(constraint_violations, toplevel_class_name, class_names = [])
    self.constraint_violations = constraint_violations
    self.toplevel_class_name = toplevel_class_name
    self.class_names = class_names
  end

  alias message constraint_violations

  def code
    Http::STATUS_UNPROCESSABLE_ENTITY
  end

  def messages(params_key = nil, current_hash = self.message)
    results = []
    current_hash.each do |attribute, value|
      if value.class == Array
        results.concat(value.map do |m|
          "#{human_attribute_name(params_key, attribute)}#{m}"
        end)
      elsif value.class == Hash
        results.concat(messages(attribute, value))
      end
    end
    results
  end

  def error
    'constraint_violation'
  end

  private

  attr_writer :constraint_violations, :toplevel_class_name, :class_names

  def human_attribute_name(params_key, attribute)
    clazz_name = (params_key.nil? || params_key.class == Integer) ? self.toplevel_class_name : self.class_names[params_key]
    clazz_name.constantize.human_attribute_name(attribute)
  end
end
