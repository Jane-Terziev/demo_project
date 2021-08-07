DemoProject::Container.boot(:arel) do
  init do
    Dir[File.join(Rails.root, 'arel', '**', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end
end
