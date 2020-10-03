::Script by Shadow256
@echo off
Setlocal enabledelayedexpansion
chcp 65001 >nul
cls
IF EXIST "tools\Storage\update_manager_updater.bat.version" (
	set /p this_script_version=<"tools\Storage\update_manager_updater.bat.version"
) else (
	set this_script_version=1.00.00
)
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
cd >templogs\tempvar.txt
set /p ushs_base_path=<templogs\tempvar.txt
set ushs_base_path=%ushs_base_path%\
:define_language_path
set language_custom=0
set language_path=
IF EXIST "Ultimate-Switch-Hack-Script.bat.lng" set /p language_path=<Ultimate-Switch-Hack-Script.bat.lng
IF NOT "%language_path%"=="" (
	IF NOT EXIST "%language_path%\*.*" (
		del /q "Ultimate-Switch-Hack-Script.bat.lng"
		goto:define_language_path
	)
)
IF NOT "%language_path%"=="" call "%language_path%\language_general_config.bat"
set this_script_full_path=%ushs_base_path%tools\Storage\update_manager_updater.bat
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "display_title"
) else (
	title Shadow256 Ultimate Switch Hack Script Update Manager Updater %this_script_version%
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
	mkdir "failed_updates"
set temp_file_path=tools\Storage\update_manager.bat
set temp_file_slash_path=%temp_file_path:\=/%
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "begin_update"
) else (
	echo :::::::::::::::::::::::::::::::::::::
	echo ::Shadow256 Ultimate Switch Hack Script Update Manager Updater::
	echo.
	echo Updating script Update Manager...
)
ping /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "no_internet_connection_error"
		pause
		endlocal
		exit
	) else (
		echo No internet connection could be verified, update could not be done and script will be closed.
		pause
		endlocal
		exit
	)
)
IF NOT EXIST "tools\aria2\aria2c.exe" (
	"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/tools/aria2 tools\aria2 --force >nul
)
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%" "%files_url_project_base%/%temp_file_slash_path%"
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "update_file_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	) else (
	echo Update file "%temp_file_path%" error, script will close and will retry the update on next update try.
	IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%.version" "%files_url_project_base%/%temp_file_slash_path%.version"
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "update_file.version_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	) else (
	echo Update file "%temp_file_path%.version" error, script will close and will retry the update on next update try.
	IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
)
IF EXIST "languages\FR_fr" (
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "languages\FR_fr\%temp_file_path%" "%files_url_project_base%/languages/FR_fr/%temp_file_slash_path%"
	IF %errorlevel% NEQ 0 (
		IF NOT "%language_path%"=="" (
			call "%associed_language_script%" "update_file_error"
			IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		) else (
		echo Update file "languages\FR_fr\%temp_file_path%" error, script will close and will retry the update on next update try.
		IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		)
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "languages\FR_fr\%temp_file_path%.version" "%files_url_project_base%/languages/FR_fr/%temp_file_slash_path%.version"
	IF %errorlevel% NEQ 0 (
		IF NOT "%language_path%"=="" (
			call "%associed_language_script%" "update_file.version_error"
			IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		) else (
		echo Update file "languages\FR_fr\%temp_file_path%.version" error, script will close and will retry the update on next update try.
		IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		)
	)
)
IF NOT "%language_path%"=="" (
	IF NOT "%language_path%"=="languages\FR_fr" (
		IF "%language_custom%"=="0" (
			"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%language_path%\%temp_file_path%" "%files_url_project_base%/%language_path:\=/%/%temp_file_slash_path%"
			IF %errorlevel% NEQ 0 (
				call "%associed_language_script%" "update_language_file_error"
				IF EXIST "templogs" (
					rmdir /s /q "templogs"
				)
				pause
				endlocal
				exit
			)
			"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%language_path%\%temp_file_path%.version" "%files_url_project_base%/%language_path:\=/%/%temp_file_slash_path%.version"
			IF %errorlevel% NEQ 0 (
				call "%associed_language_script%" "update_language_file.version_error"
				IF EXIST "templogs" (
					rmdir /s /q "templogs"
				)
				pause
				endlocal
				exit
			)
		)
	)
)
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
IF EXIST "templogs" (
	rmdir /s /q "templogs"
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates"
)
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "update_success"
) else (
	echo Update Manager update success, script will restart.
)
pause
endlocal
start /i "" "%windir%\system32\cmd.exe" /c call "Ultimate-Switch-Hack-Script.bat"
IF /i "%language_echo%"=="on" pause
exit