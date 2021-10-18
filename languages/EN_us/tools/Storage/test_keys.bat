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
title Test keys file %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script analyse a keys file and indicate the unknown or unic keys and the incorrect keys.
goto:eof

:keys_file_choice
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "all files ^(*.*^)|*.*|" "Select keys file" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:total_keys
echo Number of possible keys to analyse: %possible_analysed_keys%
goto:eof

:correct_keys
IF "%correct_keys_state%"=="0" (
	echo No correct verifiable key found.
) else IF "%correct_keys_state%"=="1" (
	echo Correct verifiable key found: & type templogs\correct_keys.txt
) else IF "%correct_keys_state%"=="2" (
	echo %count_correct_keys% correct verifiable keys found: & type templogs\correct_keys.txt
)
goto:eof

:unknown_keys
IF "%unknown_keys_state%"=="0" (
	echo No unknown or unic key found.
) else IF "%unknown_keys_state%"=="1" (
	echo Unknown or unic key found: & type templogs\unknown_keys.txt
) else IF "%unknown_keys_state%"=="2" (
	echo %count_unknown_keys% unknown or unic keys founded: & type templogs\unknown_keys.txt
)
goto:eof

:possible_missing_keys
IF "%possible_missing_keys_state%"=="0" (
	echo No verifiable missing key found.
) else IF "%possible_missing_keys_state%"=="1" (
	echo Verifiable missing key found: & type templogs\possible_missing_keys.txt
) else IF "%possible_missing_keys_state%"=="2" (
	echo %count_possible_missing_keys% verifiable missing keys found: & type templogs\possible_missing_keys.txt
)
goto:eof

:missing_keys
IF "%missing_keys_state%"=="0" (
	echo No incorrect key found.
) else IF "%missing_keys_state%"=="1" (
	echo Incorrect key found: & type templogs\missing_keys.txt
) else IF "%missing_keys_state%"=="2" (
	echo %count_missing_keys% incorrect keys found: & type templogs\missing_keys.txt
)
goto:eof