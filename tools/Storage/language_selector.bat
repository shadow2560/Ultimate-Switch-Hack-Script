::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master
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
ping /n 2 www.github.com >nul 2>&1
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "language_list_downloading"
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "tools\default_configs\Lists" -o "languages.list" "%files_url_project_base%/tools/default_configs/Lists/languages.list"
	echo.
)
:set_temp_language
set temp_language_number=
call "%associed_language_script%" "language_choice_begin"
echo.
tools\gnuwin32\bin\grep.exe -c "" <"tools\default_configs\Lists\languages.list" > templogs\tempvar.txt
set /p count_languages=<templogs\tempvar.txt
set /a temp_count=1
:listing_languages
IF %temp_count% GTR %count_languages% goto:skip_listing_languages
"tools\gnuwin32\bin\sed.exe" -n %temp_count%p "tools\default_configs\Lists\languages.list" >templogs\tempvar.txt
set /p temp_language=<templogs\tempvar.txt
echo %temp_language%|tools\gnuwin32\bin\cut.exe -d ; -f 2 >templogs\tempvar.txt
set /p temp_language_name=<templogs\tempvar.txt
echo %temp_count%: %temp_language_name%
set /a temp_count+=1
goto:listing_languages
:skip_listing_languages
set /a temp_count-=1
call "%associed_language_script%" "language_choice"
IF "%temp_language_number%"=="" (
	call "%associed_language_script%" "language_choice_empty_error"
	goto:set_temp_language
)
call TOOLS\Storage\functions\strlen.bat nb "%temp_language_number%"
set i=0
:check_chars_temp_language_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!temp_language_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_temp_language_number
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "language_choice_char_error"
		goto:set_temp_language
	)
)
IF %temp_language_number% GTR %temp_count% (
	call "%associed_language_script%" "language_choice_bad_value_error"
	goto:set_temp_language
) else IF %temp_language_number% EQU 0 (
	call "%associed_language_script%" "language_choice_bad_value_error"
	goto:set_temp_language
)
tools\gnuwin32\bin\sed.exe -n %temp_language_number%p <"tools\default_configs\Lists\languages.list"|tools\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p temp_language_path=<templogs\tempvar.txt
set temp_language_path=languages\%temp_language_path%
IF NOT EXIST "%temp_language_path%" call :init_language
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "init_language_error"
	goto:end_script
)
copy nul "Ultimate-Switch-Hack-Script.bat.lng" >nul
echo %temp_language_path%>>"Ultimate-Switch-Hack-Script.bat.lng"
call "%associed_language_script%" "language_change_success"
pause
rmdir /s /q templogs
set /p language_path=<Ultimate-Switch-Hack-Script.bat.lng
call tools\Storage\update_manager.bat "general_content_update" "force"
endlocal
start /i "" "%windir%\system32\cmd.exe" /c call "Ultimate-Switch-Hack-Script.bat"
exit

:init_language
ping /n 2 www.github.com >nul 2>&1
IF !errorlevel! NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	exit /b 404
)
"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_language_path:\=/% %temp_language_path% --force >nul
IF !errorlevel! NEQ 0 (
	exit /b 400
)
exit /b

:end_script
rmdir /s /q templogs
endlocal