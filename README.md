# PXC Perf testing using tpcc-mysql

This test requires vagrant-percona-server-aws, which is included as a submodule.  Check the README in that repo for instructions about how to get your environment setup properly to use vagrant-aws and to create your own AMI vagrant box.  Running this test yourself assumes all of that is already setup and working properly.


## Quick steps

```bash
./setup_env.sh
# Wait until all background provisioning is done
./vagrant/bootstrap.sh
./setup_test.sh
```