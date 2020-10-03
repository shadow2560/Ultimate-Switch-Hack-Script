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
:define_action_choice
cls
call "%associed_language_script%" "display_title"
echo.
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" (
	start https://www.paypal.me/shadow256
	goto:define_action_choice
)
IF "%action_choice%"=="2" (
	start https://commerce.coinbase.com/checkout/08c16541-bf06-4d7b-baf7-7e84e6da06ad
	goto:define_action_choice
)
IF "%action_choice%"=="3" (
	start "" "http://rover.ebay.com/rover/1/709-53476-19255-0/1?icep_ff3=2&pub=5575378759&campid=5338273189&customid=&icep_item=114242698090&ipn=psmain&icep_vectorid=229480&kwid=902099&mtid=824&kw=lg&toolid=11111"
	goto:define_action_choice
)
goto:end_script

:end_script
endlocal