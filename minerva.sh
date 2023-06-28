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
NC='\033[0m'	   # Makes on-screen text default (white)
RED='\033[1;31m'   # Makes on-screen text red
YEL='\033[1;33m'   # Makes on-screen text yellow

BarTwo(){
	GreenBar
	GreenBar
}

GreenBar(){
	EchoColor "${GRN}" "####################################################################################################"
}

EchoColor(){ # color, text
	# Prints the passed string onto the screen in the designated color
	# Usage: EchoColor <color> <text>
	echo "$1$2${NC}"
}

EchoMain(){ # text
	# Prints the passed string onto the screen.  Formats the text so that it stands out
	# Usage: EchoMain <text>
	GreenBar
	EchoColor "${GRN}" $1
	GreenBar
}

ProcessOne(){
	# Performs the first part of the proces and drops a marker file to demonstrate completing this phase
	EchoMain "Adding signature for webmin repository"
	curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
	EchoMain "Adding webmin repository"
	sudo su -c "echo 'deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list"
	EchoMain "Updating repositories"
	apt update
	EchoMain "Upgrading Ubuntu"
	apt upgrade -y
	touch ProcessOneComplete
	BarTwo
	EchoColor "${MAG}" "The system must be rebooted to complete the kernel update"
	EchoColor "${MAG}" "Re-run this script after reboot is finished"
	BarTwo
	# TODO:: Handle input to initiate reboot
	reboot
}

ProcessTwo(){
	# Performs the second part of the proces and drops a marker file to demonstrate completing this phase
	apt install -y debconf-utils
	EchoMain "Installing Apache Webserver"
	apt install -y apache2

	EchoMain "Updating Firewall Rules"
	ufw allow 80/tcp
	ufw allow 443/tcp
	EchoMain "Installing PHP and associated components"
	apt install -y php libapache2-mod-php php-curl php-intl php-zip php-xml php-gd php-mbstring php-bcmath php-common php-mysqli
	a2enmod rewrite
	phpenmod mbstring
	EchoMain "Installing MySQL"
	apt install -y mysql-server
	BarTwo
	EchoColor "${YEL}" "MySQL must be secured before phpMyAdmin can be installed."
	echo ""
	EchoColor "${GRN}" "execute the following commands:"
	EchoColor "${CYA}" "sudo mysql"
	EchoColor "${CYA}" "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '<password>';"
	EchoColor "${CYA}" "exit"
	echo ""
	EchoColor "${YEL}" "After this, execute this script again"
	BarTwo
	touch ProcessTwoComplete
}

ProcessThree(){
	# Performs the last part of the proces and drops a marker file to demonstrate completing this phase 
	GreenBar
	EchoColor "${RED}" "Answer No to VALIDATE PASSWORD COMPONENT!"
	EchoColor "${YEL}" "phpMyAdmin install will fail if you answer Yes"
	GreenBar

	sudo mysql_secure_installation

	EchoMain "Installing webmin prerequisites"
	apt install -y apt-transport-https software-properties-common

	EchoMain "Installing webmin"
	apt install -y webmin

	EchoMain "Allowing webmin through the firewall"
	ufw allow 10000

	EchoMain "Prepping for phpMyAdmin Unattended Install"
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password A14227ec00" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password A14227ec00" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

	EchoMain "Installing phpmyadmin"
	apt install -y phpmyadmin

	EchoMain "Installing Samba and support for exFAT drives"
	apt install -y samba exfat-fuse

	EchoMain "Installing ProFTP Server"
	apt install -y proftpd

	EchoMain "Installing Bind DNS Server"
	apt install -y bind9 bind9utils bind9-doc dnsutils

	BarTwo
	EchoColor "${MAG}" "Process is complete!"
	echo ""
	EchoColor "${MAG}" "Reboot is recommended, but not required"
	BarTwo

	touch ProcessThreeComplete
}

Navigate(){
	if ! [ -e ProcessOneComplete ]; then
		ProcessOne
	fi

	if ! [ -e ProcessTwoComplete ]; then
		ProcessTwo
	fi

	if ! [ -e ProcessThreeComplete ]; then
		ProcessThree
	fi
}

# Start processing the script
Navigate
