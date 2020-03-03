# klipper-DWC2-installer
This installer script is made to streamline the install or upgrade of KLIPPER and Duet Web Control front-end for it.
with these 2 together no need to use octoprint, so your hardware will not be bloated nor overloaded.
I run mine on orangepi zero with H2+ CPU 512MB and it works nicely.
To run it:

`cd ~` 
`git clone https://github.com/manu7irl/klipper-DWC2-installer`  
`cd klipper-DWC2-installer`  
`./klipper-dwc2-installer.sh`

you will be presented to an interactive menu to install or update your system.

Todo list:
- uninstall klipper script integration
- automatic install of generic printer.cfg, if needed
- script to create a klipper back-end server services to run multiple printers against it
- automatic DWC update based on DWC releases

