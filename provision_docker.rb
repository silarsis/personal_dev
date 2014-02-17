#!/usr/bin/ruby1.9.3
#
# Script to provision docker instances

require 'docker'
require 'yaml'
require 'optparse'

class DockerCommands
	def initialize
		@config = YAML.load_file('/vagrant/docker.yaml')
		@main_ip = `ifconfig docker0 | grep 'inet addr'`.split(':')[1].split[0]
		Docker.validate_version!
		# Ensure that we're registered with shipyard, assuming shipyard is running
		if `pgrep 'shipyard-agent'` == ""
			key = `/vagrant/shipyard-agent -url http://#{@main_ip}:8000 -register 2>&1 | grep Agent | awk '{ print $5 }'`
			fork do
				exec("/vagrant/shipyard-agent -url http://#{@main_ip}:8000 -key #{key}")
			end
		end
	end

	def create
		imagesToCreate.each_pair do |name, data|
			puts "Creating Image #{name}"
			data['container']['Env'] = enhanceEnvironment(data['container'].fetch('Env', []))
			Docker::Image.create('fromImage' => data['container']['Image'])
		end
	end

	def run
		containersToRun.each_pair do |name, data|
			puts "Running Container #{name}"
			Docker::Container.create(data['container']).start(data['run'])
		end
	end

	def ps
		puts "Containers running:"
		puts containers.map{ |c| "  #{@config.find{ |k, v| v['container']['Image'] == c }[0]}"}
		puts "Containers not running:"
		puts containersToRun.map{ |k, v| "  #{k}"}
	end

	def stop
		Docker::Container.all.map { |c| c.delete }
	end

	private

	def enhanceEnvironment(env)
		env << "MAIN_IP=#{@main_ip}"
	end

	def images
		Docker::Image.all.map{ |image| image.info['Repository']}
	end

	def containers
		Docker::Container.all.map{ |container| container.json['Config']['Image'] }
	end

	def imagesToCreate
		@config.select{ |k, v| !images.include?(v['container']['Image']) }
	end

	def containersToRun
		@config.select{ |k, v| !containers.include?(v['container']['Image']) }
	end
end

valid_commands = DockerCommands.instance_methods(false)
optparse = OptionParser.new do |opts|
	opts.banner = "Usage: #{$0} #{valid_commands}"
	opts.on_tail('-h', '--help', 'Show this message') do
		puts opts
		exit
	end
end
optparse.parse!
dc = DockerCommands.new
if ARGV.empty?
	dc.create
	dc.run
else
	dc.method(ARGV.pop).call
end

