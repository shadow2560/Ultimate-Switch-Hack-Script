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
IF NOT EXIST "tools\android_apps\*.*" (
	del /q "tools\android_apps" 2>nul
	mkdir "tools\android_apps"
)
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
IF NOT EXIST "tools\android_tools" (
	call "%associed_language_script%" "adb_not_finded"
	call :update_adb
	IF !errorlevel! EQU 404 (
		call "%associed_language_script%" "adb_no_internet_connection"
		goto:end_script
	)
)
:list_aps
copy nul templogs\apps_list.txt >nul
set /a max_apps=1
cd "tools\android_apps"
for %%z in (*.apk) do (
	echo !max_apps!: %%z >>..\..\templogs\apps_list.txt
	set /a max_apps+=1
)
cd ..\..
:select_app
set app_path=
set app_choice=
call "%associed_language_script%" "action_choice"
IF "%app_choice%"=="" goto:finish_script
IF /i "%app_choice%"=="u" (
	call :update_adb
	goto:select_app
)
IF /i "%app_choice%"=="f" (
	call "%associed_language_script%" "select_app_file"
	set /p app_path=<templogs\tempvar.txt
)
IF /i "%app_choice%"=="f" (
	IF "%app_path%"=="" (
		call "%associed_language_script%" "no_file_selected_error"
		set app_choice=
		goto:select_app
	)
	goto:install_app
)
IF /i "%app_choice%"=="d" (
	call "%associed_language_script%" "select_app_folder"
	set /p app_path=<templogs\tempvar.txt
	IF NOT "!app_path!"=="" (
		set app_path=!app_path!\
		set app_path=!app_path:\\=\!
		goto:install_app
	) else (
		call "%associed_language_script%" "no_folder_selected_error"
		set app_choice=
		goto:select_app
	)
)
tools\gnuwin32\bin\grep.exe "%app_choice%: " <templogs\apps_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p app_path=<templogs\tempvar.txt
IF "%app_path%"=="" (
	goto:finish_script
)
set app_path=%app_path:~1,-1%
:install_app
IF /i "%app_choice%"=="f" (
	tools\android_tools\adb.exe -d install -r "%app_path%"
) else IF /i "%app_choice%"=="d" (
	call :install_folder_apps "%app_path%"
) else (
	tools\android_tools\adb.exe -d install -r "tools\android_apps\%app_path%"
)
IF %errorlevel% GTR 0 (
	call "%associed_language_script%" "adb_install_error"
) else (
	call "%associed_language_script%" "adb_install_success"
)
pause
goto:select_app

:install_folder_apps
for %%f in ("%~1*.apk") do (
	tools\android_tools\adb.exe -d install -r "%%f"
)
exit /b

:update_adb
call "%associed_language_script%" "update_tools_begin_message"
"%windir%\system32\ping.exe" /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_tools_no_internet_connection"
	exit /b 404
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "adb.zip" "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_tools_download_error"
	exit /b 404
)
tools\7zip\7za.exe x -y -sccUTF-8 "templogs\adb.zip" -o"templogs" -r
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_tools_extract_error"
	exit /b 404
)
del /q templogs\adb.zip"
IF EXIST "tools\android_tools" rmdir /s /q "tools\android_tools"
move "templogs\platform-tools" "tools\android_tools"
call "%associed_language_script%" "update_tools_success"
exit /b

:end_script
pause 
:finish_script
tools\android_tools\adb.exe kill-server
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal