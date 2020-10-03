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
title About %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:action_choice
echo About
echo.
echo Script actual version: %ushs_version%
echo Packs actual version: %ushs_packs_version%
echo.
echo GPL V3 Licence  for my work ^(shadow256 on forums and shadow2560 on Github^), others softwares are on their own licences. Note that the language packs are also on GPL V3.
echo.
echo Language used info:
echo Name: %language_name%
echo Author^(s^): %language_authors%
echo.
echo Note: You must do the update twice if an update of the Update Manager is found.
echo.
echo What do you want to do?
echo 1: Display the most recent script changelog?
echo 2: Display the most recent packs changelog?
echo 3: Display last credits page.
echo 4: Update all updatable elements ^(recomanded^) ^(the script will close after the update and must be restarted manualy^)?
echo 5: Force update  of all the script ^(last choice^)  ^(the script will close after the update and must be restarted manualy^)?
echo 6: Donate to me?
echo All other choices: Go back to main menu?
echo.
set /p action_choice=Enter your choice: 
goto:eof

:no_internet_connection
echo No internet connection, displaying this information is not possible.
goto:eof