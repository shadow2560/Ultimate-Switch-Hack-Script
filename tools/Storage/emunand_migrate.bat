::script by shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%ushs_base_path%=!
	set associed_language_script=%ushs_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	endlocal
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
cls
call "%associed_language_script%" "intro"
pause
:define_volume_letter
set volume_letter=
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
set disk_not_finded_choice=
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "disk_not_finded_choice" "o/n_choice"
	IF /i "!disk_not_finded_choice!"=="o" (
		goto:define_volume_letter
	) else (
		goto:end_script_2
	)
)
echo. 
call "%associed_language_script%" "disk_list_begin"
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1 
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
call "%associed_language_script%" "disk_list_choice"
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	call "%associed_language_script%" "disk_choice_empty_error"
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:end_script2
set nb=1
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat volume_letter
set i=0
:check_chars_volume_letter
IF %i% LSS %nb% (
	set check_chars_volume_letter=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		IF "!volume_letter:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_volume_letter=1
			goto:check_chars_volume_letter
		)
	)
	IF "!check_chars_volume_letter!"=="0" (
		call "%associed_language_script%" "disk_choice_char_error"
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	call "%associed_language_script%" "disk_choice_not_exist_error"
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	call "%associed_language_script%" "disk_choice_letter_not_exist_error"
	goto:define_volume_letter
)
:sd_emunand_test
set sxos_emunand_folder_path=%volume_letter%:\sxos\emunand
set sxos_emunand_boot0_path=%sxos_emunand_folder_path%\boot0.bin
set sxos_emunand_boot1_path=%sxos_emunand_folder_path%\boot1.bin
set sxos_emunand_rawnand0_path=%sxos_emunand_folder_path%\full.00.bin
set sxos_emunand_files_exist=0
set sxos_emunand_partition_exist=0
set atmo_emummc_config_file=%volume_letter%:\emummc\emummc.ini
set atmo_emunand_enabled=
set atmo_emunand_id=
set atmo_emunand_sector=
set atmo_emunand_path=
set atmo_emunand_nintendo_path=
set atmo_emunand_exist=0
set atmo_emunand_type=
:sxos_emunand_partition_verif
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_drive_letter_associated_with_deviceid.vbs
tools\gnuwin32\bin\grep.exe "%volume_letter%: =" <templogs\volumes_list.txt | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p physicale_path_off_sd=<templogs\tempvar.txt
set physicale_path_off_sd=%physicale_path_off_sd:~1%
call :get_type_nand "%physicale_path_off_sd%"
IF /i "!nand_type!"=="FULL NAND" (
	IF EXIST "%atmo_emummc_config_file%" (
		set sxos_emunand_partition_exist=1
	) else (
		set sxos_emunand_partition_exist=2
	)
)

:sxos_emunand_files_verif
IF EXIST "%sxos_emunand_folder_path%\*.*" (
	IF EXIST "%sxos_emunand_boot0_path%" (
		call :get_type_nand "%sxos_emunand_boot0_path%"
		IF /i "!nand_type!"=="BOOT0" (
			IF EXIST "%sxos_emunand_boot1_path%" (
				call :get_type_nand "%sxos_emunand_boot1_path%"
				IF /i "!nand_type!"=="BOOT1" (
					IF EXIST "%sxos_emunand_rawnand0_path%" (
						call :get_type_nand "%sxos_emunand_rawnand0_path%"
						IF /i "!nand_type!"=="RAWNAND - splitted dump" (
							set nand_type=RAWNAND
						)
						IF /i "!nand_type!"=="RAWNAND" (
							set sxos_emunand_files_exist=1
						) else (
							goto:atmo_emunand_verif
						)
					) else (
						goto:atmo_emunand_verif
					)
				) else (
					goto:atmo_emunand_verif
				)
			) else (
				goto:atmo_emunand_verif
			)
		) else (
			goto:atmo_emunand_verif
		)
	) else (
		goto:atmo_emunand_verif
	)
) else (
	goto:atmo_emunand_verif
)
:atmo_emunand_verif
IF EXIST "%atmo_emummc_config_file%" (
	call :atmo_parse_emummc_config_file
) else (
	IF "%sxos_emunand_partition_exist%"=="2" (
		tools\dd_for_windows\dd-removable.exe bs=512 skip=2 count=8192 if=%physicale_path_off_sd% of=templogs\boot0_test.bin
		call :get_type_nand "templogs\boot0_test.bin"
		IF /i "!nand_type!"=="BOOT0" (
			set sxos_emunand_partition_exist=3
		) else (
			set sxos_emunand_partition_exist=0
		)
	)
)
IF "%sxos_emunand_partition_exist%"=="1" (
	IF "%atmo_emunand_sector%"=="0x2" (
		set atmo_emunand_exist=1
		set atmo_emunand_type=sxos_partition
	)
)
IF "%sxos_emunand_partition_exist%"=="3" set sxos_emunand_partition_exist=1
IF "%atmo_emunand_sector%"=="" (
	IF NOT "%atmo_emunand_path%"=="" (
		IF EXIST "%atmo_emunand_path:/=\%\BOOT0" (
			call :get_type_nand "%atmo_emunand_path:/=\%\BOOT0"
			IF /i NOT "!nand_type!"=="BOOT0" goto:pass_atmo_emunand_verif
			IF EXIST "%atmo_emunand_path:/=\%\BOOT1" (
				call :get_type_nand "%atmo_emunand_path:/=\%\BOOT1"
				IF /i NOT "!nand_type!"=="BOOT1" goto:pass_atmo_emunand_verif
				IF EXIST "%atmo_emunand_path:/=\%\00" (
					call :get_type_nand "%atmo_emunand_path:/=\%\00"
					IF /i "!nand_type!"=="RAWNAND - splitted dump" set nand_type=RAWNAND
					IF /i NOT "!nand_type!"=="RAWNAND" goto:pass_atmo_emunand_verif
				) else (
					goto:pass_atmo_emunand_verif
				)
			) else (
				goto:pass_atmo_emunand_verif
			)
		) else (
			goto:pass_atmo_emunand_verif
		)
		set atmo_emunand_exist=1
		set atmo_emunand_type=files
	)
) else (
	IF "%atmo_emunand_sector%"=="0x2" goto:pass_atmo_emunand_verif
	tools\dd_for_windows\dd-removable.exe bs=512 skip=%int_atmo_emunand_sector% count=8192 if=%physicale_path_off_sd% of=templogs\boot0_test.bin
	call :get_type_nand "templogs\boot0_test.bin"
	IF /i NOT "!nand_type!"=="BOOT0" goto:pass_atmo_emunand_verif
	set atmo_emunand_exist=1
	set atmo_emunand_type=partition
)
:pass_atmo_emunand_verif

:define_action_choice
echo.
call "%associed_language_script%" "emunands_sumary"
IF NOT "%sxos_emunand_files_exist%"=="1" (
	IF NOT "%sxos_emunand_partition_exist%"=="1" (
		IF NOT "%atmo_emunand_exist%"=="1" (
			echo.
			call "%associed_language_script%" "no_action_possible"
			pause
			goto:end_script2
		)
	)
)
IF NOT "%sxos_emunand_files_exist%"=="1" (
	IF NOT "%sxos_emunand_partition_exist%"=="1" (
		IF "%atmo_emunand_exist%"=="1" (
			IF NOT "%atmo_emunand_type%"=="files" (
				echo.
				call "%associed_language_script%" "no_action_possible"
				pause
				goto:end_script2
			)
		)
	)
)
IF NOT "%sxos_emunand_files_exist%"=="1" (
	IF "%sxos_emunand_partition_exist%"=="1" (
		IF "%atmo_emunand_exist%"=="1" (
			IF "%atmo_emunand_type%"=="sxos_partition" (
				echo.
				call "%associed_language_script%" "no_action_possible"
				pause
				goto:end_script2
			)
		)
	)
)
pause
set action_choice=
call "%associed_language_script%" "set_action_choice"
IF "%action_choice%"=="1" (
	call :migrate_sxos_partition_emunand
) else IF "%action_choice%"=="2" (
	call :migrate_sxos_files_emunand
) else IF "%action_choice%"=="3" (
	call :reverse_migrate_sxos_files_emunand
) else (
	goto:end_script2
)
goto:end_script2

:migrate_sxos_partition_emunand
IF NOT "%sxos_emunand_partition_exist%"=="1" (
	call "%associed_language_script%" "sxos_partition_emunand_not_exist"
	pause
	exit /b
)
IF "%atmo_emunand_exist%"=="1" (
	call "%associed_language_script%" "atmo_emunand_already_exists"
	pause
	exit /b
)
IF NOT EXIST "%volume_letter%:\emummc" mkdir "%volume_letter%:\emummc" >nul
IF NOT EXIST "%volume_letter%:\emummc\ER00" mkdir "%volume_letter%:\emummc\ER00" >nul
copy "tools\default_configs\emummc_migration_files\sxos_share_emummc.ini" "%volume_letter%:\emummc\emummc.ini" >nul
copy "tools\default_configs\emummc_migration_files\ER00\raw_based" "%volume_letter%:\emummc\ER00\raw_based" >nul
call "%associed_language_script%" "succesful_migration"
pause
exit /b

:migrate_sxos_files_emunand
IF NOT "%sxos_emunand_files_exist%"=="1" (
	call "%associed_language_script%" "sxos_files_emunand_not_exist"
	pause
	exit /b
)
IF "%atmo_emunand_exist%"=="1" (
	call "%associed_language_script%" "atmo_emunand_already_exists"
	pause
	exit /b
)
IF NOT EXIST "%volume_letter%:\emummc" mkdir "%volume_letter%:\emummc" >nul
IF NOT EXIST "%volume_letter%:\emummc\eMMC" mkdir "%volume_letter%:\emummc\eMMC" >nul
IF EXIST "%sxos_emunand_boot0_path%" move "%sxos_emunand_boot0_path%" "%volume_letter%:\emummc\eMMC\BOOT0" >nul
IF EXIST "%sxos_emunand_boot1_path%" move "%sxos_emunand_boot1_path%" "%volume_letter%:\emummc\eMMC\BOOT1" >nul
set /a tempcount=0
:sxos_rename_rawnand_files
IF %tempcount% LSS 10 (
	IF EXIST "%volume_letter%:\sxos\emunand\full.0%tempcount%.bin" (
		move "%volume_letter%:\sxos\emunand\full.0%tempcount%.bin" "%volume_letter%:\emummc\eMMC\0%tempcount%" >nul
	) else (
		goto:pass_sxos_rename_rawnand_files
	)
) else (
	IF EXIST "%volume_letter%:\sxos\emunand\full.%tempcount%.bin" (
		move "%volume_letter%:\sxos\emunand\full.%tempcount%.bin" "%volume_letter%:\emummc\eMMC\%tempcount%" >nul
	) else (
		goto:pass_sxos_rename_rawnand_files
	)
set /a tempcount=%tempcount%+1
goto:sxos_rename_rawnand_files
:pass_sxos_rename_rawnand_files
copy "tools\default_configs\emummc_migration_files\atmo_files_emummc.ini" "%volume_letter%:\emummc\emummc.ini" >nul
call "%associed_language_script%" "succesful_migration"
pause
exit /b

:reverse_migrate_sxos_files_emunand
IF /i NOT "%atmo_emunand_type%"=="files" (
	call "%associed_language_script%" "atmo_emunand_not_files_type"
	pause
	exit /b
)
IF "%sxos_emunand_files_exist%"=="1" (
	call "%associed_language_script%" "sxos_emunand_files_already_exists"
	pause
	exit /b
)
set temp_atmo_emummc_path=%atmo_emunand_path:/=\%\eMMC
IF NOT EXIST "%volume_letter%:\sxos" mkdir "%volume_letter%:\sxos" >nul
IF NOT EXIST "%volume_letter%:\sxos\emunand" mkdir "%volume_letter%:\sxos\emunand" >nul
IF EXIST "%volume_letter%:\%temp_atmo_emummc_path%\BOOT0" move "%volume_letter%:\%temp_atmo_emummc_path%\BOOT0" "%sxos_emunand_boot0_path%" >nul
IF EXIST "%volume_letter%:\%temp_atmo_emummc_path%\BOOT1" move "%volume_letter%:\%temp_atmo_emummc_path%\BOOT1" "%sxos_emunand_boot1_path%" >nul
set /a tempcount=0
:atmo_rename_rawnand_files
IF %tempcount% LSS 10 (
	IF EXIST "%volume_letter%:\%temp_atmo_emummc_path%\0%tempcount%" (
		move "%volume_letter%:\%temp_atmo_emummc_path%\0%tempcount%" "%volume_letter%:\sxos\emunand\full.0%tempcount%.bin" >nul
	) else (
		goto:pass_atmo_rename_rawnand_files
	)
) else (
	IF EXIST "%volume_letter%:\%temp_atmo_emummc_path%\%tempcount%" (
		move "%volume_letter%:\%temp_atmo_emummc_path%\%tempcount%" "%volume_letter%:\sxos\emunand\full.%tempcount%.bin" >nul
	) else (
		goto:pass_atmo_rename_rawnand_files
	)
set /a tempcount=%tempcount%+1
goto:atmo_rename_rawnand_files
:pass_atmo_rename_rawnand_files
IF NOT "%volume_letter%:\%atmo_nintendo_emunand_path:/=\%"=="%volume_letter%:\emutendo" (
	IF EXIST "%volume_letter%:\emutendo" rmdir /s /q "%volume_letter%:\emutendo" >nul
	move "%volume_letter%:\%atmo_nintendo_emunand_path:/=\%" "%volume_letter%:\emutendo" >nul
)
del /q "%volume_letter%:\emummc\emummc.ini" >nul
call "%associed_language_script%" "succesful_migration"
pause
exit /b

:get_type_nand
set nand_type=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
exit /b

:atmo_parse_emummc_config_file
tools\gnuwin32\bin\grep.exe -e "^enabled *=" <"%atmo_emummc_config_file%" | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p atmo_emunand_enabled=<templogs\tempvar.txt
IF NOT "!atmo_emunand_enabled!"=="" (
	set atmo_emunand_enabled=!atmo_emunand_enabled:~1!
)
tools\gnuwin32\bin\grep.exe -e "^id *=" <"%atmo_emummc_config_file%" | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p atmo_emunand_id=<templogs\tempvar.txt
IF NOT "!atmo_emunand_id!"=="" (
	set atmo_emunand_id=!atmo_emunand_id:~1!
)
tools\gnuwin32\bin\grep.exe -e "^sector *=" <"%atmo_emummc_config_file%" | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p atmo_emunand_sector=<templogs\tempvar.txt
IF NOT "!atmo_emunand_sector!"=="" (
	set atmo_emunand_sector=!atmo_emunand_sector:~1!
	IF "!atmo_emunand_sector!"=="0x0" set atmo_emunand_sector=
	IF "!atmo_emunand_sector!"=="0" set atmo_emunand_sector=
)
IF NOT "!atmo_emunand_sector!"=="" (
	set /a int_atmo_emunand_sector=%atmo_emunand_sector%
) else (
	set /a int_atmo_emunand_sector=0
)
tools\gnuwin32\bin\grep.exe -e "^path *=" <"%atmo_emummc_config_file%" | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p atmo_emunand_path=<templogs\tempvar.txt
IF NOT "!atmo_emunand_path!"=="" (
	set atmo_emunand_path=!atmo_emunand_path:~1!
)
tools\gnuwin32\bin\grep.exe -e "^nintendo_path *=" <"%atmo_emummc_config_file%" | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p atmo_emunand_nintendo_path=<templogs\tempvar.txt
IF NOT "!atmo_emunand_nintendo_path!"=="" (
	set atmo_emunand_nintendo_path=!atmo_emunand_nintendo_path:~1!
) else (
	IF NOT "!atmo_emunand_id!"=="" (
		set atmo_emunand_nintendo_path=emummc/Nintendo_!atmo_emunand_id:~2,4!
	)
)
exit /b

:end_script
pause
:end_script2
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal