DemoProject::Container.boot(:persistence) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'persistence', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end

    register('persistence.transaction_template') { TransactionTemplate.new }
  end
end
