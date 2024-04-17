curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.24 sh -s - --write-kubeconfig-mode 644
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s-config
# Set it also in the bashrc or zshrc file, or you can flatten both of these configs into a single file
export KUBECONFIG=~/.kube/config:~/.kube/k3s-config

kubectl get nodes
sudo rm ~/.kube/k3s-config  #to make k3s uses ~/.kube/config
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config


### helm installation

mkdir ~/helm && cd ~/helm
wget https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz
tar -zxvf helm-v3.14.4-linux-amd64.tar.gz
mv /helm /usr/local/bin/helm


