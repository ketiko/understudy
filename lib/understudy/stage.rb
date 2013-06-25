module Understudy
  module Stage
    DEFAULT_DIRECTORY = '/etc/understudy/'

    class << self
      def setup(directory = nil)
        config_dir = directory ||= DEFAULT_DIRECTORY

        hostname = `hostname`
        config_file = File.join(config_dir, "#{hostname.chomp}.config")

        FileUtils.mkdir_p(config_dir) unless File.exists?(config_dir)
        FileUtils.touch(config_file)
      end
    end
  end
end
