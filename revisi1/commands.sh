ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook-create-k8s-cluster.yml -u Group-3 --private-key=$HOME/.ssh/id_rsa 

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook-create-k8s-cluster.yml --tags "master-node-init" -u Group-3 --private-key=$HOME/.ssh/id_rsa 


# Run Flannel fix
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "fix-flannel" -u Group-3 --private-key=$HOME/.ssh/id_rsa

# Run containerd fix
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "fix-containerd" -u Group-3 --private-key=$HOME/.ssh/id_rsa

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini initialize-metal-lb.yml -u demo --private-key=$HOME/id_rsa

# Deploy microservices application
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini fix-flannel-and-containerd.yml --tags "deploy-microservices-app" -u demo --private-key=$HOME/id_rsa







#benerin kubeconfig wktu fix flannel terjadi error (waktu awal setup cluster)
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -b -m shell -a "cp /etc/kubernetes/admin.conf /home/Group-3/.kube/config && chown Group-3:Group-3 /home/Group-3/.kube/config"
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl cluster-info"
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -b -m shell -a "systemctl restart kubelet"

ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl cluster-info dump"
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl get nodes"

#fix cni lagi plis bisa
# Apply Flannel CNI
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"

# Wait and check
sleep 60
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl get pods -n kube-flannel"

# Check nodes
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl get nodes"

# If still NotReady, restart kubelet
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -b -m shell -a "systemctl restart kubelet"

# Wait and check again
sleep 30
ansible master-node -i inventory.ini -u Group-3 --private-key=$HOME/.ssh/id_rsa -m shell -a "kubectl get nodes -o wide"
#------------- end of bnerin cni ---------------

#buat join control plane
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini join-control-plane.yml -u Group-3 --private-key=$HOME/.ssh/id_rsa

