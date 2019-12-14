# minio-cluster

Files and directories:
- ansible_adhoc.sh - Contains Ansible ad-hoc commands
- ansible.cfg - Ansible configuration file
- main.yaml - Main playbook file
- python-minio.py - MinIO Python API example file
- roles - Directory with Ansible roles used by "main.yaml"
- simple-playbook.yml - "All-in-one" playbook, configures the cluster without calling any roles. Can be used instead of "main.yaml"
- Vagrantfile - Contains VMs description for Vagrant
- vault_password_file - Contains Ansible Vault password
- vault_vars.yaml - Contains vault-encrypted MinIO secret key

To deploy a MinIO test cluster with 3 VMs install "vagrant" package, copy content of ./vagrant to your local ~./vagrant directory, then run "vagrant up". These VMs will be configured via Ansible automatically as well.

    # cd ./vagrant
    # vagrant up

You can also run the Ansible playbook with a pre-generated inventory manually via

    # ansible-playbook -i ~/vagrant/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ./main.yaml

or

    # vagrant provision

After the cluster has been deployed, you can configure a r/w user and upload a test file

    # export ANSIBLE_AUTO_INVENTORY=~/vagrant/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt config host add minio_cluster http://{{ inventory_hostname }} {{ minio_access_key }} zg8Q9y3yD8ayQEkFFh4yF7p828Jydeqzwpu8L4DuTw8ZWjNEgTVnW7FLuvkXe7tS"
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt admin user add minio_cluster minio_rw_user uvcmSQTczZtf4ZnyxUv5RM92F2E3jbjp"
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt admin policy set minio_cluster readwrite user=minio_rw_user"
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m copy -a 'src="~/Downloads/test (1).jpg" dest=/tmp'
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt config host add minio_cluster_rw_user http://{{ inventory_hostname }} minio_rw_user uvcmSQTczZtf4ZnyxUv5RM92F2E3jbjp"
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt mb minio_cluster_rw_user/storage"
    # ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a 'minioclt cp "/tmp/test (1).jpg" minio_cluster_rw_user/storage

Then you can install a MinIO Python integration layer via

    # pip install minio

and configire port forwarding in your VirtualBox GUI from the guest's port 80 to the host's port 8080. After it you will be able to download the uploaded file via the Python example file

    # ./python-minio.py
