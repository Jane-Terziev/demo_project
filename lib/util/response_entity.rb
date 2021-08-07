class ResponseEntity
  def self.payload(payload)
    new(code: 200, message: 'success', data: payload)
  end

  def self.success
    payload({})
  end

  def self.accepted
    new(code: 202, message: 'accepted', data: {})
  end

  def self.no_content
    new(code: 204, message: 'success', data: {})
  end

  def initialize(code:, message:, data:)
    self.code = code
    self.message = message
    self.data = data
  end

  private

  attr_accessor :code, :message, :data
end
