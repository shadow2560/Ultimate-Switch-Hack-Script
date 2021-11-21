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
	call "%associed_language_script%" "theme_list_downloading"
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "tools\default_configs\Lists" -o "themes.list" "%files_url_project_base%/tools/default_configs/Lists/themes.list"
	echo.
)
:set_temp_theme
set temp_theme_number=
call "%associed_language_script%" "theme_choice_begin"
echo.
tools\gnuwin32\bin\grep.exe -c "" <"tools\default_configs\Lists\themes.list" > templogs\tempvar.txt
set /p count_themes=<templogs\tempvar.txt
set /a temp_count=1
:listing_themes
IF %temp_count% GTR %count_themes% goto:skip_listing_themes
"tools\gnuwin32\bin\sed.exe" -n %temp_count%p "tools\default_configs\Lists\themes.list" >templogs\tempvar.txt
set /p temp_theme=<templogs\tempvar.txt
echo %temp_theme%|tools\gnuwin32\bin\cut.exe -d ; -f 2 >templogs\tempvar.txt
set /p temp_theme_name=<templogs\tempvar.txt
echo %temp_count%: %temp_theme_name%
set /a temp_count+=1
goto:listing_themes
:skip_listing_themes
set /a temp_count-=1
call "%associed_language_script%" "theme_choice"
IF "%temp_theme_number%"=="" (
	call "%associed_language_script%" "theme_choice_empty_error"
	goto:set_temp_theme
)
call TOOLS\Storage\functions\strlen.bat nb "%temp_theme_number%"
set i=0
:check_chars_temp_theme_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!temp_theme_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_temp_theme_number
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "theme_choice_char_error"
		goto:set_temp_theme
	)
)
IF %temp_theme_number% GTR %temp_count% (
	call "%associed_language_script%" "theme_choice_bad_value_error"
	goto:set_temp_theme
) else IF %temp_theme_number% EQU 0 (
	call "%associed_language_script%" "theme_choice_bad_value_error"
	goto:set_temp_theme
)
tools\gnuwin32\bin\sed.exe -n %temp_theme_number%p <"tools\default_configs\Lists\themes.list"|tools\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p temp_theme=<templogs\tempvar.txt
copy nul "Ultimate-Switch-Hack-Script.bat.theme" >nul
echo %temp_theme%>>"Ultimate-Switch-Hack-Script.bat.theme"
call "%associed_language_script%" "theme_change_success"
pause
rmdir /s /q templogs
set /p ushs_theme=<Ultimate-Switch-Hack-Script.bat.theme
color %ushs_theme%
endlocal

:end_script
rmdir /s /q templogs
endlocal