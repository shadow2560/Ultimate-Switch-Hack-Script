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
title Verify NSP files %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will verify the NSP files in a folder and his sub-folders.
echo At the end of the process, the files listing the NSP with problems could be finded on script root.
echo If you don't find any file, this will indicate that the NSP files verified have no problems.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Do you want to define a new default keys file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded_error
echo Keys file not found, please follow the instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo You'll need to select the keys file in the next window.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:input_folder_choice
echo Hou will need to select the folder where your NSP files are. Note that the sub-folders will also be scaned.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Select folder containing NSP files"
goto:eof

:no_input_folder_selected_error
echo No input folder selected, the script couldn't continue.
goto:eof

:verifying_error
echo An unknown error occured.
goto:eof

:no_error_in_nsp_files
echo All NSP verified seems to be correct refering to NSPVerify.
goto:eof

:no_error_during_exec
echo No error encountered during execution of NSPVerify.
goto:eof

:verify_end
echo Files verification ended.
goto:eof