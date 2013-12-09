require 'safe_yaml'
require 'active_support/core_ext/hash/indifferent_access'

module Understudy
  class Config
    def self.from_file path
      file = File.open path
      YAML.load(file, safe: true).with_indifferent_access
    end

    def self.find_files path
      Dir[File.join(path, '**/*.yml')].map { |f| File.basename f, File.extname(f) }
    end
  end
end
