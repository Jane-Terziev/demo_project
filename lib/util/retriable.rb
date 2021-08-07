module Retriable
  def retriable(on:, max_retries:, backoff: 1.second)
    retry_count = 0
    begin
      yield
    rescue *on => error
      retry_count += 1
      raise error if retry_count > max_retries
      sleep(rand(backoff.to_i))
      retry
    end
  end

  module_function :retriable
end
