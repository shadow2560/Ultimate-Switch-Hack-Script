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
title SXOS licence spoof %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to create a "boot.dat" file with a spoof for a license.
echo.
echo You must have the fingerprint and the "license.dat" file associed of a console or the "license_request.dat" file of the targeted console. Also, a method without needed any of these thing is possible and recommanded.
echo.
echo To find the console fingerprint, start SXOS and go to "album" to display the SXOS menu, then press "R" once and you will find the "console fingerprint" under the license number.
echo To generate the "license_request.dat" file, launch SXOS without a license on the targeted console and click on "Launch CFW" and a message indicating that the file has been created should appear.
goto:eof

:license_request_file_path_selection
	echo Select the license_request file of the targeted console.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier dat^(*.dat^)|*.dat|" "Select the license_request file" "templogs\tempvar.txt"
goto:eof

:no_license_request_file_selected_error
echo No license_request file selected, the script will stop.
goto:eof

:fingerprint_set
set /p fingerprint=Enter the fingerprint of the console to spoof ^(32 hexadecimal characters^) ^(leave empty to create a pre-configured licence or enter "0" to exit the script^): 
goto:eof

:fingerprint_error_number_chars
echo The number of characters entered must be 32.
goto:eof

:fingerprint_error_char_not_authorized
echo A character entered is incorrect.
goto:eof

:outdir_folder_select
echo You will have to select the directory in which to create the files.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Files output folder selection"
goto:eof

:autoboot_parram_choice
set /p autoboot=Disable SXOS autoboot? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:emunand_sd_file_param_choice
set /p emunand_sd_file=Files based emunand? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:boot_creation_success
echo File^(s^) successfully created.
goto:eof

:boot_creation_error
echo Error during the process.
goto:eof