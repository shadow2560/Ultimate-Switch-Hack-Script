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
title Split game %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script could split a NSP game in 4 GO parts.
echo It could also split a XCI with XCI Cutter.
goto:eof

:cut_type_choice
echo What do you want to do:
echo 1: Split a NSP?
echo 2: Split a XCI?
echo All other choices: Go back to previous menu?
echo.
set /p cut_type=Make your choice: 
goto:eof

:nsp_split_type_choice
echo How do you want to split your NSP:
echo 1: Split the file and keep the original?
echo 2: Split the file but not keep the original ^(take less time^)?
echo All other choice: Go back to previous menu?
echo.
set /p split_type=Make your choice: 
goto:eof

:nsp_input_file_choice
echo You will need to select the NSP file.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "NSP file ^(*.nsp^)|*.nsp|" "Select NSP file" "templogs\tempvar.txt"
goto:eof

:no_nsp_input_file_selected_error
echo No NSP selected, the script will stop.
goto:eof

:nsp_output_folder_choice
echo You will need to select the folder where the splited NSP will be copied.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_nsp_output_folder_selected_error
echo No output folder selected, the script will stop.
goto:eof

:nsp_split_error
echo Unknown error during the split.
goto:eof

:nsp_split_success
echo NSP split success.
goto:eof

:launch_xcicutter_message
echo XCI Cutter will be launched to split your XCI.
goto:eof