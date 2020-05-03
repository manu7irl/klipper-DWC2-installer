#!/bin/bash
# Uninstall script for raspbian/debian type installations
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

verify_ready

installLocation=/home/$userSelect
PrinterFarm=$installLocation/PrinterFarm
KlipperFarm=$PrinterFarm/KlipperFarm
OctoPrintFarm=$PrinterFarm/OctoPrintFarm
OCTOPRINT=$PrinterFarm/octoprint
KLIPPER=$PrinterFarm/klipper
GITSRC=$PrinterFarm/git_source
PYTHONDIR="$KLIPPER/klippy-env"
SYSTEMDDIR="/etc/systemd/system"
KLIPPER_USER=$userSelect
KLIPPER_GROUP=$userSelect
SDCARD=$PRINTER_FOLDER/sdcard
SERV_F=$GITSRC/service_files

# Stop Klipper Service
report_status "#### Stopping Klipper Service..."
sleep 3
session_num=${find /etc/systemd/system -type f -name 'klipper-*' -printf x | wc -c}

#sudo service klipper stop
printer_num=0
while (( $printer_num <= $session_num ))
  do
  report_status "Stopping klipper-$printer_num service..."
  sudo systemctl stop klipper-$printer_num
  sleep 1
  report_status "Disabling klipper-$printer_num service..."
  sudo systemctl disable klipper-$printer_num
  sleep 1
  report_status "Removing klipper-$printer_num service..."
  sudo rm /etc/systemd/system/klipper-$printer_num
  sleep 1
  report_status "Your printer-$printer_num.cfg is still available, under $KlipperFarm/printer-$printer-num..."
  sleep 3
  printer_num=$(( printer_num+1 ))
  done
# Remove Klipper from Services
sleep 3
report_status "#### Removing Klipper Service.."
#sudo rm -f /etc/init.d/klipper /etc/default/klipper
sudo rm /etc/systemd/system/klipper.service
sleep 3
# Notify user of method to remove Klipper source code
sleep 3
report_status "The Klipper & DWC system files have been removed."
rm -vRf $KLIPPER $SDCARD/dwc2
sleep 3
report_status "~/sdcard folder has not been removed"
sleep 3
exit

