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
title Launch HID-mitm_compagnon %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
ECHO ////////////////////// hid_mitm ^(starting script by Krank, modified by Shadow256^) //////////////////////
ECHO.
ECHO Working dir: %cd%
goto:eof

:ip_choice
set /p IP_Adress=Enter IP adress of your Switch or leave it empty to go back to previous menu: 
goto:eof