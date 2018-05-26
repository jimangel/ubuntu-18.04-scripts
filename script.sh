######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################

# TO DO
# - git custom file
# - install and setup go for golang
# - install vscode

# SETUP & RUN
# sudo apt install curl
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

# put dock at bottom
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM

# git placeholder
# sudo apt install git
# git config --global user.email "<email>"
# git config --global user.name "<name>"

# install media codecs and fonts
sudo apt install ubuntu-restricted-extras

# update and upgrade all
sudo apt update && sudo apt upgrade

# reminder to update to AM/PM format
echo "MANUALLY UPDATE TO A 12HR CLOCK"
echo "STEPS: Click on Activities and search for 'Settings' and launch it. Click on Details at the bottom of the sidebar and then select 'Date & Time'."
