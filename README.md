# klipper-DWC2-installer
This installer script is made to streamline the install or upgrade of KLIPPER and Duet Web Control front-end for it.
with these 2 together no need to use octoprint, so your hardware will not be bloated nor overloaded.
I run mine on orangepi zero with H2+ CPU 512MB and it works nicely.
Now the script is based on a new multi-session method, to make an ultimate "Klipper server" to connect multiple printers or only one if needed.
You can by running it get klipper installed with DWC2 and octoprint, in 
less than 5 minutes!

Do not run this script as root, as it will prevent you to do so.

To run it:
```
cd ~ 
sudo apt install git -y 
git clone https://github.com/manu7irl/klipper-DWC2-installer
cd klipper-DWC2-installer
./installer.sh
```
You will be presented to an interactive menu to install or update your system. 
This is pretty staright-forward but if you need help ping me.
If you install DWC for the first time,  the script will add the default sections, to the end of your printer.cfg file, in order to the tornado web server and the file manager can use the virtual_sdcard function:
tip: the virtual_sdcard folder path, can point to your ~/.octoprint/sdcard folder.
So an uploaded gcode file through the octoprint ui will also appears on DWC and vice versa.  

```
     "=========================="
     "    INSTALL OR UPDATE     "
     "    KLIPPER & DWC2        "
     "    OCTOPRINT             "
     "    BY MANU7IRL           "
     "=========================="
     "1. Install KLIPPER"
     "2. Update KLIPPER"
     "3. Flash your MCU"
     "4. Install DWC2"
     "5. Update DWC2"
     "6. Install OCTOPRINT"
     "7. Uninstall KLIPPER & DWC"
     "8. Uninstall OCTOPRINT"
     "9. Exit"
```

```
[virtual_sdcard]
path: ~/PrinterFarm/KlipperFarm/printer-0/sdcard #use the folder of your choice

[web_dwc2]
# optional - defaulting to Klipper
printer_name: My_own_klipper_printer
# optional - defaulting to 127.0.0.1
listen_adress: 0.0.0.0
# needed - use above 1024 as nonroot user
listen_port: 4750
#	optional defaulting to dwc2/web. Its a folder relative to your virtual sdcard.
web_path: dwc2/web
# optional - defaulting to /tmp/printer, needed in order to get dwc multi-session
serial_path: /tmp/printer-$printer-num
```
your printer.cfg file should be placed under ~/PrinterFarm/KlipperFarm/printer-{0..9} folder and renamed after the corresponding printer-{0..9} folder.
ex: if the folder is printer-0, the printer.cfg file should be printer-0.cfg


**##NEW##**
You will be presented to a set of question to decide to run it on which user and how many printers to be added.
Todo list:
- haproxy to get url like http://localhost/dwc2/printer-0 to point to http://localhost:4750 (DWC2 web ui) and http://localhost/octo/printer-0 to point to http://localhost:5000 (octoprint web ui)
- integrate the sdcard virtual folder to be symlinked to sdcard folder in klipper ~/sdcard/gcodes (created by DWC2)
- integrate the new multisession scripts under the main script framework (DONE)
- automatic install of generic printer.cfg, if needed (DONE PARTIALLY)
- uninstall klipper script integration (DONE)
- automatic add to a default printer.cfg file with the DWC & Virtual SDCARD sections (DONE)
- script to create a klipper back-end server with multiple services to run multiple printers om it, by adding systemd services based on incremented virtual serial path /tmp/printer-{0..9}(DONE)
- script to create a Octoprint back-end server with multiple services to run multiple printers om it (DONE)
- script to create a DWC2 multiple server instances to run multiple printers om it, via incremented access port 475{0..9} (DONE)
- automatic DWC update based on DWC releases (DONE)
- git-source folder maintained to update all the main repos (klipper, dwc2-for-klipper). (DONE)
- Octoprint automatically download the latest release from source, and is updatable inside the web ui, so no need to make a script update for it (DONE)
- Octoprint script, installs autostart via init.d, webcam support (DONE)
