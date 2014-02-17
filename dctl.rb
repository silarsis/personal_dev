#!/usr/bin/ruby1.9.3
#
# Script to provision docker instances
#
# Set "DCTL_CONFIG" to the name of your docker config file if you want
# a sane default (eg. "dev" to always use the "/vagrant/docker/dev.yaml"
# file by default).

require 'docker'
require 'yaml'
require 'optparse'
require 'logger'

LOG = Logger.new STDOUT
LOG.level = Logger::WARN

class DockerCommands
	def initialize options
		Docker.validate_version!
		load_config options[:fnames]
		@main_ip = `ifconfig docker0 | grep 'inet addr'`.split(':')[1].split[0]
	end

	def self.parse(args)
		options = OpenStruct.new
		options.fnames = []
		optparse = OptionParser.new do |opts|
			cmds = DockerCommands.instance_methods(false).map { |x| x.to_s }.join(', ')
			opts.banner = "Usage: #{$0} [#{cmds}]"
			opts.on("-f", "--file FILENAME", "Load config from FILENAME, can be given multiple times") do |fname|
				options.fnames << fname
			end
			opts.on("-l", "--list", "List available config filenames") do
				puts configFiles
			end
			opts.on("-v", "--verbose", "Verbose logging") do
				LOG.level = Logger::DEBUG
			end
			opts.on_tail('-h', '--help', 'Show this message') do
				puts opts
				puts "There must always be a config file, either via '-f' or the 'DCTL_CONFIG' environment variable"
				exit
			end
		end
		optparse.parse!
		options.fnames << ENV['DCTL_CONFIG'] if ENV.has_key? 'DCTL_CONFIG' and options.fnames.empty? and !ENV['DCTL_CONFIG'].empty?
		options
	end

	def create
		imagesToCreate.each_pair do |name, data|
			puts "Creating Image #{name}"
			data['container']['Env'] = enhanceEnvironment(data['container'].fetch('Env', []))
			Docker::Image.create('fromImage' => data['container']['Image'])
		end
	end

	def run
		containersConfiguredAndNotRunning.each_pair do |name, data|
			puts "Running Container #{name}"
			Docker::Container.create(data['container']).start(data['run'])
		end
	end

	def status
		containers = containersConfiguredAndRunning
		if !containers.empty?
			puts "Containers running:"
			puts containers.map{ |k, v| "  #{k}"}
		end
		containers = containersConfiguredAndNotRunning
		if !containers.empty?
			puts "Containers not running:"
			puts containers.map { |k, v| "  #{k}"}
		end
		containers = containersRunningAndNotConfigured
		if !containers.empty?
			puts "Extra containers running:"
			puts containers.map{ |k, v| "  #{k}"}
		end
	end

	def stop
		containersConfiguredAndRunning.each { |c| c['running'].stop }
	end

	def provision
		create
		run
	end

	def restart
		stop
		start
	end

	private

	def load_config fnames
		@config = {}
		fnames.each do |fname|
			fname = findYAML fname
			LOG.debug "Loading #{fname}"
			@config.update YAML.load_file(fname)
			@config.each_pair do |name, data|
				if data.has_key? 'import'
					fname = findYAML data['import']
					LOG.debug "  Loading #{fname}"
					@config.update YAML.load_file(fname)
				end
			end
		end
		updateConfigWithLiveData
		LOG.debug(@config)
	end

	def updateConfigWithLiveData
		Docker::Container.all.each do |container|
			imageName = container.json['Config']['Image']
			configEntry = @config.find{ |k, v| v.has_key? 'container' and v['container']['Image'] == imageName }
			if configEntry.nil?
				@config[imageName] = {'running' => container}
			else
				configEntry[1]['running'] = container
			end
		end
	end

	def findYAML fname
		if !fname.end_with?('.yaml') and File.exist?("/vagrant/docker/#{fname}.yaml")
			fname = "/vagrant/docker/#{fname}.yaml"
		end
		fname
	end

	def self.configFiles
		Dir.glob('/vagrant/docker/*.yaml').map { |fname| File.basename(fname, '.yaml') }
	end

	def enhanceEnvironment(env)
		env << "MAIN_IP=#{@main_ip}"
	end

	def imageNames
		Docker::Image.all.map{ |image| image.info['RepoTags'][0].split(':')[0]}
	end

	def containers
		@config.map{ |container| container.json['Config']['Image'] }
	end

	def imagesToCreate
		liveImages = imageNames
		@config.select{ |k, v| v.has_key? 'container' and !liveImages.include?(v['container']['Image']) }
	end

	def containersConfiguredAndRunning
		@config.select{ |k, v| v.has_key? 'container' and v.has_key? 'running' }
	end

	def containersConfiguredAndNotRunning
		@config.select{ |k, v| v.has_key? 'container' and !v.has_key? 'running' }
	end

	def containersRunningAndNotConfigured
		@config.select{ |k, v| !v.has_key? 'container' and v.has_key? 'running' }
	end
end

options = DockerCommands.parse(ARGV)
if options.fnames.empty?
	puts "No config file provided, please use '-f' or DCTL_CONFIG to specify one of: #{DockerCommands.configFiles.join(', ')}"
end
if !options.fnames.empty?
	dc = DockerCommands.new :fnames => options.fnames
	ARGV.each { |arg| dc.method(arg).call }
end