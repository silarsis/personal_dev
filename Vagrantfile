# For AWS, you need the following ENV variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_KEYPAIR_NAME (default 'aws-syd')
# SSH_PRIVKEY (default '~/.ssh/aws-syd.pem')
#
# In addition, your AWS should have a "vagrant" security group available. The AWS setup
# is pretty much locked down to ap-southeast-2b atm - if you want a different region,
# you'll need change AWS_REGION and AWS_AMI, and find an appropriate image at
# http://cloud-images.ubuntu.com/locator/ec2/
#
# This was largely cribbed from https://github.com/relateiq/docker_public/blob/master/Vagrantfile

## Ubuntu 12.04 (need docker support compiled in)
#VBOX_NAME = "docker-ubuntu-12.04.3-amd64-vbox"
#VBOX_URI = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
#VMWAREBOX_NAME = "docker-ubuntu-12.04.3-amd64-vmwarefusion"
#VMWAREBOX_URI = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vmwarefusion.box"
#AWS_REGION = 'ap-southeast-2'
#AWS_AMI = 'ami-9fc25ea5'

# Ubuntu 13.10
VBOX_NAME = "ubuntu-13.10-amd64-daily"
VBOX_URI = 'http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box'
VMWAREBOX_NAME = 'ubuntu-13.10-amd64-vmware'
VMWAREBOX_URI = 'http://brennovich.s3.amazonaws.com/saucy64_vmware_fusion.box'
AWS_REGION = 'ap-southeast-2'
AWS_AMI = 'ami-0329b739'

# The following two methods were taken from https://github.com/mitchellh/vagrant/issues/1874
# and should be removed and replaced when Vagrantfile can manage installation of plugins.
# We do this so we can install https://github.com/dotless-de/vagrant-vbguest
def plugin(name, version = nil, opts = {})
  @vagrant_home ||= opts[:home_path] || ENV['VAGRANT_HOME'] || "#{ENV['HOME']}/.vagrant.d"
  plugins = File.exists?("#@vagrant_home/plugins.json") ?
    JSON.parse(File.read("#@vagrant_home/plugins.json")) :
    nil

  if plugins.nil? || !plugins['installed'].include?(name) || (version && !version_matches(name, version))
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
plugin "facter"
#plugin "vagrant-cachier"

Vagrant.configure("2") do |config|
  # No forwarded ports on this because we've added an actual IP on the private network below
  #config.vm.network "forwarded_port", guest: 4040, host: 4040

  config.vm.provision "docker"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provider 'virtualbox' do |vbox|
    #config.cache.scope = :box
    # XXX At the moment, the network config is getting run twice,
    # so the following hacks around that. I don't know why that's happening.
    #config.vm.network :public_network, bridge: "en0: Wi-Fi (AirPort)"
    config.vm.network :private_network, ip: "10.42.42.2" unless config.vm.networks.index { |item| item[0] == :private_network }
    config.vm.box = VBOX_NAME
    config.vm.box_url = VBOX_URI
    vbox.name = VBOX_NAME
    vbox.gui = true
    # Disable DNS NAT to fix performance issues
    vbox.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    # Using Facter to give us a machine with a quarter the memory and half the cpus of host
    vbox.memory = [Facter.memorysize_mb.to_i/4, 512].max
    vbox.cpus = [Facter.processorcount.to_i/2, 1].max
    vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
    # Map a couple of drives through
    config.vm.synced_folder File.expand_path("~"), "/home/vagrant/host_home"
    config.vm.synced_folder File.expand_path("~/.docker_registry"), "/tmp/registry"
    config.vm.synced_folder File.expand_path("./squid3"), "/var/spool/squid3"
  end

  config.vm.provider :aws do |aws, override|
    config.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME'] || 'aws-syd'
    aws.region = ENV['AWS_REGION'] || AWS_REGION
    aws.instance_type = 'm1.small'
    aws.security_groups = ['vagrant']
    aws.ami = ENV['AWS_AMI'] || AWS_AMI
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['SSH_PRIVKEY']
  end

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box = VMWAREBOX_NAME
    override.vm.box_url = VMWAREBOX_URI
    #override.vm.synced_folder ".", "/vagrant", disabled: true
    f.vmx["displayName"] = "docker"
  end

end
