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
title Launch Ns-usbloader %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:java_error
echo Java is not installed, verify your internet connection  and relaunch the script.
goto:eof

:intro
echo This script will just launch Ns-usbloader, a software witch can install content on the Switch via NSA-Installer, Awoo-Installer, Tinleaf or Goldleaf.
echo.
echo By using this program, you accept the license to use Java for personal, non-commercial use of the product.
echo.
echo 0: Display the Java's license?
echo 1: Decline  the Java's license and go back to menu?
echo All other choices: Accept the Java's license and use Ns-usbloader?
echo.
set /p action_choice=Make your choice: 
goto:eof