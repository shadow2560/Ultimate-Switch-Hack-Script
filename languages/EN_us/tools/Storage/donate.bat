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
title Donate %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:action_choice
echo Thanks in advance for your donation.
echo.
echo How do you want to do the donation:
echo 1: Credit card ^(open my Paypal page^)?
echo 2: Crypto-money?
echo 3: Obtain assistance with unbricking?
echo All other choices: Go back to previous menu.
echo.
set /p action_choice=Make your choice: 
goto:eof