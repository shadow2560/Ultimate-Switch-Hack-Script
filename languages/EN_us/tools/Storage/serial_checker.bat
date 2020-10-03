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
title Fusee Gelee compatible serial consoles verification %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will verify the serial number of a console to tell if it is compatible with the Fusee Gelee exploit.
echo.
echo If you encounter a false data in the beta database, please inform me of it with the ten first chars of the serial and the result of your test.
echo It is important to also report serials that is "probably patched", this will help to have a more precise database.
echo.
echo Big thank to AkdM from logic-sunrise for the python script that is used by this script and thanks to those who contribute to the database.
echo.
echo It is recommanded to have an internet connection to update the serials database.
goto:eof

:begin_update_database
echo Updating database...
goto:eof

:no_database_and_no_internet_connection_error
echo No internet connection and no database installed, the script couldn't continue.
goto:eof

:no_internet_connection_info
echo No internet connection to update the database, the script will continue with actual database.
goto:eof

:database_choice
echo Database choice to download:
echo.
echo 1: Classic database, less precise but more exact?
echo 2: Beta database, more precise but maybe with more errors?
echo 0: Go back to previous menu?
echo All other choices: Don't download database and use the last used version?
echo.
set /p database_choice=Make your choice: 
	goto:eof

:update_database_success
echo Database update success.
goto:eof

:serial_choice
echo What do you want to do?
echo.
echo 0: End this script and go back to previous menu.
echo 1: Open the page where you can tell me about an error about this script (french language only).
echo 2: Change database ^(need an internet connection^)?
echo.
set /p console_serial=Enter a serial  number or choose an action: 
goto:eof

:serial_empty_error
echo This choice couldn't be empty.
goto:eof

:serial_patched
echo The console %console_serial% is patched.
goto:eof

:serial_warning
echo The console %console_serial% is maybe patched.
goto:eof

:serial_safe
echo The console %console_serial% is not patched.
goto:eof

:serial_bad_value
echo The serial number entered is not valid.
goto:eof

:serial_error
echo An unknown error occured.
goto:eof