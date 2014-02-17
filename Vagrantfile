# For AWS, you need the following ENV variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_KEYPAIR_NAME
# SSH_PRIVKEY
#
# For Rackspace, you need the following ENV variables:
# RS_USERNAME
# RS_API_KEY
# RS_PUBLIC_KEY
# SSH_PRIVKEY
#
# This was largely cribbed from https://github.com/relateiq/docker_public/blob/master/Vagrantfile

# The following two methods were taken from https://github.com/mitchellh/vagrant/issues/1874
# and should be removed and replaced when Vagrantfile can manage installation of plugins.
# We do this so we can install https://github.com/dotless-de/vagrant-vbguest
def plugin(name, version = nil, opts = {})
  @vagrant_home ||= opts[:home_path] || ENV['VAGRANT_HOME'] || "#{ENV['HOME']}/.vagrant.d"
  plugins = JSON.parse(File.read("#@vagrant_home/plugins.json"))

  if !plugins['installed'].include?(name) || (version && !version_matches(name, version))
    cmd = "vagrant plugin install"
    cmd << " --entry-point #{opts[:entry_point]}" if opts[:entry_point]
    cmd << " --plugin-source #{opts[:source]}" if opts[:source]
    cmd << " --plugin-version #{version}" if version
    cmd << " #{name}"

    result = %x(#{cmd})
  end
end

def version_matches(name, version)
  gems = Dir["#@vagrant_home/gems/specifications/*"].map { |spec| spec.split('/').last.sub(/\.gemspec$/,'').split(/-(?=[\d]+\.?){1,}/) }
  gem_hash = {}
  gems.each { |gem, v| gem_hash[gem] = v }
  gem_hash[name] == version
end

plugin "vagrant-vbguest"

# Use the pre-built vagrant box: http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/
BOX_NAME = ENV['BOX_NAME'] || "docker-ubuntu-12.04.3-amd64-vbox"
BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
VBOX_VERSION = ENV['VBOX_VERSION'] || "4.3.2"

Vagrant.configure("2") do |config|
  config.vm.box = BOX_NAME

  # No forwarded ports on this - we assume the vagrant server should only
  # be accessible locally. If this is wrong, feel free to add forwards in here.
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provision "docker"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    aws.region = ENV['AWS_REGION'] || 'ap-southeast-2'
    aws.instance_type = 'm1.small'
    aws.ami = "ami-9fc25ea5"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['SSH_PRIVKEY']
  end

  config.vm.provider :rackspace do |rs|
    config.ssh.private_key_path = ENV["SSH_PRIVKEY"]
    rs.username = ENV["RS_USERNAME"]
    rs.api_key  = ENV["RS_API_KEY"]
    rs.public_key_path = ENV["RS_PUBLIC_KEY"]
    rs.flavor   = /512MB/
    rs.image    = /Ubuntu/
  end

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box = BOX_NAME
    override.vm.box_url = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vmwarefusion.box"
    #override.vm.synced_folder ".", "/vagrant", disabled: true
    f.vmx["displayName"] = "docker"
  end

end