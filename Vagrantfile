# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

pxc_config = {
	"innodb_buffer_pool_size" => "10G",
	"innodb_log_file_size" => "1G",
	"wsrep_provider_options" => "gcache.size=2G; gcs.fc_limit=2048",
	"wsrep_slave_threads" => 16
}

Vagrant.configure("2") do |config|

	config.vm.define :node1 do |node1_config|
		node1_config.vm.box = "centos6-aws-us-east"
		node1_config.vm.hostname = "node1"

		node1_config.vm.provider :aws do |aws, override|
			aws_config = YAML::load_file(File.join(Dir.home, ".aws_secrets"))
			aws.access_key_id = aws_config.fetch("access_key_id")
			aws.secret_access_key = aws_config.fetch("secret_access_key")
			aws.keypair_name = aws_config.fetch("keypair_name")
			# override.ssh.username = "ubuntu"
			override.ssh.username = "root"			
			override.ssh.private_key_path = aws_config.fetch("keypair_path")
			name = aws_config.fetch("instance_name_prefix") + " Vagrant Node1 PXC"

			aws.tags = {
				'Name' => name
			}
			aws.instance_type="m3.xlarge"
		end

	  node1_config.vm.provision :puppet do |puppet|
			puppet.manifests_path = "vagrant/puppet/manifests"
			puppet.manifest_file  = "pxc.pp"
			puppet.module_path = "vagrant/puppet/modules"
			puppet.options = "--verbose"
		    puppet.facter = pxc_config
		end
	end

	config.vm.define :node2 do |node2_config|
		# node2_config.vm.box = "ubuntu-aws-us-east"
		node2_config.vm.box = "centos6-aws-us-east"
		node2_config.vm.hostname = "node2"

		node2_config.vm.provider :aws do |aws, override|
			aws_config = YAML::load_file(File.join(Dir.home, ".aws_secrets"))
			aws.access_key_id = aws_config.fetch("access_key_id")
			aws.secret_access_key = aws_config.fetch("secret_access_key")
			aws.keypair_name = aws_config.fetch("keypair_name")
			# override.ssh.username = "ubuntu"
			override.ssh.username = "root"
			override.ssh.private_key_path = aws_config.fetch("keypair_path")
			name = aws_config.fetch("instance_name_prefix") + " Vagrant Node2 PXC"
			aws.tags = {
				'Name' => name
			}
         	aws.instance_type="m3.xlarge"
		end

	  node2_config.vm.provision :puppet do |puppet|
			puppet.manifests_path = "vagrant/puppet/manifests"
			puppet.manifest_file  = "pxc.pp"
			puppet.module_path = "vagrant/puppet/modules"
			puppet.options = "--verbose"
			puppet.facter = pxc_config
		end
	end

	config.vm.define :node3 do |node3_config|
		# node3_config.vm.box = "ubuntu-aws-us-east"
		node3_config.vm.box = "centos6-aws-us-east"
		node3_config.vm.hostname = "node3"

		node3_config.vm.provider :aws do |aws, override|
			aws_config = YAML::load_file(File.join(Dir.home, ".aws_secrets"))
			aws.access_key_id = aws_config.fetch("access_key_id")
			aws.secret_access_key = aws_config.fetch("secret_access_key")
			aws.keypair_name = aws_config.fetch("keypair_name")
			# override.ssh.username = "ubuntu"
			override.ssh.username = "root"
			override.ssh.private_key_path = aws_config.fetch("keypair_path")
			name = aws_config.fetch("instance_name_prefix") + " Vagrant Node3 PXC"
			aws.tags = {
				'Name' => name
			}
         	aws.instance_type="m3.xlarge"
		end

	  node3_config.vm.provision :puppet do |puppet|
			puppet.manifests_path = "vagrant/puppet/manifests"
			puppet.manifest_file  = "pxc.pp"
			puppet.module_path = "vagrant/puppet/modules"
			puppet.options = "--verbose"
        	puppet.facter = pxc_config
		end
	end


	config.vm.define :client1 do |client1_config|
		client1_config.vm.box = "centos6-aws-us-east"
		client1_config.vm.hostname = "client1"

		client1_config.vm.provider :aws do |aws, override|
			aws_config = YAML::load_file(File.join(Dir.home, ".aws_secrets"))
			aws.access_key_id = aws_config.fetch("access_key_id")
			aws.secret_access_key = aws_config.fetch("secret_access_key")
			aws.keypair_name = aws_config.fetch("keypair_name")
			override.ssh.username = "root"			
			override.ssh.private_key_path = aws_config.fetch("keypair_path")
			name = aws_config.fetch("instance_name_prefix") + " PXC test client"

			aws.tags = {
				'Name' => name
			}
			aws.instance_type="c1.xlarge"
		end

		client1_config.vm.provision :puppet do |puppet|
			puppet.manifests_path = "vagrant/puppet/manifests"
			puppet.manifest_file  = "client.pp"
			puppet.module_path = "vagrant/puppet/modules"
			puppet.options = "--verbose"
		end
	end
end
