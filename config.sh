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




Navigate(){
  Note "Updating Repositories"
  apt update 
  Note "Upgrading Software"
  apt upgrade -y

  Note "Installing Preliminary Software"
  apt install apt-transport-https tasksel -y
  
  Note "Installing LAMP web server"
  tasksel install lamp-server
  
  Note "Updating Repositories so we can install Webmin"
  wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
  
  Note "Adding Webmin Repositories"
  add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib"
  
  Note "Installing Webmin"
  apt install webmin -y

  Note "Prepping for phpMyAdmin Unattended Install"
  echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
  #echo "phpmyadmin phpmyadmin/mysql/app-pass password A14227ec00" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

  Note "Installing phpMyAdmin"
  apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
  
  Note "Reinforcing phpMyAdmin Security"
  #phpenmod mcrypt
  phpenmod mbstring
  
  Note "Restarting Apache webserver"
  systemctl restart apache2
  
  Note "Installing Samba FileServer"
  tasksel install samba-server
  
  Note "Installing Samba Adders"
  apt-get install acl attr -y
  
  Note "Installing OpenVPN Server"
  apt-get install openvpn easy-rsa -y
}

# xargs -a packages.txt sudo apt-get install
Navigate
