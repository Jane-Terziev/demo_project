require 'util/errors/application_error'
require 'http/status_codes'

class Post
  class ArchivedError < ApplicationError
    def initialize(message, error = nil, code = nil)
      @message = message
      @error = error || 'post_archived_error'
      @code = code || Http::STATUS_UNPROCESSABLE_ENTITY
    end
  end
end