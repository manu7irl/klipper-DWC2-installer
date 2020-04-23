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
	echo "How many OctoPrint instances (one main install + (n)*instances) are needed?"
	read printerCount
	octo_session=1
	one_install=0
	printer_number=$(($printerCount-$octo_session))
	
	if [ $(($printer_number)) == $(($one_install)) ];
		then
			read -p "Only $octo_session the main OctoPrint instance will be install without instances, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) echo "Please answer by yes (Y/y) or no (N/n).";;
    		esac
		else
			read -p "Only $print_number instances of OctoPrint will be installed, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) echo "Please answer by yes (Y/y) or no (N/n).";;
    		esac
			break	
	fi		
done

echo "Thanks! Full steam ahead to install $printerCount OctoPrint instance(s) in $installLocation"
echo "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 5
echo "Just preparing your system for install"
echo "..."
sudo apt update && sudo apt install git python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential -y &> /dev/null
echo "Done!"
echo "Just making sure your $userSelect has the correct permissions"
echo "..."
sudo usermod -a -G tty $userSelect &> /dev/null
sudo usermod -a -G dialout $userSelect &> /dev/null
echo "Done!"
echo "Now I will handle the installations of your $printerCount OctoPrint instance(s) "
echo "..."
mkdir $installLocation/OctoprintFarm &> /dev/null
cd $installLocation/OctoprintFarm &> /dev/null
echo "Done!"
echo "Downloading Latest OctoPrint version from Github"
echo "..."
mkdir OctoPrint && cd OctoPrint &> /dev/null
virtualenv venv &> /dev/null &> /dev/null
source venv/bin/activate &> /dev/null
echo "Setting up the initial octoprint instance"
pip install pip --upgrade &> /dev/null
pip install https://get.octoprint.org/latest &> /dev/null
echo "Done!"
if [ ! -f $installLocation/OctoprintFarm/octoprint.init ];
then
    echo "Downloading init...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init -P $installLocation/OctoprintFarm
    echo "Done!"
fi
if [ ! -f $installLocation/OctoprintFarm/octoprint.default ];
then
    echo "Downloading init...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default -P $installLocation/OctoprintFarm
    echo "Done!"
fi
echo "Now we need to create a system service for each instance. Two sec's I'll get on it!"
echo "..."
sudo systemctl daemon-reload
PRT=5000
CONcounter=0
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
	echo "Service octoprint-$CONcounter has started on http://$hostname:$PORTcounter or http://locahost:$PORTcounter"
	((CONcounter++))
done

echo "Done!"
echo "..."
sleep 5
echo "Congradulations.... You should have a load of printers running!"
cd ~
echo "Install webcam support"
sudo apt install subversion libjpeg-dev imagemagick ffmpeg libv4l-dev cmake
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
mkdir build && cd build
cmake ..
make
sudo make install
cd $installLocation/
mkdir octo-scripts
cd octo-scripts
cat webcam < EOF
#!/bin/bash
# Start / stop streamer daemon

case "$1" in
    start)
        /home/chris/scripts/webcamDaemon >/dev/null 2>&1 &
        echo "$0: started"
        ;;
    stop)
        pkill -x webcamDaemon
        pkill -x mjpg_streamer
        echo "$0: stopped"
        ;;
    *)
        echo "Usage: $0 {start|stop}" >&2
        ;;
esac
EOF

cat webcamDaemon < EOF
#!/bin/bash

MJPGSTREAMER_HOME=/home/chris/mjpg-streamer/mjpg-streamer-experimental
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
EOF

sudo chmod +x webcam*

sudo cat /etc/rc.local < EOF
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

/home/'$userSelect'/Octo-scripts/webcam start

exit0

EOF

sudo apt install avahi-daemon

sudo cat /etc/hosts < EOF

127.0.0.1       localhost.localdomain   localhost
::1             localhost6.localdomain6 localhost6

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

127.0.0.1      octolinux

EOF





