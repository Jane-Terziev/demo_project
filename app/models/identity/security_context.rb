module Identity
  class SecurityContext < ActiveSupport::CurrentAttributes
    attribute :authenticated_identity
  end
end
