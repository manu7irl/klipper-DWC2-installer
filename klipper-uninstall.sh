#!/bin/bash
# Uninstall script for raspbian/debian type installations

# Stop Klipper Service
echo "#### Stopping Klipper Service.."
sleep 3
#sudo service klipper stop
sudo systemctl stop klipper.service
sudo systemctl disable klipper.service

# Remove Klipper from Services
sleep 3
echo "#### Removing Klipper Service.."
#sudo rm -f /etc/init.d/klipper /etc/default/klipper
sudo rm /etc/systemd/system/klipper.service
sleep 3
# Notify user of method to remove Klipper source code
sleep 3
echo "The Klipper & DWC system files have been removed."
rm -vrf ~/klipper ~/klippy-env ~/dwc2-for-klipper
sleep 3
echo "~/sdcard folder is not removed and still available also the printer.cfg file is not touched!"
sleep 3
exit

