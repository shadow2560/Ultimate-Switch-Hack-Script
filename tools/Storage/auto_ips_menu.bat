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
	call :create_loader_patches
	goto:menu_choice
)
IF "%action_choice%"=="2" (
	call :create_fs_and_es_patches
	goto:menu_choice
)
IF "%action_choice%"=="3" (
	call :create_fs_patches
	goto:menu_choice
)
IF "%action_choice%"=="4" (
	call :create_es_patches
	goto:menu_choice
)
goto:end_script

:create_loader_patches
call :fusee-secondary_choice
IF %errorlevel% EQU 0 (
	call :outdir_choice
	IF !errorlevel! EQU 0 (
		tools\python3_scripts\AutoIPS-Patcher\Loader-AutoIPS.exe "!fusee_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
		IF !errorlevel! EQU 0 (
			call "%associed_language_script%" "loader_patches_creation_success"
			pause
		) else (
			call "%associed_language_script%" "loader_patches_creation_error"
			pause
		)
	)
)
exit /b

:create_fs_and_es_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF !errorlevel! EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\FS-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "FS_patches_creation_success"
			) else (
				call "%associed_language_script%" "FS_patches_creation_error"
			)
			tools\python3_scripts\AutoIPS-Patcher\ES-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "ES_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "ES_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:create_fs_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF !errorlevel! EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\FS-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "FS_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "FS_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:create_es_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF !errorlevel! EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\ES-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "ES_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "ES_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:keys_file_choice
set keys_file_path=
call "%associed_language_script%" "keys_file_selection"
set /p keys_file_path=<"templogs\tempvar.txt"
IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
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

:firmware_download_and_choice
set firmware_folder=
set firmware_choice=
call tools\storage\prepare_update_on_sd.bat "firmware_download_and_extract"
call "%associed_language_script%" "display_title"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	exit /b 400
)
IF EXIST "templogs\firmware_folder.txt" (
	set /p firmware_folder=<templogs\firmware_folder.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	exit /b 400
)
IF NOT EXIST "%firmware_folder%*.*" (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	exit /b 400
)
IF EXIST "templogs\firmware_chosen.txt" (
	set /p firmware_choice=<templogs\firmware_chosen.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	exit /b 400
)
echo.
:daybreak_convert
call :daybreak_convertion "%firmware_folder%"
exit /b 0

:daybreak_convertion
call "%associed_language_script%" "daybreak_convert_begin"
rem set /a count_loop = 0
for /d %%f in ("%~1\*.nca") do (
	move "%%f" "%%f.bak" >nul
	move "%%f.bak\00" "%%f" >nul
	rmdir "%%f.bak"
)
for %%f in ("%~1\*.nca") do (
	IF NOT EXIST "%%f\*.*" (
		set temp_file_name=%%f
		IF NOT "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			rem tools\Hactool_based_programs\tools\hactool.exe -k "%keys_file_path%" -i "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\Hactool_based_programs\hactoolnet.exe -k "%keys_file_path%" "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\gnuwin32\bin\grep.exe -c -i "ERROR: Unable to decrypt NCA section." <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
				call "%associed_language_script%" "daybreak_convert_keys_warning"
				pause
				exit /b 400
			)
			rem pause
			rem notepad "templogs\temptest.txt"
			tools\gnuwin32\bin\grep.exe -c -i -e "Content Type: *Meta" <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
			rem echo Meta trouvé.
			move "!temp_file_name!" "!temp_file_name:~0,-3!cnmt.nca" >nul
			)
		) else IF "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			rem tools\Hactool_based_programs\tools\hactool.exe -k "%keys_file_path%" -i "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\Hactool_based_programs\hactoolnet.exe -k "%keys_file_path%" "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\gnuwin32\bin\grep.exe -c -i "ERROR: Unable to decrypt NCA section." <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
				call "%associed_language_script%" "daybreak_convert_keys_warning"
				pause
				exit /b 400
			)
			rem pause
			rem notepad "templogs\temptest.txt"
			tools\gnuwin32\bin\grep.exe -c -i -e "Content Type: *Meta" <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF "!temp_count!"=="0" (
			rem echo NCA mal nommé.
			move "!temp_file_name!" "!temp_file_name:~0,-8!nca" >nul
			)
		)
	)
)
rem echo %count_loop%
exit /b

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
)
endlocal