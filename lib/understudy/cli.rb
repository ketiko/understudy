module Understudy
  class CLI < Thor
    def initialize(args=[], options={}, config={})
      super

      log = Logger.new(STDOUT)
      log.level = Logger::INFO
      @rdiff = RdiffSimple::RdiffBackup.new(log)
    end

    desc "perform [job]", "Perform backup [job]"
    def perform(job_name)
      config = config_for(job_name)

      source = config.delete(:source)
      destination = config.delete(:destination)

      @rdiff.execute(source, destination, config)
    end

    private
    def config_for(job_name)
      config_file = "/etc/understudy/#{job_name}.yml"
      YAML.load(File.open(config_file)).symbolize_keys!
    end
  end
end
