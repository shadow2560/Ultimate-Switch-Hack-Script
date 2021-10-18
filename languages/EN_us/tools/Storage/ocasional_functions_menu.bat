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
title Ocasionnal functions menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Ocasionnal functions menu
echo.
echo What do you want to do?
echo.
echo 1: Get the Bis keys in a text file via RCM mode?
echo.
echo 2: Decrypt the partial keys for Mariko consoles?
echo.
echo 3: Use the Hid-mitm Compagnon software?
echo.
echo 4: Launch the emuGUIibo software?
echo.
echo 5: Extract gamesaves?
echo.
echo 6: Launch Linux ^(obsolete function^)?
echo.
echo 7: Update Shofel2 ^(obsolete function^)?
echo.
echo All other choices: Go back to main menu?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof