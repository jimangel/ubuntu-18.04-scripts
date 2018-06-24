######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################

# TESTED ON UBUNTU 18.04 LTS

# TO DO:
# create template and clean up script
# https://gist.github.com/jcppkkk/ba195725a2532bce3740315c637b7414
# update template to blacklist ipv6 via: sudo bash -c "echo blacklist ipv6 >> /etc/modprobe.d/blacklist.conf"

# fix swap
# sudo swapoff -a
# sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# add golang and critcl
# sudo apt install golang-go
# go get github.com/kubernetes-incubator/cri-tools/cmd/crictl

# add CNI - replace with coreDNS ...
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# SETUP & RUN
# sudo apt -y install curl
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-18.04-scripts/master/kubeadm-prereqs-install.sh | sudo -E bash -

# set vars
goVersion="1.10.2"
kubectlVersion="1.10.2"
javaVersion="11"
dockerVersion="17.03.2"

# build function to see if program exists
cant_find_program() {
  if command -v "${1}" > /dev/null 2>&1; then
    return 1
  fi
}

if free | awk '/^Swap:/ {exit !$2}'; then
    echo "WARNING: swap enabled, disabling now"
    # disable swap
    swapoff --all
    sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
else
    echo "PASSED: swap disabled"
fi

# install docker
if cant_find_program docker; then
  echo "WARNING: docker not found, installing now"
  sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
  sudo apt update
  sudo apt -y install docker-ce=$dockerVersion~ce-0~ubuntu-xenial
  sudo usermod -a -G docker $USER
  sudo systemctl enable docker
else
	dockerSpecs=$(docker --version)
    echo "PASSED: $dockerSpecs found"
fi

# install k8s utils
if cant_find_program kubeadm; then
  echo "WARNING: kubeadm not found, installing utils"
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
else
 echo "PASSED: kubeadm found"
fi
