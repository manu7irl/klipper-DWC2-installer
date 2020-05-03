#!/bin/bash
# This script installs Klipper on an debian
#
# Helper functions
clear
report_status()
{
    echo -e "\n\n###### $1"
}

verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        report_status "This script must not run as root"
        exit -1
    fi
}

# Force script to exit if an error occurs
set -e

report_status "This will install Klipper on linux for you, as many times as you require."
report_status "On Which unix user this install should be run on? watch out for typos!"
read userSelect
installLocation=/home/$userSelect
mkdir -p $installLocation/KlipperFarm/
klipperfarm=$installLocation/KlipperFarm
SRCDIR=$installLocation/klipper
while true; do
	read -p "The klipper instance(s) will be installed for user $userSelect, are you sure?[Y/N]" yn
	case $yn in
		[Yy]* ) break;;
   		[Nn]* ) report_status "On Which unix user this install should be run on? watch out for typos!"; read userSelect; continue;;
    		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
	esac
done	
while true; do
	report_status "How many 3D-printers do you want to run on it?"
	read printerCount
	klipper_session=1
	octoprint_session=1
    one_install=1
	
	if [ $(($printerCount)) == $(($one_install)) ];
		then
			read -p "Only $printerCount main Klipper service will be installed without instances, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
		else
			read -p "Only $printerCount instances of Klipper will be installed, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
			break	
	fi		
done

report_status "Thanks! Full steam ahead to install $printerCount Klipper instance(s) in $klipperfarm"

# Step 0: Clone Klipper folder
clone_klipper()
{
    cd $installLocation
    if [ -d klipper ]; then
    continue
    else
    report_status "Cloning Klipper folder from Kevin's GITHUB main branch"
    report_status "..."
    git clone https://github.com/KevinOConnor/klipper &> /dev/null
    sleep 5
    report_status "Done!"
    fi
    
}
report_status "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 5
report_status "Just preparing your system for install"
report_status "..."

PYTHONDIR="$installLocation/klippy-env"
SYSTEMDDIR="/etc/systemd/system"
KLIPPER_USER=$userSelect
KLIPPER_GROUP=$userSelect

# Step 1: Install system packages
install_packages()
{
    # Packages for python cffi
    PKGLIST="python-virtualenv virtualenv python-dev libffi-dev build-essential"
    # kconfig requirements
    PKGLIST="${PKGLIST} libncurses-dev"
    # hub-ctrl
    PKGLIST="${PKGLIST} libusb-dev"
    # AVR chip installation and building
    PKGLIST="${PKGLIST} avrdude gcc-avr binutils-avr avr-libc"
    # ARM chip installation and building
    PKGLIST="${PKGLIST} stm32flash libnewlib-arm-none-eabi"
    PKGLIST="${PKGLIST} gcc-arm-none-eabi binutils-arm-none-eabi"

    # Update system package info
    report_status "Running package updater..."
    sudo apt-get update &> /dev/null

    # Install desired packages
    report_status "Installing packages..."
    sudo apt-get install --yes ${PKGLIST} &> /dev/null

    # Confirm user permissions
    report_status "Check $userSelect permissions..."
    sudo usermod -a -G tty $userSelect &> /dev/null
    sudo usermod -a -G dialout $userSelect &> /dev/null
}

# Step 2: Create python virtual environment
create_virtualenv()
{
    report_status "Updating python virtual environment..."

    # Create virtualenv if it doesn't already exist
    [ ! -d ${PYTHONDIR} ] && virtualenv ${PYTHONDIR} &> /dev/null

    # Install/update dependencies
    [ ! -d ${PYTHONDIR} ] && ${PYTHONDIR}/bin/pip install -r ${SRCDIR}/scripts/klippy-requirements.txt &> /dev/null
}

# Step 3: Install startup script
install_script()
{
    # Create systemd service file
    sudo systemctl daemon-reload
    CONcounter=1
    PORT=4750
    while [ $CONcounter -le $printerCount ]
    do
        mkdir -p $klipperfarm/printer-$CONcounter/sdcard
        PRINTER_FOLDER=$klipperfarm/printer-$CONcounter
        cat &> /dev/null <<EXAMPLE > $PRINTER_FOLDER/printer-$CONcounter.cfg
        this is an example config to start with,
        you will have to connect each printer separately first, 
        to find the serial path of each one and configure this under:
        [mcu]
        serial: /dev/serial/by-id/myprinter-$CONcounter

        enter in your terminal: ls /dev/serial/by-id
        and you will get the physical path to your printer, 
        this path or id should be unique for each printer in order to run with the others without conflicts
        
        
        ########
        # DWC UI
        ########

        [virtual_sdcard]
        path: $PRINTER_FOLDER/sdcard

        [web_dwc2]
        # optional - defaulting to Klipper
        printer_name: My PRINTER-$CONcounter
        # optional - defaulting to 127.0.0.1
        listen_adress: 0.0.0.0
        # needed - use above 1024 as nonroot
        listen_port: $(($PORT + CONcounter))
        #	optional defaulting to dwc2/web. Its a folder relative to your virtual sdcard.
        web_path: dwc2/web
EXAMPLE
        KLIPPER_LOG=/tmp/klippy-$CONcounter.log
        TMP_PRINTER=/tmp/printer-$CONcounter
        PRINTER_FOLDER=$klipperfarm/printer-$CONcounter
        PRINTER_CONFIG=$PRINTER_FOLDER/printer-$CONcounter.cfg
        report_status "Installing systemd startup script..."

        cat &> /dev/null <<SERVICE > $klipperfarm/klipper-$CONcounter.service
        #Systemd service file for klipper
        [Unit]
        Description=Starts klipper on startup
        After=network.target
        [Install]
        WantedBy=multi-user.target
        [Service]
        Type=simple
        User=$KLIPPER_USER
        RemainAfterExit=yes
        ExecStart=${PYTHONDIR}/bin/python ${SRCDIR}/klippy/klippy.py ${PRINTER_CONFIG} -I ${TMP_PRINTER} -l ${KLIPPER_LOG}
        Restart=always
        RestartSec=10
SERVICE
        sudo mv $klipperfarm/klipper-$CONcounter.service $SYSTEMDDIR/
        # Use systemctl to enable the klipper systemd service script
        sudo systemctl enable klipper-$CONcounter.service &> /dev/null
        sudo systemctl start klipper-$CONcounter &> /dev/null
        sleep 5
        report_status "Service klipper-$CONcounter has been started!"
    ((CONcounter++))
    done
        report_status "Done!"
        report_status "..."
        sleep 5
        report_status "Congradulations.... You should have $printerCount Klipper instance(s) running!"
        }

# Run installation steps defined above
verify_ready
clone_klipper
install_packages
create_virtualenv
install_script