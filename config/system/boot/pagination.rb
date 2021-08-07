DemoProject::Container.boot(:pagination) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'pagination', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end
end
