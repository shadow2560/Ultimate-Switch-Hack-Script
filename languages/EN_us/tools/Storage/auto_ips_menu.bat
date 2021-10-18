set lng_label_exist=0
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Sig_patches creation %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo No internet connection available, the script will stop.
goto:eof

:intro
echo This script can create the sig_patches for Atmosphere.
echo.
echo You must create the loader patches each time you update Atmosphere based on the "fusee-secondary.bin" or "package3" file.
echo.
echo For FS_patches and ES_patches, you will need to update them if you update the console firmware using the latest keys retrievable via Lockpick-RCM and a folder containing the firmware files.
echo.
echo Note that the patches will be created respecting the tree structure necessary for them to be used on the SD, so I advise to use the root of the SD as the output folder.
goto:eof

:action_choice
echo What do you want to do:
echo 1: Create the loader_patches?
echo 2: Create the FS_patches and ES_patches?
echo 3: Create the FS_patches?
echo 4: Create the ES_patches?
echo All other choices: Back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:keys_file_selection
echo You'll need to select the specific keys file of the console in the next window.
pause
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:fusee_file_selection
echo Please fill in the file "fusee-secondary.bin" or "package3" of the version of Atmosphere you are using in the following window.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "All files^(*.*^)|*.*|" "fusee-secondary.bin or package3 file selection" "templogs\tempvar.txt"
goto:eof

:no_fusee_file_selected_error
echo No "fusee-secondary.bin" or "package3" file filled in, the script will stop.
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Firmware folder selection"
goto:eof

:bad_choice_error
echo Bad choice.
goto:eof

:no_firmware_source_selected_error
echo No update directory filled in, the script will stop.
goto:eof

:outdir_folder_select
echo You will have to select the directory in which to create the patches ^(root of your SD recommended^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Output patches folder selection"
goto:eof

:no_outdir_source_selected_error
echo No output directory filled in, the script will stop.
goto:eof

:loader_patches_creation_success
echo Loader_patches creation success.
goto:eof

:loader_patches_creation_error
echo Error during the creation of loader_patches, check that you have specified the file "fusee-secondary.bin" of the version of Atmosphere you are using.
goto:eof

:FS_patches_creation_success
echo FS_patches creation success.
goto:eof

:FS_patches_creation_error
echo Error during the creation of FS_patches, check that you have dumpled and indicated the last keys of your console and check the source firmware folder.
goto:eof

:ES_patches_creation_success
echo ES_patches creation success.
goto:eof

:ES_patches_creation_error
echo Error during the creation of ES_patches, check that you have dumpled and indicated the last keys of your console and check the source firmware folder.
goto:eof

:firmware_choice_begin
echo Choose the firmware that you want to prepare
echo.
echo Firmwares list:
goto:eof

:firmware_choice_end
echo F: Open the folder containing the firmwares already downloaded?
echo C: Choose a firmware folder?
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

:daybreak_convert_begin
echo Converting and verifying firmware...
goto:eof

:daybreak_convert_keys_warning
echo Warning: Some keys seem to be missing in your key file, the firmware  can neither be verified nor converted.
echo For this to work, please dump the latest keys using the latest version of the Lockpick-RCM payload and then specify the file dumped as the key file.
goto:eof