DemoProject::Container.boot(:util) do
  init do

    Dir[File.join(Rails.root, 'lib', 'util', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end

    Dir[File.join(Rails.root, 'lib', 'util', '**', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end

    Dir[File.join(Rails.root, 'lib', 'util', 'caching', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end

  start do
    register('util.job_scheduler', memoize: true) { JobScheduler.new }
    register('util.cache_manager', CacheManager.new(cache_store: Rails.cache))
    register('util.html_sanitizer', HtmlSanitizer)
    register('util.contract_validator', memoize: true) { ContractValidator.new }
  end
end
