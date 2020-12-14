# RTD OEM System Builder: 
![RTD Builder Screenshot](Media_files/Scr2.png?raw=true "Executing the Script")

The RTD OEM System builder is intended to facilitate adding optional software to a vanilla install of Ubuntu or Debian based distribution. The bootstrap script will identify Linux/Mac/BSD/windows versions and execute those configurations scripts if they are defined. The non Linux references are essentially empty in the bootstrap script, since most of the items intended for windows and Mac are proprietary and may not be distributed. 

If a graphical environment is not detected, the RTD OEM System Builder will interpret this as it is being run on a server without a graphical environment and will offer to setup the productivity tools for that environment. 

![RTD Builder Screenshot 2](Media_files/Scr-13-43-45.png?raw=true "Executing the Script")

As promised, the rtd-me.sh.cmd script will run under windows as well. Simply download it and double click on it. Please NOTE that at this time the windows functionality is less extensive. However, the script will optimize Windows by removing bloatware (Sponsored Software) and turning off services that most do not use to enhance both performance ad security. Several useful and fun software titles are automatically added. The windows changes are made with PowerShell. 

![RTD Builder Screenshot 2](Media_files/Scr11.png?raw=true "Executing the Script in Windows")

# RTD-Build

It would make me happy if any modification are shared back. Please read the license file for details. 

