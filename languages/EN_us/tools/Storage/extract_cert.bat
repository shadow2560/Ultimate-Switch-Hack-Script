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
title Extract console Cert %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will extract the console's certificat from a PRODINFO decrypted partition file.
echo To obtain this file, you will need the Bis keys ^(Bis Key 0^) of the console that you can obtain via the Biskeydump payload.
goto:eof

:launch_biskeydump_choice
set /p biskey=Do you want to launch the Biskeydump payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:mount_emmc_choice
set /p mount_emmc=Do you want to mount the EMMC partition of the Switch? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:rcm_instructions
echo *********************************************
echo ***    Connect the Switch in RCM mode    ***
echo *********************************************
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
echo Waiting a Switch in RCM...
goto:eof

:after_rcm_instructions_choice
echo The disk should be mounted in your operating system. To unmount it, eject it via the bottom-right task bar button used to eject a device and force shut down of the Switch by maintaining "Power" button during around 15 secondes.
echo To explore the Rawnand of the Switch, you should use the software HacDiskMount launched as administrator ^(need the  biskey to decrypt the datas but not needed to dump/restaure the nand^). If you want to make a dump with this method, the dump could take some time ^(around three hours^).
echo.
echo Sometime, the disk is not reconized automaticaly. You should open the Devices Manager, find the device with an exclamation mark, right click on it, click on "Update drivers...", click on "Search automaticaly an updated driver" and click on "close" when installed. Now, the device should be usable.
set /p launch_devices_manager=Do you want to launch the Devices Manager? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:launch_hacdiskmount_choice
set /p launch_hacdiskmount=Do you want to launch HacDiskMount? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:prodinfo_file_choice
echo You will have to select the decrypted PRODINFO file from witch you want to extract the certificat.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "bin files ^(*.bin^)|*.bin|" "Select PRODINFO.bin file" "templogs\tempvar.txt"
goto:eof

:prodinfo_no_file_selected_error
echo No input file selected, the script couldn't continue.
goto:eof

:certificat_first_success
ECHO The "nx_tls_client_cert.pfx" file has been saved in the "Certificat" folder on the script root.
ECHO Pasword = switch
goto:eof

:certificat_extraction_success
ECHO The "nx_tls_client_cert.pem" file has been saved in the "Certificat" folder on the script root.
ECHO All operations completed with success!
goto:eof