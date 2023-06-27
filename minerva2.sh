#! /bin/bash
####################################################################################################
####################################################################################################
#                                  DEV SCRIPT FOR MINERVA - STEP 2
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

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${RED}" "Answer No to VALIDATE PASSWORD COMPONENT!"
EchoColor "${YEL}" "phpMyAdmin install will fail if you answer Yes"
EchoColor "${GRN}" "####################################################################################################"

# shore up mySQL
sudo mysql_secure_installation

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing webmin prerequisites"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install apt-transport-https -y
sudo apt install software-properties-common -y

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing webmin"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install webmin -y

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Allowing webmin through the firewall"
EchoColor "${GRN}" "####################################################################################################"
sudo ufw allow 10000

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing phpmyadmin"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install phpmyadmin -y 
sudo apt install php-mbstring -y 
sudo phpenmod mbstring

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing samba and support for exFAT drives"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install samba -y
sudo apt install exfat-fuse -y

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing FTP server"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install proftpd -y

EchoColor "${GRN}" "####################################################################################################"
EchoColor "${GRN}" "Installing bind DNS Server"
EchoColor "${GRN}" "####################################################################################################"
sudo apt install bind9 bind9utils bind9-doc dnsutils -y
