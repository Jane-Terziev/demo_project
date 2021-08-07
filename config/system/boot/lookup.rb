DemoProject::Container.boot(:lookup) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'lookup', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end

  start do
    register('util.lookup.service_factory', memoize: true) { SimpleLookupTableService }
  end
end
