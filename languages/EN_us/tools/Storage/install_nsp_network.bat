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
title Network Install NSP %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will install a NSP file or a folder containing NSP files on a Switch connected on the network.
echo The software used to install NSP on the Switch need to be on network mode and the console should be on the same network than the PC.
echo Be careful: Accept the firewall authorisation if asked because if you don't, the NSP installation will not work.
echo Be careful: You should disable the sleeping mode of the Switch because the NSP installation will be interupted if the console go to sleeping state.
goto:eof

:ip_choice
set /p custom_ip=Enter the IP of your Switch: 
goto:eof

:install_type_choice
echo.
echo What do you want to do:
echo 1: Install a NSP file?
echo 2: Install NSP files by selecting a folder without caring of sub-folders?
echo 3: Install NSP files by selecting a folder with caring of sub-folders?
echo All other choices: Go back to previous menu.
echo.
set /p install_type=Make your choice: 
goto:eof

:file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "NSP files ^(*.nsp^)|*.nsp|" "Select NSP file to install" "templogs\tempvar.txt"
goto:eof

:folder_choice
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select the folder containing NSP files"
goto:eof

:canceled
echo Installation canceled.
goto:eof

:install_error
echo An error occured during the installation.
goto:eof

:multi_install_error
echo An error occured during installation of %filepath%\%~2 file.
goto:eof

:no_file_to_install_error
echo There are no NSP file in this folder or his sub-folders.
goto:eof

:multi_recursive_install_error
echo An error occured during installation of %filepath%\!temp_nsp! file.
goto:eof

:install_end
echo Install ended.
goto:eof