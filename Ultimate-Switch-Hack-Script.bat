::Script by Shadow256
@echo off
:: BatchGotAdmin, see https://sites.google.com/site/eneerge/scripts/batchgotadmin
::-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
	echo Requesting administrative privileges...
	goto UACPrompt
) else (
	goto gotAdmin
)

:UACPrompt
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	exit /B

:gotAdmin
	if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
	pushd "%CD%"
	cd /D "%~dp0"
::--------------------------------------

chcp 65001 >nul
Setlocal enabledelayedexpansion
::MODE con:cols=140 lines=70
cls
set ushs_base_path=%~dp0
set this_script_full_path=%~0
set language_custom=0
:define_language_path
set language_path=
IF NOT EXIST "Ultimate-Switch-Hack-Script.bat.lng" (
	call :config_lng
)
set /p language_path=<Ultimate-Switch-Hack-Script.bat.lng
IF NOT EXIST "%language_path%\*.*" (
	del /q "Ultimate-Switch-Hack-Script.bat.lng"
	goto:define_language_path
)
set temp_language_path=%language_path%
::call "%language_path%\script_general_config.bat"
call "%language_path%\language_general_config.bat"
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST tools\version.txt (
	set /p ushs_version=<tools\version.txt
) else (
	set ushs_version=1.00.00
)
IF EXIST tools\sd_switch\version.txt (
	set /p ushs_packs_version=<tools\sd_switch\version.txt
) else (
	set ushs_packs_version=0
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
chcp 1252 >nul
call "%associed_language_script%" "display_title"
mkdir test
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "admin_error"
	goto:end_script
)
rmdir /s /q test
:define_theme
set ushs_theme=
IF NOT EXIST "Ultimate-Switch-Hack-Script.bat.theme" (
	call :config_theme
)
set /p ushs_theme=<Ultimate-Switch-Hack-Script.bat.theme
color %ushs_theme%
call "%associed_language_script%" "display_utf8_instructions"
pause
cls
IF NOT EXIST "tools\Storage\update_manager.bat" (
	call tools\Storage\update_manager_updater.bat
)
IF EXIST "failed_updates\tools;Storage;update_manager.bat.file.failed" (
	call tools\Storage\update_manager_updater.bat
)
call tools\Storage\update_manager.bat "general_content_update"
cls
chcp 1252 >nul
set debug_flag=
call "%associed_language_script%" "set_debug_flag"
IF "%debug_flag%"=="1" (
	set ushs_debug_mode=on
) else if "%debug_flag%"=="2" (
	set ushs_debug_mode=on
	set language_echo=on
)
chcp 65001 >nul
IF /i NOT "%ushs_debug_mode%"=="on" (
	call tools\Storage\menu.bat
) else (
	call tools\Storage\menu.bat 2>&1 | tools\gnuwin32\bin\tee.exe Ultimate-Switch-Hack-Script.log >con
)
goto:end_script

:config_lng
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF EXIST "Ultimate-Switch-Hack-Script.bat.lng\*.*" (
	rmdir /s /q "Ultimate-Switch-Hack-Script.bat.lng"
)
:set_temp_language
cls
echo Choose language:
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
set temp_language_number=
set /p temp_language_number=Enter language number: 
IF "%temp_language_number%"=="" (
	echo Language couldn't be empty.
	pause
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
		echo Unauthorized char in language choice.
		pause
		goto:set_temp_language
	)
)
IF %temp_language_number% GTR %temp_count% (
	echo Bad value for language selection.
	pause
	goto:set_temp_language
) else IF %temp_language_number% EQU 0 (
	echo Bad value for language selection.
	pause
	goto:set_temp_language
)
tools\gnuwin32\bin\sed.exe -n %temp_language_number%p <"tools\default_configs\Lists\languages.list"|tools\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p temp_language_path=<templogs\tempvar.txt
set temp_language_path=languages\%temp_language_path%
IF NOT EXIST "%temp_language_path%" call "tools\Storage\update_manager.bat" "" "language_init"
copy nul "Ultimate-Switch-Hack-Script.bat.lng" >nul
echo %temp_language_path%>>"Ultimate-Switch-Hack-Script.bat.lng"
rmdir /s /q "templogs" 2>nul
cls
exit /b

:config_theme
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF EXIST "Ultimate-Switch-Hack-Script.bat.theme\*.*" (
	rmdir /s /q "Ultimate-Switch-Hack-Script.bat.theme"
)
:set_temp_theme
cls
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
set temp_language_number=
call "%associed_language_script%" "theme_number_set"
IF "%temp_theme_number%"=="" (
	call "%associed_language_script%" "empty_theme_number_error"
	pause
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
		call "%associed_language_script%" "bad_char_theme_number_error"
		pause
		goto:set_temp_theme
	)
)
IF %temp_theme_number% GTR %temp_count% (
	call "%associed_language_script%" "bad_value_theme_number_error"
	pause
	goto:set_temp_theme
) else IF %temp_theme_number% EQU 0 (
	call "%associed_language_script%" "bad_value_theme_number_error"
	pause
	goto:set_temp_theme
)
tools\gnuwin32\bin\sed.exe -n %temp_theme_number%p <"tools\default_configs\Lists\themes.list"|tools\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p temp_theme=<templogs\tempvar.txt
copy nul "Ultimate-Switch-Hack-Script.bat.theme" >nul
echo %temp_theme%>>"Ultimate-Switch-Hack-Script.bat.theme"
rmdir /s /q "templogs" 2>nul
cls
exit /b

:end_script
endlocal
exit