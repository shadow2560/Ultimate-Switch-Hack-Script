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
title Prepare firmware update %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo No internet connexion, the script couldn't continue.
goto:eof

:intro
IF NOT "%special_launch%" == "unbrick_package_creation" (
	echo This script will download and prepare a SD with a firmware that you could use with ChoiDuJourNX or Daybreak. Note that you'll need a CFW to launch ChoiDuJourNX or Daybreak so if you haven't prepared an SD, you must do it before or after this script ^(if after, don't erase data or format the volume because you'll need to execute again this script^).
	echo Be careful, you should select the good letter for your SD because no verification will be done for this point.
	echo.
)
echo For advanced users, this script could prepare a package with ChoiDuJour or EmmcHaccGen with the selected firmware.
echo.
echo Be careful: No verification will be done on disk space, you'll need at least 1 GO of free space on the disk where this script is installed and 400 MO on the SD.
echo Note that the MD5 of the downloaded file will be verified but not after extraction so realy, be careful with disk space and pay attention to error messages during the script.
echo.
echo Also, note that the files will be downloaded via Mega so limitations could apply if too many downloads are made for the same IP in a short period. If you have an  acount on Mega.nz, you could configure the "tools\megatools\mega.ini" file to add your acount informations, remove the "#" char from the begining of the "Username" and "Password" lines and set your informations after the "=" char.
goto:eof

:action_choice
echo Firmware update preparation
echo.
Echo What do you want to do?
echo.
IF "%special_launch%" == "unbrick_package_creation" (
	echo 1: Prepare a firmware for the manual installation via ChoiDuJour ^(firmware 6.1.0 max^)?
	echo 2: Prepare a firmware for the manual installation via EmmcHaccGen ^(prod.keys of the console required^)?
	echo All other choices: Go back to previous menu?
	echo.
	set /p action_type=Make your choice: 
) else (
	echo 1: Prepare a firmware witch will be copied on the SD for ChoiDuJourNX/Daybreak?
	echo 2: Prepare a firmware for the manual installation via ChoiDuJour ^(firmware 6.1.0 max^)?
	echo 3: Make the two actions?
	echo 4: Prepare an SD for the different CFWs ans go back to this menu after the SD preparation?
	echo 5: Only download the firmware?
	echo 6: Prepare a firmware for the manual installation via EmmcHaccGen ^(prod.keys of the console required^)?
	echo All other choices: Go back to previous menu?
	echo.
	set /p action_type=Make your choice: 
)
goto:eof

:firmware_choice_begin
echo Choose the firmware that you want to prepare
echo.
echo Firmwares list:
goto:eof

:firmware_choice_end
echo F: Open the folder containing the firmwares already downloaded?
echo All other choices: Go back to principal action of this script.
echo.
set /p firmware_choice=Enter the  wanted firmware  or the action you want to make: 
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

:no_disk_found_error
echo No compatible disk found, please insert your drive.
echo.
set /p disk_not_finded_choice=Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Disk list:
goto:eof

:disk_list_choice
echo 0: Go back to principal action of this script.
echo.
echo.
set /p volume_letter=Enter the volume letter that you want to use: 
goto:eof

:disk_choice_empty_error
echo The volue letter couldn't be empty.
goto:eof

:disk_choice_char_error
echo Unauthorised char in volume letter.
goto:eof

:disk_choice_not_exist_error
echo This volume doesn't exist.
goto:eof

:disk_choice_letter_not_exist_error
echo This volume letter isn't in the list.
goto:eof

:disk_choice_not_fat32_formated_choice	
echo Be careful, the volume selected isn't formated in FAT32. If the EXFAT driver isn't installed on your Switch, you will need to format your volume in FAT32.
set /p cancel_script=Do you want to cancel the script to format your volume in FAT32 ^(you will not need to download again the firmware^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copying_begin
echo Copying the firmware on the SD in  the "FW_%firmware_choice%" folder and copying ChoiDuJourNX homebrew...
goto:eof

:copying_end
echo Copy success.
goto:eof

:choidujour_special_message
echo Now, the package preparation script via ChoiDuJour will be launched and you will have to set his options.
goto:eof

:choidujournx_doc_launch_choice
set /p launch_choidujournx_doc=Do you want to launch the doc to know how to use ChoiDuJourNX ^(recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:choidujour_max_firmware_error
echo You couldn't use this firmware with ChoiDuJour, the higher firmware supported for this function is the 6.1.0 firmware.
goto:eof

:choidujour_max_firmware_error_but_choidujournx_uste_choice
echo You couldn't use this firmware with ChoiDuJour, the higher firmware supported for this function is the 6.1.0 firmware.
echo But, the firmware could be downloaded and used with ChoiDuJourNX.
set /p cdjnx_use=Do you want to download and use this firmware with ChoiDuJourNX only? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:daybreak_keys_file_select
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to provide a keys files to verify/convert the firmware  to use it with Daybreak? ^(%lng_yes_choice%/%lng_no_choice%^): "
IF %errorlevel% EQU 2 goto:eof
IF %errorlevel% EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Select the file containing the keys" "templogs\tempvar.txt"
	set /p keys_file_path=<"templogs\tempvar.txt"
)
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