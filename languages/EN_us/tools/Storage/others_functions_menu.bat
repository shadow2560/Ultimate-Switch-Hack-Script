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
title Other functions menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Other functions menu
echo.
echo What do you want to do?
echo.
echo 1: Convert a XCI or NCA file in NSP?
echo.
echo 2: Convert a NSP to try to make it compatible with the lowest possible firmware?
echo.
echo 3: Install NSPs via the network and Goldleaf?
echo.
echo 4: Install NSPs via USB and Goldleaf ^(doesn't work with latest Goldleaf's version^)?
echo.
echo 5: Convert a Zelda Breath Of The Wild gamesave from Switch to Wii U or Wii U to Switch?
echo.
echo 6: Extract the certificat of a device?
echo.
echo 7: Verify NSP files?
echo.
echo 8: Split NSPs/XCIs?
echo.
echo 9: Merge a XCI/NSP splited?
echo.
echo 10: Configure the emulator Nes Classic Edition?
echo.
echo 11: Configure the emulator Snes Classic Edition?
echo.
echo 12: Install Android APPS ^(USB debugging  MODE REQUIRED^)?
echo.
echo 13: Modchips management?
echo.
echo All other choices: Go back to main menu?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof