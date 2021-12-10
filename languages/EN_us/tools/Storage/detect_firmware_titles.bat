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
title NCAs identification extract %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to obtain the NCAs used to identify a firmware.
echo.
echo This is useful to, for example, more easily update the data of a project like FVI.
echo If the file "titles_output.txt" exists in the folder selected for extraction of the information it will be replaced.
echo.
echo You will have to choose the firmware to work on and a folder where the information will be extracted.
goto:eof

:firmware_preparation_error
echo No firmware selected or an error occurred during firmware preparation.
goto:eof

:output_folder_choice
echo You will have to select the folder where to create the file containing the extracted information.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select the folder"
goto:eof

:output_folder_empty_error
echo The folder containing the extracted informations couldn't be empty.
goto:eof

:extract_error
echo Error during the extraction of the informations.
goto:eof

:extract_sucess
echo Informations extracted in the file "%output_folder%%titles_output_file%".
goto:eof