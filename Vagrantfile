ARCH = 64
CHEF_VERSION = "11.10.4"
OS = "ubuntu"
# OS = "centos"

def select_vmbox(config, os)
  suffix = (ARCH == 32 ? '-i386' : '')
  case os
  when "ubuntu"
    # Chef 11 support with opscode bento
    config.vm.box = "opscode_ubuntu-14.04#{suffix}_chef-provisionerless"
    # from https://github.com/opscode/bento
    config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04#{suffix}_chef-provisionerless.box"

  when "centos"
    version = "v20140110"
    config.vm.box = "CentOS-6.5-#{suffix}-#{version}"
    config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5#{suffix}_chef-provisionerless.box"
  end
end

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end
  config.omnibus.chef_version = CHEF_VERSION
  config.berkshelf.enabled = true
  select_vmbox config, OS
  config.vm.define OS do |c|
    c.vm.provision :chef_solo do |chef|
      chef.verbose_logging = true
      chef.add_recipe("rs_mongodb::default")
      chef.add_recipe("mongodb::replicaset")
      chef.json = {
        "build-essential" => {
          "compile_time" => true
        },
        "mongodb" => {
          "config" => {
            "port" => "27017",
            "replSet" => "rs_mongodb"
          },
          "cluster_name" => "rs_mongodb_cluster"
        },
      }
    end
    c.vm.network :forwarded_port, guest: 80, host: 8888
  end

  puts "Done."
end
