::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%ushs_base_path%=!
	set associed_language_script=%ushs_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	endlocal
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
call "%associed_language_script%" "keys_file_choice"
set /p keys_file_path=<"templogs\tempvar.txt"
if "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:end_script
)
tools\python3_scripts\Keys_management\keys_management.exe test_keys_file "%keys_file_path%" >templogs\keys_result.txt
tools\gnuwin32\bin\sed.exe -n 1p <templogs\keys_result.txt | tools\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p possible_analysed_keys=<templogs\tempvar.txt
set possible_analysed_keys=%possible_analysed_keys:~1%
TOOLS\gnuwin32\bin\sed.exe -n 2p <templogs\keys_result.txt > templogs\tempvar.txt
set /p correct_keys_line=<templogs\tempvar.txt
echo %correct_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c ":" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set correct_keys_state=0
	goto:skip_correct_keys_verif
)
echo %correct_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p correct_keys=<templogs\tempvar.txt
set correct_keys=%correct_keys:~1%
echo %correct_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c "," >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set correct_keys_state=1
	goto:skip_correct_keys_verif
)
set correct_keys_state=2
echo %correct_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p count_correct_keys=<templogs\tempvar.txt
:skip_correct_keys_verif
TOOLS\gnuwin32\bin\sed.exe -n 3p <templogs\keys_result.txt > templogs\tempvar.txt
set /p unknown_keys_line=<templogs\tempvar.txt
echo %unknown_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c ":" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set unknown_keys_state=0
	goto:skip_unknown_keys_verif
)
echo %unknown_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p unknown_keys=<templogs\tempvar.txt
set unknown_keys=%unknown_keys:~1%
echo %unknown_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c "," >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set unknown_keys_state=1
	goto:skip_unknown_keys_verif
)
set unknown_keys_state=2
echo %unknown_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p count_unknown_keys=<templogs\tempvar.txt
:skip_unknown_keys_verif
TOOLS\gnuwin32\bin\sed.exe -n 4p <templogs\keys_result.txt > templogs\tempvar.txt
set /p possible_missing_keys_line=<templogs\tempvar.txt
echo %possible_missing_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c ":" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set possible_missing_keys_state=0
	goto:skip_possible_missing_keys_verif
)
echo %possible_missing_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p possible_missing_keys=<templogs\tempvar.txt
set possible_missing_keys=%possible_missing_keys:~1%
echo %possible_missing_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c "," >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set possible_missing_keys_state=1
	goto:skip_possible_missing_keys_verif
)
set possible_missing_keys_state=2
echo %possible_missing_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p count_possible_missing_keys=<templogs\tempvar.txt
:skip_possible_missing_keys_verif
TOOLS\gnuwin32\bin\sed.exe -n 5p <templogs\keys_result.txt > templogs\tempvar.txt
set /p missing_keys_line=<templogs\tempvar.txt
echo %missing_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c ":" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set missing_keys_state=0
	goto:skip_missing_keys_verif
)
echo %missing_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p missing_keys=<templogs\tempvar.txt
set missing_keys=%missing_keys:~1%
echo %missing_keys_line% | TOOLS\gnuwin32\bin\grep.exe -c "," >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" (
	set missing_keys_state=1
	goto:skip_missing_keys_verif
)
set missing_keys_state=2
echo %missing_keys_line% | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p count_missing_keys=<templogs\tempvar.txt
:skip_missing_keys_verif
call "%associed_language_script%" "total_keys"
call "%associed_language_script%" "correct_keys"
call "%associed_language_script%" "unknown_keys"
call "%associed_language_script%" "possible_missing_keys"
call "%associed_language_script%" "missing_keys"
echo.
:end_script
pause
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal