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
title BOOT0 keyblobs repair %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to rebuild a BOOT0 file in case of errors on key_blob_XX dump with Lockpick-RCM.
echo.
echo Warning, before flashing such a file, please first dump your current BOOT0 file and try to restore the console using a package created via ChoiDuJour.
echo Also note that in firmware 6.1.0 or lower, official boot will not work and the console will remain on a black screen, booting will only be possible in CFW. However, in firmware higher than 6.1.0, official boot will be possible again.
echo.
echo You will need the console key file dumped via Lockpick-RCM as well as a BOOT0 file of the same firmware that is currently installed on your console ^(BOOT0 file created via ChoiDuJour or dumped from your console^).
goto:eof

:boot0_input_file_select_choice
echo Select the BOOT0 file witch will be used as a base to reconstruct the file.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "BOOT0 file select" "templogs\tempvar.txt"
goto:eof

:boot0_input_file_empty_error
echo The BOOT0 file used as a base cannot be empty, the script will stop.
goto:eof

:nand_type_must_be_boot0_error
echo The dump type must be BOOT0, the process cannot continue.
goto:eof

:nand_soc_must_be_erista_error
echo The SoC type must be "Erista", the script couldn't continue.
goto:eof

:prod_keys_file_select_choice
echo Select the file containing the keys dumped on the console via Lockpick-RCM.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Console\'s keys file select" "templogs\tempvar.txt"
goto:eof

:prod_keys_file_empty_error
echo The key file cannot be empty, the script will stop.
goto:eof

:output_folder_choice
echo You will need to select the folder where to create the reconstructed BOOT0 file.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Folder select"
goto:eof

:output_folder_empty_error
echo The directory where to create the rebuilt BOOT0 file cannot be empty, the function will be cancelled.
goto:eof

:erase_existing_file_choice
set /p erase_output_file=This folder already contains a "%boot0_output_file%", file, do you really want to continue overwriting the existing file ^(if so, the file will be deleted just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:create_boot0_first_error
echo An error occurred during the creation of the reconstructed BOOT0 file.
echo.
echo If you have a keys file containing the necessary common keys ^(a file retrieved via a functional console for example^) you can try to fill it in.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to use a complementary keys file? ^(%lng_yes_choice%/%lng_no_choice%^): "
if !errorlevel! EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Selection of the complementary keys file" "templogs\tempvar.txt"
)
goto:eof

:create_boot0_error
echo An error occurred during the creation of the reconstructed BOOT0 file.
echo.
echo This error may mean that some keys are missing from your key file, so please check it before trying this unbricking procedure again.
echo.
echo Common keys needed, can be found quite easily on the internet:
echo keyblob_00 to keyblob_05, keyblob_key_source_00 to keyblob_key_source_05, keyblob_mac_key_source
echo.
echo Unique keys to the console required:
echo secure_boot_key, tsec_key, 
echo.
echo Unique keys to the console optional, at least one of the two groups required but both would obviously be better:
echo keyblob_key_00 to keyblob_key_05, keyblob_mac_key_00 to keyblob_mac_key_05
echo.
goto:eof

:create_boot0_success
echo Creation of the reconstructed BOOT0 file successfully completed.
goto:eof