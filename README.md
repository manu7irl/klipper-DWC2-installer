# klipper-DWC2-installer
This installer script is made to streamline the install or upgrade of KLIPPER and Duet Web Control front-end for it.
with these 2 together no need to use octoprint, so your hardware will not be bloated nor overloaded.
I run mine on orangepi zero with H2+ CPU 512MB and it works nicely.
To run it:
`cd ~`   
`git clone https://github.com/manu7irl/klipper-DWC2-installer`  
`cd klipper-DWC2-installer`
`chmod +x`  
`./installer.sh`  

You will be presented to an interactive menu to install or update your system. 
This is pretty staright-forward but if you need help ping me.
If you install DWC for the first time,  the script will add the default sections, to the end of your printer.cfg file, in order to the tornado web server and the file manager can use the virtual_sdcard function:
tip: the virtual_sdcard folder path, can point to your ~/.octoprint/sdcard folder.
So an uploaded gcode file through the octoprint ui will also appears on DWC and vice versa.  

`[virtual_sdcard]
path: ~/sdcard #use the folder of your choice 

[web_dwc2]
# optional - defaulting to Klipper
printer_name: My_own_klipper_printer
# optional - defaulting to 127.0.0.1
listen_adress: 0.0.0.0
# needed - use above 1024 as nonroot user
listen_port: 4750
#	optional defaulting to dwc2/web. Its a folder relative to your virtual sdcard.
web_path: dwc2/web`

**##NEW##**
You will be presented to a set of question to decide to run it on which user and how many printers to be added.
Todo list:
Integrate the new multisession scripts under the main script framework (DONE)
- automatic install of generic printer.cfg, if needed (DONE PARTIALLY)
- uninstall klipper script integration (DONE)
- automatic add to a current printer.cfg file the DWC & Virtual SDCARD sections (DONE)
- script to create a klipper back-end server with multiple services to run multiple printers om it (DONE)
- script to create a Octoprint back-end server with multiple services to run multiple printers om it (DONE)
- automatic DWC update based on DWC releases (DONE)

