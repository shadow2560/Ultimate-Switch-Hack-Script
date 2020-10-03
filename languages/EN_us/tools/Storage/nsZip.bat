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
title Compress/uncompress a game %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will compress/uncompress a XCI/NSP game file.
echo Be careful: Preferably, don't use this script on a FAT32 file system because of the 4 GO pair file limit.
goto:eof

:input_file_choice
echo You will need to select the file to compress/uncompress.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Switch game files ^(*.xci;*.nsp;*.xciz;*.nspz^)|*.xci;*.nsp;*.xciz;*.nspz;" "Select file to compress/uncompress" "templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo No game selected, conversion canceled.
goto:eof

:output_folder_choice
echo Now, select the output folder.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_selected_error
echo No output folder selected, conversion canceled.
goto:eof

:compression_level_choice
set /p compression_level=Choose the compression level ^(1 for the minimum, 22 for the maximum^): 
goto:eof

:no_empty_value_error
echo This value couldn't ve empty.
goto:eof

:bad_value_error
echo Unauthorised value.
goto:eof

:compression_level_too_low_error
echo The compression level couldn't be lesser than 1.
goto:eof

:compression_level_too_high_error
echo echo The compression level couldn't be greater than 22.
goto:eof

:operation_error
echo Error during compression/decompression process.
goto:eof

:operation_success
echo Compression/decompression success.
goto:eof