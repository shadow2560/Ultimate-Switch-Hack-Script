set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Mount part of device's nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Be careful, this script can mount the internal memory of the Switch.
echo Not that the read/write speed in SD mode is little slow but this could be useful to copy/modify/remove some files.
echo Please read carefuly the infos displayed during the script.
goto:eof

:memory_choice
echo What partition do you want to mount?
echo.
echo 1: Rawnand.
echo 2: SD card.
echo 3: Boot0.
echo 4: Boot1
echo All other choices: Go back to previous menu.
echo.
set /p disc_mounted=Make your choice: 
goto:eof

:rcm_instructions
echo *********************************************
echo ***    Connect the Switch in RCM mode    ***
echo ********************************************* 
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
echo Waiting a Switch in RCM...
goto:eof

:after_launch_first_choice
echo The disk should be mounted in your operating system. To unmount it, eject it via the bottom-right task bar button used to eject a device and force shut down of the Switch by maintaining "Power" button during around 15 secondes.
IF "%disc_mounted%"=="1" echo To explore the Rawnand of the Switch, you should use the software HacDiskMount launched as administrator ^(need the  biskey to decrypt the datas but not needed to dump/restaure the nand^). If you want to make a dump with this method, the dump could take some time ^(around three hours^).
echo.
echo Sometime, the disk is not reconized automaticaly. You should open the Devices Manager, find the device with an exclamation mark, right click on it, click on "Update drivers...", click on "Search automaticaly an updated driver" and click on "close" when installed. Now, the device should be usable.
set /p launch_devices_manager=Do you want to launch the Devices Manager? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:hacdiskmount_launch_choice
set /p launch_hacdiskmount=Do you want to launch HacDiskMount? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof