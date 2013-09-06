# -*- mode: ruby -*-
# vi: set ft=ruby :
require './vagrant/lib/vagrant-common.rb'

# Our definitions
pxc_config = {
	'datadir_dev' => 'xvdl',
	"innodb_buffer_pool_size" => "10G",
	"innodb_log_file_size" => "1G",
	"wsrep_provider_options" => "gcache.size=2G; gcs.fc_limit=2048",
	"wsrep_slave_threads" => 16,
	"wsrep_auto_increment_control" => "OFF"
}

pxc_instance_type = "m3.xlarge"

pxc_block_device = [
    {
        'DeviceName' => "/dev/sdl",
        'VirtualName' => "mysql_data",
        'Ebs.VolumeSize' => 100,
        'Ebs.DeleteOnTermination' => true,
        'Ebs.VolumeType' => 'io1',
        'Ebs.Iops' => 1000
    }
]

Vagrant.configure("2") do |config|
	config.vm.box = "centos-6_4-64_percona"
	config.ssh.username = "root"

	config.vm.define :node1 do |node1_config|
		# Every Vagrant virtual environment requires a box to build off of.
		node1_config.vm.hostname = "node1"
        node1_config.vm.network :private_network, ip: "192.168.70.2"

		node1_config.vm.provider :aws do |aws, override|
			aws_provider( aws, override, "Vagrant Node1 PXC Perf Test" )

			# The instance_type and EBS device name seem intertwined
			aws.instance_type = pxc_instance_type
			puppet( override, 'pxc.pp', pxc_config )

			aws.block_device_mapping = pxc_block_device
		end
	end

	config.vm.define :node2 do |node2_config|
		# Every Vagrant virtual environment requires a box to build off of.
		node2_config.vm.hostname = "node2"
        node2_config.vm.network :private_network, ip: "192.168.70.3"

		node2_config.vm.provider :aws do |aws, override|
			aws_provider( aws, override, "Vagrant Node2 PXC Perf Test" )

			# The instance_type and EBS device name seem intertwined
			aws.instance_type = pxc_instance_type
			puppet( override, 'pxc.pp', pxc_config )

			aws.block_device_mapping = pxc_block_device
		end
	end

	config.vm.define :node3 do |node3_config|
		# Every Vagrant virtual environment requires a box to build off of.
		node3_config.vm.hostname = "node3"
        node3_config.vm.network :private_network, ip: "192.168.70.4"

		node3_config.vm.provider :aws do |aws, override|
			aws_provider( aws, override, "Vagrant Node3 PXC Perf Test" )

			# The instance_type and EBS device name seem intertwined
			aws.instance_type = pxc_instance_type
			puppet( override, 'pxc.pp', pxc_config )

			aws.block_device_mapping = pxc_block_device
		end
	end


	config.vm.define :client1 do |client1_config|
		client1_config.vm.hostname = "client1"
        client1_config.vm.network :private_network, ip: "192.168.70.4"

		client1_config.vm.provider :aws do |aws, override|
			aws_provider( aws, override, "Vagrant PXC test client")
			aws.instance_type="c1.xlarge"

			puppet( override, 'client.pp' )
		end
	end
end

