######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################

# TESTED ON UBUNTU 18.04 LTS

# TO DO
# - git custom file
# - consolidate the apt install junk...
# - add ng (https://github.com/angular/angular-cli/wiki)
# - add JQ
# - add pythong / pip

# SETUP & RUN
# sudo apt -y install curl
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-18.04-scripts/master/developer-laptop-config.sh | sudo -E bash -

# SET VARS
goVersion="1.12.9"
kubectlVersion="1.15.2"
javaVersion="11"
# set font colors
red='\033[0;31m'
nocolor='\033[0m'

# build function to see if program exists
cant_find_program() {
  if command -v "${1}" > /dev/null 2>&1; then
    return 1
  fi
}

cant_find_npm_program() {
    if command -v "${1}" > /dev/null 2>&1; then
      if cant_find_program npm; then
        sudo apt -y install npm
      fi
    return 1
  fi
}

# install tlp for better power mgmt on laptop
if cant_find_program tlp; then
  sudo apt -y install tlp tlp-rdw --no-install-recommends
fi

# create git folder in homedir
mkdir ~/Git 2>/dev/null

# install sublime
# to remove: sudo apt remove sublime-text && sudo apt autoremove
if cant_find_program subl; then
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &> /dev/null
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null
  sudo apt update
  sudo apt -y install sublime-text
fi

# fix vi
printf ":set nocompatible\n:set backspace=2" > ~/.vimrc

# put dock at bottom
if ! gsettings list-recursively | grep dock-position | grep BOTTOM > /dev/null; then
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
fi

# git placeholder
# sudo apt -y install git
# git config --global user.email "<email>"
# git config --global user.name "<name>"

# install media codecs and fonts
#if ! grep "Commandline: apt install ubuntu-restricted-extras" /var/log/apt/history.log > /dev/null; then
#sudo apt -y install ubuntu-restricted-extras
#fi

# reminder to update to AM/PM format
echo "MANUALLY UPDATE TO A 12HR CLOCK"
echo "STEPS: Click on Activities and search for 'Settings' and launch it. Click on Details at the bottom of the sidebar and then select 'Date & Time'."

echo "IF YOU WANT TO UPDATE RUN: # update and upgrade all
sudo apt update && sudo apt upgrade"

# install terminator terminal
if cant_find_program terminator; then
sudo apt -y install terminator
fi

# install golang
# note: to upgrade 'sudo rm -rf /usr/local/go' and change version in script
if cant_find_program go; then
wget https://dl.google.com/go/go${goVersion}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${goVersion}.linux-amd64.tar.gz
rm -rf go${goVersion}.linux-amd64.tar.gz
cat << 'EOT' >> ~/.bashrc

# set PATH so it includes go bin if it exists
if [ -d "/usr/local/go/bin" ] ; then
    PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
    GOPATH="$HOME/go"
fi
EOT
# create working dirs
mkdir -p ~/go/{bin,src,pkg} 2>/dev/null
printf "${red}!!! MUST RESTART TERMINAL BEFORE GO CAN BE USED${nc}\n"
fi

# install kubectl binary
if cant_find_program kubectl; then
wget https://storage.googleapis.com/kubernetes-release/release/v${kubectlVersion}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
fi

if ! grep "source <(kubectl completion bash)" ~/.bashrc > /dev/null; then
cat << 'EOT' >> ~/.bashrc

# enable kubectl auto completion
source <(kubectl completion bash)
EOT
fi

# install virtual box
if cant_find_program VBoxManage; then
    sudo apt -y install virtualbox
    echo "REMINDER: Turn VT-x on in the BIOS for all CPU modes before running virtualbox or minikube!"
fi

# install mini-kube
# FYI: minikube delete && rm -rf ~/.minikube
# minikube start --vm-driver=xvirtualbox
# https://github.com/kubernetes/minikube/blob/v0.27.0/README.md
if cant_find_program minikube; then
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.27.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
fi

# install docker
if cant_find_program docker; then
  sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic test"
  sudo apt update
  sudo apt -y install docker-ce
  sudo usermod -a -G docker $USER
fi

# install vscode
if cant_find_program code; then
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt -y update
sudo apt -y install code
fi

if cant_find_program gcloud; then
# Create environment variable for correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Update the package list and install the Cloud SDK
sudo apt update && sudo apt -y install google-cloud-sdk
fi

if cant_find_program cfssl; then
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
  chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
  sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
  sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
fi

# install remaining reqs for k8s dashboard dev
if cant_find_program nodejs; then
  sudo apt -y install nodejs
fi

if cant_find_program java; then
 sudo apt -y install openjdk-${javaVersion}-jdk
fi

if cant_find_npm_program gulp; then
  sudo npm install -g gulp
fi

# install ZOOM clinet?

if cant_find_program aspell; then
 sudo apt -y install aspell
fi

# sudo apt autoremove <- might need to add at the end?
# look into using apt for more of this stuff w/ version control
