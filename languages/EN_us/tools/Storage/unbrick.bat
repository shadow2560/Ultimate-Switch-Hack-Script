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
title Unbrick  %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Welcome to this script for unbricking a console.
echo.
echo Please follow the instructions that will be given to you throughout the procedure.
echo.
echo I could not be held responsible for any problems following the execution of this procedure.
echo.
echo Please, if you have not done so before, make a full backup of your nand and any items you wish to back up, this will not be covered by this script.
echo.
echo Warning, at the end of this procedure, all data in the sysnand ^(nand of the console^) will be deleted.
echo Also note that the firmware that will be installed will be 6.1.0 firmware.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you wish to continue the procedure? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:intro_2
echo.
echo To continue, it will be necessary to have an internet connection, 1 GB of free space on the hard disk ^(may be less, it depends on the items to be downloaded during the script^), an SD with 500 MB of free space ^(preferably a blank SD or else backup the "atmosphere" and "sept" folders of the SD if they exist to be able to restore them easily after this procedure^) and a Switch connected to the PC via a USB cable and which can be started in RCM at any time.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to install the drivers for the PC to recognize the switches in RCM mode ^(to be done only once per PC^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:dump_keys_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Would you like to dump your console keys ^(highly recommended to check if the console can possibly be debricked using this method^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:dump_keys_instructions_begin
echo.
echo Insert your SD into the switch and turn it on in RCM mode.
echo WARNING: If your current firmware is equal or higher than firmware 7.0.0, the folder "sept" of Atmosphere is necessary to be able to dump the keys so please copy this one to the root of your SD.
goto:eof

:dump_keys_instructions_end
echo The payload should be launched on your console.
echo Press the "Power" button to launch teh keys dump.
echo.
echo If the dump didn't work, please specify this in the following choice to stop the script.
echo If you have not copied the Atmosphere's "sept" folder to the root of your SD, do so and restart the script.
echo If this still doesn't work, the console problem probably can't be solved with this unbricking method alone.
echo.
echo If the dump worked well or if you want to try this procedure, you should put your SD in the PC.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Did the key dump go well? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:extract_error
echo An error occurred during a file extraction, the script will stop.
echo Check the disk space on which you run the script and that the script is running as an administrator.
goto:eof

:define_new_keys_file_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Would you like to define a new default key file? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:keys_file_not_finded
echo Key files not found, please follow the instructions.
goto:eof

:keys_file_selection
IF /i NOT "%define_new_keys_file%"=="o" (
	echo Please select  the key file in the next window, prefer the prod.keys file from your console if youhave it.
	pause
)
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Keys file select" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No key files selected, the script will stop.
goto:eof

:choidujour_keys_file_creation
IF "%create_choidujour_keys_file_state%"=="0" (
	echo Creation of the file "ChoiDuJour_keys.txt" successfully completed.
) else IF "%create_choidujour_keys_file_state%"=="1" (
	echo The mandatory "%key_missing%" key is not in the key file, the script cannot continue.
) else IF "%create_choidujour_keys_file_state%"=="2" (
	echo The last optional key found is the "%key_missing%" key, you will only be able to generate upgrade packages up to the firmware using only the keys up to this one.
)
goto:eof

:choidujour_keys_file_create_error
echo It seems that the key file needed for ChoiDuJour could not be created, please check your key file and restart the script.
echo To help you, look at the incorrect keys that were displayed just before.
goto:eof

:no_internet_connection_error
echo No internet connection available, the script will stop.
goto:eof

:no_disk_found_error
echo No compatible disk found. Please insert a compatible disk.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:disk_list_begin
echo Disks list:
goto:eof

:disk_choice
set /p volume_letter=Enter the volume letter that you want to use or enter "0" to go back to previous menu: 
goto:eof

:disk_choice_empty_error
echo The volume letter couldn't be empty.
goto:eof

:disk_choice_char_error
echo Unauthorised char in volume letter.
goto:eof

:disk_choice_not_exist_error
echo This volume doesn't exist.
goto:eof

:disk_choice_not_in_list_error
echo This volume letter is not in the list.
goto:eof

:disk_format_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to format the SD ^(volume "%volume_letter%"^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:disk_format_type_choice
echo What format type do you want to do:
echo 1: EXFAT ^(the Switch must have the EXFAT drivers installed to support it^)?
echo 2: FAT32 ^(limited to  4 GO maximum file size^)?
echo 0: Cancel formating.echo.
echo.
choice /c 120 /n /m "Make your choice: "
goto:eof

:disk_formating_begin
echo Formating...
goto:eof

:disk_formating_error
echo An error occured during formating, the script will be stoped.
goto:eof

:disk_formating_success
echo Formating success.
goto:eof

:disk_formating_fat32_not_admin_error
echo You don't have accepted the admin rights ask, formating step is canceled.
goto:eof

:disk_formating_fat32_disk_used_error
echo The formating has not been done.
echo Try to properly eject your volume, insert it and retry to execute the script imediatly.
echo You could also try to close all the explorer's windows just before formating, sometimes it fix the problem.
echo.
echo The script will end now.
goto:eof

:disk_formating_fat32_disk_not_exist_error
echo The volume that you want to format doesn't exist, maybe you have ejected or disconected the volume during this script.
echo.
echo The script will end now.
goto:eof

:disk_formating_fat32_unknown_error
echo An unknown error occured during formating operation.
echo.
echo The script will end now.
goto:eof

:disk_formating_fat32_canceled_info
echo The formating has been canceled by the user.
goto:eof

:firmware_downloading_begin
echo Downloading firmware %firmware_choice%...
goto:eof

:firmware_downloading_md5_error
echo The firmware's MD5 seems to be incorrect, please verify your internet connexion and the space on the disk where this script is installed and retry.
goto:eof

:firmware_downloading_md5_retry
echo The firmware's MD5 seems to be incorrect, the download will be retried.
goto:eof

:firmware_exist_but_bad_md5_tested_error
echo The firmware file seems to exist but his MD5 is not correct, for this reason the firmware will be downloaded.
goto:eof

:firmware_downloading_end
echo Download of firmware %firmware_choice% success.
goto:eof

:extract_firmware_begin
echo Extracting firmware files...
goto:eof

:copy_to_sd_error
echo An error occurred while copying files to the SD, the script will stop.
echo Check the available space on your SD or that it is not write-protected.
goto:eof

:firmware_choice_begin
echo Choose the firmware you want to install via ChoiDuJourNX when the console will be running again.
echo.
echo Firmwares list:
goto:eof

:firmware_choice_end
echo All other choices: End this script.
echo.
set /p firmware_choice=Make your choice: 
goto:eof

:create_choidujour_package_backup_warning
echo An error occurred while archiving the ChoiDuJour package, check the disk space on which this script is running.
echo However, the script can continue.
goto:eof

:package_creation_success
echo Firmware creation success.
goto:eof

:package_creation_error
echo A problem occurred during firmware creation.
echo Check that you have all the required keys in the "keys.txt" file.
goto:eof

:boot0_keyblobs_reparation_choice
echo You can repair the keyblobs in the BOOT0 file if you have errors related to them during the key dump via Lockpick-RCM.
echo Be careful, this is an advanced and rarely necessary operation, do it only if you know what you are doing.
echo An other warning, it is necessary to have chosen the key file linked to the console and dumped with Lockpick-RCM on it when you choose the key file during this script.
echo Also note that in firmware 6.1.0 or lower, official boot will not work and the console will remain on a black screen, booting will only be possible in CFW. However, in firmware higher than 6.1.0, official boot will be possible again.
echo.
echo What do you want to do?
echo 1: Don't modify the BOOT0 file and continue.
echo 2: Modify the BOOT0 file and continue.
echo 0: End this script.
echo.
choice /c 120 /n /m "Make your choice: "
goto:eof

:boot0_keyblobs_reparation_error
echo An error occurred while trying to modify BOOT0, the script will continue with the original files.
echo.
echo This error may mean that some keys are missing from your key file, so please check it before trying this unbricking procedure again.
echo.
echo Common keys needed, can be found quite easily on the internet:
echo keyblob_00 to keyblob_05, keyblob_key_source_00 to keyblob_key_source_05, keyblob_mac_key_source
echo.
echo Unique keys to the console required:
echo secure_boot_key, tsec_key, 
echo.
echo Unique keys to the console optional, at least one of the two groups required but both would obviously be better:
echo keyblob_key_00 to keyblob_key_05, keyblob_mac_key_00 to keyblob_mac_key_05
echo.
goto:eof

:boot0_keyblobs_reparation_success
echo BOOT0 file successfully modified, remember that it should not be used on any other console than the one related to the keys used during this script.
goto:eof

:copy_begin_info
echo Copying files on the SD...
goto:eof

:restore_method_choice
echo Which restoration method do you want to use?
echo 1: Method only via TegraExplorer, recommanded in most case?
echo 2: Method via TegraExplorer and HacDiskMount, e.g. if you restore the nand via another console than the one to which the nand is linked, to be done only if you really know what you are doing?
echo 0: End this script?
echo.
choice /c 120 /n /m "Make your choice: "
goto:eof

:copying_end
echo The necessary files have been prepared, you can put the SD back into the Switch.
goto:eof

:tegraexplorer_launch_begin
echo The restoration of the nand will start, if you haven't done a dump of the nand via Hekate for example it's now or never time to do it, this will not be covered here.
pause
echo.
echo Now, with the help of TegraExplorer, we will restore the nand.
echo.
echo Boot the console to RCM.
goto:eof

:tegraexplorer_launch_correctly_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Did the TegraExplorer payload launch on the console? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:tegraexplorer_launch_end
echo.
echo Once the payload is launched, go to the "[SD:/] SD CARD" menu. 
echo You should see a file named "cdj_restore_firmware.te" at the root of the SD,.
echo Select it with the directional arrows or with the volume buttons and validate with the "A" button or the "Power" button then select "Launch Script" in the same way.
echo The script starts, presenting a menu to you.
echo First, run the "Save BOOT0, BOOT1, PRODINFO and PRODINFOF" choice ^(to be done only once^) and keep the created files aside, these are the most important files to have absolutely in case of problems.
IF "%restore_method%"=="1" (
	echo Launch "Restore with datas wip" ^(be careful, once this script is executed, all data in the sysnand will be deleted^) or "Restore without datas wip" ^(less chance to work^).
) else IF "%restore_method%"=="2" (
	echo Launch "Only restore the  BOOT0, BOOT1 and BCPKG2-* partitions".
	echo Be careful, once this script is executed, it will then be necessary to restore the SYSTEM and USER partitions with  Memloader and HacDiskMount or an other method.
)
echo Warning, this script of TegraExplorer requires files previously copied by this script, never execute it otherwise than during this procedure.
echo An other warning, only use the restore from a chosen folder only if you know what you're doing, else prefer the default options.
echo Also note that the console, if the script worked well, is now in auto-RCM so simply pressing the "Power" button at startup or plugging the off console into a USB outlet will start the console in RCM.
echo.
IF "%restore_method%"=="1" (
	echo Once the script on the console finished without error, shut down the console or reboot on the payload Hekate via TegraExplorer.
) else IF "%restore_method%"=="2" (
	echo Once the script on the console has finished without error, turn off the console.
)
goto:eof

:memloader_launch_begin
echo With Memloader and HacDiskMount, we will now restore the contents of the SYSTEM and USER partitions.
echo.
echo Boot the console to RCM.
goto:eof

:memloader_launch_correctly_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Did the Memloader payloader launch on the console ^(the screen should light up slightly^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:memloader_launch_end
echo Be careful, if the computer asks to format a disk, absolutely refuse this choice.
echo Be careful, for the next steps you must have activated the display of hidden files as well as the display of system files on Windows, this will not be treated here.
echo.
echo Now, HacDiskMount will be launched.
echo You will also see the opening of a folder "NX-6.1.0_exfat" in a file explorer window, it will be very useful.
echo.
echo In HacDiskMount, you will have to click on "file" then on "Open physical drive" and select the disk of the Switch.
echo Once this is done, the list of partitions should be displayed.
echo Double-click on the "SYSTEM" partition.
echo If the driver is not installed, click on "Install" in the "Virtual drive" section and accept any messages that may appear.
echo Enter the keys and click on "Test". If a green message appears, click on "Save". Attention, if a red message is displayed, do not continue.
echo Go back and double-click on the "USER" partition.
echo Enter the keys and click on "Test". If a green message appears, click on "Save". Attention, if a red message is displayed, do not continue.
echo Return to the "SYSTEM" partition.
echo In the "Virtual drive" section, select a drive letter from the list, check the "Passthrough zeroes" box and finally click on "Mount".
echo You should see a new disk with the drive letter you chose in your workstation ^(sometimes called "computer" or "this pc" depending on the version of Windows installed^), enter it and delete everything on it.
echo In the "NX-6.1.0_exfat" folder which also opened at the same time as HacDiskMount, go to the "SYSTEM" folder, copy everything there and paste it into the drive created by HacDiskMount.
echo Once finished without errors, close the drive created by HacDiskMount, return to it, click on "Unmount" and return to the list of partitions.
echo Do exactly as you just did with the "SYSTEM" partition but replace "SYSTEM" with "USER".
echo Close HacDiskMount and turn off the console by holding the "Power" button on the console until it is turned off.
echo.
goto:eof

:hekate_launch_begin
echo Now, with Hekate's help, we'll try to launch the restored firmware.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Would you like to launch the Hekate payload? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:hekate_rcm_instruction
echo Boot the console to RCM.
goto:eof

:hekate_launch_end
echo.
echo Once the payload is launched, click on "More configs" ^(second icon on the left^).
echo Next, click on "sysnand first launch FW 6.1.0" ^(first icon in the top left corner^).
echo.
IF "%optional_firmware_download%"=="Y" (
	echo If the console has booted, you will be able to start Atmosphere with one of the configurations available in Hekate's "More configs" menu and then update to the firmware you chose at the beginning of this script using ChoiDuJourNX ^(preferably choose the EXFAT firmware that ChoiDuJourNX will offer you, the rest of the instructions won't be covered here^).
) else (
	echo If the console has booted, you can do what you want to do with it.
)
echo Be careful, The configuration "sysnand first launch FW 6.1.0" in Hekate should not be restarted if the console has been booted at least once.
echo.
echo If the console has not booted, try running Hekate again and choose the same configuration to run or one of the others available in the "More configs" menu.
echo If it still doesn't work, either something went wrong during the script and in this case redo the operations from the beginning or the problem can't be solved using this method.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Would you like to restart Hekate? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:script_end_message
echo Thank you for using this script.
goto:eof

:daybreak_keys_file_select_passed
echo File containing keys not selected, Daybreak verification/conversion will not be performed.
goto:eof

:daybreak_convert_begin
echo Converting firmware for Daybreak...
goto:eof

:daybreak_convert_keys_warning
echo Warning: Some keys seem to be missing in your key file, the conversion to Daybreak can neither be verified nor performed.
echo For this to work, please dump the latest keys using the latest version of the Lockpick-RCM payload and then specify the file dumped as the key file.
goto:eof