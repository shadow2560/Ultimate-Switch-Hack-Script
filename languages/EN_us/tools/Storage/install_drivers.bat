set lng_label_exist=0
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Drivers install %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This will will propose to install the drivers of the Switch on the computer.
echo For more infos on the different methods, choose to open the documentation when it will be proposed.
goto:eof

:install_choice
echo Drivers install
echo.
echo Choose how to install drivers:
echo.
echo 1: Automatic install for the RCM and homebrews mode ^(recommanded for these modes^)?
echo 2: Install drivers via Zadig?
echo 3: Install drivers via the Windows Devices Manager?
echo 4: Maximize Hekate's USB mass storage function speed ^(must be executed only one time^)?
echo 0: Launch the documentation?
echo All other choices: Bo back to previous menu?
echo.
set /p install_choice=Make your choice:  
goto:eof

:test_payload_choice
set /p test_payload=Do you wish to launch a payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:zadig_launch_instructions
echo Zadig will be launched, accept the admin privileges elevation to use this program.
goto:eof

:manual_install_instructions
echo The Devices Manager will be launched.
echo The folder to select to  install the drivers is the "tools\drivers\manual_installation_usb_driver" folder on root of the script.
goto:eof