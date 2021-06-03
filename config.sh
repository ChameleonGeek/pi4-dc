#! /bin/bash

# NOTE:  This script is in the early stages of development.

# ======================================
#                              VARIABLES
# ======================================
#display variables
BLU='\033[1;34m'   # Makes on-screen text blue
CYA='\033[1;36m'   # Makes on-screen text cyan
GRN='\033[1;32m'   # Makes on-screen text green
MAG='\033[1;35m'   # Makes on-screen text magenta
NC='\033[0m'	     # Makes on-screen text default (white)
RED='\033[1;31m'   # Makes on-screen text red
YEL='\033[1;33m'   # Makes on-screen text yellow


# ======================================
#               BASIC USER COMMUNICATION
# ======================================
Alert(){ # text
	# Prints the passed string in red
	EchoColor "${RED}" "$1";
}

EchoColor(){ # color, text
	# Prints the passed string onto the screen in the designated color
	# Usage: EchoColor <color> <text>
	echo -e "$1$2${NC}";
}

Note(){ # text
	# Prints the passed string in green
	echo ""
	echo ""
	EchoColor "${GRN}" "################################################################################"
	EchoColor "${GRN}" "$1";
	EchoColor "${GRN}" "################################################################################"
}

BaseUpdate(){
  Note "Updating Repositories - Stystem will reboot"
  sudo apt update
  echo "DONE" >> step1
  sudo reboot
}

FirstUpgrade(){
  Note "Upgrading Software - System will reboot"
  sudo apt upgrade -y
  echo "DONE" >> step2
  sudo reboot
}

MainConfig(){
  Note "Installing Preliminary Software"
  sudo apt install apt-transport-https tasksel -y
  
  Note "Installing LAMP web server"
  sudo tasksel install lamp-server
  
  Note "Updating Repositories so we can install Webmin"
  wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
  
  Note "Adding Webmin Repositories"
  sudo add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib"
  
  Note "Installing Webmin"
  sudo apt install webmin -y

  Note "Prepping for phpMyAdmin Unattended Install"
  sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
  sudo echo "phpmyadmin phpmyadmin/app-password-confirm password A14227ec00" | debconf-set-selections
  sudo echo "phpmyadmin phpmyadmin/mysql/app-pass password A14227ec00" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections

  Note "Installing phpMyAdmin"
  sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
  
  Note "Reinforcing phpMyAdmin Security"
  #phpenmod mcrypt
  sudo phpenmod mbstring
  
  Note "Restarting Apache webserver"
  sudo systemctl restart apache2
  
  Note "Installing Samba FileServer"
  sudo tasksel install samba-server
  
  Note "Installing Samba Adders"
  sudo apt-get install acl attr -y
  
  Note "Installing OpenVPN Server"
  sudo apt-get install openvpn easy-rsa -y

  echo "DONE" >> step3
}

Navigate(){
  if ![ -e step1 ]; then
    BaseUpdate
  fi
  
  if ![ -e step2 ]; then
    FirstUpgrade
  fi
  
  if ![ -e step3 ]; then
    MainConfig
  fi
  


}

# xargs -a packages.txt sudo apt-get install
Navigate
