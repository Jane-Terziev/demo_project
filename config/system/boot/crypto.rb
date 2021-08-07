require 'fileutils'

DemoProject::Container.boot(:crypto) do
  init do
    Dir[File.join(Rails.root, 'lib', 'util', 'crypto', '*.rb')].each do |file|
      require File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end

  start do
    register('util.crypto.token_generator', Crypto::SecureTokenGenerator.new)
  end
end
