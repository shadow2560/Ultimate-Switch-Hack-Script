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
tools\gnuwin32\bin\sed.exe -n 1p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
IF NOT "%temp_result%"=="12" (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
tools\gnuwin32\bin\sed.exe -n 6p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
IF NOT "%temp_result%"=="13" (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
tools\gnuwin32\bin\sed.exe -n 11p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
IF NOT "%temp_result%"=="14" (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
tools\gnuwin32\bin\sed.exe -n 16p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_result=<templogs\tempvar.txt
IF NOT "%temp_result%"=="15" (
	call "%associed_language_script%" "create_partial_keys_error"
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

tools\gnuwin32\bin\grep.exe -c "mariko_kek" <"%prod_keys_file%" > templogs\tempvar.txt
set /p temp_key_founded=<templogs\tempvar.txt
IF %temp_key_founded% NEQ 0 (
	call "%associed_language_script%" "mariko_kek_already_present_message"
	goto:pass_mariko_kek
)
tools\gnuwin32\bin\sed.exe -n 2p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_first_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 3p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_second_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 4p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_third_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 5p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_fourth_key_part=<templogs\tempvar.txt
tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% %temp_first_key_part% %temp_second_key_part% %temp_third_key_part% %temp_fourth_key_part% >templogs\tempvar.txt
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
set /p mariko_kek_key=<templogs\tempvar.txt
IF NOT "%first_key_write%"=="Y" echo.>>"%prod_keys_file%"
echo mariko_kek = %mariko_kek_key%>>"%prod_keys_file%"
set first_key_write=Y

:pass_mariko_kek
tools\gnuwin32\bin\grep.exe -c "mariko_bek" <"%prod_keys_file%" > templogs\tempvar.txt
set /p temp_key_founded=<templogs\tempvar.txt
IF %temp_key_founded% NEQ 0 (
	call "%associed_language_script%" "mariko_bek_already_present_message"
	goto:pass_mariko_bek
)
tools\gnuwin32\bin\sed.exe -n 7p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_first_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 8p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_second_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 9p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_third_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 10p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_fourth_key_part=<templogs\tempvar.txt
tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% %temp_first_key_part% %temp_second_key_part% %temp_third_key_part% %temp_fourth_key_part% >templogs\tempvar.txt
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
set /p mariko_bek_key=<templogs\tempvar.txt
IF NOT "%first_key_write%"=="Y" echo.>>"%prod_keys_file%"
echo mariko_bek = %mariko_bek_key%>>"%prod_keys_file%"
set first_key_write=Y

:pass_mariko_bek
tools\gnuwin32\bin\grep.exe -c "secure_boot_key" <"%prod_keys_file%" > templogs\tempvar.txt
set /p temp_key_founded=<templogs\tempvar.txt
IF %temp_key_founded% NEQ 0 (
	call "%associed_language_script%" "secure_boot_key_already_present_message"
	goto:pass_secure_boot_key
)
tools\gnuwin32\bin\sed.exe -n 12p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_first_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 13p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_second_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 14p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_third_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 15p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_fourth_key_part=<templogs\tempvar.txt
tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% %temp_first_key_part% %temp_second_key_part% %temp_third_key_part% %temp_fourth_key_part% >templogs\tempvar.txt
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
set /p secure_boot_key=<templogs\tempvar.txt
IF NOT "%first_key_write%"=="Y" echo.>>"%prod_keys_file%"
echo secure_boot_key = %secure_boot_key%>>"%prod_keys_file%"
set first_key_write=Y

:pass_secure_boot_key
tools\gnuwin32\bin\grep.exe -c "secure_storage_key" <"%prod_keys_file%" > templogs\tempvar.txt
set /p temp_key_founded=<templogs\tempvar.txt
IF %temp_key_founded% NEQ 0 (
	call "%associed_language_script%" "secure_storage_key_already_present_message"
	goto:pass_secure_storage_key
)
tools\gnuwin32\bin\sed.exe -n 17p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_first_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 18p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_second_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 19p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_third_key_part=<templogs\tempvar.txt
tools\gnuwin32\bin\sed.exe -n 20p <"%partial_keys_input_file%" > templogs\tempvar.txt 2> nul
set /p temp_fourth_key_part=<templogs\tempvar.txt
tools\PartialAesKeyCrack\PartialAesKeyCrack.exe --numthreads=%num_threads% %temp_first_key_part% %temp_second_key_part% %temp_third_key_part% %temp_fourth_key_part% >templogs\tempvar.txt
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_partial_keys_error"
	goto:endscript
)
set /p secure_storage_key=<templogs\tempvar.txt
IF NOT "%first_key_write%"=="Y" echo.>>"%prod_keys_file%"
echo secure_storage_key = %secure_storage_key%>>"%prod_keys_file%"
set first_key_write=Y

:pass_secure_storage_key
call "%associed_language_script%" "create_partial_keys_success"

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal