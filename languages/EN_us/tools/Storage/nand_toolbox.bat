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
title Nand Toolbox %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Welcome to the Nand Toolbox.
echo.
echo Here, you can do a lot of actions on your console's nand or on an already dumped nand file.
echo IF you haven't launch the Ultimate-Switch-Hack-Script has administrator ^(Windows 8 and up^), all functions on physical drives will not be usable.
::echo.
echo note: To select a splitted dump, you only need to select it first file.
echo.
echo Be careful: The operations of this script could modify your console's nand, you are the own responsible of what you do.
goto:eof

:first_action_choice
echo Nand Toolbox
echo.
echo What do you want to do?
echo.
echo 1: Obtain  infos on a dumped file or on a nand part of the console?
echo 2: Dump the nand or a partition of the nand of a console, copy a file or extract a partition   of a dumped file?
echo 3: Restaure the nand or a partition of the nand of a console on a console or in a dumped file?
echo 4: Create an emunand on a SD?
echo 5: Enable or disable auto-RCM on a BOOT0 partition of a console or of a dumped file?
echo 6: Remove console's identification infos  from PRODINFO for a rawnand or a PRODINFO file (same function as Incognito)?
echo 7: Join a splitted dump of a rawnand, for example a dump made via Hekate on a FAT32 formated SD?
echo 8: Split a rawnand dump?
echo 9: Create a file from a complete nand dump that you can use to flash a partition on a SD for emunand?
echo 10: Extract a complete dump from an emunand partition created/dumped file?
echo 11: Decrypt a dump or a partition of a rawnand?
echo 12: Encrypt a dump or a partition of a rawnand?
echo 13: Use Ninfs to mount a rawnand dump file?
echo 14: Resize the USER partition of a RAWNAND or a FULL NAND?
echo 15: Create a BOOT0 file with keyblobs repaired ^(beta function^)?
echo 16: Brute force the bis_keys?
echo 0: Mount a console's nand partition via USB and Memloader?
echo All other choices: Go back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:nand_infos_begin
echo On what nand do you want to obtain infos?
goto:eof

:nand_choice
echo 0: Dump file?
echo No value: Go back to main choice of this script?
echo.
set /p action_choice=Make your choice: 
goto:eof

:dump_not_exist_error
echo No file selected or the number of the disk doesn't exist.
goto:eof

:biskeys_file_selection_empty_authorised
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to indicate a file containing the Bis keys to obtain more infos on the nand? ^(%lng_yes_choice%/%lng_no_choice%^): "
IF %errorlevel% EQU 2 goto:eof
IF %errorlevel% EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Select the file containing the Bis keys" "templogs\tempvar.txt"
	set /p biskeys_file_path=<"templogs\tempvar.txt"
	IF "!biskeys_file_path!"=="" (
		echo File containing Bis keys not selected, you will not obtain more infos on the nand.
		pause
	) else (
		set biskeys_param=-keyset "!biskeys_file_path!"
	)
)
goto:eof

:dump_input_begin
echo Choose the support from where the dump will be done:
goto:eof

:dump_output_folder_choice
echo You will need to select the folder where the dump will be extracted.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select output folder"
goto:eof

:dump_output_folder_empty_error
echo The folder where dump will be extracted couldn't be empty, the function will be canceled.
goto:eof

:zip_param_choice
set /p zip_param=Do you want to compress the output file in a zip file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:dump_erase_existing_file_choice
set /p erase_output_file=This folder already contain a file of this type of dump, do you realy want to continue and remove the existing file ^(if yes, the file will be removed just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Operation canceled by user.
goto:eof

:restaure_input_file_begin
echo You will have to select the dumped file from where you want to restaure, quit the file selection without selecting anything to go back to main action choice of this script.
goto:eof

:restaure_input_empty_error
echo The dumped file has not been selected, back to main action choice of this script.
goto:eof

:restaure_output_begin
echo Choose the support where you want to restaure the dump:
goto:eof

:restaure_input_dump_invalid_error
echo The input dump seems to be corupted or is not a valid dump, for security reason the script will not continue.
goto:eof

:restaure_output_dump_invalid_error
echo The output dump seems to be corupted or is not a valid dump, for security reason the script will not continue.
goto:eof

:restaure_try_partition_on_other_than_rawnand_error
echo It's not possible to restaure a specific partition  if the output nand type  is not "RAWNAND", the script couldn't continue.
goto:eof

:restaure_partitions_not_match_error
echo The partition type chosen seems to not correspond to the partition file that you want to restaure, for security reason the script will not continue.
goto:eof

:restaure_input_and_output_type_not_match_error
echo The input and output nand type doesn't correspond, the script couldn't continue.
goto:eof

:emunand_create_input_begin
echo This script can create an emunand on a SD with some nand dump files .
echo.
echo Choose the RAWNAND or  the FULLNAND to use:
goto:eof

:emunand_create_nand_type_error
echo The nand type must be RAWNAND or FULLNAND.
goto:eof

:select_boot0_file
echo You will have to select the BOOT0 file linked with your RAWNAND.
goto:eof

:emunand_create_boot1_dump_not_exist_error
echo BOOT0 file is mendatory.
goto:eof

:select_boot0_file_invalid_error
echo The file must be a  valid BOOT0 file.
goto:eof

:select_boot1_file
echo You will have to select the BOOT1 file linked with your RAWNAND.
goto:eof

:emunand_create_boot1_dump_not_exist_error
echo BOOT1 file is mendatory.
goto:eof

:select_boot1_file_invalid_error
echo The file must be a  valid BOOT1 file.
goto:eof

:emunand_create_type_choice
echo What type of emunand do you want to create?
echo 1: Partition based emunand ^(compatibility with Atmosphere and SX OS^) ^(All datas on the SD will be removed^)?
echo 2: Atmosphere files based emunand?
echo 3: SX OS files based emunand?
echo.
set /p emunand_type=Make your choice: 
goto:eof

:select_emunand_type_invalid_error
echo Bad emunand type choice.
goto:eof

:no_disk_found_error
echo No compatible disk founded.
	echo.
set /p disk_not_finded_choice=Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emunand_output_choice_intro
echo Select the disk where the emunand will be copied:
goto:eof

:emunand_output_choice
echo 0: Reload the devices list?
echo No value: back to menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:disk_not_exist_error
echo Disk selection error.
goto:eof

:emunand_create_action_error
echo Emunand creation error.
goto:eof

:emunand_create_action_success
echo Emunand creation success.
goto:eof

:autorcm_dump_choice_begin
echo On what BOOT0 partition type do you want to work?
goto:eof

:autorcm_choice
echo What do you want to do:
echo 1: Enable auto-RCM?
echo 2: Disable auto-RCM?
echo All other choices: Go back to main action choice of this script.
echo.
set /p action_choice=Make your choice: 
goto:eof

:autorcm_nand_type_must_be_boot0_error
echo The nand type must be "BOOT0", the script couldn't continue.
goto:eof

:autorcm_nand_soc_must_be_erista_error
echo The SoC type must be "Erista", the script couldn't continue.
goto:eof

:autorcm_action_error
echo An unknown error ocured during enabling/disabling auto-RCM.
echo Verify that the script is executed as administrator andif the file/device is accessible. In the case of a file, also verify that the file is not flagged as read only.
goto:eof

:autorcm_enabled_success
echo Auto-RCM enabled with success.
goto:eof

:autorcm_disabled_success
echo Auto-RCM disabled with success.
goto:eof

:decrypt_input_begin
echo Select the nand to decrypt.
goto:eof

:decrypt_rawnand_not_selected_error
echo You must select a rawnand or partition of a rawnand file type to encrypt it, the script couldn't continue.
goto:eof

:biskeys_file_not_selected_error
echo No file containing Bis keys selected, the script couldn't continue.
goto:eof

:decrypt_biskeys_not_valid_error
echo An error occured during the test of nand decryption, some of your Bis keys could be not valid.
goto:eof

:decrypt_verif_encrypted_or_not_error
echo The nand or partition selected seems to be already decrypted, the script will not continue.
goto:eof

:encrypt_input_begin
echo You will have to select the dumped file to encrypt, quit the file selection without selecting anything to go back to main action choice of this script.
goto:eof

:encrypt_input_empty_error
echo No input file selected to encrypt, the script couldn't continue.
goto:eof

:encrypt_rawnand_not_selected_error
echo You must select a rawnand or partition of a rawnand file type to encrypt it, the script couldn't continue.
goto:eof

:encrypt_verif_encrypted_or_not_error
echo The nand or partition selected seems to be already encrypted, the script will not continue.
goto:eof

:incognito_input_begin
echo Selection of the rawnand or the PRODINFO partition  where you want to aply Incognito
goto:eof

:incognito_nand_type_error
echo You couldn't apply Incognito on the nand selected, the script couldn't continue.
goto:eof

:incognito_biskeys_not_valid_error
echo Error during the test of Bis keys, the script couldn't continue.
goto:eof

:incognito_action_error
echo An error ocured during Incognito applying.
goto:eof

:incognito_action_success
echo Incognito applyed with success.
goto:eof

:incognito_prodinfo_backup_moved
IF %temp_count% EQU 0 (
	echo The PRODINFO partition backup has been moved on the "%base_folder_path_of_a_file_path%" folder and named "PRODINFO.backup".
) else (
	echo The PRODINFO partition backup has been moved on the "%base_folder_path_of_a_file_path%" folder and named "PRODINFO.backup%temp_count%".
)
goto:eof

:resize_user_part_input_begin
echo Choose a RAWNAND or a FULL NAND from where the USER partition will be resized
goto:eof

:resize_user_part_bad_input_choice
echo The  USER partition of this nand type couldn't be modified.
goto:eof

:resize_user_part_value_choice
set /p resize_user_partition_value=Define the new size of the partition in MB or leave empty to cancel ^(the value couldn't be lesser than 2000 and must be a integer^): 
goto:eof

:brute_force_input_begin
echo In fact, this function isn't usful cause it takes too much time, it's just a function that I have developed for fun. Also, the FULL DUMP are not supported.
pause
echo.
echo Choose the support from where the key brute force will be done:
goto:eof

:brute_force_output_folder_choice
echo You will need to select the folder where the key will be extracted.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select folder"
goto:eof

:brute_force_output_folder_empty_error
echo The folder where the key will be extracted couldn't be empty, the function will be canceled.
goto:eof

:brute_force_erase_existing_file_choice
set /p erase_output_file=This folder already contain a file of this type of key, do you realy want to continue and remove the existing file ^(if yes, the file will be removed just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:bad_char_error
echo Unhautorized char.
goto:eof

:resize_user_part_define_greater_size_error
echo The size of the new partition couldn't be lesser than  2000.
goto:eof

:resize_user_partition_format_choice
set /p resize_user_partition_format=Do you want to format the new USER partition? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nand_file_select_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "all files ^(*.*^)|*.*|" "Select dump file" "templogs\tempvar.txt"
goto:eof

:nand_choice_char_error
echo Unauthrised char.
goto:eof

:biskeys_file_select_choice
echo You will have to select the file containing the Bis keys to use.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "all files ^(*.*^)|*.*|" "Select the file containing the Bis keys" "templogs\tempvar.txt"
goto:eof

:partition_choice_begin
echo On what partition do you want to work?
IF NOT "%except_all%"=="Y" (
	echo 0: All the rawnand.
)
goto:eof

:partition_choice
echo Empty choice: Cancel the operation.
echo.
set /p choose_partition=Make your choice: 
goto:eof

:bad_value
echo Bad choice.
goto:eof

:force_param_choice
set /p force_option=Do you want that the   software don't ask any questions during the operation ^(FORCE mode^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:skipmd5_param_choice
set /p skip_md5=Do you want to pass the MD5 verification? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:debug_param_choice
set /p debug_option=Do you want to enable the debug infos? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:passthrough_0_option_choice
set /p passthrough_0_option=Do you want that the no assigned clusters  of the nand be replaced by zeros ^(better nand compression possibility^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nnm_split_option_choice
set /p nnm_split_option=Do you want to split the output file ^(no verification will be made if output file parts already exist, files will be erased^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nnm_split_size_option_choice
set /p nnm_split_size_option=What size in MB each splited part must be ^(300 minimum^)? ^(4096 MB if empty, enter 0 to go back to previous choice^): 
goto:eof

:nnm_split_size_option_to_small_error
echo The minimum size must be 300 MB.
goto:eof

:display_infos_nand
IF /i "%nand_type%"=="RAWNAND - splitted dump" (
	echo Nand type: RAWNAND - splitted dump
) else IF /i "%nand_type%"=="FULL NAND" (
echo Nand type: Full nand
) else IF /i "%nand_type%"=="UNKNOWN" (
	echo Unknown nand type.
) else (
	echo Nand type: %nand_type%
)
IF "%nand_sectors_interval%"=="" (
	IF /i "%nand_file_or_disk%"=="File" (
		echo Support: file
	) else IF /i "%nand_file_or_disk%"=="Disk" (
		echo Support: physical drive
	)
) else (
	IF /i "%nand_file_or_disk%"=="File" (
		echo Support: file ^(%nand_sectors_interval%^)
	) else IF /i "%nand_file_or_disk%"=="Disk" (
		echo Support: physical drive ^(%nand_sectors_interval%^)
	)
)
IF /i "%nand_encrypted:~0,3%"=="Yes" (
	echo Nand encrypted.
) else (
	echo Nand decrypted.
)
echo Size: %nand_size%
IF /i "%nand_type%"=="BOOT0" (
	IF /i "%nand_autorcm%"=="ENABLED" (
		echo Auto-RCM enabled.
	) else (
		echo Auto-RCM disabled.
	)
	IF NOT "%nand_soc_rev%"=="" (
		echo SoC revision: %nand_soc_rev%
	)
	IF NOT "%nand_bootloader_ver%"=="" (
		echo Bootloader version: %nand_bootloader_ver%
	)
	IF NOT "%nand_firmware_ver%"=="" (
		echo Firmware version: %nand_firmware_ver%
	)
)
IF /i "%nand_type%"=="RAWNAND" (
	IF NOT "%nand_serial_number%"=="" (
		echo Console serial number: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo Console Device ID: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Console MAC address: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Firmware version: !nand_firmware_ver:~0,5! or a little higher
		) else (
			echo Firmware version: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT not detected.
		) else (
			echo Driver EXFAT detected.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Last boot: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 12
	set /a temp_last_line=%begin_partition_line% + 11
	echo.
	echo Partitions informations:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, free space !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			echo !temp_partition_line_content:encrypted=encrypted!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo GPT partition table backup not finded.
	) else (
		echo GPT partition table backup finded: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="RAWNAND - splitted dump" (
	IF NOT "%nand_serial_number%"=="" (
		echo Console serial number: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo Console Device ID: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Console MAC address: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Firmware version: !nand_firmware_ver:~0,5! or a little higher
		) else (
			echo Firmware version: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT not detected.
		) else (
			echo Driver EXFAT detected.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Last boot: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 11
	echo.
	echo Partitions informations:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, free space !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			echo !temp_partition_line_content:encrypted=encrypted!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo GPT partition table backup not finded.
	) else (
		echo GPT partition table backup finded: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="FULL NAND" (
	IF /i "%nand_autorcm%"=="ENABLED" (
		echo Auto-RCM enabled.
	) else (
		echo Auto-RCM disabled.
	)
	IF NOT "%nand_soc_rev%"=="" (
		echo SoC revision: %nand_soc_rev%
	)
	IF NOT "%nand_bootloader_ver%"=="" (
		echo Bootloader version: %nand_bootloader_ver%
	)
	IF NOT "%nand_serial_number%"=="" (
		echo Console serial number: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo Console Device ID: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Console MAC address: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Firmware version: !nand_firmware_ver:~0,5! or a little higher
		) else (
			echo Firmware version: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT not detected.
		) else (
			echo Driver EXFAT detected.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Last boot: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 11
	echo.
	echo Partitions informations:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, free space !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			echo !temp_partition_line_content:encrypted=encrypted!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo GPT partition table backup not finded.
	) else (
		echo GPT partition table backup finded: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="PRODINFO" (
	IF NOT "%nand_serial_number%"=="" (
		echo Console serial number: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo Console Device ID: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Console MAC address: %nand_mac_address%
	)
)
IF /i "%nand_type%"=="SYSTEM" (
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Firmware version: !nand_firmware_ver:~0,5! or a little higher
		) else (
			echo Firmware version: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT not detected.
		) else (
			echo Driver EXFAT detected.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Last boot: %nand_last_boot%
	)
)
goto:eof