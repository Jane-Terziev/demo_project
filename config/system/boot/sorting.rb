DemoProject::Container.boot(:sorting) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'sort', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end
end
