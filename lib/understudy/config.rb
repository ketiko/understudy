module Understudy
  class Config
    def self.from_file(path)
      YAML.load(File.open(path), safe: true).symbolize_keys!
    end
  end
end
