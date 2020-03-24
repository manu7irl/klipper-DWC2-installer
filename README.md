# klipper-DWC2-installer
This installer script is made to streamline the install or upgrade of KLIPPER and Duet Web Control front-end for it.
with these 2 together no need to use octoprint, so your hardware will not be bloated nor overloaded.
I run mine on orangepi zero with H2+ CPU 512MB and it works nicely.
To run it:

`cd ~`   
`git clone https://github.com/manu7irl/klipper-DWC2-installer`  
`cd klipper-DWC2-installer`  
`./klipper-dwc2-install.sh`

You will be presented to an interactive menu to install or update your system.   
If you install DWC for the first time, coppy and add this to your printer.cfg file, for it to work properly:
`[virtual_sdcard]
path: ~/sdcard #this path is auto-created by the script, just need klipper to point to it

[web_dwc2]
# optional - defaulting to Klipper
printer_name: My_own_klipper_printer
# optional - defaulting to 127.0.0.1
listen_adress: 0.0.0.0
# needed - use above 1024 as nonroot user
listen_port: 4750
#	optional defaulting to dwc2/web. Its a folder relative to your virtual sdcard.
web_path: dwc2/web`

Todo list:
- uninstall klipper script integration (DONE)
- automatic install of generic printer.cfg, if needed
- automatic add to a current printer.cfg file the DWC & Virtual SDCARD sections 
- script to create a klipper back-end server services to run multiple printers against it (STARTED)
- automatic DWC update based on DWC releases (DONE)

