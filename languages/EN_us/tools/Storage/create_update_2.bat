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
title EmmcHaccGen %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:folder_script_param_error
echo Error in the folder param, the script can't continue.
goto:eof

:keys_file_selection
echo You'll need to select the specific keys file of the console in the next window.
pause
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:launch_xci_explorer_choice
echo It is possible to launch  XCI Explorer to extract the update partition of a XCI game file. Not that if you choose to launch it, the script could only continue after the closing of XCI Explorer.
set /p launch_xci_explorer=Do you want to launch XCI Explorer? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\select_dir.vbs" "%calling_script_dir%\templogs\tempvar.txt" "Select folder containing update package"
goto:eof

:bad_choice_error
echo This choice is not supported.
goto:eof

:no_source_selected_error
echo No input folder or file selected, the script can't continue.
goto:eof

:noexfat_param_choice
set /p no_exfat=Do you want to disable the SD card EXFAT support? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:mariko_console_param_choice
set /p mariko_console=Do you want to create a package for a Mariko console? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_creation_success
echo Firmware creation success.
goto:eof

:package_creation_error
echo A problem occurred during firmware creation.
echo Check that you have all the required keys in the "keys.txt" file.
goto:eof

:emmchaccgen_package_creation_first_error
echo A problem occurred during firmware creation.
echo Check that you have all the required keys in the "keys.txt" file.
echo.
echo However, it is also possible that .net Framework 3 is not installed on your system.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Would you like to install .net Framework 3 on your system? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:netfx3_install_error
echo Error during the installation of .net Framework 3.
goto:eof

:emmchaccgen_package_creation_second_error
echo A problem occurred during firmware creation.
echo Check that you have all the required keys in the "keys.txt" file.
echo.
echo However, it is also possible that your system requires a reboot.
echo You can try to quit the script, reboot your system and retry the procedure.
goto:eof