::script by shadow256
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
IF NOT EXIST "tools\java\jre1.8.0_261\*.*" (
	call "tools\Storage\update_manager.bat" "update_launch_nsusbloader.bat"
)
IF NOT EXIST "tools\java\jre1.8.0_261\*.*" (
	call "%associed_language_script%" "java_error"
	pause
	goto:end_script
)
:define_action_choice
set action_choice=
cls
call "%associed_language_script%" "intro"
IF "%action_choice%"=="1" goto:end_script
IF "%action_choice%"=="0" (
	start https://java.com/otnlicense
	goto:define_action_choice
)
ECHO.
start "" /i /b tools\java\jre1.8.0_261\bin\java.exe -jar tools\Ns-usbloader\ns-usbloader.jar
ECHO.
:end_script
endlocal