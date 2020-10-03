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
title Atmosphere's emummc profiles management %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo Atmosphere's emummc profiles management
echo.
echo What do you want to do?
echo.
echo 1: Create a profile?
echo 2: Modify a profile?
echo 3: Remove a profile?
echo 0: Display profile's emummc configuration?
echo All other choices: Go back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:intro_info_profile
echo Profile infos
goto:eof

:info_no_profile_exist_error
echo No profile created, you need to create one to obtain infos on it.
goto:eof

:info_profile
echo Profile name: %profile_selected:~0,-4%
goto:eof

:intro_create_profile
echo Creating a profile
echo.
set /p new_profile_name=Enter the profile's name, leave empty to cancel this operation: 
goto:eof

:char_error_in_profile_name
echo Unauthorised char in profile's name.
goto:eof

:create_profile_success
echo Profile "%new_profile_name%" creation success.
goto:eof

:intro_modify_profile
echo Profile modifying
goto:eof

:modify_no_profile_exist_error
echo No profile created, you need to create one to modify it.
goto:eof

:intro_delete_profile
echo Profile removing
goto:eof

:delete_no_profile_exist_error
echo No profile created, you need to create one to remove it.
goto:eof

:delete_profile_finded_in_general_profile
echo This profile is used in the following general profiles:
goto:eof

:delete_profile_finded_in_general_profile2
set /p define_del_profile=Remove this profile will remove the associed general profiles, do you want to countinue? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:delete_profile_success
echo Profile "%profile_selected:~0,-4%" remove success.
goto:eof

:intro_select_profile
echo Select a profile:
goto:eof

:select_profile_choice
echo All other choices: Go back to previous action.
echo.
set /p profile_choice=Make your choice: 
goto:eof

:display_emummc_config_parsed
IF /i "%emunand_enable%"=="o" (
	echo Emunand enabled with these settings:
	IF "%emummc_id%"=="" (
		echo Default emunand ID.
	) else (
		echo Emunand ID: %emummc_id%
	)
	IF "%emummc_title%"=="" (
		echo Default emunand title.
	) else (
		echo Emunand title: %emummc_title%
	)
	IF "%emummc_sector%"=="" (
		echo No boot sector configured.
	) else (
		echo Emunand boot sector: %emummc_sector%
	)
	IF "%emummc_path%"=="" (
		echo No path to nand files defined.
	) else (
		echo Path to nand files: %emummc_path%
	)
	IF "%emummc_nintendo_path%"=="" (
		echo Default emunand nintendo path.
	) else (
		echo Emunand nintendo path: %emummc_nintendo_path%
	)
) else (
	echo Emunand disabled.
)
goto:eof

:emummc_config_enable_choice
echo Emunand configuration
echo.
set /p "emunand_enable=Do you want to enable emunand? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:canceled
echo Operation canceled.
goto:eof

:emummc_id_choice
set /p emummc_id=Set the emunand ID ^(leave empty to use the default ID^) ^(dont't write the begining 0x^) ^(4 chars max^): 
goto:eof

:emummc_id_size_error
echo The emunand ID must contain 4 chars max.
goto:eof

:emummc_id_char_error
echo Unauthorised char in emunand ID.
goto:eof

:emummc_title_choice
set /p emummc_title=Set the emunand title ^(leave empty to use the default title^): 
goto:eof

:emummc_sector_choice
set /p emummc_sector=Set the sector of the partition to boot the emunand ^(if emunand via files, leave this value empty^) ^(don't write the begining 0x^): 
goto:eof

:emummc_sector_char_error
echo Unauthorised char in emunand boot sector.
goto:eof

:emummc_path_choice
set /p emummc_path=Set the path to the files that boot the emunand ^(if left empty, the emunand will be disabled^): 
goto:eof

:emummc_no_sector_or_path_error
echo No boot sector or path to files defined, the emunand will be disabled.
goto:eof

:emummc_nintendo_path_choice
set /p emummc_nintendo_path=Set the emunand nintendo path ^(leave empty to use the default path^): 
goto:eof

:emummc_config_success
echo Config of the emunand saved with success in the  profile "%profile_selected:~0,-4%".
goto:eof