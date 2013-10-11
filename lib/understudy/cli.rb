module Understudy
  class CLI < Thor
    def initialize(args=[], options={}, config={})
      super

      log = Logger.new(STDOUT)
      log.level = Logger::INFO
      @rdiff = options.delete(:rdiff) { RdiffSimple::RdiffBackup.new(log) }
    end

    desc "perform [job]", "Perform backup [job]"
    method_option :config_directory, type: :string, default: '/etc/understudy',
      alias: '-d', desc: 'Directory to search for job configuration file'
    def perform(job)
      config = config_for(job, options[:config_directory])

      source = config.delete(:source)
      destination = config.delete(:destination)

      @rdiff.execute(source, destination, config)
    end

    private
    def config_for(job, config_directory)
      config_file = File.join(config_directory, "#{job}.yml")
      YAML.load(File.open(config_file), safe: true).symbolize_keys!
    end
  end
end
