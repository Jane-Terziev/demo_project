DemoProject::Container.boot(:filtering) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'filter', '**', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end
end
