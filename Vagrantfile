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

# Node names and ips (for local VMs)
# Security groups are 'default' (22 open) and 'pxc' (3306, 4567-4568,4444 open) for each respective region
pxc_nodes = {
	'node1' => {
	   'aws_region' => 'us-east-1',
	   'local_vm_ip' => '192.168.70.2',
	   'security_groups' => ['default','pxc']
	},
	'node2' => {
	   'aws_region' => 'us-east-1',
	   'local_vm_ip' => '192.168.70.3',
      'security_groups' => ['default','pxc']
      
	},
	'node3' => {
	   'aws_region' => 'us-east-1',
	   'local_vm_ip' => '192.168.70.4',
      'security_groups' => ['default','pxc']
	}
}

Vagrant.configure("2") do |config|
	config.vm.box = "centos-6_4-64_percona"
	config.ssh.username = "root"

	# Create all three nodes identically except for provided params
	pxc_nodes.each_pair { |node, node_params|
		config.vm.define node do |node_config|
			node_config.vm.hostname = node
			node_config.vm.network :private_network, ip: node_params['local_vm_ip']

			provider_aws( node_config, "PXC Perf Test #{node}", pxc_instance_type, node_params['aws_region'], node_params['security_groups'] ) { |aws, override|
				aws.block_device_mapping = pxc_block_device
				provision_puppet( override, 'pxc.pp', 
					pxc_config.merge( 'datadir_dev' => 'xvdl' )
				)
			}
		end
	}

	config.vm.define :client1 do |client1_config|
		client1_config.vm.hostname = "client1"
        client1_config.vm.network :private_network, ip: "192.168.70.4"

		provider_aws( client1_config, "PXC Pef Test client", 'c1.xlarge', 'us-east-1', ['default'] ) { |aws, override|
				provision_puppet( override, 'client.pp')
		}
	end
end
