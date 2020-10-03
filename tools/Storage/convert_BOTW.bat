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
IF EXIST "BOTW_save" (
	rmdir /s /q "BOTW_save" 2>nul
	del /q BOTW_save 2>nul
)
	mkdir "BOTW_save"
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
call "%associed_language_script%" "select_save_folder"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	set filepath=%filepath:\\=\%
) else (
	call "%associed_language_script%" "no_folder_selected_error"
	rmdir /s /q "BOTW_save" 2>nul
	goto:end_script
)
IF NOT EXIST "%filepath%\option.sav" (
	set files_error=1
	goto:files_error
)
IF EXIST "%filepath%\0\*.*" (
	IF EXIST "%filepath%\0\caption.jpg" (
		IF EXIST "%filepath%\0\caption.sav" (
			IF EXIST "%filepath%\0\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\1\*.*" (
	IF EXIST "%filepath%\1\caption.jpg" (
		IF EXIST "%filepath%\1\caption.sav" (
			IF EXIST "%filepath%\1\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\2\*.*" (
	IF EXIST "%filepath%\2\caption.jpg" (
		IF EXIST "%filepath%\2\caption.sav" (
			IF EXIST "%filepath%\2\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\3\*.*" (
	IF EXIST "%filepath%\3\caption.jpg" (
		IF EXIST "%filepath%\3\caption.sav" (
			IF EXIST "%filepath%\3\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\4\*.*" (
	IF EXIST "%filepath%\4\caption.jpg" (
		IF EXIST "%filepath%\4\caption.sav" (
			IF EXIST "%filepath%\4\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\5\*.*" (
	IF EXIST "%filepath%\5\caption.jpg" (
		IF EXIST "%filepath%\5\caption.sav" (
			IF EXIST "%filepath%\5\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\6\*.*" (
	IF EXIST "%filepath%\6\caption.jpg" (
		IF EXIST "%filepath%\6\caption.sav" (
			IF EXIST "%filepath%\6\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\7\*.*" (
	IF EXIST "%filepath%\7\caption.jpg" (
		IF EXIST "%filepath%\7\caption.sav" (
			IF EXIST "%filepath%\7\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
:files_error
call "%associed_language_script%" "error_with_save_file"
rmdir /s /q "BOTW_save" 2>nul
goto:end_script
:start_converting
call "%associed_language_script%" "intro_copying_files"
copy "TOOLS\BOTW_SaveConv\BOTW_SaveConv.exe" "BOTW_save\BOTW_SaveConv.exe"
%windir%\System32\Robocopy.exe "%filepath%" "BOTW_save" /e
call "%associed_language_script%" "end_copying_files"
cd "BOTW_save"
BOTW_SaveConv.exe
del /q "BOTW_SaveConv.exe"
cd ..
call "%associed_language_script%" "converting_success"
:end_script
rmdir /s /q templogs
pause 
endlocal