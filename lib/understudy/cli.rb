require 'thor'
require 'logger'
require 'rdiff_simple'
require 'active_support/core_ext/object/blank'
require_relative 'config'

module Understudy
  class CLI < Thor
    include Thor::Actions

    attr_accessor :rdiff, :logger

    def initialize args=[], options={}, config={}
      super

      @logger = Logger.new 'understudy.log'
      @rdiff = RdiffSimple::RdiffBackup.new do |r|
        r.logger = @logger
      end
    end

    def self.source_root
      File.expand_path "../../../templates", __FILE__
    end

    desc "prepare [job]", "Create [job] template file"
    method_option :config_directory, type: :string, default: '/etc/understudy',
      alias: '-d', desc: 'Directory to write the job configuration file to'
    def prepare job
      destination_file = "#{job}.yml"
      template "job.yml", "#{File.join options[:config_directory], destination_file}"
    end

    desc "perform backup", "Perform backup"
    method_option :job, type: :string, alias: '-j', desc: 'Specific job to run'
    method_option :config_directory, type: :string, default: '/etc/understudy',
      alias: '-d', desc: 'Directory to search for job configuration file'
    method_option :verbose, type: :boolean, alias: '-v', desc: 'Verbose output'
    def perform
      logger.level = Logger::INFO if options.verbose?

      jobs = Array[options[:job]] unless options[:job].blank?
      jobs ||= Config.find_files options[:config_directory]
      jobs.each do |job|
        say "Performing job #{job}" if options.verbose?
        logger.info "Performing job #{job}"

        config = config_for job, options[:config_directory]

        source = config.delete :source
        destination = config.delete :destination

        failed = rdiff.backup(source, destination, config) != 0
        error "Job #{job} failed"
        logger.error "Job #{job} failed"
      end

    end

    private
    def config_for job, config_directory
      config_file = File.join config_directory, "#{job}.yml"
      Config.from_file config_file
    end
  end
end
