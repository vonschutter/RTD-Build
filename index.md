# RTD OEM System Builder: 
![RTD Builder Screenshot](Media_files/Scr2.png?raw=true "Executing the Script")

The RTD OEM System builder is intended to facilitate adding optional software to a vanilla install of Ubuntu or Debian based distribution. The bootstrap script will identify Linux/Mac/BSD/windows versions and execute those configurations scripts if they are defined. The non Linux references are essentially empty in the bootstrap script, since most of the items intended for windows and Mac are proprietary and may not be distributed. 

If a graphical environment is not detected, the RTD OEM System Builder will interpret this as it is being run on a server without a graphical environment and will offer to setup the productivity tools for that environment. 

![RTD Builder Screenshot 2](Media_files/Scr-13-43-45.png?raw=true "Executing the Script")

As promised, the rtd-me.sh.cmd script will run under windows as well. Simply download it and double click on it. Please note that at this time the windows functionality i less extensive. However, the script will optimize Windows by removing bloatware and turning off services that most do not use to enhance both performance ad security. 

![RTD Builder Screenshot 2](Media_files/Scr10.png?raw=true "Executing the Script in Windows")

# RTD-Build

Here you will find some scripts for windows and Linux that I have created and/or modified over the years. I have added them here simply to share in the hopes that someone will find something useful. 

It would make me happy if any modification are shared back. 

## Enroll Your Computer

Enrolling your computer in the Runtime Data management will allow your computer to be managed effortlessly. You will no longer need to manage software installs or security. :) 



### How to enroll...
Simply cut and paste this command in to a terminal on your computer. If you are using Windows, download the file "rtd-me.sh.cmd" and double click it. 

```

wwget https://github.com/vonschutter/RTD-Build/raw/master/rtd-me.sh.cmd && chmod +x rtd-me.sh.cmd && bash rtd-me.sh.cmd 

```

### RTD OEM System Builder Enrolls Your Computer Automatically: 
The RTD System builder is intended to facilitate adding optional software to a vanilla install of Ubuntu or Debian based distribution. The bootstrap script will identify windows versions and execute those configurations scripts as well... these are empty here though since most of the items intended for windows are proprietary and may not be distributed. 



