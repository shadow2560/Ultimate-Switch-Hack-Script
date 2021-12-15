::Script by Shadow256
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
call "%associed_language_script%" "display_title"
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "intro"
pause
:define_action_choice
cls
set biskeys_param=
set biskeys_file_path=
set erase_output_file=
set partition=
set zip_param=
set existing_file_finded=
set split_param=
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "first_action_choice"
IF "%action_choice%"=="1" cls & goto:info_nand
IF "%action_choice%"=="2" cls & goto:dump_nand
IF "%action_choice%"=="3" cls & goto:restaure_nand
IF "%action_choice%"=="4" cls & goto:create_emunand_on_sd
IF "%action_choice%"=="5" cls & goto:autorcm_management
IF "%action_choice%"=="6" cls & goto:exfat_driver_manual_install
IF "%action_choice%"=="7" cls & goto:incognito_apply
IF "%action_choice%"=="8" (
	cls
	call tools\storage\nand_joiner.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="9" (
	cls
	call tools\storage\nand_spliter.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="10" (
	cls
	call tools\storage\emunand_partition_file_create.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="11" (
	cls
	call tools\storage\extract_nand_files_from_emunand_partition_file.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="12" cls & goto:decrypt_nand
IF "%action_choice%"=="13" cls & goto:encrypt_nand
IF "%action_choice%"=="14" (
	cls
	call tools\storage\ninfs.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="15" cls & goto:resize_user_partition
IF "%action_choice%"=="16" (
	cls
	call tools\storage\boot0_rewrite.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="17" cls & goto:brute_force
IF "%action_choice%"=="18" cls & goto:unbrick_menu
IF "%action_choice%"=="0" (
	cls
	call tools\storage\mount_discs.bat "auto_close"
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
goto:end_script

:unbrick_menu
cls
set biskeys_param=
set biskeys_file_path=
set partition=
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "unbrick_menu_choice"
IF "%action_choice%"=="1" (
	cls
	call tools\storage\mount_discs.bat "rawnand_force"
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:unbrick_menu
)
IF "%action_choice%"=="2" cls & goto:pass_first_config_screen
IF "%action_choice%"=="3" cls & goto:del_parental_control
IF "%action_choice%"=="4" cls & goto:reset_rawnand
IF "%action_choice%"=="5" (
	cls
	call tools\storage\prepare_update_on_sd.bat "unbrick_package_creation"
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:unbrick_menu
)
IF "%action_choice%"=="6" cls & goto:apply_fw_package_on_rawnand
IF "%action_choice%"=="0" (
	cls
	tools\NxNandManager\NxNandManager.exe --install_dokan
	goto:unbrick_menu
)
goto:define_action_choice

:info_nand
set input_path=
set action_choice=
call "%associed_language_script%" "nand_infos_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:info_nand
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:info_nand
)
call "%associed_language_script%" "biskeys_file_selection_empty_authorised"
call :set_debug_param_only
IF /i "%debug_option%"=="o" (
	tools\NxNandManager\NxNandManager.exe --info -i "%input_path%" %biskeys_param% DEBUG_MODE
) else (
	call :get_type_nand "%input_path%" "display"
)
echo.
pause
goto:define_action_choice

:dump_nand
set input_path=
set output_path=
set action_choice=
call "%associed_language_script%" "dump_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:dump_nand
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:dump_nand
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND" call :partition_select
IF /i "%nand_type%"=="RAWNAND - splitted dump" call :partition_select
IF /i "%nand_type%"=="FULL NAND" call :partition_select full_nand_choice
IF %errorlevel% EQU 3001 (
	goto:dump_nand
)
echo.
call "%associed_language_script%" "dump_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_output_folder_empty_error"
	goto:dump_nand
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
IF NOT "%partition%"=="" (
	IF /i "%partition%"=="RAWNAND" (
		set output_path=%output_path%%partition%.bin
	) else (
		set output_path=%output_path%%partition%
	)
) else (
	IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand.bin
	) else IF "%nand_type%"=="RAWNAND - splitted dump" (
		set output_path=%output_path%rawnand.bin
	) else IF "%nand_type%"=="FULL NAND" (
		set output_path=%output_path%full_nand.bin
	) else (
		set output_path=%output_path%%nand_type%
	)
)
call :set_nnm_split_param
set zip_param=
call "%associed_language_script%" "zip_param_choice"
IF NOT "%zip_param%"=="" set zip_param=%zip_param:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "zip_param" "o/n_choice"
set existing_file_finded=
IF /i NOT "%nnm_split_option%"=="O" (
	IF /i NOT "%zip_param%"=="o" (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
		IF EXIST "%output_path%.zip" (
			set existing_file_finded=Y
		)
	)
)
IF "%existing_file_finded%"=="Y" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_output_file" "o/n_choice"
IF "%existing_file_finded%"=="Y" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:dump_nand
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" del /q "%output_path%"
		)
		IF /i "%zip_param%"=="o" (
			IF EXIST "%output_path%.zip" del /q "%output_path%.zip"
		)
	)
)
call :set_NNM_params
call :set_nnm_passthrough_0_param
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
pause
goto:define_action_choice

:exfat_driver_manual_install
set output_path=
set action_choice=
IF EXIST "update_packages\*.*" rmdir /s /q "update_packages"
call "%associed_language_script%" "exfat_driver_begin"
pause
call tools\storage\prepare_update_on_sd.bat "firmware_create_ehg" "exfat_force"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:define_action_choice
)
IF NOT EXIST "update_packages\*.*" (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:define_action_choice
)
call "%associed_language_script%" "exfat_restaure_output_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:exfat_driver_manual_install
)
IF "%action_choice%" == "0" (
	call :nand_file_output_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p output_path=<templogs\tempvar.txt
	)
)
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:exfat_driver_manual_install
)
call :get_type_nand "%output_path%"
IF %errorlevel% EQU 3001 (
	goto:restaure_nand
)
set output_nand_type=%nand_type%
IF "%output_nand_type%"=="RAWNAND - splitted dump" set output_nand_type=RAWNAND
IF "%output_nand_type%"=="FULL NAND" set output_nand_type=RAWNAND
IF "%output_nand_type%"=="UNKNOWN" (
	call "%associed_language_script%" "restaure_output_dump_invalid_error"
	goto:exfat_driver_manual_install
)
IF NOT "%output_nand_type%"=="RAWNAND" (
	call "%associed_language_script%" "nand_type_must_be_rawnand_error"
	pause
	goto:exfat_driver_manual_install
)
for /d %%f in ("update_packages\*") do (
	tools\NxNandManager\NxNandManager.exe -i "%%f\BCPKG2-1-Normal-Main.bin" -o "%output_path%" -part=BCPKG2-1-Normal-Main FORCE BYPASS_MD5SUM
	tools\NxNandManager\NxNandManager.exe -i "%%f\BCPKG2-2-Normal-Sub.bin" -o "%output_path%" -part=BCPKG2-2-Normal-Sub FORCE BYPASS_MD5SUM
	tools\NxNandManager\NxNandManager.exe -i "%%f\BCPKG2-3-SafeMode-Main.bin" -o "%output_path%" -part=BCPKG2-3-SafeMode-Main FORCE BYPASS_MD5SUM
	tools\NxNandManager\NxNandManager.exe -i "%%f\BCPKG2-4-SafeMode-Sub.bin" -o "%output_path%" -part=BCPKG2-4-SafeMode-Sub FORCE BYPASS_MD5SUM
)
echo.
pause
goto:define_action_choice

:restaure_nand
set input_path=
set output_path=
set output_nand_soc_rev=
set input_nand_soc_rev=
set action_choice=
call "%associed_language_script%" "restaure_input_file_begin"
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	call "%associed_language_script%" "restaure_input_empty_error"
	echo.
	pause
	goto:define_action_choice
)
call "%associed_language_script%" "restaure_output_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:restaure_nand
)
IF "%action_choice%" == "0" (
	call :nand_file_output_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p output_path=<templogs\tempvar.txt
	)
)
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:restaure_nand
)
set partition=
call :get_type_nand "%output_path%"
IF /i "%nand_type%"=="RAWNAND" call :partition_select
IF /i "%nand_type%"=="RAWNAND - splitted dump" call :partition_select
IF /i "%nand_type%"=="FULL NAND" call :partition_select full_nand_choice
IF %errorlevel% EQU 3001 (
	goto:restaure_nand
)
set output_nand_type=%nand_type%
IF "%output_nand_type%"=="BOOT0" set output_nand_soc_rev=%nand_soc_rev%
IF "%output_nand_type%"=="FULL NAND" set output_nand_soc_rev=%nand_soc_rev%
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF "%input_nand_type%"=="BOOT0" set input_nand_soc_rev=%nand_soc_rev%
IF "%input_nand_type%"=="FULL NAND" (
	set input_nand_soc_rev=%nand_soc_rev%
)
IF "%input_nand_type%"=="UNKNOWN" (
	call "%associed_language_script%" "restaure_input_dump_invalid_error"
	goto:restaure_nand
)
IF "%input_nand_type%"=="RAWNAND - splitted dump" (
	set input_nand_type=RAWNAND
)
IF "%output_nand_type%"=="UNKNOWN" (
	call "%associed_language_script%" "restaure_output_dump_invalid_error"
	goto:restaure_nand
)
IF "%output_nand_type%"=="RAWNAND - splitted dump" (
	set output_nand_type=RAWNAND
)
IF "%output_nand_type%"=="BOOT0" (
	IF NOT "%input_nand_soc_rev%"=="%output_nand_soc_rev%" (
		call "%associed_language_script%" "restaure_partitions_not_match_error"
		goto:restaure_nand
	)
)
IF "%partition%"=="" (
	IF "%output_nand_type%"=="FULL NAND" (
		IF NOT "%input_nand_soc_rev%"=="%output_nand_soc_rev%" (
			call "%associed_language_script%" "restaure_partitions_not_match_error"
			goto:restaure_nand
		)
	)
)
IF NOT "%partition%"=="" (
	IF "%input_nand_type%"=="RAWNAND" (
		set input_nand_type=%partition%
	) else IF "%input_nand_type%"=="FULL NAND" (
		set input_nand_type=%partition%
	)
)
IF NOT "%partition%"=="" (
	IF "%output_nand_type%"=="RAWNAND" (
		IF NOT "%partition%"=="%input_nand_type%" (
			call "%associed_language_script%" "restaure_partitions_not_match_error"
			goto:restaure_nand
		)
	) else IF "%output_nand_type%"=="FULL NAND" (
		IF "%partition%"=="BOOT0" (
			IF NOT "%input_nand_type%"=="BOOT0" (
				call "%associed_language_script%" "restaure_partitions_not_match_error"
				goto:restaure_nand
			)
			IF NOT "%input_nand_soc_rev%"=="%output_nand_soc_rev%" (
				call "%associed_language_script%" "restaure_partitions_not_match_error"
				goto:restaure_nand
			)
		) else IF "%partition%"=="BOOT1" (
			IF NOT "%input_nand_type%"=="BOOT1" (
				call "%associed_language_script%" "restaure_partitions_not_match_error"
				goto:restaure_nand
			)
		) else IF NOT "%partition%"=="%input_nand_type%" (
			call "%associed_language_script%" "restaure_partitions_not_match_error"
			goto:restaure_nand
		)
	) else (
			call "%associed_language_script%" "restaure_try_partition_on_other_than_rawnand_error"
		goto:restaure_nand
	)
) else (
	IF NOT "%input_nand_type%"=="%output_nand_type%" (
		call "%associed_language_script%" "restaure_input_and_output_type_not_match_error"
		goto:restaure_nand
	)
)
call :set_NNM_params
call :set_nnm_passthrough_0_param
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
pause
goto:define_action_choice

:create_emunand_on_sd
set input_path=
set input_path_save=
set rawnand_path=
set output_path=
set boot0_path=
set boot1_path=
set emunand_type=
set action_choice=
call "%associed_language_script%" "emunand_create_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:create_emunand_on_sd
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
		set input_path_save=!input_path!
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:create_emunand_on_sd
)
set rawnand_path=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="RAWNAND" (
	set rawnand_path=-i ^"%input_path%^"
	goto:boot0_boot1_select
) else IF /i "%nand_type%"=="FULL NAND" (
	set rawnand_path=-i ^"%input_path%^"
	goto:emunand_type_choice
) else (
	call "%associed_language_script%" "emunand_create_nand_type_error"
	goto:create_emunand_on_sd
)
:boot0_boot1_select
call "%associed_language_script%" "select_boot0_file"
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	call "%associed_language_script%" "emunand_create_boot1_dump_not_exist_error"
	echo.
	goto:create_emunand_on_sd
)
call :get_type_nand "%input_path%"
IF /i NOT "%nand_type%"=="BOOT0" (
	call "%associed_language_script%" "select_boot0_file_invalid_error"
	pause
	goto:create_emunand_on_sd
)
set rawnand_path=%rawnand_path% -boot0 ^"%input_path%^"
call "%associed_language_script%" "select_boot1_file"
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	call "%associed_language_script%" "emunand_create_boot1_dump_not_exist_error"
	echo.
	goto:create_emunand_on_sd
)
call :get_type_nand "%input_path%"
IF /i NOT "%nand_type%"=="BOOT1" (
	call "%associed_language_script%" "select_boot1_file_invalid_error"
	goto:create_emunand_on_sd
)
set rawnand_path=%rawnand_path% -boot1 ^"%input_path%^"
:emunand_type_choice
set emunand_type=
call "%associed_language_script%" "emunand_create_type_choice"
IF "%emunand_type%"=="1" (
	set emunand_type=--create_partition_emunand
) else IF "%emunand_type%"=="2" (
	set emunand_type=--create_filebased_emunand_AMS
) else IF "%emunand_type%"=="3" (
	set emunand_type=--create_filebased_emunand_SXOS
) else (
	call "%associed_language_script%" "select_emunand_type_invalid_error"
	pause
	goto:emunand_type_choice
)
:emunand_create_list_disk_choice
IF EXIST templogs\disks_list.txt del /q templogs\disks_list.txt
tools\NxNandManager\NxNandManager.exe %emunand_type% %rawnand_path% >templogs\temp_disks_list.txt
if %errorlevel% NEQ 0 (
	del /q templogs\temp_disks_list.txt
	set disk_not_finded_choice=
	call "%associed_language_script%" "no_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "disk_not_finded_choice" "o/n_choice"
	IF /i "!disk_not_finded_choice!"=="o" (
		goto:emunand_create_list_disk_choice
	) else (
		goto:define_action_choice
	)
)
echo.
call "%associed_language_script%" "emunand_output_choice_intro"
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\temp_disks_list.txt > templogs\tempvar.txt
set /p count_disks=<templogs\tempvar.txt
set /a temp_count_disks=0
set /a real_count=0
copy nul templogs\disks_list.txt >nul
:emunand_create_disks_listing
set /a temp_count_disks+=1
IF %temp_count_disks% GTR %count_disks% (
	goto:emunand_create_finish_disks_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_disks%p <templogs\temp_disks_list.txt >templogs\tempvar.txt
set /p temp_disk=<templogs\tempvar.txt
IF NOT "%temp_disk:~0,2%" == "- " goto:emunand_create_disks_listing
echo %temp_disk% | tools\gnuwin32\bin\cut.exe -d ( -f 1 >templogs\tempvar.txt
set /p temp_disk_path=<templogs\tempvar.txt
set temp_disk_path=%temp_disk_path: =%
set temp_disk_path=%temp_disk_path:-=%
IF "%temp_disk_path%"=="%input_path_save%" goto:emunand_create_disks_listing
echo %temp_disk_path%>>templogs\disks_list.txt
echo %temp_disk% | tools\gnuwin32\bin\cut.exe -d ( -f 2 >templogs\tempvar.txt
set /p temp_disk_infos=<templogs\tempvar.txt
set temp_disk_infos=%temp_disk_infos:(=%
set temp_disk_infos=%temp_disk_infos:)=%
set /a real_count=%real_count%+1
echo %real_count%: %temp_disk_path%; %temp_disk_infos%
goto:emunand_create_disks_listing
:emunand_create_finish_disks_listing
del /q templogs\temp_disks_list.txt
set action_choice=
call "%associed_language_script%" "emunand_output_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:emunand_create_list_disk_choice
)
IF "%action_choice%" == "0" (
	goto:emunand_create_list_disk_choice
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p output_path=<templogs\tempvar.txt
	)
)
IF "%output_path%"=="" (
	call "%associed_language_script%" "disk_not_exist_error"
	echo.
	goto:emunand_create_list_disk_choice
)
call :set_NNM_params
tools\NxNandManager\NxNandManager_emunand.exe %emunand_type% %rawnand_path% -o "%output_path%" %params%%lflags%
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "emunand_create_action_error"
) else (
	call "%associed_language_script%" "emunand_create_action_success"
)
pause
goto:define_action_choice

:autorcm_management
set input_path=
set action_choice=
call "%associed_language_script%" "autorcm_dump_choice_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:autorcm_management
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:autorcm_management
)
echo.
set action_choice=
set autorcm_param=
call "%associed_language_script%" "autorcm_choice"
IF "%action_choice%" == "1" (
	set autorcm_param=--enable_autoRCM
) else IF "%action_choice%" == "2" (
	set autorcm_param=--disable_autoRCM
) else (
	goto:autorcm_management
)
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF "%input_nand_type%"=="FULL NAND" (
	set input_nand_type=BOOT0
)
IF NOT "%input_nand_type%"=="BOOT0" (
	call "%associed_language_script%" "autorcm_nand_type_must_be_boot0_error"
	goto:autorcm_management
)
IF NOT "%nand_soc_rev%"=="Erista" (
	call "%associed_language_script%" "autorcm_nand_soc_must_be_erista_error"
	goto:autorcm_management
)
call :set_debug_param_only
IF /i "%debug_option%"=="o" (
	tools\NxNandManager\NxNandManager.exe %autorcm_param% -i "%input_path%" DEBUG_MODE
) else (
	tools\NxNandManager\NxNandManager.exe %autorcm_param% -i "%input_path%" >nul
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "autorcm_action_error"
) else (
	IF "%action_choice%" == "1" call "%associed_language_script%" "autorcm_enabled_success"
IF "%action_choice%" == "2" call "%associed_language_script%" "autorcm_disabled_success"
)
echo.
pause
goto:define_action_choice

:decrypt_nand
set input_path=
set output_path=
set biskeys_param=
set action_choice=
call "%associed_language_script%" "decrypt_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:decrypt_nand
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:decrypt_nand
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="RAWNAND" (
	call :partition_select
) else IF /i "%nand_type%"=="FULL NAND" (
	call :partition_select all_partitions_excepted
) else IF /i "%nand_type%"=="unknown" (
	call "%associed_language_script%" "decrypt_rawnand_not_selected_error"
	goto:decrypt_nand
) else (
	set partition=%nand_type%
	goto:decrypt_verif_encrypted_or_not
)
IF %errorlevel% EQU 3001 (
	goto:decrypt_nand
)
:decrypt_verif_encrypted_or_not
IF /i NOT "%nand_encrypted:~0,3%"=="Yes" (
	call "%associed_language_script%" "decrypt_verif_encrypted_or_not_error"
	goto:decrypt_nand
)
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:decrypt_nand
)
if "%partition%"=="" (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" >nul 2>&1
) else (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=%partition%>nul 2>&1
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:decrypt_nand
) else (
	set biskeys_param=-keyset "%biskeys_file_path%" 
)
echo.
call "%associed_language_script%" "dump_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_output_folder_empty_error"
	goto:decrypt_nand
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
IF NOT "%partition%"=="" (
	set output_path=%output_path%%partition%.bin
) else (
	IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand_decrypted.bin
	) else IF "%nand_type%"=="RAWNAND - splitted dump" (
		set output_path=%output_path%rawnand_decrypted.bin
	)
)
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call :set_nnm_split_param
	)
)
set zip_param=
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call "%associed_language_script%" "zip_param_choice"
	)
)
IF NOT "%zip_param%"=="" set zip_param=%zip_param:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "zip_param" "o/n_choice"
set existing_file_finded=
IF /i NOT "%nnm_split_option%"=="O" (
	IF /i NOT "%zip_param%"=="o" (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
		IF EXIST "%output_path%.zip" (
			set existing_file_finded=Y
		)
	)
)
IF "%existing_file_finded%"=="Y" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_output_file" "o/n_choice"
IF "%existing_file_finded%"=="Y" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:decrypt_nand
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" del /q "%output_path%"
		)
		IF /i "%zip_param%"=="o" (
			IF EXIST "%output_path%.zip" del /q "%output_path%.zip"
		)
	)
)
IF /i NOT "%nand_type%"=="RAWNAND" (
	set partition=
)
call :set_NNM_params
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call :set_nnm_passthrough_0_param
	)
)
IF /i "%nand_type%"=="RAWNAND" (
	IF "%partition%"=="" (
		::tools\NxNandManager\NxNandManager.exe -part=PRODINFO,PRODINFOF,SAFE,SYSTEM,USER -i "%input_path%" -o "%output_path%" -d %biskeys_param% %params%%lflags%
		tools\NxNandManager\NxNandManager_old.exe -i "%input_path%" -o "%output_path%" -d %biskeys_param% %params%%lflags%
		goto:skip_decrypt_nxnandmanager_command
	)
)
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" -d %biskeys_param% %params%%lflags%
:skip_decrypt_nxnandmanager_command
echo.
pause
goto:define_action_choice

:encrypt_nand
set input_path=
set output_path=
set biskeys_param=
set action_choice=
call "%associed_language_script%" "encrypt_input_begin"
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	call "%associed_language_script%" "encrypt_input_empty_error"
	echo.
	pause
	goto:define_action_choice
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="RAWNAND" (
	call :partition_select
) else IF /i "%nand_type%"=="FULL NAND" (
	call :partition_select all_partitions_excepted
) else IF /i "%nand_type%"=="unknown" (
	call "%associed_language_script%" "encrypt_rawnand_not_selected_error"
	goto:encrypt_nand
) else (
	set partition=%nand_type%
	goto:encrypt_verif_encrypted_or_not
)
IF %errorlevel% EQU 3001 (
	goto:encrypt_nand
)
:encrypt_verif_encrypted_or_not
IF /i NOT "%nand_encrypted%"=="No" (
	call "%associed_language_script%" "encrypt_verif_encrypted_or_not_error"
	goto:encrypt_nand
)
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:encrypt_nand
) else (
	set biskeys_param=-keyset "%biskeys_file_path%" 
)
echo.
call "%associed_language_script%" "dump_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_output_folder_empty_error"
	goto:encrypt_nand
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
IF NOT "%partition%"=="" (
	set output_path=%output_path%%partition%
) else (
	IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand.bin
	) else IF "%nand_type%"=="RAWNAND - splitted dump" (
		set output_path=%output_path%rawnand.bin
	)
)
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call :set_nnm_split_param
	)
)
set zip_param=
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call "%associed_language_script%" "zip_param_choice"
	)
)
IF NOT "%zip_param%"=="" set zip_param=%zip_param:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "zip_param" "o/n_choice"
set existing_file_finded=
IF /i NOT "%nnm_split_option%"=="O" (
	IF /i NOT "%zip_param%"=="o" (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
		IF EXIST "%output_path%.zip" (
			set existing_file_finded=Y
		)
	)
)
IF "%existing_file_finded%"=="Y" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_output_file" "o/n_choice"
IF "%existing_file_finded%"=="Y" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:encrypt_nand
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" del /q "%output_path%"
		)
		IF /i "%zip_param%"=="o" (
			IF EXIST "%output_path%.zip" del /q "%output_path%.zip"
		)
	)
)
IF /i NOT "%nand_type%"=="RAWNAND" (
	set partition=
)
call :set_NNM_params
IF /i NOT "%nand_type%"=="RAWNAND" (
	IF NOT "%partition%"=="" (
		call :set_nnm_passthrough_0_param
	)
)
IF /i "%nand_type%"=="RAWNAND" (
	IF "%partition%"=="" (
		::tools\NxNandManager\NxNandManager.exe -part=PRODINFO,PRODINFOF,SAFE,SYSTEM,USER -i "%input_path%" -o "%output_path%" -e %biskeys_param% %params%%lflags%
		tools\NxNandManager\NxNandManager_old.exe -i "%input_path%" -o "%output_path%" -e %biskeys_param% %params%%lflags%
		goto:skip_encrypt_nxnandmanager_command
	)
)
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" -e %biskeys_param% %params%%lflags%
:skip_encrypt_nxnandmanager_command
echo.
pause
goto:define_action_choice

:incognito_apply
set input_path=
set output_path=
set biskeys_param=
set action_choice=
call "%associed_language_script%" "incognito_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:incognito_apply
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:incognito_apply
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="RAWNAND" (
	set partition=PRODINFO
	goto:incognito_verif_encrypted_or_not
) else IF /i "%nand_type%"=="FULL NAND" (
	set partition=PRODINFO
	goto:incognito_verif_encrypted_or_not
) else IF /i "%nand_type%"=="PRODINFO" (
	goto:incognito_verif_encrypted_or_not
) else (
	call "%associed_language_script%" "incognito_nand_type_error"
	goto:incognito_apply
)
:incognito_verif_encrypted_or_not
echo.
set decrypt_param=
IF /i NOT "%nand_encrypted:~0,3%"=="Yes" (
	set biskeys_param=
	goto:skip_incognito_biskeys_file_choice
) else (
	set decrypt_param=-d 
	call :select_biskeys_file
	IF "!biskeys_file_path!"=="" (
		call "%associed_language_script%" "biskeys_file_not_selected_error"
		goto:incognito_apply
	)
)
if "%partition%"=="" (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" >nul 2>&1
) else (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=%partition%>nul 2>&1
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "incognito_biskeys_not_valid_error"
	goto:incognito_apply
) else (
	set biskeys_param=-keyset "%biskeys_file_path%" 
)
echo.
:skip_incognito_biskeys_file_choice
call :set_NNM_params
IF "%input_path:~0,4%"=="\\.\" (
	set base_folder_path_of_a_file_path=%ushs_base_path%
) else (
	call :get_base_folder_path_of_a_file_path "%input_path%"
)
tools\NxNandManager\NxNandManager.exe --incognito -i "%input_path%" %biskeys_param% %decrypt_param%%params%%lflags%
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "incognito_action_error"
	goto:skip_move_nnm_prodinfo_backup
) else (
	call "%associed_language_script%" "incognito_action_success"
	IF NOT EXIST "PRODINFO.backup" goto:skip_move_nnm_prodinfo_backup
)
echo.
IF "%input_path:~0,4%"=="\\.\" call "%associed_language_script%" "incognito_prodinfo_backup_moved"
IF "%input_path:~0,4%"=="\\.\" goto:skip_move_nnm_prodinfo_backup
set /a temp_count=0
:move_nnm_prodinfo_backup
IF %temp_count% EQU 0 (
	IF EXIST "%base_folder_path_of_a_file_path%\PRODINFO.backup" (
		set /a temp_count=2
		goto:move_nnm_prodinfo_backup
	) else (
		move "PRODINFO.backup" "%base_folder_path_of_a_file_path%\PRODINFO.backup" >nul
		call "%associed_language_script%" "incognito_prodinfo_backup_moved"
	)
) else (
	IF EXIST "%base_folder_path_of_a_file_path%\PRODINFO.backup%temp_count%" (
		set /a temp_count +=1
		goto:move_nnm_prodinfo_backup
	) else (
		move "PRODINFO.backup" "%base_folder_path_of_a_file_path%\PRODINFO.backup%temp_count%" >nul
		call "%associed_language_script%" "incognito_prodinfo_backup_moved"
	)
)
:skip_move_nnm_prodinfo_backup
pause
goto:define_action_choice

:resize_user_partition
set partition=
set input_path=
set output_path=
set partition_size=
set action_choice=
call "%associed_language_script%" "resize_user_part_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:resize_user_partition
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:resize_user_partition
)
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND" goto:resize_user_partition_input_ok
IF /i "%nand_type%"=="RAWNAND - splitted dump" goto:resize_user_partition_input_ok
IF /i "%nand_type%"=="FULL NAND" goto:resize_user_partition_input_ok
call "%associed_language_script%" "resize_user_part_bad_input_choice"
goto:resize_user_partition
:resize_user_partition_input_ok
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:resize_user_partition
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=USER>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:resize_user_partition
) else (
	set biskeys_param=-keyset "%biskeys_file_path%" 
)
echo.
call "%associed_language_script%" "dump_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_output_folder_empty_error"
	goto:resize_user_partition
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand_resized.bin
) else IF "%nand_type%"=="RAWNAND - splitted dump" (
		set output_path=%output_path%rawnand_resized.bin
) else IF "%nand_type%"=="FULL NAND" (
		set output_path=%output_path%full_nand_resized.bin
)
call :set_nnm_split_param
set zip_param=
call "%associed_language_script%" "zip_param_choice"
IF NOT "%zip_param%"=="" set zip_param=%zip_param:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "zip_param" "o/n_choice"
set existing_file_finded=
IF /i NOT "%nnm_split_option%"=="O" (
	IF /i NOT "%zip_param%"=="o" (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" (
				set existing_file_finded=Y
			)
		)
		IF EXIST "%output_path%.zip" (
			set existing_file_finded=Y
		)
	)
)
IF "%existing_file_finded%"=="Y" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_output_file" "o/n_choice"
IF "%existing_file_finded%"=="Y" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:resize_user_partition
	) else (
		IF /i NOT "%nnm_split_option%"=="o" (
			IF EXIST "%output_path%" del /q "%output_path%"
		)
		IF /i "%zip_param%"=="o" (
			IF EXIST "%output_path%.zip" del /q "%output_path%.zip"
		)
	)
)
set partition=
call :set_NNM_params
call :set_nnm_passthrough_0_param
:define_resize_partition_size_value
set resize_user_partition_value=
call "%associed_language_script%" "resize_user_part_value_choice"
IF "%resize_user_partition_value%"=="" (
	call "%associed_language_script%" "canceled"
	goto:resize_user_partition
)
call TOOLS\Storage\functions\strlen.bat nb "%resize_user_partition_value%"
set i=0
:check_chars_resize_partition_size_value
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!resize_user_partition_value:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_resize_partition_size_value
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:define_resize_partition_size_value
	)
)
IF %resize_user_partition_value% LSS 2000 (
	call "%associed_language_script%" "resize_user_part_define_greater_size_error"
goto:define_resize_partition_size_value
)
set params=-user_resize=%resize_user_partition_value%
set resize_user_partition_format=
call "%associed_language_script%" "resize_user_partition_format_choice"
IF NOT "%resize_user_partition_format%"=="" set resize_user_partition_format=%resize_user_partition_format:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "resize_user_partition_format" "o/n_choice"
IF /i "%resize_user_partition_format%"=="o" (
	set lflags=%lflags%FORMAT_USER
)
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %biskeys_param% %params% %lflags%
echo.
pause
goto:define_action_choice

:brute_force
set input_path=
set output_path=
set action_choice=
call "%associed_language_script%" "brute_force_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:brute_force
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:brute_force
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="PRODINFO" set partition=PRODINFO
IF /i "%nand_type%"=="PRODINFOF" set partition=PRODINFO
IF /i "%nand_type%"=="SAFE" set partition=SAFE
IF /i "%nand_type%"=="SYSTEM" set partition=SYSTEM
IF /i "%nand_type%"=="USER" set partition=USER
IF /i "%nand_type%"=="RAWNAND" call :partition_select brute_force brute_force_choice
IF /i "%nand_type%"=="RAWNAND - splitted dump" call :partition_select brute_force brute_force_choice
IF /i "%nand_type%"=="FULL NAND" call :partition_select brute_force_choice
IF %errorlevel% EQU 3001 (
	goto:brute_force
)
IF /i "%partition%" == "PRODINFOF" set partition=PRODINFO
echo.
call "%associed_language_script%" "brute_force_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "brute_force_output_folder_empty_error"
	goto:brute_force
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
IF /i "%partition%" == "PRODINFO" set output_path=%output_path%\biskey_00.txt
IF /i "%partition%" == "SAFE" set output_path=%output_path%\biskey_01.txt
IF /i "%partition%" == "SYSTEM" set output_path=%output_path%\biskey_02.txt
IF /i "%partition%" == "USER" set output_path=%output_path%\biskey_03.txt
IF EXIST "%output_path%" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_output_file" "o/n_choice"
IF EXIST "%output_path%" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:brute_force
	) else (
		del /q "%output_path%"
	)
)
"tools\python3_scripts\brute_force_biskeys\brute_force_biskeys.exe" "%partition%" "%input_path%" "%output_path%"
echo.
pause
goto:define_action_choice

:pass_first_config_screen
set input_path=
set biskeys_file_path=
set action_choice=
call "%associed_language_script%" "pass_first_config_screen__begin"
pause
echo.
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:unbrick_menu
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:pass_first_config_screen
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:pass_first_config_screen
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND" set partition=SYSTEM
IF /i "%nand_type%"=="RAWNAND - splitted dump" set partition=SYSTEM
IF /i "%nand_type%"=="FULL NAND" set partition=SYSTEM
IF /i "%nand_type%"=="SYSTEM" set partition=SYSTEM
IF /i NOT "%partition%"=="SYSTEM" (
	call "%associed_language_script%" "partition_should_be_system_error"
	goto:pass_first_config_screen
)
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:pass_first_config_screen
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=SYSTEM>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:pass_first_config_screen
)
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:pass_first_config_screen
)
"tools\python3_scripts\pass_first_configuration_screen_save_rewrite\pass_first_configuration_screen_save_rewrite.exe" -i "%mounted_partition_letter%:\save\8000000000000050" -k "%biskeys_file_path%" >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "pass_first_config_screen_save_modif_error"
	call :unmount_nand_partition
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "unmounting_partition_error"
	)
	goto:pass_first_config_screen
)
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
call "%associed_language_script%" "pass_first_config_screen_save_modif_sucess"
pause
goto:unbrick_menu

:del_parental_control
set input_path=
set biskeys_file_path=
set action_choice=
call "%associed_language_script%" "del_parental_control_begin"
pause
echo.
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:unbrick_menu
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:del_parental_control
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:del_parental_control
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND" set partition=SYSTEM
IF /i "%nand_type%"=="RAWNAND - splitted dump" set partition=SYSTEM
IF /i "%nand_type%"=="FULL NAND" set partition=SYSTEM
IF /i "%nand_type%"=="SYSTEM" set partition=SYSTEM
IF /i NOT "%partition%"=="SYSTEM" (
	call "%associed_language_script%" "partition_should_be_system_error"
	goto:del_parental_control
)
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:del_parental_control
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=SYSTEM>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:del_parental_control
)
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:del_parental_control
)
IF EXIST "%mounted_partition_letter%:\save\8000000000000100" del /q "%mounted_partition_letter%:\save\8000000000000100" >nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "del_parental_control_error"
	call :unmount_nand_partition
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "unmounting_partition_error"
	)
	goto:del_parental_control
)
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
call "%associed_language_script%" "del_parental_control_sucess"
pause
goto:unbrick_menu

:reset_rawnand
set input_path=
set biskeys_file_path=
set action_choice=
call "%associed_language_script%" "reset_rawnand_begin"
pause
echo.
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:unbrick_menu
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:reset_rawnand
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:reset_rawnand
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="FULL NAND" set nand_type=RAWNAND
IF /i NOT "%nand_type%"=="RAWNAND" (
	call "%associed_language_script%" "nand_type_must_be_rawnand_error"
	pause
	goto:reset_rawnand
)
echo.
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:reset_rawnand
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=SYSTEM>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:reset_rawnand
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=USER>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:reset_rawnand
)
set partition=SYSTEM
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:reset_rawnand
)
IF EXIST "%mounted_partition_letter%:\save\8000000000000120" move "%mounted_partition_letter%:\save\8000000000000120" "templogs" >nul
IF EXIST "%mounted_partition_letter%:\save\80000000000000d1" move "%mounted_partition_letter%:\save\80000000000000d1" "templogs" >nul
IF EXIST "%mounted_partition_letter%:\save\8000000000000047" move "%mounted_partition_letter%:\save\8000000000000047" "templogs" >nul
rmdir /s /q "%mounted_partition_letter%:\save" >nul
mkdir "%mounted_partition_letter%:\save" >nul
IF EXIST "templogs\8000000000000120" move "templogs\8000000000000120" ""%mounted_partition_letter%:\save" >nul
IF EXIST "templogs\80000000000000d1" move "templogs\80000000000000d1" "%mounted_partition_letter%:\save" >nul
IF EXIST "templogs\8000000000000047" move "templogs\8000000000000047" "%mounted_partition_letter%:\save" >nul
rmdir /s /q "%mounted_partition_letter%:\saveMeta" >nul
mkdir "%mounted_partition_letter%:\saveMeta" >nul
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
set partition=USER
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:reset_rawnand
)
rmdir /s /q "%mounted_partition_letter%:\Album" >nul
mkdir "%mounted_partition_letter%:\Album" >nul
rmdir /s /q "%mounted_partition_letter%:\Contents" >nul
mkdir "%mounted_partition_letter%:\Contents" >nul
mkdir "%mounted_partition_letter%:\Contents\placehld" >nul
mkdir "%mounted_partition_letter%:\Contents\registered" >nul
rmdir /s /q "%mounted_partition_letter%:\save" >nul
mkdir "%mounted_partition_letter%:\save" >nul
rmdir /s /q "%mounted_partition_letter%:\saveMeta" >nul
mkdir "%mounted_partition_letter%:\saveMeta" >nul
rmdir /s /q "%mounted_partition_letter%:\temp" >nul
mkdir "%mounted_partition_letter%:\temp" >nul
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
call "%associed_language_script%" "reset_rawnand_sucess"
pause
goto:unbrick_menu

:apply_fw_package_on_rawnand
set input_path=
set biskeys_file_path=
set action_choice=
call "%associed_language_script%" "apply_fw_package_on_rawnand_begin"
pause
echo.
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:unbrick_menu
)
call :verif_disk_choice %action_choice%
IF %errorlevel% EQU 3000 (
	goto:apply_fw_package_on_rawnand
)
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:apply_fw_package_on_rawnand
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND - splitted dump" set nand_type=RAWNAND
IF /i "%nand_type%"=="FULL NAND" set nand_type=RAWNAND
IF /i NOT "%nand_type%"=="RAWNAND" (
	call "%associed_language_script%" "nand_type_must_be_rawnand_error"
	pause
	goto:apply_fw_package_on_rawnand
)
echo.
set package_folder_path=
call "%associed_language_script%" "package_folder_choice"
set /p package_folder_path=<templogs\tempvar.txt
IF "%package_folder_path%"=="" (
	call "%associed_language_script%" "package_folder_empty_error"
	pause
	goto:apply_fw_package_on_rawnand
)
IF NOT "%package_folder_path%"=="" set package_folder_path=%package_folder_path%\
IF NOT "%package_folder_path%"=="" set package_folder_path=%package_folder_path:\\=\%
set /a verif_package_folder=0
IF NOT EXIST "%package_folder_path%BOOT0.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%BOOT1.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%BCPKG2-1-Normal-Main.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%BCPKG2-2-Normal-Sub.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%BCPKG2-3-SafeMode-Main.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%BCPKG2-4-SafeMode-Sub.bin" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%SYSTEM\Contents\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%SYSTEM\save\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%USER\Album\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%USER\Contents\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%USER\save\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%USER\saveMeta\*.*" set /a verif_package_folder=1
IF NOT EXIST "%package_folder_path%USER\temp\*.*" set /a verif_package_folder=1
IF %verif_package_folder% NEQ 0 (
	call "%associed_language_script%" "bad_package_folder_error"
	pause
	goto:apply_fw_package_on_rawnand
)
set package_type=
IF EXIST "%package_folder_path%boot.bis" (
	set package_type=CDJ
) else (
	set package_type=EHG
)
set package_flash_type=
call "%associed_language_script%" "package_flash_type_choice"
IF "%package_flash_type%"=="1" goto:package_flash_verif_nand
IF "%package_flash_type%"=="2" goto:package_flash_verif_nand
IF "%package_flash_type%"=="3" goto:package_flash_bcpkg_files
goto:unbrick_menu
:package_flash_verif_nand
call :select_biskeys_file
IF "%biskeys_file_path%"=="" (
	call "%associed_language_script%" "biskeys_file_not_selected_error"
	goto:apply_fw_package_on_rawnand
)
tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=SYSTEM>nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:apply_fw_package_on_rawnand
)
IF "%package_flash_type%"=="1" (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" -part=USER>nul 2>&1
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
		goto:apply_fw_package_on_rawnand
	)
)
:package_flash_bcpkg_files
"tools\NxNandManager\NxNandManager.exe" -i "%input_path%" -o "%package_folder_path%BCPKG2-1-Normal-Main.bin" -part=BCPKG2-1-Normal-Main FORCE>nul 2>&1
"tools\NxNandManager\NxNandManager.exe" -i "%input_path%" -o "%package_folder_path%BCPKG2-2-Normal-Sub.bin" -part=BCPKG2-2-Normal-Sub FORCE>nul 2>&1
"tools\NxNandManager\NxNandManager.exe" -i "%input_path%" -o "%package_folder_path%BCPKG2-3-SafeMode-Main.bin" -part=BCPKG2-3-SafeMode-Main FORCE>nul 2>&1
"tools\NxNandManager\NxNandManager.exe" -i "%input_path%" -o "%package_folder_path%BCPKG2-4-SafeMode-Sub.bin" -part=BCPKG2-4-SafeMode-Sub FORCE>nul 2>&1
IF "%package_flash_type%"=="3" goto:package_flash_end
set partition=SYSTEM
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:apply_fw_package_on_rawnand
)
rmdir /s /q "%mounted_partition_letter%:\Contents" >nul
IF "%package_flash_type%"=="1" (
	rmdir /s /q "%mounted_partition_letter%:\save" >nul
	mkdir "%mounted_partition_letter%:\save" >nul
	rmdir /s /q "%mounted_partition_letter%:\saveMeta" >nul
	mkdir "%mounted_partition_letter%:\saveMeta" >nul
)
%windir%\System32\Robocopy.exe "%package_folder_path%SYSTEM\ " "%mounted_partition_letter%:\ " /e >nul
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
IF "%package_flash_type%"=="2" goto:package_flash_end
	set partition=USER
call :mount_nand_partition "%partition%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "mounting_partition_error"
	goto:apply_fw_package_on_rawnand
)
rmdir /s /q "%mounted_partition_letter%:\Album" >nul
mkdir "%mounted_partition_letter%:\Album" >nul
rmdir /s /q "%mounted_partition_letter%:\Contents" >nul
mkdir "%mounted_partition_letter%:\Contents" >nul
mkdir "%mounted_partition_letter%:\Contents\placehld" >nul
mkdir "%mounted_partition_letter%:\Contents\registered" >nul
rmdir /s /q "%mounted_partition_letter%:\save" >nul
mkdir "%mounted_partition_letter%:\save" >nul
rmdir /s /q "%mounted_partition_letter%:\saveMeta" >nul
mkdir "%mounted_partition_letter%:\saveMeta" >nul
rmdir /s /q "%mounted_partition_letter%:\temp" >nul
mkdir "%mounted_partition_letter%:\temp" >nul
call :unmount_nand_partition
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "unmounting_partition_error"
)
:package_flash_end
IF NOT "%package_flash_type%"=="3" (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -keyset "%biskeys_file_path%" >nul 2>&1
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "decrypt_biskeys_not_valid_warning"
	)
)
echo.
call "%associed_language_script%" "apply_fw_package_on_rawnand_sucess"
pause
goto:unbrick_menu

:get_type_nand
set nand_type=
set nand_file_or_disk=
set nand_encrypted=
set nand_decrypt_OK=
set nand_size=
set nand_autorcm=
set nand_soc_rev=
set nand_bootloader_ver=
set begin_partition_line=
set nand_backup_gpt=
set nand_serial_number=
set nand_device_id=
set nand_mac_address=
set nand_firmware_ver=
set nand_exfat_driver=
set nand_last_boot=
set nand_sectors_interval=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" %biskeys_param% >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
tools\gnuwin32\bin\grep.exe "File/Disk" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_file_or_disk=<templogs\tempvar.txt
set nand_file_or_disk=%nand_file_or_disk:~1%
IF /i "%nand_type%"=="FULL NAND" (
	set temp_nand_file_or_disk=%nand_file_or_disk%
	echo !temp_nand_file_or_disk! | tools\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
	set /p nand_file_or_disk=<templogs\tempvar.txt
		echo !temp_nand_file_or_disk! | tools\gnuwin32\bin\cut.exe -d ( -f 2 >templogs\tempvar.txt
	set /p nand_sectors_interval=<templogs\tempvar.txt
	set nand_sectors_interval=!nand_sectors_interval:~0,-1!
)
tools\gnuwin32\bin\grep.exe "Encrypted " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_encrypted=<templogs\tempvar.txt
set nand_encrypted=!nand_encrypted:~1!
IF "%nand_encrypted%"=="Yes" (
	set nand_decrypt_OK=1
) else IF "%nand_encrypted%"=="No" (
	set nand_decrypt_OK=1
) else (
	set nand_decrypt_OK=0
	set nand_encrypted=Yes
)
tools\gnuwin32\bin\grep.exe "Size " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_size=<templogs\tempvar.txt
set nand_size=%nand_size:~1%
IF "%nand_type%"=="BOOT0" (
	tools\gnuwin32\bin\grep.exe "AutoRCM " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_autorcm=<templogs\tempvar.txt
	set nand_autorcm=!nand_autorcm:~1!
	tools\gnuwin32\bin\grep.exe "SoC revision " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_soc_rev=<templogs\tempvar.txt
	set nand_soc_rev=!nand_soc_rev:~1!
	tools\gnuwin32\bin\grep.exe "Bootloader ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_bootloader_ver=<templogs\tempvar.txt
	set nand_bootloader_ver=!nand_bootloader_ver:~1!
	tools\gnuwin32\bin\grep.exe "Firmware ver. " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_firmware_ver=<templogs\tempvar.txt
	set nand_firmware_ver=!nand_firmware_ver:~1!
)
IF "%nand_type%"=="RAWNAND" (
	tools\gnuwin32\bin\grep.exe -E -n "^^Partitions" <"templogs\infos_nand.txt" |tools\gnuwin32\bin\cut.exe -d : -f 1 >templogs\tempvar.txt
	set /p begin_partition_line=<templogs\tempvar.txt
	tools\gnuwin32\bin\grep.exe "Backup GPT " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_backup_gpt=<templogs\tempvar.txt
		set nand_backup_gpt=!nand_backup_gpt:~1!
		IF "!nand_backup_gpt:~0,5!"=="FOUND" (
		echo !nand_backup_gpt!|tools\gnuwin32\bin\cut.exe -d ^( -f 2 >templogs\tempvar.txt
		set /p nand_backup_gpt=<templogs\tempvar.txt
		) else (
		set nand_backup_gpt=0
		)
	IF "%nand_encrypted%"=="No" (
		tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_firmware_ver=<templogs\tempvar.txt
		set nand_firmware_ver=!nand_firmware_ver:~1!
		tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_exfat_driver=<templogs\tempvar.txt
		set nand_exfat_driver=!nand_exfat_driver:~1!
		tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
		set /p nand_last_boot=<templogs\tempvar.txt
		set nand_last_boot=!nand_last_boot:~1!
		tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_serial_number=<templogs\tempvar.txt
		set nand_serial_number=!nand_serial_number:~1!
		tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_device_id=<templogs\tempvar.txt
		set nand_device_id=!nand_device_id:~1!
		tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_mac_address=<templogs\tempvar.txt
		set nand_mac_address=!nand_mac_address:~1!
	) else IF "%nand_encrypted%"=="Yes" (
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Firmware ver" <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_firmware_ver=<templogs\tempvar.txt
			set nand_firmware_ver=!nand_firmware_ver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "ExFat driver " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_exfat_driver=<templogs\tempvar.txt
			set nand_exfat_driver=!nand_exfat_driver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Last boot " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
			set /p nand_last_boot=<templogs\tempvar.txt
			set nand_last_boot=!nand_last_boot:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Serial number " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_serial_number=<templogs\tempvar.txt
			set nand_serial_number=!nand_serial_number:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Device Id " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_device_id=<templogs\tempvar.txt
			set nand_device_id=!nand_device_id:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "MAC Address " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_mac_address=<templogs\tempvar.txt
			set nand_mac_address=!nand_mac_address:~1!
		)
	)
)
IF "%nand_type%"=="RAWNAND - splitted dump" (
	tools\gnuwin32\bin\grep.exe -E -n "^^Partitions" <"templogs\infos_nand.txt" |tools\gnuwin32\bin\cut.exe -d : -f 1 >templogs\tempvar.txt
	set /p begin_partition_line=<templogs\tempvar.txt
	tools\gnuwin32\bin\grep.exe "Backup GPT " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_backup_gpt=<templogs\tempvar.txt
		set nand_backup_gpt=!nand_backup_gpt:~1!
		IF "!nand_backup_gpt:~0,5!"=="FOUND" (
		echo !nand_backup_gpt!|tools\gnuwin32\bin\cut.exe -d ^( -f 2 >templogs\tempvar.txt
		set /p nand_backup_gpt=<templogs\tempvar.txt
		) else (
		set nand_backup_gpt=0
		)
	IF "%nand_encrypted%"=="No" (
		tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_firmware_ver=<templogs\tempvar.txt
		set nand_firmware_ver=!nand_firmware_ver:~1!
		tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_exfat_driver=<templogs\tempvar.txt
		set nand_exfat_driver=!nand_exfat_driver:~1!
		tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
		set /p nand_last_boot=<templogs\tempvar.txt
		set nand_last_boot=!nand_last_boot:~1!
		tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_serial_number=<templogs\tempvar.txt
		set nand_serial_number=!nand_serial_number:~1!
		tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_device_id=<templogs\tempvar.txt
		set nand_device_id=!nand_device_id:~1!
		tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_mac_address=<templogs\tempvar.txt
		set nand_mac_address=!nand_mac_address:~1!
	) else IF "%nand_encrypted%"=="Yes" (
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Firmware ver" <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_firmware_ver=<templogs\tempvar.txt
			set nand_firmware_ver=!nand_firmware_ver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "ExFat driver " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_exfat_driver=<templogs\tempvar.txt
			set nand_exfat_driver=!nand_exfat_driver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Last boot " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
			set /p nand_last_boot=<templogs\tempvar.txt
			set nand_last_boot=!nand_last_boot:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Serial number " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_serial_number=<templogs\tempvar.txt
			set nand_serial_number=!nand_serial_number:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Device Id " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_device_id=<templogs\tempvar.txt
			set nand_device_id=!nand_device_id:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "MAC Address " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_mac_address=<templogs\tempvar.txt
			set nand_mac_address=!nand_mac_address:~1!
		)
	)
)
IF "%nand_type%"=="FULL NAND" (
	tools\gnuwin32\bin\grep.exe "AutoRCM " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_autorcm=<templogs\tempvar.txt
	set nand_autorcm=!nand_autorcm:~1!
	tools\gnuwin32\bin\grep.exe "SoC revision " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_soc_rev=<templogs\tempvar.txt
	set nand_soc_rev=!nand_soc_rev:~1!
	tools\gnuwin32\bin\grep.exe "Bootloader ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_bootloader_ver=<templogs\tempvar.txt
	set nand_bootloader_ver=!nand_bootloader_ver:~1!
	tools\gnuwin32\bin\grep.exe -E -n "^^Partitions" <"templogs\infos_nand.txt" |tools\gnuwin32\bin\cut.exe -d : -f 1 >templogs\tempvar.txt
	set /p begin_partition_line=<templogs\tempvar.txt
	tools\gnuwin32\bin\grep.exe "Backup GPT " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
	set /p nand_backup_gpt=<templogs\tempvar.txt
		set nand_backup_gpt=!nand_backup_gpt:~1!
		IF "!nand_backup_gpt:~0,5!"=="FOUND" (
		echo !nand_backup_gpt!|tools\gnuwin32\bin\cut.exe -d ^( -f 2 >templogs\tempvar.txt
		set /p nand_backup_gpt=<templogs\tempvar.txt
		) else (
		set nand_backup_gpt=0
		)
	IF "%nand_encrypted%"=="No" (
		tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_firmware_ver=<templogs\tempvar.txt
		set nand_firmware_ver=!nand_firmware_ver:~1!
		tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_exfat_driver=<templogs\tempvar.txt
		set nand_exfat_driver=!nand_exfat_driver:~1!
		tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
		set /p nand_last_boot=<templogs\tempvar.txt
		set nand_last_boot=!nand_last_boot:~1!
		tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_serial_number=<templogs\tempvar.txt
		set nand_serial_number=!nand_serial_number:~1!
		tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_device_id=<templogs\tempvar.txt
		set nand_device_id=!nand_device_id:~1!
		tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_mac_address=<templogs\tempvar.txt
		set nand_mac_address=!nand_mac_address:~1!
	) else IF "%nand_encrypted%"=="Yes" (
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Firmware ver" <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_firmware_ver=<templogs\tempvar.txt
			set nand_firmware_ver=!nand_firmware_ver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "ExFat driver " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_exfat_driver=<templogs\tempvar.txt
			set nand_exfat_driver=!nand_exfat_driver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Last boot " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
			set /p nand_last_boot=<templogs\tempvar.txt
			set nand_last_boot=!nand_last_boot:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Serial number " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_serial_number=<templogs\tempvar.txt
			set nand_serial_number=!nand_serial_number:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Device Id " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_device_id=<templogs\tempvar.txt
			set nand_device_id=!nand_device_id:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "MAC Address " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_mac_address=<templogs\tempvar.txt
			set nand_mac_address=!nand_mac_address:~1!
		)
	)
)
IF "%nand_type%"=="PRODINFO" (
	IF "%nand_encrypted%"=="No" (
		tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_serial_number=<templogs\tempvar.txt
		set nand_serial_number=!nand_serial_number:~1!
		tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_device_id=<templogs\tempvar.txt
		set nand_device_id=!nand_device_id:~1!
		tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_mac_address=<templogs\tempvar.txt
		set nand_mac_address=!nand_mac_address:~1!
	) else IF "%nand_encrypted%"=="Yes" (
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Serial number " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Serial number " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_serial_number=<templogs\tempvar.txt
			set nand_serial_number=!nand_serial_number:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Device Id " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Device Id " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_device_id=<templogs\tempvar.txt
			set nand_device_id=!nand_device_id:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "MAC Address " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "MAC Address " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_mac_address=<templogs\tempvar.txt
			set nand_mac_address=!nand_mac_address:~1!
		)
	)
)
IF "%nand_type%"=="SYSTEM" (
	IF "%nand_encrypted%"=="No" (
		tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_firmware_ver=<templogs\tempvar.txt
		set nand_firmware_ver=!nand_firmware_ver:~1!
		tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
		set /p nand_exfat_driver=<templogs\tempvar.txt
		set nand_exfat_driver=!nand_exfat_driver:~1!
		tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
		set /p nand_last_boot=<templogs\tempvar.txt
		set nand_last_boot=!nand_last_boot:~1!
	) else IF "%nand_encrypted%"=="Yes" (
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Firmware ver" <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Firmware ver" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_firmware_ver=<templogs\tempvar.txt
			set nand_firmware_ver=!nand_firmware_ver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "ExFat driver " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "ExFat driver " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
			set /p nand_exfat_driver=<templogs\tempvar.txt
			set nand_exfat_driver=!nand_exfat_driver:~1!
		)
		set temp_count=
		tools\gnuwin32\bin\grep.exe -c "Last boot " <"templogs\infos_nand.txt" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			tools\gnuwin32\bin\grep.exe "Last boot " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2- >templogs\tempvar.txt
			set /p nand_last_boot=<templogs\tempvar.txt
			set nand_last_boot=!nand_last_boot:~1!
		)
	)
)
IF "%~2"=="display" (
	call "%associed_language_script%" "display_infos_nand"
)
exit /B

:list_disk
IF EXIST templogs\disks_list.txt del /q templogs\disks_list.txt
tools\NxNandManager\NxNandManager.exe --list >templogs\temp_disks_list.txt
if %errorlevel% EQU -1009 (
	del /q templogs\temp_disks_list.txt
	exit /B
)
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\temp_disks_list.txt > templogs\tempvar.txt
set /p count_disks=<templogs\tempvar.txt
set /a temp_count_disks=0
set /a real_count=0
copy nul templogs\disks_list.txt >nul
:disks_listing
set /a temp_count_disks+=1
IF %temp_count_disks% GTR %count_disks% (
	goto:finish_disks_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_disks%p <templogs\temp_disks_list.txt >templogs\tempvar.txt
set /p temp_disk=<templogs\tempvar.txt
IF NOT "%temp_disk:~0,4%" == "\\.\" goto:disks_listing
echo %temp_disk% | tools\gnuwin32\bin\cut.exe -d [ -f 1 >templogs\tempvar.txt
set /p temp_disk=<templogs\tempvar.txt
set temp_disk=%temp_disk: =%
call :get_type_nand "%temp_disk%"
echo %temp_disk%>>templogs\disks_list.txt
set /a real_count=%real_count%+1
echo %real_count%: %temp_disk%; %nand_type%
goto:disks_listing
:finish_disks_listing
del /q templogs\temp_disks_list.txt
exit /b

:nand_file_input_select
set input_path=
call "%associed_language_script%" "nand_file_select_choice"
set /p input_path=<templogs\tempvar.txt
exit /b

:nand_file_output_select
set output_path=
call "%associed_language_script%" "nand_file_select_choice"
set /p output_path=<templogs\tempvar.txt
exit /b

:select_biskeys_file
set biskeys_path=
call "%associed_language_script%" "biskeys_file_select_choice"
set /p biskeys_file_path=<templogs\tempvar.txt
exit /b

:verif_disk_choice
set choice=%~1
call TOOLS\Storage\functions\strlen.bat nb "%choice%"
set i=0
:check_chars_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "nand_choice_char_error"
	exit /b 3000
	)
)
exit /b 0

:partition_select
set partition=
set choose_partition=
IF "%~1"=="all_partitions_excepted" (
	set except_all=Y
) else (
	set except_all=
)
call "%associed_language_script%" "partition_choice_begin"
echo 1: PRODINFO.
echo 2: PRODINFOF.
IF NOT "%~1" == "brute_force_choice" echo 3: BCPKG2-1-Normal-Main
IF NOT "%~1" == "brute_force_choice" echo 4: BCPKG2-2-Normal-Sub
IF NOT "%~1" == "brute_force_choice" echo 5: BCPKG2-3-SafeMode-Main
IF NOT "%~1" == "brute_force_choice" echo 6: BCPKG2-4-SafeMode-Sub
IF NOT "%~1" == "brute_force_choice" echo 7: BCPKG2-5-Repair-Main
IF NOT "%~1" == "brute_force_choice" echo 8: BCPKG2-6-Repair-Sub
echo 9: SAFE
echo 10: SYSTEM
echo 11: USER
IF "%~1"=="full_nand_choice" (
	echo 12: BOOT0
	echo 13: BOOT1
	echo 14: RAWNAND
)
call "%associed_language_script%" "partition_choice"
IF "%choose_partition%"=="" exit /b 3001
call :verif_disk_choice %choose_partition%
IF %errorlevel% EQU 3000 (
	goto:partition_select
)
IF "%except_all%"=="Y" (
	IF %choose_partition% EQU 0 (
		call "%associed_language_script%" "bad_value"
		goto:partition_select
	)
)
IF "%~1"=="full_nand_choice" (
	IF %choose_partition% GTR 14 (
		call "%associed_language_script%" "bad_value"
		goto:partition_select
	)
) else (
	IF %choose_partition% GTR 11 (
		call "%associed_language_script%" "bad_value"
		goto:partition_select
	)
)
IF %choose_partition% EQU 1 set partition=PRODINFO
IF %choose_partition% EQU 2 set partition=PRODINFOF
IF %choose_partition% EQU 3 set partition=BCPKG2-1-Normal-Main
IF %choose_partition% EQU 4 set partition=BCPKG2-2-Normal-Sub
IF %choose_partition% EQU 5 set partition=BCPKG2-3-SafeMode-Main
IF %choose_partition% EQU 6 set partition=BCPKG2-4-SafeMode-Sub
IF %choose_partition% EQU 7 set partition=BCPKG2-5-Repair-Main
IF %choose_partition% EQU 8 set partition=BCPKG2-6-Repair-Sub
IF %choose_partition% EQU 9 set partition=SAFE
IF %choose_partition% EQU 10 set partition=SYSTEM
IF %choose_partition% EQU 11 set partition=USER
IF %choose_partition% EQU 12 set partition=BOOT0
IF %choose_partition% EQU 13 set partition=BOOT1
IF %choose_partition% EQU 14 set partition=RAWNAND
exit /b 0

:set_NNM_params
set params=
set lflags=
set force_option=
set skip_md5=
set debug_option=
IF NOT "%partition%"=="" set params=-part=%partition% 
call "%associed_language_script%" "force_param_choice"
IF NOT "%force_option%"=="" set force_option=%force_option:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "force_option" "o/n_choice"
IF /i "%force_option%"=="o" (
	set lflags=%lflags%FORCE 
)
call "%associed_language_script%" "skipmd5_param_choice"
IF NOT "%skip_md5%"=="" set skip_md5=%skip_md5:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "skip_md5" "o/n_choice"
IF /i "%skip_md5%"=="o" (
	set lflags=%lflags%BYPASS_MD5SUM 
)
call "%associed_language_script%" "debug_param_choice"
IF NOT "%debug_option%"=="" set debug_option=%debug_option:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "debug_option" "o/n_choice"
IF /i "%debug_option%"=="o" (
	set lflags=%lflags%DEBUG_MODE 
)
IF /i "%zip_param%"=="o" (
	set lflags=%lflags%ZIP 
)
IF NOT "%split_param%"=="" (
	set params=%split_param%%params%
)
exit /b

:set_debug_param_only
set debug_option=
call "%associed_language_script%" "debug_param_choice"
IF NOT "%debug_option%"=="" set debug_option=%debug_option:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "debug_option" "o/n_choice"
exit /b

:set_nnm_passthrough_0_param
set passthrough_0_option=
call "%associed_language_script%" "passthrough_0_option_choice"
IF NOT "%passthrough_0_option%"=="" set passthrough_0_option=%passthrough_0_option:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "passthrough_0_option" "o/n_choice"
IF /i "%passthrough_0_option%"=="o" (
	IF "%biskeys_file_path%"=="" (
		call :get_type_nand "%input_path%"
		IF /i "!nand_encrypted:~0,3!"=="Yes" (
			call :select_biskeys_file
			IF "!biskeys_file_path!"=="" (
				call "%associed_language_script%" "biskeys_file_not_selected_error"
				goto:set_nnm_passthrough_0_param
			)
			tools\NxNandManager\NxNandManager.exe --crypto_check -i "%input_path%" -biskey "!biskeys_file_path!" >nul 2>&1
			IF !errorlevel! NEQ 0 (
				call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
				set biskeys_file_path=
				goto:set_nnm_passthrough_0_param
			) else (
				set params=-keyset "!biskeys_file_path!" %params%
			)
		)
	)
	set lflags=%lflags%PASSTHROUGH_0 
)
exit /b

:set_nnm_split_param
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="BOOT0" exit /b
IF /i "%nand_type%"=="BOOT1" exit /b

IF /i "%nand_type%"=="PRODINFO" exit /b
IF /i "%nand_type%"=="PRODINFOF" exit /b
IF /i "%nand_type%"=="BCPKG2-1-Normal-Main" exit /b
IF /i "%nand_type%"=="BCPKG2-2-Normal-Sub" exit /b
IF /i "%nand_type%"=="BCPKG2-3-SafeMode-Main" exit /b
IF /i "%nand_type%"=="BCPKG2-4-SafeMode-Sub" exit /b
IF /i "%nand_type%"=="BCPKG2-5-Repair-Main" exit /b
IF /i "%nand_type%"=="BCPKG2-6-Repair-Sub" exit /b
IF /i "%nand_type%"=="SAFE" exit /b
IF NOT "%partition%"=="" (
	IF "%choose_partition%"=="1" exit /b
	IF "%choose_partition%"=="2" exit /b
	IF "%choose_partition%"=="3" exit /b
	IF "%choose_partition%"=="4" exit /b
	IF "%choose_partition%"=="5" exit /b
	IF "%choose_partition%"=="6" exit /b
	IF "%choose_partition%"=="7" exit /b
	IF "%choose_partition%"=="8" exit /b
	IF "%choose_partition%"=="9" exit /b
	IF "%choose_partition%"=="12" exit /b
	IF "%choose_partition%"=="13" exit /b
)
set nnm_split_option=
call "%associed_language_script%" "nnm_split_option_choice"
IF NOT "%nnm_split_option%"=="" set nnm_split_option=%nnm_split_option:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "nnm_split_option" "o/n_choice"
:define_nnm_split_size_option
set nnm_split_size_option=4096
IF /i "%nnm_split_option%"=="o" (
	call "%associed_language_script%" "nnm_split_size_option_choice"
) else (
	exit /b
)
IF "%nnm_split_size_option%"=="0" goto:set_nnm_split_param
call TOOLS\Storage\functions\strlen.bat nb "%nnm_split_size_option%"
set i=0
:check_chars_nnm_split_size_option
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!nnm_split_size_option:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_nnm_split_size_option
		)
	)
	call "%associed_language_script%" "nand_choice_char_error"
	goto:define_nnm_split_size_option
)
IF %nnm_split_size_option% LSS 300 (
	call "%associed_language_script%" "nnm_split_size_option_to_small_error"
	goto:define_nnm_split_size_option
)
set split_param=-split=%nnm_split_size_option% 
exit /b

:get_base_folder_path_of_a_file_path
set base_folder_path_of_a_file_path=
set base_folder_path_of_a_file_path=%~dp1
exit /b

:mount_nand_partition
::set mounted_partition_process_id=
IF NOT "%mounted_partition_letter%"=="" (
	tools\NxNandManager\dokan_x86\dokanctl.exe /u %mounted_partition_letter%
	IF !errorlevel! NEQ 0 (
		set mounted_partition_letter=
		exit /b 400
	)
)
call :find_not_used_disk_letter
start %windir%\system32\wscript.exe //Nologo tools\NxNandManager\mount_nand.vbs "%input_path%" "%biskeys_file_path%" "%mounted_partition_letter%" "%~1" "templogs\mounted_partition.txt" "templogs\mounted_partition_process_id.txt"
"%windir%\system32\timeout.exe" /t 2 /nobreak >nul
:test_mount_launch
IF NOT EXIST "%mounted_partition_letter%:\" (
	IF EXIST "templogs\mounted_partition_process_id.txt" (
		"%windir%\system32\timeout.exe" /t 1 /nobreak >nul
		tools\gnuwin32\bin\tail.exe -n-1 <templogs\mounted_partition.txt >templogs\tempvar.txt
		set /p temp_line=<templogs\tempvar.txt
		IF "!temp_line:~0,10!"=="Partition " exit /b
		goto:test_mount_launch
	) else (
		exit /b 401
	)
)
::set /p mounted_partition_process_id=<templogs\mounted_partition_process_id.txt
::IF "%mounted_partition_process_id%"=="" (
	::exit /b 402
::)
exit /b

:unmount_nand_partition
IF "%mounted_partition_letter%"=="" (
	exit /b 400
)
tools\NxNandManager\dokan_x86\dokanctl.exe /u %mounted_partition_letter% >nul 2>&1
::start tools\NxNandManager\windows-kill.exe -SIGBREAK %mounted_partition_process_id%
"%windir%\system32\timeout.exe" /t 5 /nobreak >nul
IF NOT EXIST "%mounted_partition_letter%:\" (
	set mounted_partition_letter=
	set mounted_partition_process_id=
) else (
	exit /b 401
)
exit /b

:find_not_used_disk_letter
FOR %%z IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
	IF NOT EXIST "%%z:\" (
		set mounted_partition_letter=%%z
		exit /b
	)
)
exit /b 400

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal