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
echo.
:menu_choice
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" (
	call :create_atmosphere_logo
	goto:menu_choice
)
IF "%action_choice%"=="2" (
	call :create_nintendo_logo
	goto:menu_choice
)
goto:end_script

:create_atmosphere_logo
set resize_image=
call :logo_file_choice
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "resize_image_choice"
	IF NOT "!resize_image!"=="" set resize_image=!resize_image:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "resize_image" "o/n_choice"
	if /i "!resize_image!"=="o" (
		call :copy_logo "!logo_file_path!"
		"tools\ImageMagick\magick.exe" mogrify -resize 1280x720^^! "!logo_file_path!"
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "image_conversion_error"
			pause
			exit /b
		)
	)
	call :fusee-secondary_choice
	IF !errorlevel! EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			call :copy_fusee_secondary "!fusee_file_path!"
			tools\python3_scripts\Insert_splash_screen\insert_splash_screen.exe "!logo_file_path:\=\\!" "!fusee_file_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "logo_creation_success"
				pause
			) else (
				call "%associed_language_script%" "logo_creation_error"
				pause
			)
		)
	)
)
exit /b

:create_nintendo_logo
set resize_image=
call :logo_file_choice
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "resize_image_choice"
	IF NOT "!resize_image!"=="" set resize_image=!resize_image:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "resize_image" "o/n_choice"
	if /i "!resize_image!"=="o" (
		call :copy_logo "!logo_file_path!"
		"tools\ImageMagick\magick.exe" mogrify -resize 308x350^^! "!logo_file_path!"
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "image_conversion_error"
			pause
			exit /b
		)
	)
	call :outdir_choice
	IF !errorlevel! EQU 0 (
		IF NOT EXIST "!outdir_path!\atmosphere" mkdir "!outdir_path!\atmosphere"
		IF NOT EXIST "!outdir_path!\atmosphere\exefs_patches" mkdir "!outdir_path!\atmosphere\exefs_patches"
		IF NOT EXIST "!outdir_path!\atmosphere\exefs_patches\logo" (
			mkdir "!outdir_path!\atmosphere\exefs_patches\logo"
		) else (
			rmdir /s /q "!outdir_path!\atmosphere\exefs_patches\logo" >nul
			mkdir "!outdir_path!\atmosphere\exefs_patches\logo"
		)
		set outdir_path=!outdir_path!\atmosphere\exefs_patches\logo
		del /q !outdir_path!\*.* >nul 2>&1
		tools\python3_scripts\Switch-logo-patcher\gen_patches.exe "!outdir_path:\=\\!" "!logo_file_path:\=\\!" >nul 2>&1
		IF !errorlevel! EQU 0 (
			call "%associed_language_script%" "logo_creation_success"
			pause
		) else (
			call "%associed_language_script%" "logo_creation_error"
			pause
		)
	)
)
exit /b

:copy_fusee_secondary
set temp_fusee_secondary_filename=%~nx1
IF NOT EXIST "%outdir_path%\atmosphere\*.*" mkdir "%outdir_path%\atmosphere"
copy "%fusee_file_path%" "%outdir_path%\atmosphere\%temp_fusee_secondary_filename%" >nul
set fusee_file_path=%outdir_path%\atmosphere\%temp_fusee_secondary_filename%
exit /b

:copy_logo
set temp_logo_filename=%~nx1
copy "!logo_file_path!" "templogs\%temp_logo_filename%" >nul
set logo_file_path=%ushs_base_path%templogs\%temp_logo_filename%
exit /b

:logo_file_choice
set logo_file_path=
call "%associed_language_script%" "logo_file_selection"
set /p logo_file_path=<"templogs\tempvar.txt"
IF "%logo_file_path%"=="" (
	call "%associed_language_script%" "no_logo_file_selected_error"
	pause
	exit /b 400
)
exit /b

:outdir_choice
set outdir_path=
call "%associed_language_script%" "outdir_folder_select"
set /p outdir_path=<"templogs\tempvar.txt"
IF "%outdir_path%"=="" (
	call "%associed_language_script%" "no_outdir_source_selected_error"
	exit /b 400
)
set outdir_path=%outdir_path%\
set outdir_path=%outdir_path:\\=\%
exit /b

:fusee-secondary_choice
set fusee_file_path=
call "%associed_language_script%" "fusee_file_selection"
set /p fusee_file_path=<"templogs\tempvar.txt"
IF "%fusee_file_path%"=="" (
	call "%associed_language_script%" "no_fusee_file_selected_error"
	exit /b 400
)
exit /b

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal