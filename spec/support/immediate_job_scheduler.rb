class ImmediateJobScheduler
  def schedule(callable, _delay: 0.seconds)
    result = callable.call
    Concurrent::Promises.resolved_future(true, result, nil)
  rescue StandardError => e
    Concurrent::Promises.rejected_future(e)
  end
end
