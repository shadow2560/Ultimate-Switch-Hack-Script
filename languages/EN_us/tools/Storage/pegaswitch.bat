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
title PegaScape/PegaSwitch %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will do all actions linked to Caffeine and Nereba exploit, or more exactly it could launch a local PegaScape/PegaSwitch server and prepare the SD with necessary files.
echo To prepare a SD with a CFW, you should prepare a SD with the appropriated script, this will be proposed during the script.
goto:eof

:first_action_choice
echo What do you want to do?
echo 1: Prepare the SD for exploits.
echo 2: Launch Pegaswitch or PegaScape server.
echo 3: Prepare the SD for the exploits and launch Pegaswitch or PegaScape server.
echo 0: Launch the prepare SD script to prepare, for example, a CFW on it.
echo All other choices: Go back to previous menu.
echo.
set /p nereba_choice=Make your choice: 
goto:eof

:no_disk_found_error
echo No compatible disk found. Please insert a compatible disk.
echo.
set /p disk_not_finded_choice=Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Disks list:
goto:eof

:disk_choice
set /p volume_letter=Enter the volume letter that you want to use or enter "0" to cancel the operation: 
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

:disk_choice_not_in_list_error
echo This volume letter is not in the list.
goto:eof

:payload_choice_begin
echo Select the payload that will be launched by the Caffeine/Nereba exploits:
goto:eof

:payload_choice
echo 0: Choose a payload file
echo All other choices: Cancel the operation.
echo.
set /p payload_number=Make your choice: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Switch payload files ^(*.bin^)|*.bin|" "Select payload file" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo No payload selected, back to payload selection.
goto:eof

:payload_for_pegascape_official_choice
set /p integrate_pegascape_official=Do you want also to use the payload with the official version of  PegaScape ^(will replace the "reboot_payload.bin" file of the "atmosphere" folder on the SD by the chosen payload^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:end_prepare_sd
echo SD preparation success.
goto:eof

:server_choice
echo What server do you want to use?
echo
echo 1: PegaScape ^(recommanded^)?
echo 2: PegaSwitch?
echo All other choices: Go back to principal action choice of this script.
echo.
set /p pegaswitch_server_type=Make your choice: 
goto:eof

:server_launch_mode_choice
echo How do you want to use PegaSwitch/PegaScape?
echo.
echo 1: Via the wifi test connection ^(2.0.0 and upper firmwares^)?
echo 2: Via the webapplet ^(1.0.0 firmware and and jap version of Puyo Puyo Tetris or you use the entry point Fake News^)?
echo All other choices: Go back to principal action choice of this script.
echo.
set /p pegaswitch_launch_mode=Make your choice: 
goto:eof

:begin_launch_server
echo You will need to know your PC IP address and copy it in your Switch for DNS servers.
echo The Switch and the PC must be on the same network.
echo.
echo Preparing and launching server...
goto:eof

:end_launch_server
echo The server should be launched. To close it, just enter "exit" without the quotes on the server window.
goto:eof