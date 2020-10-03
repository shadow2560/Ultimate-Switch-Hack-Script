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
title Modchips management %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will help you to make some action on modchips or for some dongles UF2, based particularly  on Switchboot project but not only.
goto:eof

:main_action_choice
echo Modchips management
echo.
echo What do you want to do:
echo.
echo 1: Switch the modchip in  UF2 mod using a payload ^(you will have to press twice the   "reset" buton of the modchip after the payload launch^)?
echo 2: Launch the Switchboot payload?
echo 3: Flash an UF2 file on a modchip or on some dongles?
echo 4: Flash Switchboot on a modchip or for some dongles?
echo 5: Prepare the base files on the SD for Switchboot?
echo 6: Organize the payloads on the SD for Switchboot?
echo 7: Flash a SX Core or SX Lite modchip?
echo 0: Go to the  Gbatemp subject of Switchboot?
echo All other choices: Go back to previous menu.
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof

:select_uf2_file
echo You will have to select an UF2 file to copy.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "uf2 file ^(*.uf2^)|*.uf2|" "Select UF2 file" "templogs\tempvar.txt"
goto:eof

:uf2_file_empty_error
echo No UF2 file selected, back to the main actions of this script.
goto:eof

:select_uf2_device
echo you will have to select an UF2 device.
pause
goto:eof

:select_modchip_device
echo Select the modchip or the dongle to flash:
echo.
echo 1: Feather M0 Express modchip?
echo 2: Gemma M0 modchip?
echo 3: Itsybitsy M0 modchip?
echo 4: RCM-X86 modchip?
echo 5: Rebug SwitchME modchip?
echo 6: Trinket M0 modchip?
echo 7: Generic Gemma dongle?
echo 8: Generic Trinket dongle?
echo 9: RCMX86 dongle?
echo All other choices: Go back to main actions choice of this script.
echo.
echo.
set /p modchip_choice=Make your choice: 
goto:eof

:switchboot_part1_type
echo How the modchip will work ^(Switchboot part1)?
echo 1: Perma-CFW?
echo 2: Dual boot?
echo All other choices: Go back to main actions choice of this script.
echo.
echo.
set /p switchboot_part1_type=Make your choice: 
goto:eof

:switchboot_part2_type
echo How the modchip will work ^(Switchboot part2)?
echo 1: Launch a payload "payload.bin" witch is on the SD root?
echo 2: Launch Switchboot?
echo All other choices: Go back to main actions choice of this script.
echo.
echo.
set /p switchboot_part2_type=Make your choice: 
goto:eof

:select_uf2_device_again
echo Again, you will have to select an UF2 device for the second part flash process.
pause
goto:eof

:switchboot_flash_end
echo Flash of the modchip or of the dongle with Switchboot finished.
goto:eof

:select_sd_device
echo You will have to select the SD cartd where the files will be copied.
pause
goto:eof

:copy_base_switchboot_on_sd_finished
echo Copy of Switchboot base files on the SD finished.
goto:eof

:select_switchboot_payload_number
set /p switchboot_payload_number=Enter a number for the payload that will be copied ^(1 to 8, leave empty to go back to the main actions of this script^): 
goto:eof

:switchboot_payload_number_select_error
echo An error has been detected in the payload number choice for Switchboot.
goto:eof

:select_if_payload_1_is_unic
set /p payload1_is_unic=This payload will be the only one witch will be launched by the modchip? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:manage_payloads_switchboot_finished
echo The payload has been copied on the SD with the selected params.
goto:eof

:begin_payload_choice
echo Choose a payload: 
goto:eof

:end_payload_choice
echo 0: Choose a payload file.
echo All other choices: Go back to main actions choice of this script.
echo.
set /p payload_number=Make your choice: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Payload Switch file ^(*.bin^)|*.bin|" "Payload file select" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo No payload selected, back to the select payload choice.
goto:eof

:sx_flasher_launch_intro
echo This allows you to flash an SX Core or SX Lite modchip.
echo To do this, you need to connect your console via USB..
echo In the program that will launch, choose a firmware then click on the "Update" button.
echo You can find the available firmwares in the "tools\SX_Core_Lite\firmwares" folder from the root of this script.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to launch the program to flash your modchip? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:no_compatible_disk_found_error
echo No compatible disk found. Please insert a compatible disk and relaunch the script.
goto:eof

:disk_list_begin
echo Disks list:
goto:eof

:disk_list_choice
echo 0: Go back to the main actions of this script.
echo.
echo.
set /p volume_letter=Enter the volume letter that you want to use: 
goto:eof

:disk_choice_empty_error
echo The volume letter couldn't be empty.
goto:eof

:disk_choice_char_error
echo Unauthorised char in volume letter.
goto:eof

:disk_choice_not_exist_error
echo This volume doesn't exist.
goto:eof

:disk_choice_letter_not_exist_error
echo This volume letter is not in the list.
goto:eof

:reset_uf2_device_to_flash
echo Press the  "reset" button of the modchip to flash the UF2 file.
pause
goto:eof