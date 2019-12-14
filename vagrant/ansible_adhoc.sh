#!/bin/sh

set -x

ANSIBLE_AUTO_INVENTORY=~/vagrant/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt config host add minio_cluster http://{{ inventory_hostname }} {{ minio_access_key }} zg8Q9y3yD8ayQEkFFh4yF7p828Jydeqzwpu8L4DuTw8ZWjNEgTVnW7FLuvkXe7tS"

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt admin user add minio_cluster minio_rw_user uvcmSQTczZtf4ZnyxUv5RM92F2E3jbjp"

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt admin policy set minio_cluster readwrite user=minio_rw_user"

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m copy -a 'src="~/Downloads/test (1).jpg" dest=/tmp'

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt config host add minio_cluster_rw_user http://{{ inventory_hostname }} minio_rw_user uvcmSQTczZtf4ZnyxUv5RM92F2E3jbjp"

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a "minioclt mb minio_cluster_rw_user/storage"

ansible minio-node-1 -i ${ANSIBLE_AUTO_INVENTORY} -m shell -a 'minioclt cp "/tmp/test (1).jpg" minio_cluster_rw_user/storage'
