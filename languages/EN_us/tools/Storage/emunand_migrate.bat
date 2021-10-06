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
title Migrate emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allow to migrate an emunand from SXOS to Atmosphere.
goto:eof

:no_disk_found_error
echo No compatible disk found, please insert your drive.
echo.
set /p disk_not_finded_choice=Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Disk list:
goto:eof

:disk_list_choice
echo 0: Go back to principal action of this script.
echo.
echo.
set /p volume_letter=Enter the volume letter that you want to use: 
goto:eof

:disk_choice_empty_error
echo The volue letter couldn't be empty.
goto:eof

:disk_choice_char_error
echo Unauthorised char in volume letter.
goto:eof

:disk_choice_not_exist_error
echo This volume doesn't exist.
goto:eof

:disk_choice_letter_not_exist_error
echo This volume letter isn't in the list.
goto:eof

:emunands_sumary
echo Sumary of emunands founded:
echo.
IF "%sxos_emunand_files_exist%"=="1" (
	echo Emunand via files for SXOS found.
)
IF "%sxos_emunand_partition_exist%"=="1" (
	echo Emunand via partition for SXOS found.
)
IF "%atmo_emunand_exist%"=="1" (
	IF "%atmo_emunand_type%"=="files" (
		echo Emunand via files for Atmosphere.
	) else IF "%atmo_emunand_type%"=="partition" (
		echo Emunand via partition for Atmosphere.
	) else IF "%atmo_emunand_type%"=="sxos_partition" (
		echo Emunand via partition for Atmosphere compatible with SXOS.
	)
	echo Informations on the settings of the emunand for Atmosphere:
	IF NOT "%atmo_emunand_enabled%"=="" (
		IF "%atmo_emunand_enabled%"=="1" (
			echo Emunand enabled.
		) else (
			echo Emunand disabled.
		)
	)
	IF NOT "%atmo_emunand_id%"=="" (
		echo Emunand ID: %atmo_emunand_id%
	)
	IF NOT "%atmo_emunand_sector%"=="" (
		echo Starting sector of the emunand: %atmo_emunand_sector%
	)
	IF NOT "%atmo_emunand_path%"=="" (
		echo Path of the "eMMC" folder containing the emunand files: %atmo_emunand_path%
	)
	IF NOT "%atmo_emunand_nintendo_path%"=="" (
		echo Path of the emulated nintendo folder associated with the emunand: %atmo_emunand_nintendo_path%
	)
)
goto:eof

:set_action_choice
echo What do you want to do:
echo 1: Make the emunand via partition of SXOS also compatible with Atmosphere?
echo 2: Migrate the emunand via files of SXOS to an emunand via files for Atmosphere?
echo 3: Migrate the emunand via files of Atmosphere to an emunand via files for SXOS?
echo All other choices: Back to previous menu.
echo.
set /p action_choice=Make your choice: 
goto:eof

:sxos_partition_emunand_not_exist
echo No SXOS emunand  via partition found.
goto:eof

:atmo_emunand_already_exists
echo An emunand for Atmosphere already exists.
goto:eof

:succesful_migration
echo Migration succesfuly done.
goto:eof

:sxos_files_emunand_not_exist
echo No SXOS emunand via files found.
goto:eof

:atmo_emunand_not_files_type
echo The emunand for Atmosphere isn't an emunand via files.
goto:eof

:sxos_emunand_files_already_exists
echo An emunand via files for SXOS already exists.
goto:eof