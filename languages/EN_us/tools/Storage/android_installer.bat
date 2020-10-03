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
title Android APK install via ADB %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will install applications on an Android device via the USB Debugging mode.
echo If you don't know how to activate this mode on your device, a quick research will give you all the informations that you will need.
echo Note that the drivers of the device needs to be installed to use this function.
echo To finish, a internet connection is required if this is the first time that you use this script or if you want to update the tools used by it.
goto:eof

:action_choice
echo Choose an application to install. 
echo.
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\apps_list.txt
echo f: Choose an Android application file ^(apk fil^).
echo d: Choose a folder containing Android application files ^(the sub-folder will not be scanned^).
echo u: Update the tools that install the applications ^(ADB...^).
echo All other choices: Go back to previous menu.
echo.
set /p app_choice=Make your choice: 
goto:eof

:select_app_file
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Android application files ^(*.apk^)|*.apk|" "Select application to install" "templogs\tempvar.txt"
goto:eof

:select_app_folder
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select folder containing Android\'s application files"
goto:eof

:adb_not_finded
echo The tools needed by this script are not installed, they will be downloaded on Google's server.
goto:eof

:adb_no_internet_connection
echo The tools needed to install Android's applications are not installed or couldn't be installed, the script couldn't continue.
goto:eof

:no_file_selected_error
echo No application select, back to applications list.
goto:eof

:no_folder_selected_error
echo No folder containing Android's applications selected, back to applications list.
goto:eof

:adb_install_error
echo An error ocured during application's installation. Verify that the developement mode is active and that the USB Debugging is enabled
goto:eof

:adb_install_success
echo *********************************************
echo ***            Installation success            ***
echo *********************************************
goto:eof

:update_tools_begin_message
echo Updating tools...
goto:eof

:update_tools_no_internet_connection
echo No internet connection, the script couldn't download the tools.
goto:eof

:update_tools_download_error
echo Error during the downloading of the tools update file.
goto:eof

:update_tools_extract_error
echo Error during extraction of the update file.
goto:eof

:update_tools_success
echo Tools update success.
goto:eof