set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Payload launch %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:begin_payload_choice
echo Choose a payload: 
goto:eof

:end_payload_choice
echo 0: Choose a payload file.
echo All other choices: Go back to main menu.
echo.
set /p payload_number=Make your choice: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Payload Switch file ^(*.bin^)|*.bin|" "Payload file select" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo No payload selected, back to the select payload choice.
goto:eof

:rcm_instructions
echo ********************************************* 
echo ***    Connect the Switch in RCM mode    ***
echo ********************************************* 
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
echo Waiting a Switch in RCM...
goto:eof

:launch_payload_error
echo Error during payload injection. Verify that the RCM mode of the Switch is loaded, that the USB cable is connected on the computer and that the drivers are installed and try to restart the script.
goto:eof

:launch_payload_success
echo ********************************************* 
echo ***            Payload injected            *** 
echo ********************************************* 
goto:eof