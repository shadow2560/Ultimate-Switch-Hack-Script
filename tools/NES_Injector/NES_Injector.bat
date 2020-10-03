::Script by markus95, modified by shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST "%~dp0\folder_version.txt" (
	set /p this_script_version=<"%~dp0\folder_version.txt"
) else (
	set this_script_version=1.00.00
)
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
set script_base=tools\NES_Injector
set target_path=tools\sd_switch\emulators\pack\Nes_Classic_Edition\switch\clover\user
call :set_paths
set /a nb_games=0
for %%a in ("%source_roms%\*.nes") do (
	copy "%%a" "%target_path%\rom"
	set /a nb_games+=1
)
IF %nb_games% EQU 0 (
	call "%associed_language_script%" "no_game_in_source_folder_error"
	rmdir /s /q game >nul 2>&1
	goto:end_script
)
for %%a in ("%target_path%\rom\*.nes") do (
	copy "%source_images%\%%~na.jpg" "%target_path%\images" >nul 2>&1
)
for /f "delims=" %%a In ('dir /b/a-d/s  "%target_path%\images" ') Do (
	set "$File=%%~nxa"
	set "$File=!$File: =_!"
	ren "%%a" "!$File!"
)
for /f "delims=" %%a In ('dir /b/a-d/s "%target_path%\rom" ') Do (
	set "$File=%%~nxa"
	set "$File=!$File: =_!"
	ren "%%a" "!$File!"
)
set /a tmp_nb_games=0
echo [>>"%target_path%\data.json"
for %%I in ("%target_path%\rom\*.*") do (
	set /a tmp_nb_games+=1
	set game_file_name=%%~nI
	set space=!game_file_name:_= !
	set "num="
	call :prepare_game
)
echo ]>>"%target_path%\data.json"
call "%associed_language_script%" "operations_success"
goto:end_script

:prepare_game
IF NOT EXIST "%target_path%\images\%game_file_name%.jpg" (
	call "%associed_language_script%" "no_image_for_the_game_warning"
	copy "%script_base%\default_image.jpg" "%target_path%\images\%game_file_name%.jpg"
)
set jpg=%game_file_name%.jpg
findstr /I /C:"%game_file_name%" 2player.txt
if "%errorlevel%"=="0" set num=2
if not "%num%"=="2" set num=1
set "nospace=%space:&=%"
set nospace=%nospace:'=%
set nospace=%nospace:,=%
set nospace=%nospace:-=%
set nospace=%nospace: =%

echo     {>>"%target_path%\data.json"
echo         "filename": "%nospace%",>>"%target_path%\data.json"
echo         "title": "%space%",>>"%target_path%\data.json"
echo         "number_of_player": ^%num%,>>"%target_path%\data.json"
IF %nb_games% NEQ !tmp_nb_games! (
	echo     },>>"%target_path%\data.json"
) else (
	echo     }>>"%target_path%\data.json"
)

"%script_base%\nconvert.exe" -out png -rmeta -resize 40 28 "%target_path%\images\%jpg%" >nul
set thumb=%jpg:~0,-4%
set "thumb1=%thumb:&=%"
set thumb1=%thumb1:'=%
set thumb1=%thumb1:,=%
set thumb1=%thumb1:-=%
set thumb1=%thumb1: =%
ren "%target_path%\images\%thumb%.png" %thumb1%.png
move "%target_path%\images\%thumb1%.png" "%target_path%\thumbnail"

"%script_base%\nconvert.exe" -out png -rmeta -resize 140 204 "%target_path%\images\%jpg%" >nul
set box=%jpg:~0,-4%
set "box1=%box:&=%"
set box1=%box1:'=%
set box1=%box1:,=%
set box1=%box1:-=%
set box1=%box1: =%
ren "%target_path%\images\%box%.png" "%box1%.png"
move "%target_path%\images\%box1%.png" "%target_path%\boxart"
exit /b

:set_paths
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "images_folder_choice"
set /p source_images=<templogs\tempvar.txt
IF "%source_images%"=="" (
	call "%associed_language_script%" "no_images_folder_defined_warning"
	pause
) else (
	set source_images=!source_images!\
	set source_images=!source_images:\\=\!
	set source_images=!source_images:~0,-1!
)
call "%associed_language_script%" "roms_folder_choice"
set /p source_roms=<templogs\tempvar.txt
IF "%source_roms%"=="" (
	call "%associed_language_script%" "no_roms_folder_defined_error"
	goto:end_script
) else (
	set source_roms=!source_roms!\
	set source_roms=!source_roms:\\=\!
	set source_roms=!source_roms:~0,-1!
)
rmdir /s /q templogs 2>nul
rmdir /s /q "%target_path%\boxart" >nul 2>&1
rmdir /s /q "%target_path%\rom" >nul 2>&1
rmdir /s /q "%target_path%\thumbnail" >nul 2>&1
rmdir /s /q "%target_path%\images" >nul 2>&1
MD "%target_path%\boxart"
MD "%target_path%\rom"
MD "%target_path%\thumbnail"
MD "%target_path%\images"
exit /b

:end_script
pause
rmdir /s /q "%target_path%\images" >nul 2>&1
endlocal