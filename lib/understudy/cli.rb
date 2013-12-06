module Understudy
  class CLI < Thor
    attr_accessor :rdiff

    def initialize(args=[], options={}, config={})
      super

      @rdiff = RdiffSimple::RdiffBackup.new do |r|
        r.logger = Logger.new(STDOUT)
      end
    end

    desc "perform [job]", "Perform backup [job]"
    method_option :config_directory, type: :string, default: '/etc/understudy',
      alias: '-d', desc: 'Directory to search for job configuration file'
    def perform(job)
      config = config_for(job, options[:config_directory])

      source = config.delete(:source)
      destination = config.delete(:destination)

      rdiff.backup(source, destination, config)
    end

    private
    def config_for(job, config_directory)
      config_file = File.join(config_directory, "#{job}.yml")
      Config.from_file(config_file)
    end
  end
end
