#!/bin/bash
##########################################
##	Script Created by James Mackay	##
##	Website: notexpectedyet.com 	##
##	Current Objective: Quickly	##
##	install mutliple Octoprint	##
##	instances with Klipper 		##
##	Version 1.1.a 			##
##	modified by Manu7irl		##
##########################################

echo "This will install OctoPrint on linux for you, as many times as you require."
echo "On Which unix user this install should be run on? watch out for typos!"
read userSelect
installLocation=/home/$userSelect
while true; do
	read -p "The octoprint instance(s) will be installed for user $userSelect, are you sure?[Y/N]" yn
	case $yn in
		[Yy]* ) break;;
   		[Nn]* ) echo "On Which unix user this install should be run on? watch out for typos!"; read userSelect; continue;;
    		* ) echo "Please answer by yes (Y/y) or no (N/n).";;
	esac
done	
while true; do
	echo "How many 3D-printers do you want to run on it?"
	read printerCount
	octo_session=1
	one_install=0
	printer_number=$(($printerCount-$octo_session))
	
	if [ $(($printer_number)) == $(($one_install)) ];
		then
			read -p "Only $octo_session main OctoPrint service will be installed without instances, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) echo "Please answer by yes (Y/y) or no (N/n).";;
    		esac
		else
			read -p "Only $printerCount instances of OctoPrint  will be installed, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) echo "Please answer by yes (Y/y) or no (N/n).";;
    		esac
			break	
	fi		
done

echo "Thanks! Full steam ahead to install $printerCount OctoPrint instance(s) in $installLocation/Octoprint"
echo "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 5
echo "Just preparing your system for install"
echo "..."
sudo apt update &> /dev/null && sudo apt install git python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential -y &> /dev/null
echo "Done!"
echo "Just making sure $userSelect has the correct permissions"
echo "..."
sudo usermod -a -G tty $userSelect &> /dev/null
sudo usermod -a -G dialout $userSelect &> /dev/null
echo "Done!"
echo "Now I will handle $printerCount OctoPrint instance(s) install "
echo "..."
mkdir $installLocation/OctoprintFarm &> /dev/null
cd $installLocation/OctoprintFarm &> /dev/null
echo "Done!"
echo "Downloading Latest OctoPrint version from Github"
echo "..."
mkdir $installLocation/OctoPrint && cd $installLocation/OctoPrint &> /dev/null
virtualenv venv &> /dev/null &> /dev/null
source venv/bin/activate &> /dev/null
echo "Setting up the initial octoprint instance"
pip install pip --upgrade &> /dev/null
pip install https://get.octoprint.org/latest &> /dev/null
echo "Done!"

mkdir $installLocation/OctoprintFarm/service-files
cd $installLocation/OctoprintFarm/service-files
servicefolder=$installLocation/OctoprintFarm/service-files
if [ ! -f $servicefolder/octoprint.init ];
then
    echo "Downloading init file...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init -P $servicefolder &> /dev/null
    echo "Done!"
fi
if [ ! -f $servicefolder/octoprint.default ];
then
    echo "Downloading default file...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default -P $servicefolder &> /dev/null
    echo "Done!"
fi
echo "Now we need to create a system service for each instance. Two sec's I'll get on it!"
echo "..."
sudo systemctl daemon-reload
PRT=5000
CONcounter=0
while [ $CONcounter -le $printer_number ]
do
	if [ -d "$DIRECTORY" ]; then
 	mkdir $installLocation/OctoprintFarm/.octoprint-$CONcounter
	fi 
	PORTcounter=$(($PRT + $CONcounter))
	cp $servicefolder/octoprint.init $installLocation/OctoprintFarm/octoprint.init
	cp $servicefolder/octoprint.default $installLocation/OctoprintFarm/octoprint.default
	sed -i "s/USER=pi/USER=$userSelect/g" octoprint.default
	sed -i "s/PORT=5000/PORT=$PORTcounter/g" octoprint.default
	sed -i "s+#DAEMON=/home/pi/OctoPrint/venv/bin/octoprint+DAEMON=$installLocation/OctoPrint/venv/bin/octoprint+g" octoprint.default
	sed -i 's|#BASEDIR=/home/pi/.octoprint|BASEDIR='$installLocation'/OctoPrintFarm/.octoprint-'$CONcounter'|g' octoprint.default
	sed -i 's|#CONFIGFILE=/home/pi/.octoprint/config.yaml|CONFIGFILE='$installLocation'/OctoPrintFarm/.octoprint-'$CONcounter'/config.yaml|g' octoprint.default
	sed -i "s/UMASK=022/UMASK=022/g" octoprint.default
	sed -i "s+DESC=\"OctoPrint\" Daemon\"+DESC=\"OctoPrint-$CONcounter Daemon\"+g" octoprint.init
	sed -i "s+NAME=\"OctoPrint\"+NAME=\"OctoPrint-$CONcounter\"+g" octoprint.init
	sed -i "s/PKGNAME=octoprint/PKGNAME=octoprint-$CONcounter/g" octoprint.init
	sudo mv octoprint.init /etc/init.d/octoprint-$CONcounter
	sudo mv octoprint.default /etc/default/octoprint-$CONcounter
	sudo chmod +x /etc/init.d/octoprint-$CONcounter
	sudo update-rc.d octoprint-$CONcounter defaults
	sudo systemctl daemon-reload
	sudo service octoprint-$CONcounter start
	sleep 10
	echo "Service octoprint-$CONcounter has started on http://$(hostname):$PORTcounter or http://localhost:$PORTcounter"
	((CONcounter++))
done

echo "Done!"
echo "..."
sleep 5
echo "Congradulations.... You should have $printerCount Octoprint instance(s) running!"

cd $installLocation
echo "Installing webcam support"
echo "..."
sudo apt install subversion libjpeg-dev imagemagick ffmpeg libv4l-dev cmake -y &> /dev/null
git clone https://github.com/jacksonliam/mjpg-streamer.git &> /dev/null
cd mjpg-streamer/mjpg-streamer-experimental/
mkdir build && cd build
cmake .. &> /dev/null
make &> /dev/null
sudo make install &> /dev/null
echo "Done!"

echo "Creating webcam lauching scripts"
echo "..."
cd $installLocation/
mkdir octo-scripts
mv $installLocation/octo-scripts/webcam $installLocation/octo-scripts/wecam_bak &> /dev/null
cat &> /dev/null <<WEBCAM > $installLocation/octo-scripts/webcam

	#!/bin/bash
	# Start / stop streamer daemon

	case "$1" in
		start)
			$installLocation/octo-scripts/webcamDaemon >/dev/null 2>&1 &
			echo "$0: started"
			;;
		stop)
			pkill -x webcamDaemon
			pkill -x mjpg_streamer
			echo "$0: stopped"
			;;
		restart)
			pkill -x webcamDaemon
			pkill -x mjpg_streamer
			$installLocation/octo-scripts/webcamDaemon >/dev/null 2>&1 &
			echo "$0: restarted"
			;;

		*)
			echo "Usage: $0 {start|stop|restart}" >&2
			;;
	esac 
WEBCAM
 
mv $installLocation/octo-scripts/webcamDaemon $installLocation/octo-scripts/wecamDaemon_bak &> /dev/null
cat &> /dev/null <<WEBCAMDAEMON > $installLocation/octo-scripts/webcamDaemon
	
	#!/bin/bash

	MJPGSTREAMER_HOME=$installLocation/mjpg-streamer/mjpg-streamer-experimental
	MJPGSTREAMER_INPUT_USB="input_uvc.so"
	MJPGSTREAMER_INPUT_RASPICAM="input_raspicam.so"

	# init configuration
	camera="auto"
	camera_usb_options="-r 640x480 -f 10"
	camera_raspi_options="-fps 10"

	if [ -e "/boot/octopi.txt" ]; then
    source "/boot/octopi.txt"
	fi

	# runs MJPG Streamer, using the provided input plugin + configuration
	function runMjpgStreamer {
    input=$1
    pushd $MJPGSTREAMER_HOME
    echo Running ./mjpg_streamer -o "output_http.so -w ./www" -i "$input"
    LD_LIBRARY_PATH=. ./mjpg_streamer -o "output_http.so -w ./www" -i "$input"
    popd
	}

	# starts up the RasPiCam
	function startRaspi {
    logger "Starting Raspberry Pi camera"
    runMjpgStreamer "$MJPGSTREAMER_INPUT_RASPICAM $camera_raspi_options"
	}

	# starts up the USB webcam
	function startUsb {
    logger "Starting USB webcam"
    runMjpgStreamer "$MJPGSTREAMER_INPUT_USB $camera_usb_options"
	}

	# we need this to prevent the later calls to vcgencmd from blocking
	# I have no idea why, but that's how it is...
	vcgencmd version

	# echo configuration
	echo camera: $camera
	echo usb options: $camera_usb_options
	echo raspi options: $camera_raspi_options

	# keep mjpg streamer running if some camera is attached
	while true; do
    	if [ -e "/dev/video0" ] && { [ "$camera" = "auto" ] || [ "$camera" = "usb" ] ; }; then
        startUsb
    	elif [ "`vcgencmd get_camera`" = "supported=1 detected=1" ] && { [ "$camera" = "auto" ] || [ "$camera" = "raspi" ] ; }; then
        startRaspi
    	fi
    sleep 120
	done
WEBCAMDAEMON

chmod +x $installLocation/octo-scripts/webcam*

sudo mv /etc/rc.local /etc/rc.local_bak &> /dev/null
cat &> /dev/null<<AUTOSTART | sudo tee -a /etc/rc.local
	#!/bin/sh -e
	#
	# rc.local
	#
	# This script is executed at the end of each multiuser runlevel.
	# Make sure that the script will "" on success or any other
	# value on error.
	#
	# In order to enable or disable this script just change the execution
	# bits.
	#
	# By default this script does nothing.

	$installLocation/Octo-scripts/webcam start

	exit0
AUTOSTART

sudo chmod +x /etc/rc.local
echo "Done!"

echo "Adding new hostname octolinux"
echo "..."
sudo apt install avahi-daemon -y &> /dev/null
sudo mv /etc/hosts /etc/hosts_bak &> /dev/null
cat &> /dev/null<<HOSTS | sudo tee -a /etc/hosts  

	127.0.0.1       localhost.localdomain   localhost
	::1             localhost6.localdomain6 localhost6

	# The following lines are desirable for IPv6 capable hosts
	::1     localhost ip6-localhost ip6-loopback
	fe00::0 ip6-localnet
	ff02::1 ip6-allnodes
	ff02::2 ip6-allrouters
	ff02::3 ip6-allhosts

	127.0.0.1      octolinux
HOSTS
echo "Done!"

echo "Adding permission to Octoprint $userSelect to reboot without password"
echo "..."
mv /etc/sudoers.d/octoprint-shutdown /etc/sudoers.d/octoprint-shutdown_bak &> /dev/null
cat &> /dev/null<<SUDOER | sudo tee -a /etc/sudoers.d/octoprint-shutdown 

	$userSelect ALL=NOPASSWD: /sbin/shutdown
SUDOER
echo "Done!"

sudo apt install haproxy -y &> /dev/null
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_bak
cat &> /dev/null<<PROXY | sudo tee -a /etc/haproxy/haproxy.cfg
	global
			maxconn 4096
			user haproxy
			group haproxy
			daemon
			log 127.0.0.1 local0 debug

	defaults
			log     global
			mode    http
			option  httplog
			option  dontlognull
			retries 3
			option redispatch
			option http-server-close
			option forwardfor
			maxconn 2000
			timeout connect 5s
			timeout client  15min
			timeout server  15min

	frontend public
			bind :::80 v4v6
			use_backend webcam if { path_beg /webcam/ }
			default_backend octoprint

	backend octoprint
			reqrep ^([^\ :]*)\ /(.*)     \1\ /\2
			option forwardfor
			server octoprint1 127.0.0.1:5000

	backend webcam
			reqrep ^([^\ :]*)\ /webcam/(.*)     \1\ /\2
			server webcam1  127.0.0.1:8080
PROXY

echo "Remember to reboot the computer at least once to complete the $printCount Octoprint instance(s) to fully set up"
echo "Everything is Done!"



