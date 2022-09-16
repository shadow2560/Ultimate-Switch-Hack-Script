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
title Loading %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:admin_error
echo This script requires Admin rights, please right click and select "run as admin" before continuing.
goto:eof

:display_utf8_instructions
echo Before continuing, please verify the following settings are correct. Not setting this correctly could cause this script to fail.
echo Make a right click on the title bar or use the shortcut "alt+space" and select "properties".
echo Go to the "fonts" tab, select the "Lucida Console" font and click the "OK" button.
echo.
echo If everything is configured correctly, the script should work without issue.
echo If the script fails and force closes, the font selected is not compatible with UTF-8 encoding.
echo.
echo If you have problems displaying the content, you can also change the number of lines options in the "Options" and "Configuration" tabs.
goto:eof

:set_debug_flag
echo.
echo Log mode choice.
echo.
echo For this session:
echo 1: Intermediate log mode ^(make the script more verbose on screen and write the outputs to a log file^)
echo 2: Full log mode ^(display a lots of thing on screen and write the outputs to a log file^)
echo All other choices: No log mode ^(recommanded^).
echo.
set /p debug_flag=Make your choice: 
goto:eof

:theme_choice_begin
echo Choose theme
goto:eof

:theme_number_set
set /p temp_theme_number=Enter theme number: 
goto:eof

:empty_theme_number_error
echo Theme couldn't be empty.
goto:eof

:bad_char_theme_number_error
echo Unauthorized char in theme choice.
goto:eof

:bad_value_theme_number_error
echo Bad value for theme selection.
goto:eof