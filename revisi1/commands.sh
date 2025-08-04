ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook-create-k8s-cluster.yml --tags "install-cni" -u demo --private-key=$HOME/id_rsa 


# Run Flannel fix
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "fix-flannel" -u demo --private-key=$HOME/id_rsa

# Run containerd fix
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "fix-containerd" -u demo --private-key=$HOME/id_rsa

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini initialize-metal-lb.yml -u demo --private-key=$HOME/id_rsa

# Deploy microservices application
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "deploy-microservices-app" -u demo --private-key=$HOME/id_rsa