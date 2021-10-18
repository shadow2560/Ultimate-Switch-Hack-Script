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
title Launch the remote control via NVDA and Nvdaremote %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script just launches NVDA and Nvdaremote to allow remote control of this computer through them.
echo.
echo The server used is "nvdaremote.com" and the key is "ushshelp".
echo.
echo To stop the remote control, simply quit NVDA by left-clicking on the NVDA icon that appears in the bar that allows you to manage the volume of the computer's sound, for example, and then select "Quit".
goto:eof

:launch_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you realy want to launch the remote control? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:nvda_launched
echo NVDA has been started, now the remote control should be possible.
goto:eof