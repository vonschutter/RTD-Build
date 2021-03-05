#!/bin/bash
#
#::             			A D M I N   C O M M A N D L E T
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::// Simple Admin Tool //::::::::::::::::::::::::::::::::::::::::// Linux //::::::::
#::
#:: Author:   	SLS
#:: Version 	1.00
#::
#::                -------------------------
#::
#::	Thursday 29 September 2005  - SLS
#::		* File originally created.
#::
#::
#::	Purpose: to mount all the SMB/Windows shares indicated in this script on the server specified.
#::		 There is no limit to the number of shares that you can mount.
#::
#::
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# This script was originally developed for RuntimeData, a small OEM in Buffalo Center, IA.
# This OEM and store nolonger exists as its owner has passed away.
# This script is shared in the hopes that someone will find it usefull.



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Settings                 ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

        # // edit this to reflect the server you want to connect to //
        # // and the shares as well                                 //
        _shares='$USER software avi-movies movies tv-series music'
        _server=horus

        # // you do not need to edit these lines or any remaining  //
        # // lines in this script                                  //

        ANS=$(dialog --stdout --title SMB password --passwordbox Password: 20 40)
	_opt="username=$USER,password=$ANS"
        _mnt=/home/$USER/mnt


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Executive                ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


        for _arg in $_shares
                do
                        if [ -e $_mnt/$_arg ]; then
                        	echo "mount point $_mnt/$_arg is there..."
                        	smbmount //$_server/$_arg $_mnt/$_arg -o $_opt

                        	else
                        	echo "mount point $_mnt/$_arg is not there..."
                        	echo "creating mount point"
                        	mkdir -p $_mnt/$_arg
                        	smbmount //$_server/$_arg $_mnt/$_arg -o $_opt
                        fi

                done



