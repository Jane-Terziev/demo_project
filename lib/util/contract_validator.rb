require_relative 'errors/constraint_error'

class ContractValidator
  def validate(input_hash, contract)
    result = contract.call(input_hash)
    return result.to_h if result.success?

    raise ConstraintError.new(result.errors.to_h, *contract.validated_classes)
  end

  def errors(input_hash, contract)
    contract.call(input_hash).errors.to_h
  end
end
