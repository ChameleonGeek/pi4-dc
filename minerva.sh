#! /bin/bash
####################################################################################################
####################################################################################################
#                                  DEV SCRIPT FOR MINERVA - STEP 1
####################################################################################################
####################################################################################################
BLU='\033[1;34m'   # Makes on-screen text blue
CYA='\033[1;36m'   # Makes on-screen text cyan
GRN='\033[1;32m'   # Makes on-screen text green
MAG='\033[1;35m'   # Makes on-screen text magenta
NC='\033[0m'	     # Makes on-screen text default (white)
RED='\033[1;31m'   # Makes on-screen text red
YEL='\033[1;33m'   # Makes on-screen text yellow

EchoColor(){ # color, text
	# Prints the passed string onto the screen in the designated color
	# Usage: EchoColor <color> <text>
	echo "$1$2${NC}";
}

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${YEL}" "Downloading second half of script"
EchoColor "${GRN}" ""####################################################################################################"
wget https://github.com/ChameleonGeek/pi4-dc/raw/main/minerva2.sh
sudo chmod +x minerva2.sh

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Adding signature for webmin repo"
EchoColor "${GRN}" ""####################################################################################################"
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Adding webmin repo"
EchoColor "${GRN}" ""####################################################################################################"
sudo su -c "echo 'deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list"

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Performing update"
EchoColor "${GRN}" ""####################################################################################################"
sudo apt update

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Upgrading Ubuntu"
EchoColor "${GRN}" ""####################################################################################################"
sudo apt upgrade -y

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Installing Apache web server"
EchoColor "${GRN}" ""####################################################################################################"
sudo apt install apache2 -y

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Allowing apache (http, https) through firewall"
EchoColor "${GRN}" ""####################################################################################################"
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Installing php and components"
EchoColor "${GRN}" ""####################################################################################################"
sudo apt install php libapache2-mod-php -y
sudo apt install php-{curl,intl,zip,soap,xml,gd,mbstring,bcmath,common,mysqli} -y
sudo a2enmod rewrite

EchoColor "${GRN}" ""####################################################################################################"
EchoColor "${GRN}" "Installing MySQL"
EchoColor "${GRN}" ""####################################################################################################"
sudo apt install mysql-server -y

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "####################################################################################################"
EchoColor "${YEL}" "MySQL must be secured before phpMyAdmin can be installed."
echo ""
EchoColor "${GRN}" "execute the following commands:"
EchoColor "${CYA}" "sudo mysql"
EchoColor "${CYA}" "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '<password>';"
EchoColor "${CYA}" "exit"
echo ""
EchoColor "${YEL}" "After this, execute minerva2.sh"
EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "####################################################################################################"

