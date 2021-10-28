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
call "%associed_language_script%" "display_title"
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
call "%associed_language_script%" "intro"
pause
echo.
call "%associed_language_script%" "partial_keys_input_file_select_choice"
set /p partial_keys_input_file=<templogs\tempvar.txt
IF "%partial_keys_input_file%"=="" (
	call "%associed_language_script%" "partial_keys_input_file_empty_error"
	goto:endscript
)
echo.
call "%associed_language_script%" "prod_keys_file_select_choice"
set /p prod_keys_file=<templogs\tempvar.txt
IF "%prod_keys_file%"=="" (
	call "%associed_language_script%" "prod_keys_file_empty_error"
	goto:endscript
)
tools\gnuwin32\bin\grep.exe -c "" "%partial_keys_input_file%" > templogs\tempvar.txt
set /p maxcount=<templogs\tempvar.txt
set /a maxcount=%maxcount%
IF %maxcount% EQU 0 (
	call "%associed_language_script%" "partial_keys_file_error"
	pause
	goto:endscript
)

tools\gnuwin32\bin\tail.exe -q -c 1 "%prod_keys_file%" >templogs\tempvar.txt
set /p temp_char_test=<templogs\tempvar.txt
IF "%temp_char_test%"=="" (
	set first_key_write=Y
)

:num_threads_select
set num_threads=1
call "%associed_language_script%" "num_threads_choose"
call TOOLS\Storage\functions\strlen.bat nb "%num_threads%"
set i=0
:check_chars_num_threads
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!num_threads:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_num_threads
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "char_not_authorized"
		goto:num_threads_select
	)
)

set /a tempcount=1
:begin
IF %tempcount% GTR %maxcount% goto:end
tools\gnuwin32\bin\sed.exe -n %tempcount%p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
set /a tempcount=%tempcount%+1
IF "%temp_result%"=="0" (
	call :create_key "mariko_aes_class_key_00"
) else IF "%temp_result%"=="1" (
	call :create_key "mariko_aes_class_key_01"
) else IF "%temp_result%"=="2" (
	call :create_key "mariko_aes_class_key_02"
) else IF "%temp_result%"=="3" (
	call :create_key "mariko_aes_class_key_03"
) else IF "%temp_result%"=="4" (
	call :create_key "mariko_aes_class_key_04"
) else IF "%temp_result%"=="5" (
	call :create_key "mariko_aes_class_key_05"
) else IF "%temp_result%"=="6" (
	call :create_key "mariko_aes_class_key_06"
) else IF "%temp_result%"=="7" (
	call :create_key "mariko_aes_class_key_07"
) else IF "%temp_result%"=="8" (
	call :create_key "mariko_aes_class_key_08"
) else IF "%temp_result%"=="9" (
	call :create_key "mariko_aes_class_key_09"
) else IF "%temp_result%"=="10" (
	call :create_key "mariko_aes_class_key_0a"
) else IF "%temp_result%"=="11" (
	call :create_key "mariko_aes_class_key_0b"
) else IF "%temp_result%"=="12" (
	call :create_key "mariko_kek"
) else IF "%temp_result%"=="13" (
	call :create_key "mariko_bek"
) else IF "%temp_result%"=="14" (
	call :create_key "secure_boot_key"
) else IF "%temp_result%"=="15" (
	call :create_key "secure_storage_key"
)
set /a tempcount=!tempcount!+1
goto:begin
:end
call "%associed_language_script%" "create_partial_keys_end"
goto:endscript

:create_key
set temp_key_name=%~1
call "%associed_language_script%" "create_partial_key_begin"
tools\gnuwin32\bin\grep.exe -c "%~1" <"%prod_keys_file%" > templogs\tempvar.txt
set /p temp_key_founded=<templogs\tempvar.txt
IF !temp_key_founded! NEQ 0 (
	call "%associed_language_script%" "key_already_present_message"
	exit /b
)
tools\gnuwin32\bin\sed.exe -n !tempcount!p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
echo !temp_result! | tools\gnuwin32\bin\cut.exe -d " " -f 1 > templogs\tempvar.txt
set /p temp_first_key_part=<templogs\tempvar.txt
echo !temp_result! | tools\gnuwin32\bin\cut.exe -d " " -f 2 > templogs\tempvar.txt
set /p temp_second_key_part=<templogs\tempvar.txt
echo !temp_result! | tools\gnuwin32\bin\cut.exe -d " " -f 3 > templogs\tempvar.txt
set /p temp_third_key_part=<templogs\tempvar.txt
echo !temp_result! | tools\gnuwin32\bin\cut.exe -d " " -f 4 > templogs\tempvar.txt
set /p temp_fourth_key_part=<templogs\tempvar.txt
IF /i "%ushs_debug_mode%"=="on" (
	tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% !temp_first_key_part! !temp_second_key_part! !temp_third_key_part! !temp_fourth_key_part! >templogs\tempvar.txt
) else (
	tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% !temp_first_key_part! !temp_second_key_part! !temp_third_key_part! !temp_fourth_key_part! >templogs\tempvar.txt 2> nul
)
IF !errorlevel! NEQ 0 (
	call "%associed_language_script%" "create_partial_key_error"
	exit /b
)
set /p temp_key=<templogs\tempvar.txt
IF NOT "!first_key_write!"=="Y" echo.>>"%prod_keys_file%"
echo %~1 = !temp_key!>>"%prod_keys_file%"
set first_key_write=Y
call "%associed_language_script%" "create_partial_key_success"
exit /b

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal