class JobScheduler
  def schedule(job, *args, &block)
    job.class_eval(&block).perform_later(*args)
  end
end
