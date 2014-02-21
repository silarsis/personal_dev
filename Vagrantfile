# For AWS, you need the following ENV variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_KEYPAIR_NAME
# SSH_PRIVKEY
#
# In addition, your AWS should have a "vagrant" security group available. The AWS setup
# is pretty much locked down to ap-southeast-2b atm.
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

Vagrant.configure("2") do |config|
  # No forwarded ports on this - we assume the vagrant server should only
  # be accessible locally. If this is wrong, feel free to add forwards in here.
  #config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provision "docker"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provider :vbox do |vbox, override|
    config.vm.box = VBOX_NAME
    config.vm.box_url = VBOX_URI
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