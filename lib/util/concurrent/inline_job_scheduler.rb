class InlineJobScheduler
  def schedule(callable, delay: 0.seconds)
    sleep(delay)
    callable.call
  end
end
