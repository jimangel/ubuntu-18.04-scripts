######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################

# TO DO
# - git custom file
# - install and setup go for golang
# - install vscode

# SETUP
# sudo apt install git curl
# git config --global user.email "<email>"
# git config --global user.name "<name>"
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-tweaks/master/script.sh | sudo -E bash -

# install tlp for better power mgmt on laptop
sudo apt install tlp tlp-rdw --no-install-recommends

# create git folder
mkdir $HOME/Git

# install sublime
# to remove: sudo apt-get remove sublime-text && sudo apt-get autoremove
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &> /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null
sudo apt-get update
sudo apt-get install sublime-text

# fix vi
printf ":set nocompatible\n:set backspace=2" | tee ~/.vimrc > /dev/null
