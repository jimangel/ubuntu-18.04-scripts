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

# SETUP & RUN
# sudo apt -y install curl
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-tweaks/master/kubeadm.sh | sudo -E bash -

# set vars
goVersion="1.10.2"
kubectlVersion="1.10.2"
javaVersion="11"

# build function to see if program exists
cant_find_program() {
  if command -v "${1}" > /dev/null 2>&1; then
    return 1
  fi
}

# install docker
if cant_find_program docker; then
  sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic test"
  sudo apt update
  sudo apt -y install docker-ce
  sudo usermod -a -G docker $USER
  sudo systemctl enable docker
fi

# TO DO: ADD DOCKER CHECKS IN
docker info | grep -i cgroup
cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
echo "Make sure that the cgroup driver used by kubelet is the same as the one used by Docker. Verify that your Docker cgroup driver matches the kubelet config"

# sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# systemctl daemon-reload
# systemctl restart kubelet

# install kubeadm reqs
if cant_find_program kubeadm; then
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
fi

sudo swapoff -a

apt-get update && apt-get upgrade
