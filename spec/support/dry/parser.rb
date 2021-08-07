module Dry
  module Parser
    SWAGGER_FIELD_TYPE_DEFINITIONS = {
        "String" => { type: :string },
        "Integer" => { type: :integer },
        "TrueClass" => { type: :boolean },
        "FalseClass" => { type: :boolean },
        "TrueClass | FalseClass" => { type: :boolean },
        "BigDecimal" => { type: :decimal },
        "Float" => { type: :float },
        "DateTime" => { type: :string, format: :datetime },
        "Date" => { type: :string, format: :date },
        "Time" => { type: :string, format: :time }
    }
  end
end