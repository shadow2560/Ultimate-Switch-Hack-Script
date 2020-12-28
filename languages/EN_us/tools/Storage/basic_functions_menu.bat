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
title Basic functions menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Basic functions menu
echo.
echo What do you want to do?
echo.
echo 1: Launch a payload via the RCM mode?
echo.
echo 2: Launch a payload with PegaScape/PegaSwitch or prepare the SD with the necessary files?
echo.
echo 3: Install the drivers?
echo.
echo 4: Prepare a SD card for the hack?
echo.
echo 5: Verify if a Switch serial is patched or not?
echo.
echo 6: Verify a keys file?
echo.
echo 7: Mount the nand, the boot0 partition, the boot1 partition or the SD card like an HDD on your OS?
echo.
echo 8: Launch Ns-usbloader to install content via NSA-Installer or Goldleaf on your Switch?
echo.
echo 9: Modchips management?
echo.
echo All other choices: Go back to main menu?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof