module Understudy
  class Config
    def self.from_file path
      file = File.open path
      YAML.load(file, safe: true).symbolize_keys!
    end

    def self.find_files path
      Dir[File.join(path, '**/*.yml')].map { |f| File.basename f, File.extname(f) }
    end
  end
end
