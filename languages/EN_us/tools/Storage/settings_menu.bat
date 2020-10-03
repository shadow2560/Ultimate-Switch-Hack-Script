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
title Settings menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Settings menu
echo.
echo What do you want to do?
echo.
echo 1: Save the importants files of the script?
echo.
echo 2: Restaure the importants files of the script?
echo.
echo 3: Totaly reset the script?
echo.
echo 4: Reset the auto-update setting of the script?
echo.
echo 5: Reset the personal list of the software toolbox  ^(this will also remove the softwares in the "tools\toolbox"^ folder)?
echo.
echo 6: Reset  the Switch-Lan-Play server list?
echo.
echo 7: remove the keys file used by NSC_Builder?
echo.
echo 8: Remove the keys files used by Hactool, XCI-Explorer, ChoiDuJour...?
echo.
echo 9: Configure the main profiles used in SD preparation?
echo.
echo 10: configure  the homebrews profiles used in the SD preparation?
echo.
echo 11: Configure the cheats profiles used in SD preparation?
echo.
echo 12: configure the emulators profiles used in SD preparation?
echo.
echo 13: configure the modules profiles used in SD preparation?
echo.
echo 14: configure the overlays profiles used in SD preparation?
echo.
echo 15: configure the Atmosphere's emummc profiles used in SD preparation?
echo.
echo All other choices: Go back to main menu?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof

:auto_update_reset_success
echo Auto-update setting reset  success.
goto:eof

:toolbox_reset_success
echo Software toolbox personnal list reset success.
goto:eof

:switchlanplay_reset_success
echo Switch-Lan-Play server list reset success.
goto:eof

:nscbuilder_keys_file_reset_success
echo Keys file for NSC_Builder removed.
goto:eof

:hactool_keys_file_reset_success
echo Keys files for tools based  on Hactool removed.
goto:eof