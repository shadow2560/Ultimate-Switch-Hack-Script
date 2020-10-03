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
title NSC_Builder %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Do you want to define a new default keys file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded
echo Keys file not found, please follow the instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo You'll need to select the keys file in the next window.
	pause
)
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected
echo No keys file selected, the script will stop.
goto:eof

:choose_nscb_language
echo Choose language of NSC_Builder:
echo 1: French?
echo All other choices: English?
echo.
set /p nscb_language_choice=Make your choice: 
goto:eof

:open_output_dir_choice
set /p open_output_dir=Do you want to open the output folder of NSC_Builder? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_dir_not_exist_error
echo Output folder doesn't exist, verify that  NSC_Builder is  configured correctly.
goto:eof