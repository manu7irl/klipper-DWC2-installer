#!/bin/bash
####################################
##Script Created by James Mackay ###
##Website: notexpectedyet.com ######
##Current Objective: Quickly #######
##install mutliple Octoprint #######
##instances with Klipper ###########
##Version 1.1 ######################
####################################
IP=$(ifdata -pa enp0s25) &> /dev/null #Grabbing IP Address
echo "Hello and welcome to my script. This will install OctoPrint for you, as many times as you require."
echo "Firstly, I'm going to need to know how many printers you want?"
read printerCount
echo "Thanks, Now what user would you like to run this as?"
read userSelect
installLocation=/home/$userSelect
echo "Thanks! Full steam ahead to install $printerCount printer(s) in $installLocation"
echo "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 5
echo "Just preparing your system for install"
echo "..."
sudo apt update && sudo apt install git python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential moreutils -y &> /dev/null
echo "Done!"
echo "Just making sure your $userSelect has the correct permissions"
echo "..."
sudo usermod -a -G tty $userSelect &> /dev/null
sudo usermod -a -G dialout $userSelect &> /dev/null
echo "Done!"
echo "Now I will handle the installations of your $printerCount printer(s)"
echo "..."
mkdir $installLocation/OctoprintFarm &> /dev/null
cd $installLocation/OctoprintFarm &> /dev/null
echo "Done!"
echo "Downloading Latest OctoPrint version from Github"
echo "..."
#git clone https://github.com/foosel/OctoPrint.git &> /dev/null
echo "Done!"
echo "Setting up the initial octoprint instance"
echo "..."
#cd $installLocation/OctoPrint/
#virtualenv venv &> /dev/null
echo "...."
#./venv/bin/pip install pip --upgrade &> /dev/null
echo "....."
#./venv/bin/python setup.py install &> /dev/null
echo "Done!"
if [ ! -f $installLocation/octoprint.init ];
then
    echo "Downloading init...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init -P $installLocation
    echo "Done!"
fi
if [ ! -f $installLocation/octoprint.default ];
then
    echo "Downloading init...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default -P $installLocation
    echo "Done!"
fi
echo "Now we need to create a system service for each instance. Two sec's I'll get on it!"
echo "..."
sudo systemctl daemon-reload
PRT=5000
CONcounter=1
while [ $CONcounter -le $printerCount ]
do
	cd $installLocation/OctoprintFarm
	if [ -d "$DIRECTORY" ]; then
 	mkdir .octoprint-$CONcounter
	fi
	PORTcounter=$(($PRT + $CONcounter))
	cp $installLocation/octoprint.init $installLocation/OctoprintFarm/octoprint.init
	cp $installLocation/octoprint.default $installLocation/OctoprintFarm/octoprint.default
	sed -i "s/USER=pi/USER=$userSelect/g" octoprint.default
	sed -i "s/PORT=5000/PORT=$PORTcounter/g" octoprint.default
	sed -i "s+#DAEMON=/home/pi/OctoPrint/venv/bin/octoprint+DAEMON=$installLocation/OctoPrint/venv/bin/octoprint+g" octoprint.default
	sed -i 's|#BASEDIR=/home/pi/.octoprint|BASEDIR='$installLocation'/.octoprint-'$CONcounter'|g' octoprint.default
	sed -i 's|#CONFIGFILE=/home/pi/.octoprint/config.yaml|CONFIGFILE='$installLocation'/.octoprint-'$CONcounter'/config.yaml|g' octoprint.default
	sed -i "s/UMASK=022/UMASK=022/g" octoprint.default
	sed -i "s+DESC=\"OctoPrint\" Daemon\"+DESC=\"OctoPrint-$CONcounter Daemon\"+g" octoprint.init
	sed -i "s+NAME=\"OctoPrint\"+NAME=\"OctoPrint-$CONcounter\"+g" octoprint.init
	sed -i "s/PKGNAME=octoprint/PKGNAME=octoprint-$CONcounter/g" octoprint.init
	sudo mv octoprint.init /etc/init.d/octoprint-$CONcounter
	sudo mv octoprint.default /etc/default/octoprint-$CONcounter
	sudo chmod +x /etc/init.d/octoprint-$CONcounter
	sudo update-rc.d octoprint-$CONcounter defaults
	sudo service octoprint-$CONcounter start
	sleep 10
	echo "Service octoprint-$CONcounter has started on http://$IP:$PORTcounter"
	((CONcounter++))
done

echo "Done!"
echo "..."
sleep 5
echo "Congradulations.... You should have a load of printers running!"

