class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n

  def has_duplicates(array)
    array.uniq.size != array.size
  end
end
