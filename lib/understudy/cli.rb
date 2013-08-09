require 'ostruct'
require 'fileutils'
require 'logger'

module Understudy
  class CLI < Thor

    desc "perform [job]", "Perform backup [job]"
    method_option :verbose, type: :boolean, banner: "Enable verbose output mode", aliases: "-v", default: false
    method_option "first-time", type: :boolean, banner: "Force first-time run", aliases: "-f", default: false
    def perform(job)
      ENV['PATH'] += ":/etc/understudy"
      ENV['TMPDIR']='/tmp/understudy/'

      log = Logger.new(STDOUT)
      log.level = options[:verbose] ? Logger::DEBUG : Logger::INFO
      log.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end

      job_name = job

      config_file = "/etc/understudy/#{job_name}.conf"

      log.error "Cannot find '#{config_file}'" unless File.exist? config_file

      data_dir = "/tmp/understudy-#{job_name}"

      FileUtils.mkdir_p data_dir

      lockfile = File.open( "#{data_dir}/LOCK", File::RDWR|File::CREAT, 0644 )
      unless lockfile.flock File::LOCK_EX|File::LOCK_NB
        log.error "Job #{job_name} is already running"
      end
      lockfile.puts $$
      lockfile.flush

      config = OpenStruct.new

      # Any options that aren't our options go to rdiff-backup
      our_options = %w{source dest command}

      rdiff_args = []

      File.read( config_file ).split( /\n/ ).each do |line|
        line.sub! /#.*$/, ''
        line.sub! /^\s+/, ''
        line.sub! /\s+$/, ''
        next if line.empty?

        line =~ /^([-\w]+)(\s+=\s+(.*))?$/ or raise "Strange line in config: #{line}"
        key = $1
        val = $3
        if our_options.member? key
          config.send "#{key}=".to_sym, val
        else
          rdiff_args.push "--#{key}" + ( val ? "=#{val}" : "" )
        end
      end

      log.error "Missing 'dest' config option" unless config.dest
      log.error "Missing 'source' config option" unless config.source

      rdiff_data = "#{config.dest}/rdiff-backup-data"
      exists = File.directory? rdiff_data

      if exists && options["first-time"]
        log.error "Cannot force first time, destination '#{config.dest}' already exists"
        return 1
      elsif !exists && !options["first-time"]
        log.error "Destination '#{config.dest}' does not appear to exist, try again with --first-time"
        return 1
      end

      run config.command if config.command

      command = []

      command << "--terminal-verbosity=5" if options[:verbose]
      command << "--print-statistics"

      command += rdiff_args

      command << config.source
      command << config.dest

      run command, log
    end

    private
    def run(command, log)
      backup = RdiffSimple::RdiffBackup.new
      friendly = nil
      succes = false
      if command.is_a? Array
        friendly = command.map { |i| i =~ /[^-=\/\.\w]/ ? "#{i}" : i }.join ' '
        log.debug "Running: #{friendly}"
        success = backup.execute friendly
      else
        friendly = command
        log.debug "Running: #{friendly}"
        success = backup.execute friendly
      end

      log.info backup.output_log
      if success
        log.debug "Backup successful"
      else
        log.error "Could not run #{friendly}"
      end
    end
  end
end
