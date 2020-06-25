#!/bin/bash
EDITOR=nano
PASSWD=/etc/passwd
clear
# function to display menus
show_menus() {
  clear
  echo '
 /$$   /$$ /$$       /$$$$$$ /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$$$$$$         /$$$           /$$$$$$$  /$$      /$$  /$$$$$$   /$$$$$$ 
| $$  /$$/| $$      |_  $$_/| $$__  $$| $$__  $$| $$_____/| $$__  $$       /$$ $$         | $$__  $$| $$  /$ | $$ /$$__  $$ /$$__  $$
| $$ /$$/ | $$        | $$  | $$  \ $$| $$  \ $$| $$      | $$  \ $$      |  $$$          | $$  \ $$| $$ /$$$| $$| $$  \__/|__/  \ $$
| $$$$$/  | $$        | $$  | $$$$$$$/| $$$$$$$/| $$$$$   | $$$$$$$/       /$$ $$/$$      | $$  | $$| $$/$$ $$ $$| $$        /$$$$$$/
| $$  $$  | $$        | $$  | $$____/ | $$____/ | $$__/   | $$__  $$      | $$  $$_/      | $$  | $$| $$$$_  $$$$| $$       /$$____/ 
| $$\  $$ | $$        | $$  | $$      | $$      | $$      | $$  \ $$      | $$\  $$       | $$  | $$| $$$/ \  $$$| $$    $$| $$      
| $$ \  $$| $$$$$$$$ /$$$$$$| $$      | $$      | $$$$$$$$| $$  | $$      |  $$$$/$$      | $$$$$$$/| $$/   \  $$|  $$$$$$/| $$$$$$$$
|__/  \__/|________/|______/|__/      |__/      |________/|__/  |__/       \____/\_/      |_______/ |__/     \__/ \______/ |________/
                                                                                                                                     
                                                                                                                                     
                                                                                                                                     
                    /$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$  /$$$$$$$  /$$$$$$$  /$$$$$$ /$$   /$$ /$$$$$$$$                            
                   /$$__  $$ /$$__  $$|__  $$__//$$__  $$| $$__  $$| $$__  $$|_  $$_/| $$$ | $$|__  $$__/                            
                  | $$  \ $$| $$  \__/   | $$  | $$  \ $$| $$  \ $$| $$  \ $$  | $$  | $$$$| $$   | $$                               
                  | $$  | $$| $$         | $$  | $$  | $$| $$$$$$$/| $$$$$$$/  | $$  | $$ $$ $$   | $$                               
                  | $$  | $$| $$         | $$  | $$  | $$| $$____/ | $$__  $$  | $$  | $$  $$$$   | $$                               
                  | $$  | $$| $$    $$   | $$  | $$  | $$| $$      | $$  \ $$  | $$  | $$\  $$$   | $$                               
                  |  $$$$$$/|  $$$$$$/   | $$  |  $$$$$$/| $$      | $$  | $$ /$$$$$$| $$ \  $$   | $$                               
                   \______/  \______/    |__/   \______/ |__/      |__/  |__/|______/|__/  \__/   |__/                               
                                                                                                                                     
                                                                                                                                     
                                                                                                                                     
                   /$$$$$$ /$$   /$$  /$$$$$$  /$$$$$$$$ /$$$$$$  /$$       /$$       /$$$$$$$$ /$$$$$$$                             
                  |_  $$_/| $$$ | $$ /$$__  $$|__  $$__//$$__  $$| $$      | $$      | $$_____/| $$__  $$                            
                    | $$  | $$$$| $$| $$  \__/   | $$  | $$  \ $$| $$      | $$      | $$      | $$  \ $$                            
                    | $$  | $$ $$ $$|  $$$$$$    | $$  | $$$$$$$$| $$      | $$      | $$$$$   | $$$$$$$/                            
                    | $$  | $$  $$$$ \____  $$   | $$  | $$__  $$| $$      | $$      | $$__/   | $$__  $$                            
                    | $$  | $$\  $$$ /$$  \ $$   | $$  | $$  | $$| $$      | $$      | $$      | $$  \ $$                            
                   /$$$$$$| $$ \  $$|  $$$$$$/   | $$  | $$  | $$| $$$$$$$$| $$$$$$$$| $$$$$$$$| $$  | $$                            
                  |______/|__/  \__/ \______/    |__/  |__/  |__/|________/|________/|________/|__/  |__/                            
'
 
    echo "=========================="
    echo "    INSTALL OR UPDATE     "
    echo "    KLIPPER & DWC2        "
    echo "    OCTOPRINT             "
    echo "    BY MANU7IRL           "
    echo "=========================="
    echo "1. Install KLIPPER"
    echo "2. Update KLIPPER"
    echo "3. Flash your MCU"
    echo "4. Install DWC2"
    echo "5. Update DWC2"
    echo "6. Install OCTOPRINT"
    echo "7. Uninstall KLIPPER & DWC"
    echo "8. Uninstall OCTOPRINT"
    echo "9. Exit"
}
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

verify_ready
show_menus
pause(){
  read -p "Press [Enter] to return to the main menu..." fackEnterKey
}

report_status "Welcome to my Klipper, DWC2 & Octoprint, global installer!"
sleep 1
report_status "Before we start it, some basic questions to get it running correctly..."
sleep 1
report_status "On Which unix user the Installer should be run on? watch out for typos!"
read userSelect
while true; do
	read -p "###### This Installer will be launched for user: $userSelect, are you sure?[Y/N]" yn
	case $yn in
		[Yy]* ) break;;
   		[Nn]* ) report_status "On Which unix user this install should be run on? watch out for typos!"; read userSelect; continue;;
    		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
	esac
done
# create some folders & variables
installLocation=/home/$userSelect
PrinterFarm=$installLocation/PrinterFarm
KlipperFarm=$PrinterFarm/KlipperFarm
OctoPrintFarm=$PrinterFarm/OctoPrintFarm
OCTOPRINT=$PrinterFarm/OctoPrintFarm/octoprint
KLIPPER=$PrinterFarm/KlipperFarm/klipper
GITSRC=$PrinterFarm/git_source
PYTHONDIR="$KLIPPER/klippy-env"
SYSTEMDDIR="/etc/systemd/system"
KLIPPER_USER=$userSelect
KLIPPER_GROUP=$userSelect
PRINTER_FOLDER=$KlipperFarm/printer-$printer_num
SDCARD=$PRINTER_FOLDER/sdcard
SERV_F=$GITSRC/service_files
while true
do
	report_status "How many 3D-printers do you want to run on it?"
	read printerCount
	install_1=0
  session_num=$(( printerCount-1 ))
	
	if [ $(( session_num )) == $(( install_1 )) ]
		then
			read -p "###### You chose only $printerCount 3D-printer to install, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
		else
			read -p "###### Ok, $printerCount 3D-printer(s) will be installed, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
			break	
	fi		
done

report_status "Thanks! We collected enough information to launch the main menu!"
report_status "Creating some folders..."
[ ! -d $PrinterFarm ] && mkdir -p $PrinterFarm
 
klipper_install(){
  if [  -d "$KLIPPER" ] || [ -f /ect/systemd/system/klipper-* ]
  then

    report_status "KLIPPER is already installed!"
    sleep 2
    report_status "Update is available in the menu, or remove it cleanly from it."
  else
    report_status "Starting KLIPPER install process..."
    [ ! -d ${KlipperFarm} ] && mkdir -p $KlipperFarm
    [ ! -d ${GITSRC} ] && mkdir -p $GITSRC
    [ ! -d ${SERV_F} ] && mkdir -p $SERV_F
    cd $GITSRC
    report_status "Cloning the KLIPPER folder From GITHUB..."
    sleep 2
    [ ! -d ${GITSRC}/klipper ] && git clone https://github.com/KevinOConnor/klipper.git &> /dev/null
    rsync -a ${GITSRC}/klipper $KlipperFarm &> /dev/null
    sleep 2 
  
    report_status "There are sudo commands contained within, you will be asked for your sudo password in the next step"
    sleep 5
    report_status "Just preparing your system for install..."

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

        # serial access perms for the chosen username
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
        [ -d ${PYTHONDIR} ] && ${PYTHONDIR}/bin/pip2 install -r ${KLIPPER}/scripts/klippy-requirements.txt &> /dev/null 
    }

    # Step 3: Install startup script
    install_script()
    {
        # Create systemd service file
        sudo systemctl daemon-reload
        printer_num=0

        while (( $printer_num <= $session_num ))
        do
            PRINTER_FOLDER=$KlipperFarm/printer-$printer_num
            SDCARD=$PRINTER_FOLDER/sdcard
            PRINTER_CFG=$PRINTER_FOLDER/printer-$printer_num.cfg
            report_status "Creating a default printer-$printer_num_default.cfg under $PRINTER_CFG"
            [ ! -d ${PRINTER_FOLDER} ] && mkdir -p $PRINTER_FOLDER
            [ ! -d ${SDCARD} ] && mkdir -p $SDCARD
            [ ! -f ${PRINTER_CFG} ] && cat &> /dev/null <<EXAMPLE > $PRINTER_FOLDER/printer-$printer_num_default.cfg
            #this is an example config to start with,
            #you will have to connect each printer separately first, 
            #to find the serial path of each one and configure this under:
            
            [mcu]
            serial: /dev/serial/by-id/myprinter-$printer_num

            #enter in your terminal: ls /dev/serial/by-id
            #and you will get the physical path to your printer, 
            #this path or id should be unique for each printer in order to run with the others without conflicts
EXAMPLE
            if [ $session_num == 0 ]
            then
            if [ -f $installLocation/printer.cfg ] && report_status "Moving and renaming your printer.cfg to the correct folder... under $PRINTER_FOLDER/"; sleep 3 && mv $installLocation/printer.cfg $KlipperFarm/$PRINTER_FOLDER
            else
            report_status "You do not a a printer.cfg file in $installLocation folder, do not forget to create one, in order to get the printer to work with klipper"
            sleep 2
            report_status "After you created a printer.cfg file move it to $PRINTER_FOLDER folder, and rename it printer-$printer_num.cfg"
            sleep 2
            fi
            KLIPPER_LOG=/tmp/klippy-$printer_num.log
            TMP_PRINTER=/tmp/printer-$printer_num
            report_status "Installing systemd startup script klipper-$printer_num..."
            cat &> /dev/null <<SERVICE > $KlipperFarm/klipper-$printer_num.service
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
            ExecStart=${PYTHONDIR}/bin/python ${KLIPPER}/klippy/klippy.py ${PRINTER_CFG} -I ${TMP_PRINTER} -l ${KLIPPER_LOG}
            Restart=always
            RestartSec=10
SERVICE
            sudo mv $KlipperFarm/klipper-$printer_num.service $SYSTEMDDIR/ &> /dev/null
            # Use systemctl to enable the klipper systemd service script
            sudo systemctl enable klipper-$printer_num.service &> /dev/null
            sudo systemctl start klipper-$printer_num &> /dev/null
            sleep 5
            report_status "Service klipper-$printer_num has been started!"
        printer_num=$(( printer_num+1 ))
        done
            
            report_status "..."
            sleep 5
            report_status "Congradulations.... You should have $printerCount Klipper instance(s) running!"
      }
    # Run installation steps defined above
    install_packages
    create_virtualenv
    install_script
    fi
pause
}
 
klipper_update(){
report_status "This will upgrade $printerCount klipper instance(s)!"  
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Stopping klipper-$printer_num service..."
  sudo systemctl stop klipper-$printer_num
  printer_num=$(( printer_num+1 ))
  done
cd $GITSRC/klipper
report_status "Updating the KLIPPER folder from github..."
git pull
report_status "Moving the current klipper folder to backup $KLIPPER.bak"
rsync -a $PYTHONDIR $KlipperFarm &> /dev/null
rsync -a $KLIPPER $KLIPPER.bak &> /dev/null && rm -fR $KLIPPER &> /dev/null
rm -Rf $KLIPPER &> /dev/null
rsync -a $GITSRC/klipper $KlipperFarm &> /dev/null
rsync -a $KlipperFarm/klippy-env $KLIPPER &> /dev/null
rm -Rf $KlipperFarm/klippy-env &> /dev/null
report_status "KLIPPER is up to date!"
sleep 1
printer_num=0
while (( $printer_num <= $session_num ))
  do
  [ -d ${SDCARD}/dwc2 ] && report_status "Also updating DWC2 in $SDCARD/, as it was installed previously" && dwc_update
  printer_num=$(( printer_num+1 ))
  done
sleep 1
report_status "You may need to reflash your MCU for the update into account"
sleep 2
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Starting klipper-$printer_num service..."
  sudo systemctl start klipper-$printer_num
  printer_num=$(( printer_num+1 ))
  done
pause
}
 
flash_mcu(){
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Stopping klipper-$printer_num service..."
  sudo systemctl stop klipper-$printer_num
  printer_num=$(( printer_num+1 ))
  done
cd $KLIPPER
report_status "please, connect only one MCU for each printer needed to flash"
sleep 2
report_status "Creating a new micro firmware for the MCU connected"
make clean
report_status "Opening menuconfig, choose your MCU type, then choose exit"
make menuconfig
report_status "Compiling the micro firmware..."
sleep 2
make
report_status "The firmware is ready! You also found it at $KLIPPER/src/klipper.elf.hex or $installLocation/PrinterFarm/klipper/out/klipper.bin"
sleep 3
cat << EOF
 
    =================================
    KLIPPER MICRO FIRMWARE FLASHING:
    ---------------------------------
    Please choose the method needed:
    (1)Flash your MCU via serial USB
    (2)Flash your MCU via SDCARD
    (Q)uit
    ---------------------------------
EOF
  read -n1 -s
    case "$REPLY" in
      "1")  report_status "Flashing the MCU with the new compiled micro firmware..."
            sleep 3
            report_status "Please connect your printer via USB cable"
            read -n 1 -s -r -p "Press any key to continue"
            mcu_add=$(ls -A /dev/serial/by-id/)
                if [ $? != 0 ] 
                then
                  report_status "Please plug in your MCU via USB cable, prior trying to flash it!"
                  sleep 3
                else
                  report_status "Flashing your MCU..."
                  make flash FLASH_DEVICE=/dev/serial/by-id/$mcu_add | tee -a flash.log
                fi

                if [ -f $KLIPPER/flash.log ]
                 then
                  report_status "Your MCU is flashed now"
                  sleep 2
                else
                  report_status "You may have encountered a problem! Check your USB connection and try to flash it again..."
                  sleep 2
                fi

                while (( $printer_num <= $session_num ))
                  do
                  report_status "Starting klipper-$printer_num service..."
                  sudo systemctl start klipper-$printer_num
                  printer_num=$(( printer_num+1 ))
                done
                sleep 3
                pause ;;
      "2")
            cd $KLIPPER
            report_status "Renaming the klipper.elf.hex to firmware.bin..."
            rsync -a $KLIPPER/out/klipper.bin $KLIPPER/out/firmware.bin
            report_status "Please insert an SDCARD (min. 128MB)..."
            read -n 1 -s -r -p "Press any key to continue"
            sudo lsblk
            sleep 5
            report_status "What is your sdcard device name? type in the deivce name in /dev/"device" like /dev/"sdb", corresponding to your sdcard"
            read DEVICE
            check_sdcard=$(ls -A /dev/$DEVICE1)
            if [ $? == 0 ] 
            then
              report_status "There are sudo commands contained within, you will be asked for your sudo password in the next step"
              sleep 2
              report_status "mounting the SDCARD to /mnt/"
              sudo mount /dev/$DEVICE1 /mnt/
              report_status "Moving the micro firmware to the SDCARD..."
              sudo rsync -va --no-owner --no-group --remove-fource-files $KLIPPER/out/firmware.bin /mnt/
              ls -A /mnt/firmware.bin
              sleep 2
              report_status "Unmounting the SDCARD..."
              sudo umount /mnt/
              report_status "Now insert the SDCARD into your MCU, power it on and press the reset button"
              sleep 3
              report_status "Congrats you just flashed your MCU!"
              sleep 2
            else
              report_status "Your SDCARD is not connected!"
              sleep 3
            fi
            printer_num=0
            while (( $printer_num <= $session_num ))
              do
              report_status "restarting klipper-$printer_num service..."
              sudo systemctl restart klipper-$printer_num
              printer_num=$(( printer_num+1 ))
              done
            sleep 3 ;;
      "Q") pause ;;
      "q") report_status "case sensitive!!" ;;
      *) report_status "invalid option" ;;
      esac
      sleep 1
      report_status "If you need to flash an other MCU, launch this script again!"
      pause
}
 
 
dwc_install(){
report_status "Installing Duet Web Control web-UI, for your $printerCount Klipper instance(s)..."
sleep 2
cd $KlipperFarm
report_status "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 2
sudo apt install wget gzip tar -y &> /dev/null
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Stopping klipper-$printer_num service..."
  sudo systemctl stop klipper-$printer_num
  printer_num=$(( printer_num+1 ))
  done
if [ -d ${KLIPPER} ] 
then
  report_status "Adding some magic to make dwc2-for-klipper working..."
  virtualenv $PYTHONDIR &> /dev/null
  ${PYTHONDIR}/bin/pip2 install tornado==5.1.1 &> /dev/null
  report_status "Cloning the dwc2-for-klipper folder from Pluuuk GITHUB..."
  cd $GITSRC
  [ ! -d $GITSRC/dwc2-for-klipper ] && git clone https://github.com/th33xitus/dwc2-for-klipper.git &> /dev/null
  [ ! -d $KLIPPER/dwc2-for-klipper ]  && rsync -a $GITSRC/dwc2-for-klipper $KLIPPER &> /dev/null
  report_status "Making a magical change in web_dwc2.py to make multi-session possible..."
  sed -i "s|'/tmp/printer'|config.get(\"serial_path\", \"/tmp/printer\")|g" $KLIPPER/dwc2-for-klipper/web_dwc2.py
  report_status "Connecting dwc2-for-klipper as an extra module for klippy -> web_dwc2.py..."
  web_dwc2=$KLIPPER/klippy/extras/web_dwc2.py
  if [ -f ${web_dwc2} ]
  then
    report_status "$dwc2_module is already linked to KLIPPY"
    sleep 2
  else
    user=$userSelect
    ln -f $KLIPPER/dwc2-for-klipper/web_dwc2.py $KLIPPER/klippy/extras/web_dwc2.py
    chown -h $userSelect:$userSelect $KLIPPER/klippy/extras/web_dwc2.py
    dwc2_module=$(ls -A $KLIPPER/klippy/extras | grep -woh web_dwc2.py)
    report_status "$dwc2_module is linked to KLIPPY"
    sleep 2
  fi
  #report_status "Backup for $KLIPPER/klippy/gcode.py file"
  #sleep 2
  #rsync -a $KLIPPER/klippy/gcode.py $KLIPPER/klippy/gcode.py.bak &> /dev/null
  #report_status "Doing some more magic... Correcting some stuff in $KLIPPER/klippy/gcode.py"
  #sleep 2
  # make changes in klipper we need
  #report_status "Patching $KLIPPER/klippy/gcode.py..."
    #patch -p0 -N -s --dry-run  $KLIPPER/klippy/gcode.py $KLIPPER/dwc2-for-klipper/dwc2_gcode_py.patch
    #if [ $? -eq 0 ];
    #then
    #patch -p0 -N  $KLIPPER/klippy/gcode.py $KLIPPER/dwc2-for-klipper/dwc2_gcode_py.patch
    #fi

  report_status "Creating a folder for nesting the DuetWebControl UI files"
  report_status "Downloading the official latest DWC release, from Chrishamm GITHUB..."
  cd $SERV_F
  latest_DWC=`curl -s https://api.github.com/repositories/28820678/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep SD`
  [ -f *.zip ] && rm $SERV_F/*.zip 
  wget $latest_DWC &> /dev/null
  klipper_num=`find /etc/systemd/system -type f -name 'klipper-*' -printf x | wc -c`
  session_num=$(( $klipper_num-1 ))
  printer_num=0
  PORT=4750
  while (( $printer_num <= $session_num ))
  do
    PRINTER_FOLDER=$KlipperFarm/printer-$printer_num
    SDCARD=$PRINTER_FOLDER/sdcard
    [ ! -d ${SDCARD}/dwc2/web ] && mkdir -p $SDCARD/dwc2/web
    [ ! -d ${SDCARD}/sys ] && mkdir -p $SDCARD/sys
    [ -f $SDCARD/dwc2/web/*.zip ] && rm $SDCARD/dwc2/web/*.zip
    [ ! -f $SDCARD/dwc2/web/*.zip ] && rsync -a $SERV_F/*.zip $SDCARD/dwc2/web
    report_status "Installing the web server files on printer-$printer_num"
    cd $SDCARD/dwc2/web
    unzip *.zip && for f_ in $(find . | grep '.gz'); do gunzip ${f_}; done
    rm $SDCARD/dwc2/web/*.zip
    sleep 2
    report_status "Creating the default sections [virtual_sdcard] and [web_dwc2], in your printer-$printer_num.cfg file, as describe in Stephan3 GITHUB"
    sleep 5
    [ -f ${PRINTER_CFG} ] && cat <<DWC2 >> $PRINTER_FOLDER/printer-$printer_num.cfg      
#########################
# OPTIONAL DWC UI CONFIG
#########################
#you can also point all your printer to the same sd
[virtual_sdcard]
path: $SDCARD

[web_dwc2]
# optional - defaulting to Klipper
printer_name: My-Printer-$printer_num
# optional - defaulting to 127.0.0.1
listen_adress: 0.0.0.0
# needed - use above 1024 as nonroot
listen_port: $(( ${PORT}+${printer_num} ))
#	optional defaulting to dwc2/web. It's a folder relative to your $SDCARD path folder.
web_path: /dwc2/web
# optional - defaulting to /tmp/printer, needed in order to get dwc multi-session
serial_path: /tmp/printer-$printer_num
DWC2
    sleep 3
    new_port=$(( ${PORT}+${printer_num} ))
    report_status "DWC2 server-$printer_num is running on http://$(hostname):$new_port or http://localhost:$new_port"
  printer_num=$(( printer_num+1 ))
  done
  [ -f $SERV_F/*.zip ] && rm $SERV_F/*.zip    
  
  report_status "..."
  sleep 5
  report_status "Congradulations.... You should have $printerCount DWC2 server(s) running!"
  printer_num=0
  while (( $printer_num <= $session_num ))
    do
    report_status "Restarting klipper-$printer_num service..."
    sudo systemctl restart klipper-$printer_num
    printer_num=$(( printer_num+1 ))
  done
  else
    report_status "Klipper is not installed please install it first!"
    sleep 2
  fi
pause
}
 
dwc_update(){
  cd $GITSRC/dwc2-for-klipper
  git pull
  rm -vRf $KLIPPER/dwc2-for-klipper &> /dev/null
  rsync -a $GITSRC/dwc2-for-klipper $KLIPPER
  report_status "Making a magical change in web_dwc2.py to make multi-session possible..."
  sed -i "s|'/tmp/printer'|config.get(\"serial_path\", \"/tmp/printer\")|g" $KLIPPER/dwc2-for-klipper/web_dwc2.py
  report_status "Connecting dwc2-for-klipper as an extra module for klippy -> web_dwc2.py..."
  web_dwc2=$KLIPPER/klippy/extras/web_dwc2.py
  if [ -f ${web_dwc2} ]
  then
    report_status "$dwc2_module is already linked to KLIPPY"
    sleep 2
  else
    user=$userSelect
    ln -f $KLIPPER/dwc2-for-klipper/web_dwc2.py $KLIPPER/klippy/extras/web_dwc2.py
    chown -h $userSelect:$userSelect $KLIPPER/klippy/extras/web_dwc2.py
    dwc2_module=$(ls -A $KLIPPER/klippy/extras | grep -woh web_dwc2.py)
    report_status "$dwc2_module is linked to KLIPPY"
    sleep 2
  fi
  cd $SERV_F
  latest_DWC=`curl -s https://api.github.com/repositories/28820678/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep SD`
  wget $latest_DWC &> /dev/null
  klipper_num=`find /etc/systemd/system -type f -name 'klipper-*' -printf x | wc -c`
  session_num=$(( $klipper_num-1 ))
  printer_num=0
  PORT=4750
  while (( $printer_num <= $session_num ))
  do
    PRINTER_FOLDER=$KlipperFarm/printer-$printer_num
    SDCARD=$PRINTER_FOLDER/sdcard
    report_status "removing the old web folder for DWC2, in $SDCARD/dwc2/..."
    [ -d ${SDCARD}/dwc2/web ] && rm -vRf $SDCARD/dwc2/web &> /dev/null
    [ ! -d ${SDCARD}/dwc2/web ] && mkdir -p $SDCARD/dwc2/web
    [ ! -d ${SDCARD}/sys ] && mkdir -p $SDCARD/sys
    [ -f ${SDCARD}/dwc2/web/*.zip ] && rm $SDCARD/dwc2/web/*.zip
    rsync -a $SERV_F/*.zip $SDCARD/dwc2/web
    report_status "Installing the web server files on printer-$printer_num"
    cd $SDCARD/dwc2/web
    unzip *.zip && for f_ in $(find . | grep '.gz'); do gunzip ${f_}; done
    sleep 2
    new_port=$(( ${PORT}+${printer_num} ))
    report_status "DWC2 server-$printer_num is running on http://$(hostname):$new_port or http://localhost:$new_port"
    printer_num=$(( printer_num+1 ))
  done
    rm $SERV_F/*.zip  
    report_status "..."
    sleep 5
    printer_num=0
    while (( $printer_num <= $session_num ))
  do
    report_status "Restarting klipper-$printer_num service..."
    sudo systemctl restart klipper-$printer_num
    printer_num=$(( printer_num+1 ))
  done
    report_status "Congradulations... You should have $printerCount DWC2 server(s) updated!"
  
  sleep 3
pause
}

octorprint_install(){
 [ ! -d ${OctoPrintFarm} ] && mkdir -p $OctoPrintFarm
 [ ! -d ${OCTOPRINT} ] && mkdir -p $OCTOPRINT
report_status "This will install OctoPrint on linux for you, as many times as you require."
while true
do
	report_status "How many 3D-printer do you want to use with OctoPrint?"
	read printerCount
  install_1=0
	session_num=$(( $printerCount-1 ))
	
	if [ $(($printer_num)) == $((install_1)) ];
		then
			read -p "###### Only $octo_session main OctoPrint service will be installed without instances, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
		else
			read -p "###### Only $printerCount OctoPrint instance(s) will be installed, are you sure?[Y/N]" yn
			case $yn in
				[Yy]* ) break;;
        		[Nn]* ) continue;;
        		* ) report_status "Please answer by yes (Y/y) or no (N/n).";;
    		esac
			break	
	fi		
done

report_status "Thanks! Full steam ahead to install $printerCount OctoPrint instance(s) in $OctoPrintFarm"
report_status "There are sudo commands contained within, you will be asked for your sudo password in the next step"
sleep 5
report_status "Just preparing your system for install"
sudo apt update &> /dev/null && sudo apt install git python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential -y &> /dev/null
report_status "Just making sure $userSelect has the correct permissions"
sudo usermod -a -G tty $userSelect &> /dev/null
sudo usermod -a -G dialout $userSelect &> /dev/null
report_status "Now I will handle $printerCount OctoPrint instance(s) install "
cd $OCTOPRINT &> /dev/null
report_status "Creating the virtualenv"
report_status "..."
virtualenv venv &> /dev/null
source venv/bin/activate &> /dev/null
report_status "Downloading Latest OctoPrint version from Github"
report_status "..."
pip install pip --upgrade &> /dev/null
pip install https://get.octoprint.org/latest &> /dev/null

[ ! -d ${SERV_F} ] && mkdir -p $SERV_F
cd $SERV_F
if [ ! -f ${SERV_F}/octoprint.init ]
then
    report_status "Downloading init file...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init -P $SERV_F &> /dev/null
    
fi
if [ ! -f ${SERV_F}/octoprint.default ]
then
    report_status "Downloading default file...."
    wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default -P $SERV_F &> /dev/null
    
fi
report_status "Now we need to create a system service for each instance. Two sec's I'll get on it!"
report_status "..."
sudo systemctl daemon-reload
PRT=5000
printer_num=0
octo_config=$OctoPrintFarm/.octoprint-$printer_num
while (( $printer_num <= $session_num ))
do
	[ ! -d ${octo_config} ] && mkdir -p $octo_config
	PORTcounter=$(( $PRT+$printer_num ))
	cp $SERV_F/octoprint.init $OctoPrintFarm/octoprint.init
	cp $SERV_F/octoprint.default $OctoPrintFarm/octoprint.default
	sed -i "s/USER=pi/USER=$userSelect/g" $OctoPrintFarm/octoprint.default
	sed -i "s/PORT=5000/PORT=$PORTcounter/g" $OctoPrintFarm/octoprint.default
	sed -i "s+#DAEMON=/home/pi/OctoPrint/venv/bin/octoprint+DAEMON=$OCTOPRINT/venv/bin/octoprint+g" $OctoPrintFarm/octoprint.default
	sed -i 's|#BASEDIR=/home/pi/.octoprint|BASEDIR='$OctoPrintFarm'/.octoprint-'$printer_num'|g' $OctoPrintFarm/octoprint.default
	sed -i 's|#CONFIGFILE=/home/pi/.octoprint/config.yaml|CONFIGFILE='$OctoPrintFarm'/.octoprint-'$printer_num'/config.yaml|g' $OctoPrintFarm/octoprint.default
	sed -i "s/UMASK=022/UMASK=022/g" $OctoPrintFarm/octoprint.default
	sed -i "s+DESC=\"OctoPrint\" Daemon\"+DESC=\"OctoPrint-$printer_num Daemon\"+g" $OctoPrintFarm/octoprint.init
	sed -i "s+NAME=\"OctoPrint\"+NAME=\"OctoPrint-$printer_num\"+g" $OctoPrintFarm/octoprint.init
	sed -i "s/PKGNAME=octoprint/PKGNAME=octoprint-$printer_num/g" $OctoPrintFarm/octoprint.init
	sudo mv $OctoPrintFarm/octoprint.init /etc/init.d/octoprint-$printer_num
	sudo mv $OctoPrintFarm/octoprint.default /etc/default/octoprint-$printer_num
	sudo chmod +x /etc/init.d/octoprint-$printer_num
	sudo update-rc.d octoprint-$printer_num defaults
	sudo systemctl daemon-reload
	sudo service octoprint-$printer_num start
	sleep 10
  new_port=
	report_status "Service octoprint-$printer_num has started on http://$(hostname):$PORTcounter or http://localhost:$PORTcounter"
	printer_num=$(( printer_num+1 ))
done


report_status "..."
sleep 5
report_status "Congradulations.... You should have $printerCount OctoPrint instance(s) running!"

cd $SERV_F
report_status "Installing webcam support"
report_status "..."
sudo apt install subversion libjpeg-dev imagemagick ffmpeg libv4l-dev cmake -y &> /dev/null
[ -d ${SERV_F}/mjpg_streamer ] && rm -fR $SERV_F/mjpg_streamer &> /dev/null
git clone https://github.com/jacksonliam/mjpg-streamer.git &> /dev/null
cd $SERV_F/mjpg-streamer/mjpg-streamer-experimental/
mkdir build && cd build
cmake .. &> /dev/null
make &> /dev/null
sudo make install &> /dev/null

report_status "Creating webcam lauching scripts in $OctPrintFarm/octo-scripts"
report_status "..."
cd $OctoPrintFarm
[ ! -d ${OctoPrintFarm}/octo-scripts ] && mkdir -p $OctoPrintFarm/octo-scripts
[ -f ${OctoPrintFarm}/octo-scripts/webcam ] && rsync - a $OctoPrintFarm/octo-scripts/webcam $OctoPrintFarm/octo-scripts/webcam.bak &> /dev/null && rm $OctoPrintFarm/octo-scripts/webcam &> /dev/null
cat &> /dev/null <<WEBCAM > $OctoPrintFarm/octo-scripts/webcam

	#!/bin/bash
	# Start / stop streamer daemon

	case "$1" in
		start)
			$installLocation/octo-scripts/webcamDaemon >/dev/null 2>&1 &
			report_status "$0: started"
			;;
		stop)
			pkill -x webcamDaemon
			pkill -x mjpg_streamer
			report_status "$0: stopped"
			;;
		restart)
			pkill -x webcamDaemon
			pkill -x mjpg_streamer
			$installLocation/octo-scripts/webcamDaemon >/dev/null 2>&1 &
			report_status "$0: restarted"
			;;

		*)
			report_status "Usage: $0 {start|stop|restart}" >&2
			;;
	esac 
WEBCAM
 
[ -f ${OctoPrintFarm}/octo-scripts/webcamDaemon ] && rsync -a $OctoPrintFarm/octo-scripts/webcamDaemon $OctoPrintFarm/octo-scripts/webcamDaemon.bak &> /dev/null && rm $OctoPrintFarm/octo-scripts/webcamDaemon &> /dev/null
cat &> /dev/null <<WEBCAMDAEMON > $OctoPrintFarm/octo-scripts/webcamDaemon
	
	#!/bin/bash

	MJPGSTREAMER_HOME=$installLocation/mjpg-ftreamer/mjpg-ftreamer-experimental
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
    report_status Running ./mjpg_streamer -o "output_http.so -w ./www" -i "$input"
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

	# report_status configuration
	report_status camera: $camera
	report_status usb options: $camera_usb_options
	report_status raspi options: $camera_raspi_options

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

chmod +x $OctoPrintFarm/octo-scripts/webcam*

[ -f /etc/rc.local ] && sudo mv /etc/rc.local /etc/rc.local.bak &> /dev/null
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

	$OctoPrintFarm/octo-scripts/webcam start

	exit0
AUTOSTART

sudo chmod +x /etc/rc.local


report_status "Adding new hostname octolinux"
report_status "..."
sudo apt install avahi-daemon -y &> /dev/null
[ -f /etc/hosts ] && sudo mv /etc/hosts /etc/hosts.bak &> /dev/null

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


report_status "Adding permission to Octoprint $userSelect user to reboot without password"
report_status "..."
[ -f /etc/sudoers.d/octoprint-shutdown ] && sudo mv /etc/sudoers.d/octoprint-shutdown /etc/sudoers.d/octoprint-shutdown.bak &> /dev/null
cat &> /dev/null<<SUDOER | sudo tee -a /etc/sudoers.d/octoprint-shutdown 

	$userSelect ALL=NOPASSWD: /sbin/shutdown
SUDOER


sudo apt install haproxy -y &> /dev/null
[ -f /etc/haproxy/haprox.cfg ] && sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
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
			option http-ferver-close
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

report_status "Remember to reboot the computer at least once to complete the $printCount Octoprint instance(s) to fully set up"
report_status "Everything is Done!"
pause
}

klipper_dwc_uninstall(){
    report_status "Launching Klipper uninstall script..."
    sleep 3
klipper_num=`find /etc/systemd/system -type f -name 'klipper-*' -printf x | wc -c`
session_num=$(( $klipper_num-1 ))

#sudo service klipper stop
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Stopping klipper-$printer_num service..."
  sudo systemctl stop klipper-$printer_num &> /dev/null
  sleep 1
  report_status "Disabling klipper-$printer_num service..."
  sudo systemctl disable klipper-$printer_num &> /dev/null
  sleep 1
  report_status "Removing klipper-$printer_num service..."
  sudo rm /etc/systemd/system/klipper-$printer_num.service &> /dev/null
  sleep 1
  report_status "Your config file, printer-$printer_num.cfg is still available, under $KlipperFarm/printer-$printer_num..."
  sleep 3
  report_status "Your $KlipperFarm/printer-$printer_num/sdcard folder is untouched..."
  sleep 3
  printer_num=$(( printer_num+1 ))
  done
# Remove Klipper from Services
sleep 3
# Notify user of method to remove Klipper source code
sleep 3
report_status "The Klipper & DWC system files have been removed."
rm -vRf $KLIPPER 
rm -vRf $SDCARD/dwc2
sleep 3
report_status "~/sdcard folder has not been removed"
sleep 3
pause    
}

octoprint_uninstall(){
  report_status "Not yet implemanted!"
  pause
} 

# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.

read_options(){
    local choice
    read -p "Please choose what to do, then press [ENTER] [ 1 - 9 ] " choice
    case $choice in
    1) klipper_install ;;
    2) klipper_update ;;
    3) flash_mcu ;;
    4) dwc_install ;;
    5) dwc_update ;;
    6) octorprint_install ;;
    7) klipper_dwc_uninstall ;;
    8) octoprint_uninstall ;;
    9) exit 0 ;;
        *) echo -e "${RED}${BG_WHITE}Error...${RESET}" && sleep 2
    esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
    show_menus
    read_options
done
