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
title Theme change %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:theme_list_downloading
echo Downloading themes list...
goto:eof

:theme_choice_begin
echo Choose theme
goto:eof

:theme_choice
set /p temp_theme_number=Choose the wanted theme: 
goto:eof

:theme_choice_empty_error
echo Theme choice couldn't be empty.
goto:eof

:theme_choice_char_error
echo Unauthorized char in theme choice.
goto:eof

:theme_choice_bad_value_error
echo Unauthorized value in theme choice.
goto:eof

:init_theme_error
echo Initialisation of the new theme error, the theme will not be changed.
goto:eof

:theme_change_success
echo Theme change success.
goto:eof

:no_internet_connection_error
echo No internet connexion, continuing the script is not possible.
goto:eof