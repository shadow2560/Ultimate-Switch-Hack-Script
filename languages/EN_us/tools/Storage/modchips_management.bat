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
echo 7: Flash Fusee_Suite on a modchip?
echo 5: Organize the payloads on the SD for Switchboot or Fusee_Suite?
echo 6: Flash a SX Core or SX Lite modchip?
echo 7: Flash Switchboot on a modchip or on some dongles?
echo 8: Prepare the base files on the SD for Switchboot?
echo 0: Go to the  Gbatemp subject of Fusee_Suite?
echo 00: Go to the  Gbatemp subject of Switchboot?
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
IF "%~2"=="fusee_suite" goto:skip_dongle_choice
echo 7: Generic Gemma dongle?
echo 8: Generic Trinket dongle?
echo 9: RCMX86 dongle?
:skip_dongle_choice
echo All other choices: Go back to main actions choice of this script?
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
echo To do this, you need to connect your console via USB.
echo.
echo What do you want to do:
echo.
echo 1: Use SX_Flasher to flash an opfficial firmware?
echo 2: Flash Spacecraft?
echo 3: Flash SXOS bootloader?
echo 4: Flash SXOS firrmware?
echo 5: Flash Spacecraft bootloader?
echo 6: Flash Spacecraft firrmware?
echo 7: Verify the Spacecraft firmware in a BOOT0 file dumped on a console?
echo 8: Flash the Spacecraft firmware via the SD ^(Spacecraft should be installed on the modchip, function not stable, is not compatible with all modchips so prefer to use this on SX Core/Lite chips^)?
echo 9: Flash the firmware witch repair the USB debug problem on some modchips for Oled consoles?
echo All other choices: Go back to main actions choice of this script?
echo.
set /p sx_core_lite_action_choice=Make your choice: 
goto:eof

:sx_flasher_launch_infos
echo In the program that will launch, choose a firmware then click on the "Update" button.
echo You can find the available firmwares in the "tools\SX_Core_Lite\firmwares" folder from the root of this script.
goto:eof

:spacecraft_begin_flash
echo Modship flashing with Spacecraft...
goto:eof

:spacecraft_error_flash
echo Error during the modship flash  with Spacecraft.
goto:eof

:spacecraft_end_flash
echo Modship flash with Spacecraft success.
goto:eof

:sx_bootloader_begin_flash
echo Modship flashing with SXOS bootloader...
goto:eof

:sx_bootloader_error_flash
echo Error during the modship flash  with SXOS bootloader.
goto:eof

:sx_bootloader_end_flash
echo Modship flash with SXOS bootloader success.
goto:eof

:sx_firmware_begin_flash
echo Modship flashing with SXOS firmware...
goto:eof

:sx_firmware_error_flash
echo Error during the modship flash  with SXOS firmware.
goto:eof

:sx_firmware_end_flash
echo Modship flash with SXOS firmware success.
goto:eof

:spacecraft_bootloader_begin_flash
echo Modship flashing with Spacecraft bootloader...
goto:eof

:spacecraft_bootloader_error_flash
echo Error during the modship flash  with Spacecraft bootloader.
goto:eof

:spacecraft_bootloader_end_flash
echo Modship flash with Spacecraft bootloader success.
goto:eof

:spacecraft_firmware_begin_flash
echo Modship flashing with Spacecraft firmware...
goto:eof

:spacecraft_firmware_error_flash
echo Error during the modship flash  with Spacecraft firmware.
goto:eof

:spacecraft_firmware_end_flash
echo Modship flash with Spacecraft firmware success.
goto:eof

:flash_spacecraft_sd_instructions
echo Now you just have to boot the console with the SD and the Spacecraft firmware should update.
echo If you have some problems, reflash the modchip via the USB or an other method.
goto:eof

:repair_usb_debug_firmware_begin_flash
echo Modship flashing with USB debug reparation firmware...
goto:eof

:repair_usb_debug_firmware_error_flash
echo Error during the modship flash  with USB debug reparation firmware.
goto:eof

:repair_usb_debug_firmware_end_flash
echo Modship flash with USB debug reparation firmware success.
goto:eof

:select_boot0_file
echo Verification of the Spacecraft version in a BOOT0 file
echo.
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "BOOT0 file select" "templogs\tempvar.txt"
goto:eof

:boot0_file_empty_error
echo No BOOT0 file selected.
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