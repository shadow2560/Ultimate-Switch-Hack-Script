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
title ChoiDuJour %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:folder_script_param_error
echo Error in the folder param, the script can't continue.
goto:eof

:warning_firmware_max_create
echo Be careful: The higher firmware package that can be create is for the firmware  6.1.0, the firmwares greater than this one will end with an error.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Do you want to define a new default keys file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded
echo Keys file not found, please follow the instructions.
goto:eof

:keys_file_selection
IF /i NOT "%define_new_keys_file%"=="o" (
	echo You'll need to select the keys file in the next window.
	pause
)
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:choidujour_keys_file_creation
IF "%create_choidujour_keys_file_state%"=="0" (
	echo Creation of "ChoiDuJour_keys.txt" file done.
) else IF "%create_choidujour_keys_file_state%"=="1" (
	echo The needed key "%key_missing%" is missing in the keys file, the script can't continue.
) else IF "%create_choidujour_keys_file_state%"=="2" (
	echo The last  facultative key finded is the key "%key_missing%", you could only generate firmware packages that need keys before this one.
)
goto:eof

:choidujour_keys_file_create_error
echo It seems that ChoiDuJour keyset file has not been created, the script can't continue.
echo To help yourself, look at the incorrect keys displayed.
goto:eof

:launch_xci_explorer_choice
echo It is possible to launch  XCI Explorer to extract the update partition of a XCI game file. Not that if you choose to launch it, the script could only continue after the closing of XCI Explorer.
set /p launch_xci_explorer=Do you want to launch XCI Explorer? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_type_choice
echo What is the input update package:
echo 1: folder?
echo 2: file?
echo.
set /p update_type=Make your choice: 
goto:eof

:no_package_type_selected_error
echo You must select a input package type.
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\select_dir.vbs" "%calling_script_dir%\templogs\tempvar.txt" "Select folder containing update package"
goto:eof

:package_file_select
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Switch partition files ^(*.hfs0^)|*.hfs0|" "Select switch update package partition file" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:bad_choice_error
echo This choice is not supported.
goto:eof

:no_source_selected_error
echo No input folder or file selected, the script can't continue.
goto:eof

:sigpatches_param_choice
set /p enable_sigpatches=Do you want to  enable the signatures verification patches ^(signatures patches are used to install and launch NSP/XCI^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nogc_param_choice
set /p disable_gamecard=Do you want to disable the gamcard reader to not update it firmware ^(use it if the console has never been on 4.0.0 firmware or higher^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:noexfat_param_choice
set /p no_exfat=Do you want to disable the SD card EXFAT support? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_creation_success
echo Created firmware package file success, you can find it in the "update_packages" folder of the script.
goto:eof

:package_creation_error
echo An error ocured during firmware package creation.
goto:eof