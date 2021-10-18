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
title Main menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Main menu
echo.
echo What do you want to do?
echo.
echo 1: Basic functions ^(launch a payload, prepare the SD, verify infos, etc...^)?
echo.
echo 2: Updates or unbrick the Switch?
echo.
echo 3: Nand toolbox?
echo.
echo 4: Launch NSC_Builder witch could display infos, to convert NSPs/XCIs, see the documentation for more infos?
echo.
echo 5: Launch or configure the software toolbox?
echo.
echo 6: Other functions?
echo.
echo 7: Ocasionnal functions?
echo.
echo 8: Save/restaure and script's settings?
echo.
echo 9: Launch or configure the network gaming client ^(Switch-Lan-Play client^)?
echo.
echo 10: Launch a network gaming server ^(Switch-Lan-Play server^)?
echo.
echo 11: Allow the remote control of this computer via NVDA and Nvdaremote?
echo.
echo 12: change language?
echo.
echo 13: About the script?
echo.
echo 14: Donate to me?
echo.
echo 0: Launch the documentation ^(recommanded^)?
echo.
echo All other choices: exit?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof