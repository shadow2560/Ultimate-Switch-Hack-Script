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
title BIS Keys dump%this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:rcm_instructions
echo *********************************************
echo ***    Connect the Switch in RCM mode    ***
echo *********************************************
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
echo 4^) When the payload is charged on the Switch, press "Power" button on it to close the payload.
echo Waiting a Switch in RCM...
goto:eof

:script_success
echo Succesful keys recuperation.
goto:eof