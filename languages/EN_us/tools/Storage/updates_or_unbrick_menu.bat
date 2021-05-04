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
title Updates or unbrick  menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Updates or unbrick menu
echo.
echo Be careful: Don't use any of these functions on a console equiped with SX Core/SX Lite modchip cause this will brick your console and also, don't use ChoiDuJour-NX on these consoles.
echo.
echo What do you want to do?
echo.
echo 1: Prepare a SD with update that could be used with ChoiDuJourNX or Daybreak and/or prepare a ChoiDuJour package; firmware will be downloaded with internet?
echo 2: Unbrick a console ^(beta function for patched/Mariko consoles^)?
echo 3: Create an update package via ChoiDuJour?
echo 4: Create a BOOT0 file with keyblobs repaired?
echo 5: Unbrick PRODINFO ^(beta function^)?
echo 6: Create an update package via EmmcHaccGen ^(beta function for Mariko consoles^)?
echo 7: Create the Atmosphere's sig_patches?
echo 0: Obtain assistance with unbricking?
echo.
echo All other choices: Exit?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof