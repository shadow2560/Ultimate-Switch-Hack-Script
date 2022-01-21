::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
:begin_script
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
IF NOT EXIST sd_user\*.* (
	mkdir sd_user
)
call "%associed_language_script%" "display_title"
set error_level=0
call "%associed_language_script%" "intro"
pause
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
set disk_not_finded_choice=
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	IF /i "!disk_not_finded_choice!"=="r" (
		goto:define_volume_letter
	) else IF /i "!disk_not_finded_choice!"=="d" (
		call "%associed_language_script%" "select_folder_choice"
		set /p volume_letter=<templogs\tempvar.txt
		IF "!volume_letter!"=="" goto:define_volume_letter
		goto:copy_to_sd
	) else (
		goto:endscript2
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
echo.
echo.
set volume_letter=
call "%associed_language_script%" "disk_choice"
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	call "%associed_language_script%" "disk_choice_empty_error"
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:endscript2
IF "%volume_letter%"=="1" (
	call "%associed_language_script%" "select_folder_choice"
	set /p volume_letter=<templogs\tempvar.txt
	IF "!volume_letter!"=="" goto:define_volume_letter
	goto:copy_to_sd
)
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
	call "%associed_language_script%" "disk_choice_not_in_list_error"
	goto:define_volume_letter
)
set format_choice=
call "%associed_language_script%" "disk_format_choice"
IF NOT "%format_choice%"=="" set format_choice=%format_choice:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "format_choice" "o/n_choice"
IF /i "%format_choice%"=="o" (
	echo.
	set format_type=
	call "%associed_language_script%" "disk_format_type_choice"
) else (
	goto:copy_to_sd
)
IF "%format_type%"=="1" goto:format_exfat
IF "%format_type%"=="2" goto:format_fat32
goto:copy_to_sd
:format_exfat
call "%associed_language_script%" "disk_formating_begin"
echo.
chcp 850 >nul
format %volume_letter%: /X /Q /FS:EXFAT
IF %errorlevel% NEQ 0 (
	chcp 65001 >nul
	call "%associed_language_script%" "disk_formating_error"
	goto:endscript
) else (
chcp 65001 >nul
	call "%associed_language_script%" "disk_formating_success"
	echo.
	goto:copy_to_sd
)
:format_fat32
call "%associed_language_script%" "disk_formating_begin"
echo.
TOOLS\fat32format\fat32format.exe -q -c128 %volume_letter%
echo.
IF "%ERRORLEVEL%"=="5" (
	call "%associed_language_script%" "disk_formating_fat32_not_admin_error"
	::echo.
	goto:copy_to_sd
)
IF "%ERRORLEVEL%"=="32" (
	call "%associed_language_script%" "disk_formating_fat32_disk_used_error"
	goto:endscript
)
IF "%ERRORLEVEL%"=="2" (
	call "%associed_language_script%" "disk_formating_fat32_disk_not_exist_error"
	goto:endscript
)
IF NOT "%ERRORLEVEL%"=="1" (
	IF NOT "%ERRORLEVEL%"=="0" (
		call "%associed_language_script%" "disk_formating_fat32_unknown_error"
		goto:endscript
	)
)
IF "%ERRORLEVEL%"=="1" (
	call "%associed_language_script%" "disk_formating_fat32_canceled_info"
)
IF "%ERRORLEVEL%"=="0" (
	call "%associed_language_script%" "disk_formating_success"
)
:copy_to_sd
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 1 (
	set volume_letter=%volume_letter%:
) else (
	IF "%volume_letter:~-1,1%"=="\" set volume_letter=%volume_letter:~0,-1%
)
set sx_core_lite_chip=
set mariko_console=
set sx_launcher_use=
call "%associed_language_script%" "sx_core_lite_chip_choice"
IF NOT "%sx_core_lite_chip%"=="" set sx_core_lite_chip=%sx_core_lite_chip:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "sx_core_lite_chip" "o/n_choice"
IF /i "%sx_core_lite_chip%"=="o" (
	call "%associed_language_script%" "mariko_console_choice"
	IF NOT "!mariko_console!"=="" set mariko_console=!mariko_console:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "mariko_console" "o/n_choice"
) else (
	call "%associed_language_script%" "sx_launcher_use_choice"
	IF NOT "!sx_launcher_use!"=="" set sx_launcher_use=!sx_launcher_use:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "sx_launcher_use" "o/n_choice"
)
:firmware_copy_choice
set firmware_copy=
set firmware_folder=
set firmware_choice=
call "%associed_language_script%" "firmware_copy_choice"
IF NOT "%firmware_copy%"=="" set firmware_copy=%firmware_copy:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "firmware_copy" "o/n_choice"
IF /i NOT "%firmware_copy%"=="o" goto:define_general_select_profile
call tools\storage\prepare_update_on_sd.bat "firmware_download_and_extract"
call "%associed_language_script%" "display_title"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:define_general_select_profile
)
IF EXIST "templogs\firmware_folder.txt" (
	set /p firmware_folder=<templogs\firmware_folder.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:define_general_select_profile
)
IF NOT EXIST "%firmware_folder%*.*" (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	set firmware_folder=
	goto:define_general_select_profile
)
IF EXIST "templogs\firmware_chosen.txt" (
	set /p firmware_choice=<templogs\firmware_chosen.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	set firmware_folder=
	goto:define_general_select_profile
)
call :daybreak_convertion "%firmware_folder%"
:define_general_select_profile
IF "%firmware_folder%"=="" set firmware_copy=
IF "%firmware_choice%"=="" set firmware_copy=
echo.
call "%associed_language_script%" "general_profile_select_begin"
set /a temp_count=0
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\profiles\*.bat" (
	goto:general_no_profile_created
)
cd tools\sd_switch\profiles
for %%p in (*.bat) do (
	IF %%~zp EQU 0 (
		del /q %%p >nul
	) else (
		set /a temp_count+=1
		set temp_profilename=%%p
		set temp_profilename=!temp_profilename:~0,-4!
		echo !temp_count!: !temp_profilename!
		echo %%p>> ..\..\..\templogs\profiles_list.txt
	)
)
cd ..\..\..
:general_no_profile_created
set /a count_default_profile=%temp_count%
IF EXIST "tools\default_configs\general_profile_all.bat" (
	set /a general_profile_number=1
	set /a general_profile_number+=%temp_count%
	set /a count_default_profile+=1
	call "%associed_language_script%" "general_profile_select_atmosphere_and_sxos_recommanded_profile_display"
) else (
	set general_no_default_config=Y
)
IF EXIST "tools\default_configs\atmosphere_profile_all.bat" (
	IF "%general_no_default_config%"=="Y" (
		set /a atmosphere_profile_number=1
	) else (
		set /a atmosphere_profile_number=2
	)
	set /a atmosphere_profile_number+=%temp_count%
	set /a count_default_profile+=1
	call "%associed_language_script%" "general_profile_select_atmosphere_recommanded_profile_display"
) else (
	set atmosphere_no_default_config=Y
)
IF EXIST "tools\default_configs\sxos_profile_all.bat" (
	IF "%general_no_default_config%"=="Y" (
		IF "%atmosphere_no_default_config%"=="Y" (
			set /a sxos_profile_number=1
		)
	) else IF "%atmosphere_no_default_config%"=="Y" (
		set /a sxos_profile_number=2
	) else (
		set /a sxos_profile_number=3
	)
	IF "%atmosphere_no_default_config%"=="Y" (
		IF "%general_no_default_config%"=="Y" (
			set /a sxos_profile_number=1
		)
	) else IF "%general_no_default_config%"=="Y" (
		set /a sxos_profile_number=2
	) else (
		set /a sxos_profile_number=3
	)
	set /a sxos_profile_number+=%temp_count%
	set /a count_default_profile+=1
	call "%associed_language_script%" "general_profile_select_sxos_recommanded_profile_display"
) else (
	set sxos_no_default_config=Y
)
set general_profile_path=
set general_profile=
call "%associed_language_script%" "general_profile_choice"
IF /i "%general_profile%"=="e" goto:endscript2
IF "%general_profile%"=="" (
	set pass_copy_general_pack=Y
	goto:skip_verif_general_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%general_profile%"
set i=0
:check_chars_general_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!general_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_general_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_general_pack=Y
		goto:skip_verif_general_profile
	)
)
IF %general_profile% GTR %count_default_profile% (
	set pass_copy_general_pack=Y
		goto:skip_verif_general_profile
)
IF "%general_profile%"=="0" (
	call tools\Storage\prepare_sd_switch_profiles_management.bat
	call "%associed_language_script%" "display_title"
	goto:define_general_select_profile
)
IF %general_profile% EQU %general_profile_number% (
	IF NOT "%general_no_default_config%"=="Y" (
		set pass_prepare_packs=Y
		set general_profile_path=tools\default_configs\general_profile_all.bat
		goto:skip_verif_general_profile
	)
)
IF %general_profile% EQU %atmosphere_profile_number% (
	IF NOT "%atmosphere_no_default_config%"=="Y" (
		set pass_prepare_packs=Y
		set general_profile_path=tools\default_configs\atmosphere_profile_all.bat
		goto:skip_verif_general_profile
	)
)
rem IF %general_profile% EQU %sxos_profile_number% (
	rem IF NOT "%sxos_no_default_config%"=="Y" (
		rem set pass_prepare_packs=Y
		rem set general_profile_path=tools\default_configs\sxos_profile_all.bat
		rem goto:skip_verif_general_profile
	rem )
rem )
TOOLS\gnuwin32\bin\sed.exe -n %general_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p general_profile_path=<templogs\tempvar.txt
set general_profile_path=tools\sd_switch\profiles\%general_profile_path%
set pass_prepare_packs=Y
:skip_verif_general_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF NOT "%pass_prepare_packs%"=="Y" (
	call tools\Storage\prepare_sd_switch_files_questions.bat
	call "%associed_language_script%" "display_title"
	IF "%language_important_error%"=="Y" goto:endscript2
	goto:test_copy_launch
) else (
	IF EXIST "%general_profile_path%" (
		call "%general_profile_path%"
	)
)

IF "%atmosphere_emummc_profile_path%"=="" set atmosphere_pass_copy_emummc_pack=Y
IF "%atmosphere_modules_profile_path%"=="" set atmosphere_pass_copy_modules_pack=Y
IF "%reinx_modules_profile_path%"=="" set reinx_pass_copy_modules_pack=Y
IF "%sxos_modules_profile_path%"=="" set sxos_pass_copy_modules_pack=Y
IF "%emu_profile_path%"=="" set pass_copy_emu_pack=Y
IF "%mixed_profile_path%"=="" set pass_copy_mixed_pack=Y
IF "%overlays_profile_path%"=="" set pass_copy_overlays_pack=Y
IF "%salty-nx_profile_path%"=="" set pass_copy_salty-nx_pack=Y
IF "%cheats_profile_path%"=="" (
	IF NOT "%copy_all_cheats_pack%"=="Y" (
		set copy_cheats=
		set atmosphere_enable_cheats=
		set sxos_enable_cheats=
	)
)
IF /i NOT "%sd_folder_structure_to_copy_choice%"=="o" (
	set sd_folder_structure_to_copy_choice=n
)
IF "%sd_folder_structure_to_copy_path%"=="" set sd_folder_structure_to_copy_choice=n
IF NOT EXIST "%sd_folder_structure_to_copy_path%\*.*" set sd_folder_structure_to_copy_choice=n

set sx_gear_present_on_sd=
IF EXIST "%volume_letter%\boot.dat" (
	TOOLS\gnuwin32\bin\md5sum.exe "%volume_letter%\boot.dat" | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
	set /p md5_verif=<templogs\tempvar.txt
	IF /i "!md5_verif!"=="20cf385a492fb0058f39f183ed1ed104" (
		set sx_gear_present_on_sd=Y
	)
)
set sx_gear_copy=
set copy_sxos_boot=
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%sx_core_lite_chip%"=="o" (
		IF /I "%mariko_console%"=="o" (
			IF /i NOT "%copy_sxos_pack%"=="o" (
				IF NOT EXIST "%volume_letter%\boot.dat" (
					set sx_gear_copy=Y
				) else (
					IF NOT "%sx_gear_present_on_sd%"=="Y" (
						call "%associed_language_script%" "sx_gear_force_copy"
						IF NOT "!sx_gear_copy!"=="" set sx_gear_copy=!sx_gear_copy:~0,1!
						call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "sx_gear_copy" "o/n_choice"
						IF /i "!sx_gear_copy!"=="o" set sx_gear_copy=Y
					)
				)
			)
		)
	)
)
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%sx_core_lite_chip%"=="o" (
		IF /I NOT "%mariko_console%"=="o" (
			IF /i NOT "%copy_sxos_pack%"=="o" (
				IF NOT "%sx_gear_copy%"=="Y" (
					set copy_sxos_boot=Y
				)
			)
		)
	)
)
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%sx_launcher_use%"=="o" (
		IF /i NOT "%copy_sxos_pack%"=="o" (
			set sx_gear_copy=Y
		)
	)
)

IF /i "%copy_atmosphere_pack%"=="o" (
	IF NOT "%atmosphere_pass_copy_modules_pack%"=="Y" (
		IF NOT "%atmosphere_modules_profile_path%"=="" (
			IF NOT EXIST "%atmosphere_modules_profile_path%" (
				set error_level=404
			)
		)
	)
)
IF /i "%copy_reinx_pack%"=="o" (
	IF NOT "%reinx_pass_copy_modules_pack%"=="Y" (
		IF NOT "%reinx_modules_profile_path%"=="" (
			IF NOT EXIST "%reinx_modules_profile_path%" (
				set error_level=404
			)
		)
	)
)
IF /i "%copy_emu%"=="o" (
	IF NOT "%pass_copy_emu_pack%"=="Y" (
		IF NOT "%emu_profile_path%"=="" (
			IF NOT EXIST "%emu_profile_path%" (
				set error_level=404
			)
		)
	)
)
IF "%copy_cheats%"=="Y" (
	IF NOT "%cheats_profile_path%"=="" (
		IF NOT EXIST "%cheats_profile_path%" (
			set error_level=404
		)
	)
)
IF NOT "%pass_copy_mixed_pack%"=="Y" (
	IF NOT "%mixed_profile_path%"=="" (
		IF NOT EXIST "%mixed_profile_path%" (
				set error_level=404
		)
	)
)
IF NOT "%pass_copy_overlays_pack%"=="Y" (
	IF NOT "%overlays_profile_path%"=="" (
		IF NOT EXIST "%overlays_profile_path%" (
				set error_level=404
		)
	)
)
IF NOT "%pass_copy_salty-nx_pack%"=="Y" (
	IF NOT "%salty-nx_profile_path%"=="" (
		IF NOT EXIST "%salty-nx_profile_path%" (
				set error_level=404
		)
	)
)
IF %error_level% EQU 404 (
	call "%associed_language_script%" "before_copy_error"
	pause
	endlocal
	goto:begin_script
)
:confirm_settings
call tools\Storage\prepare_sd_switch_infos.bat
call "%associed_language_script%" "display_title"
set confirm_copy=
call "%associed_language_script%" "confirm_copy_choice"
IF NOT "%confirm_copy%"=="" set confirm_copy=%confirm_copy:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "confirm_copy" "o/n_choice"
IF /i "%confirm_copy%"=="o" (
	goto:begin_copy
) else IF /i "%confirm_copy%"=="n" (
	call "%associed_language_script%" "canceled"
	pause
	endlocal
	goto:begin_script
) else (
	call "%associed_language_script%" "bad_choice"
	goto:confirm_settings
)

:begin_copy
echo.
set erase_fastcfwswitch_config=
IF NOT "%pass_copy_overlays_pack%"=="Y" (
	tools\gnuwin32\bin\grep.exe -c "FastCFWswitch" <"%overlays_profile_path%" > templogs\tempvar.txt
	set /p temp_count=<templogs\tempvar.txt
	IF NOT "!temp_count!"=="0" (
		IF EXIST "%volume_letter%\config\fastCFWSwitch\config.ini" (
			call "%associed_language_script%" "erase_fastcfwswitch_config_choice"
			IF NOT "!erase_fastcfwswitch_config!"=="" set erase_fastcfwswitch_config=!erase_fastcfwswitch_config:~0,1!
			call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_fastcfwswitch_config" "o/n_choice"
		) else (
			set erase_fastcfwswitch_config=o
		)
	)
)
echo.
call "%associed_language_script%" "copying_begin"

IF /i "%del_files_dest_copy%"=="1" (
	call :delete_cfw_files
	set del_files_dest_copy=0
) else IF /i "%del_files_dest_copy%"=="2" (
	rmdir /s /q "%volume_letter%\" >nul 2>&1
	set del_files_dest_copy=0
)

IF /i "%update_retroarch%"=="o" call tools\storage\update_manager.bat "retroarch_update"
IF NOT EXIST "templogs" mkdir templogs

IF /i "%copy_atmosphere_pack%"=="o" (
	call :verif_updatable_modules "atmosphere"
)
IF /i "%copy_reinx_pack%"=="o" (
	call :verif_updatable_modules "reinx"
)
IF /i "%copy_sxos_pack%"=="o" (
	call :verif_updatable_modules "sxos"
)

IF /i "%firmware_copy%"=="o" (
	IF EXIST "%volume_letter%\%firmware_choice%" rmdir /s /q "%volume_letter%\%firmware_choice%" >nul
	mkdir "%volume_letter%\Firmware %firmware_choice%"
	%windir%\System32\Robocopy.exe "%firmware_folder% " "%volume_letter%\Firmware %firmware_choice%" /e >nul
)

IF /i "%copy_atmosphere_pack%"=="o" (
	IF EXIST "%volume_letter%\atmosphere\titles*.*" (
		IF EXIST "%volume_letter%\atmosphere\contents" (
			rmdir /s /q "%volume_letter%\atmosphere\titles" >nul
		) else (
			move "%volume_letter%\atmosphere\titles" "%volume_letter%\atmosphere\contents" >nul
		)
	)
	rem IF EXIST "%volume_letter%\atmosphere\kip_patches\fs_patches" rmdir /s /q "%volume_letter%\atmosphere\kip_patches\fs_patches" >nul
	rem IF EXIST "%volume_letter%\atmosphere\kip_patches\loader_patches" rmdir /s /q "%volume_letter%\atmosphere\kip_patches\loader_patches" >nul
	rem IF EXIST "%volume_letter%\atmosphere\exefs_patches\es_patches" rmdir /s /q "%volume_letter%\atmosphere\exefs_patches\es_patches" >nul
	%windir%\System32\Robocopy.exe "TOOLS\sd_switch\atmosphere " "%volume_letter%\ " /e >nul
	IF "%sx_gear_copy%"=="Y" (
		%windir%\System32\Robocopy.exe "TOOLS\sd_switch\sx_gear " "%volume_letter%\ " /e >nul
	) else IF "%copy_sxos_boot%"=="Y" (
		copy /V /B "TOOLS\sd_switch\sxos\boot.dat" "%volume_letter%\boot.dat" >nul
	)
	IF /i "%copy_payloads%"=="o" (
		copy /V /B "TOOLS\sd_switch\payloads\Atmosphere_fusee.bin" "%volume_letter%\Atmosphere_fusee.bin" >nul
		copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\Hekate.bin" >nul
		IF EXIST "%volume_letter%\bootloader\sys\switchboot.txt" copy /v /b "TOOLS\Switchboot\tegrarcm\hekate_switchboot_mod.bin" "%volume_letter%\hekate_switchboot_mod.bin" >nul
	)
	copy /V /B "TOOLS\sd_switch\payloads\Atmosphere_fusee.bin" "%volume_letter%\bootloader\payloads\Atmosphere_fusee.bin" >nul
	copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\bootloader\payloads\Hekate.bin" >nul
	copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\bootloader\update.bin" >nul
	copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\payload.bin" >nul
	copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\start.bin" >nul
	IF EXIST "%volume_letter%\atmosphere\contents\010000000000000D\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\010000000000000D"
	IF EXIST "%volume_letter%\atmosphere\contents\010000000000002B\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\010000000000002B"
	IF EXIST "%volume_letter%\atmosphere\contents\010000000000003C\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\010000000000003C"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000008\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000008"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000032\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000032"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000034\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000034"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000036\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000036"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000037\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000037"
	IF EXIST "%volume_letter%\atmosphere\contents\0100000000000042\*.*" rmdir /s /q "%volume_letter%\atmosphere\contents\0100000000000042"
	IF EXIST "%volume_letter%\atmosphere\BCT.ini" del /q "%volume_letter%\atmosphere\BCT.ini"
	IF EXIST "%volume_letter%\atmosphere\loader.ini" del /q "%volume_letter%\atmosphere\loader.ini"
	IF EXIST "%volume_letter%\atmosphere\system_settings.ini" del /q "%volume_letter%\atmosphere\system_settings.ini"
	IF EXIST "%volume_letter%\atmosphere\hekate_kips\loader.kip" del /q "%volume_letter%\atmosphere\hekate_kips\loader.kip" >nul
	IF EXIST "%volume_letter%\sept\sept-secondary.enc" del /q "%volume_letter%\sept\sept-secondary.enc"
	IF EXIST "%volume_letter%\sept\ams\sept-secondary.enc" del /q "%volume_letter%\sept\ams\sept-secondary.enc"
	IF EXIST "%volume_letter%\switch\atmosphere-updater\*.*" rmdir /s /q "%volume_letter%\switch\atmosphere-updater"
	IF EXIST "%volume_letter%\switch\sigpatch-updater\*.*" rmdir /s /q "%volume_letter%\switch\sigpatch-updater"
	IF EXIST "%volume_letter%\switch\sigpatches-updater\*.*" rmdir /s /q "%volume_letter%\switch\sigpatches-updater"
	IF EXIST "%volume_letter%\switch\DeepSea-Toolbox\*.*" rmdir /s /q "%volume_letter%\switch\DeepSea-Toolbox"
	IF EXIST "%volume_letter%\switch\GagOrder.nro" del /q "%volume_letter%\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" rmdir /s /q "%volume_letter%\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" >nul
	IF EXIST "%volume_letter%\switch\appstore\res" rmdir /s /q "%volume_letter%\switch\appstore\res" >nul
	IF EXIST "%volume_letter%\BCT.ini" del /q "%volume_letter%\BCT.ini" >nul
	IF EXIST "%volume_letter%\fusee-secondary.bin" del /q "%volume_letter%\fusee-secondary.bin" >nul
	IF EXIST "%volume_letter%\bootlogo.bmp" del /q "%volume_letter%\bootlogo.bmp" >nul
	IF EXIST "%volume_letter%\hekate_ipl.ini" del /q "%volume_letter%\hekate_ipl.ini" >nul
	IF EXIST "%volume_letter%\switch\CFWSettings" rmdir /s /q "%volume_letter%\switch\CFWSettings" >nul
	IF EXIST "%volume_letter%\switch\CFW-Settings" rmdir /s /q "%volume_letter%\switch\CFW-Settings" >nul
	IF EXIST "%volume_letter%\modules\atmosphere\fs_mitm.kip" del /q "%volume_letter%\modules\atmosphere\fs_mitm.kip" >nul
	IF EXIST "%volume_letter%\atmosphere\titles\010000000000100D" rmdir /s /q "%volume_letter%\atmosphere\titles\010000000000100D" >nul
	IF EXIST "%volume_letter%\atmosphere\fusee-mtc.bin" del /q "%volume_letter%\atmosphere\fusee-mtc.bin" >nul
	IF EXIST "%volume_letter%\atmosphere\kip_patches\default_nogc\*.*" rmdir /s /q "%volume_letter%\atmosphere\kip_patches\default_nogc" >nul
	IF EXIST "%volume_letter%\atmosphere\config\BCT.ini" del /q "%volume_letter%\atmosphere\config\BCT.ini" >nul
	IF EXIST "%volume_letter%\atmosphere\config_templates\BCT.ini" del /q "%volume_letter%\atmosphere\config_templates\BCT.ini" >nul
	IF EXIST "%volume_letter%\atmosphere\fusee-secondary.bin" del /q "%volume_letter%\atmosphere\fusee-secondary.bin" >nul
	IF EXIST "%volume_letter%\atmosphere\flags\clean_stratosphere_for_0.19.0.flag" del /q "%volume_letter%\atmosphere\flags\clean_stratosphere_for_0.19.0.flag" >nul
	del /Q /S "%volume_letter%\Atmosphere_fusee-primary.bin" >nul 2>&1
	IF /i "%atmosphere_enable_nogc_patch%"=="O" (
		%windir%\System32\Robocopy.exe "TOOLS\sd_switch\atmosphere_patches_nogc " "%volume_letter%\ " /e >nul
	)
	%windir%\System32\Robocopy.exe "TOOLS\sd_switch\atmosphere_fs_and_es_patches " "%volume_letter%\ " /e >nul
	IF /i "%atmosphere_enable_cheats%"=="o" (
		IF "%copy_all_cheats_pack%"=="Y" (
			%windir%\System32\Robocopy.exe "TOOLS\sd_switch\cheats\titles " "%volume_letter%\atmosphere\contents" /e >nul
		) else (
			call :copy_cheats_profile "atmosphere"
		)
	)
	IF NOT EXIST "%volume_letter%\switch\.overlays" mkdir "%volume_letter%\switch\.overlays"
	%windir%\System32\Robocopy.exe "TOOLS\sd_switch\modules\pack\EdiZon\others\switch\.overlays " "%volume_letter%\switch\.overlays" /e >nul
	call :force_copy_overlays_base_files "atmosphere"
	copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\atmosphere\reboot_payload.bin" >nul
	rem copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%\switch\HekateBrew\payload.bin >nul
	copy /V /B "TOOLS\sd_switch\payloads\Lockpick_RCM.bin" "%volume_letter%\bootloader\payloads\Lockpick_RCM.bin" >nul
	IF /i NOT "%mariko_console%"=="o" (
		copy /V /B "TOOLS\sd_switch\payloads\Incognito_RCM.bin" "%volume_letter%\bootloader\payloads\Incognito_RCM.bin" >nul
	)
	copy /V /B "TOOLS\sd_switch\payloads\prodinfo_gen.bin" "%volume_letter%\bootloader\payloads\Prodinfo_gen.bin" >nul
	copy /V /B "TOOLS\sd_switch\payloads\TegraExplorer.bin" "%volume_letter%\bootloader\payloads\TegraExplorer.bin" >nul
	del /Q /S "%volume_letter%\atmosphere\.emptydir" >nul 2>&1
	del /Q /S "%volume_letter%\bootloader\.emptydir" >nul 2>&1
	del /Q /S "%volume_letter%\emummc\.emptydir" >nul 2>&1
	del /Q /S "%volume_letter%\mods\.emptydir" >nul 2>&1
	IF EXIST "%volume_letter%\switch\KosmosToolbox\*.*" rmdir /S /Q "%volume_letter%\switch\KosmosToolbox" >nul 2>&1
	IF EXIST "%volume_letter%\switch\KosmosUpdater\*.*" rmdir /S /Q "%volume_letter%\switch\KosmosUpdater" >nul 2>&1
	IF EXIST "%volume_letter%\switch\HekateToolbox\*.*" rmdir /S /Q "%volume_letter%\switch\HekateToolbox" >nul 2>&1
	IF EXIST "%volume_letter%\bootloader\hekate_ipl.ini.old" del /q "%volume_letter%\bootloader\hekate_ipl.ini.old" >nul 2>&1
	IF EXIST "%volume_letter%\bootloader\sys\switchboot.txt" (
	IF EXIST "%volume_letter%\switch\DeepSea-Updater\DeepSeaUpdater.nro" del /q "%volume_letter%\switch\DeepSea-Updater\DeepSeaUpdater.nro" >nul 2>&1
		%windir%\System32\Robocopy.exe "TOOLS\Switchboot\tegrarcm\bootloader " "%volume_letter%\bootloader" /e >nul
		%windir%\System32\Robocopy.exe "TOOLS\Switchboot\Tidy_Memloader " "%volume_letter%\ " /e >nul
		copy /v /b "TOOLS\Switchboot\tegrarcm\hekate_switchboot_mod.bin" "%volume_letter%\bootloader\payloads\hekate_switchboot_mod.bin" >nul
	)
	IF /i "%atmosphere_manual_config%"=="o" (
		call :copy_atmosphere_configuration
	)
	call :copy_modules_pack "atmosphere"
	IF NOT "%atmosphere_pass_copy_emummc_pack%"=="Y" copy /v "%atmosphere_emummc_profile_path%" "%volume_letter%\emummc\emummc.ini" >nul
	IF NOT "%pass_copy_overlays_pack%"=="Y" call :force_copy_overlays_base_files "atmosphere"
	IF NOT "%pass_copy_salty-nx_pack%"=="Y" call :force_copy_salty-nx_base_files "atmosphere"
)

IF /i "%copy_reinx_pack%"=="o" (
			IF EXIST "%volume_letter%\ReiNX\contents" (
			rmdir /s /q "%volume_letter%\ReiNX\titles" >nul
		) else (
			move "%volume_letter%\ReiNX\titles" "%volume_letter%\ReiNX\contents" >nul
		)
	IF EXIST "%volume_letter%\sept\sept-secondary.enc" del /q "%volume_letter%\sept\sept-secondary.enc" >nul
	IF EXIST "%volume_letter%\sept\reinx\sept-secondary.enc" del /q "%volume_letter%\sept\reinx\sept-secondary.enc" >nul
	IF EXIST "%volume_letter%\ReiNX\contents\010000000000100D\*.*" rmdir /s /q ""%volume_letter%\ReiNX\contents\010000000000100D" >nul
	IF EXIST "%volume_letter%\ReiNX\contents\0100000000000036\exefs\*.*" rmdir /s /q ""%volume_letter%\ReiNX\contents\0100000000000036\exefs" >nul
	IF EXIST "%volume_letter%\ReiNX\patches\*.*" rmdir /s /q "%volume_letter%\ReiNX\patches" >nul
	IF EXIST "%volume_letter%\ReiNX\splash.bin" del /q "%volume_letter%\ReiNX\splash.bin"
	IF EXIST "%volume_letter%\ReiNX\lp0fw.bin" del /q "%volume_letter%\ReiNX\lp0fw.bin"
	%windir%\System32\Robocopy.exe "TOOLS\sd_switch\reinx " "%volume_letter%\ " /e >nul
	IF /i NOT "%reinx_enable_nogc_patch%"=="o" del /q %volume_letter%\ReiNX\nogc >nul
	copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\ReiNX.bin" >nul
	IF /i "%copy_atmosphere_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\bootloader\payloads\ReiNX.bin" >nul
	IF EXIST "%volume_letter%\switch\GagOrder.nro" del /q "%volume_letter%\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%\switch\appstore\res" rmdir /s /q "%volume_letter%\switch\appstore\res" >nul
	copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\ReiNX\reboot_payload.bin" >nul
	call :copy_modules_pack "reinx"
	IF NOT "%pass_copy_overlays_pack%"=="Y" call :force_copy_overlays_base_files "reinx"
	IF NOT "%pass_copy_salty-nx_pack%"=="Y" call :force_copy_salty-nx_base_files "reinx"
)

IF /i "%copy_sxos_pack%"=="o" (
	%windir%\System32\Robocopy.exe "TOOLS\sd_switch\sxos " "%volume_letter%\ " /e >nul
	IF /i "%copy_payloads%"=="o" (
		copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\SXOS.bin" >nul
		copy /V /B "TOOLS\sd_switch\payloads\hekate.bin" "%volume_letter%\hekate.bin" >nul
	)
	IF /i "%copy_atmosphere_pack%"=="o" (
		copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\bootloader\payloads\SXOS.bin" >nul
	) else (
		IF NOT EXIST "%volume_letter%\payload.bin" copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\payload.bin" >nul
		IF NOT EXIST "%volume_letter%\start.bin" copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\start.bin" >nul
	)
	IF EXIST "%volume_letter%\switch\GagOrder.nro" del /q "%volume_letter%\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%\switch\appstore\res" rmdir /s /q "%volume_letter%\switch\appstore\res" >nul
	IF /i "%sxos_enable_cheats%"=="o" (
		IF "%copy_all_cheats_pack%"=="Y" (
			%windir%\System32\Robocopy.exe "TOOLS\sd_switch\cheats\titles " "%volume_letter%\sxos\titles" /e >nul
		) else (
			call :copy_cheats_profile "sxos"
		)
	)
	call :copy_modules_pack "sxos"
	IF NOT "%pass_copy_overlays_pack%"=="Y" call :force_copy_overlays_base_files "sxos"
	IF NOT "%pass_copy_salty-nx_pack%"=="Y" call :force_copy_salty-nx_base_files "sxos"
	IF EXIST "%volume_letter%\switch\sx_installer" rmdir /s /q "%volume_letter%\switch\sx_installer"
	rem IF EXIST "%volume_letter%\sxos\titles\420000000007E51A\*.*" rmdir /s /q "%volume_letter%\sxos\titles\420000000007E51A"
	del /Q /S "%volume_letter%\sxos\.emptydir" >nul 2>&1
	IF EXIST "%volume_letter%\sxos\titles\0100000000000123" rmdir /s /q "%volume_letter%\sxos\titles\0100000000000123"
	IF /i "%remove_sx_autoloader%"=="o" (
		IF EXIST "%volume_letter%\sxos\titles\00FF0012656180FF\cache" (
			rmdir /s /q "%volume_letter%\sxos\titles\00FF0012656180FF\flags"
			del /q "%volume_letter%\sxos\titles\00FF0012656180FF\exefs.nsp" >nul 2>&1
		) else (
			rmdir /s /q "%volume_letter%\sxos\titles\00FF0012656180FF"
		)
	)
	IF /i "%sx_core_lite_chip%"=="o" (
		IF /i NOT "%mariko_console"=="o" (
			call "%associed_language_script%" "sx_chip_clean_up_warning"
		)
	)
)

IF /i "%copy_memloader%"=="o" (
	%windir%\System32\Robocopy.exe "TOOLS\memloader\mount_discs " "%volume_letter%\ " /e >nul
	IF /i "%copy_sxos_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\memloader.bin" "%volume_letter%\Memloader.bin" >nul
	IF /i "%copy_atmosphere_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\memloader.bin" "%volume_letter%\bootloader\payloads\Memloader.bin" >nul
)

set sx_gear_present_on_sd=
IF EXIST "%volume_letter%\boot.dat" (
	TOOLS\gnuwin32\bin\md5sum.exe "%volume_letter%\boot.dat" | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
	set /p md5_verif=<templogs\tempvar.txt
	IF /i "!md5_verif!"=="20cf385a492fb0058f39f183ed1ed104" (
		set sx_gear_present_on_sd=Y
	)
)

call :copy_mixed_pack
call :copy_overlays_pack
call :copy_salty-nx_pack
call :copy_emu_pack
IF /i "%sd_folder_structure_to_copy_choice%"=="o" %windir%\System32\Robocopy.exe "%sd_folder_structure_to_copy_path% " "%volume_letter%\ " /e >nul
%windir%\System32\Robocopy.exe "sd_user " "%volume_letter%\ " /e >nul

del /Q /S "%volume_letter%\switch\.emptydir" >nul 2>&1
del /Q /S "%volume_letter%\Backup\.emptydir" >nul 2>&1
del /Q /S "%volume_letter%\pk1decryptor\.emptydir" >nul 2>&1
IF EXIST "%volume_letter%\tinfoil\" del /Q /S "%volume_letter%\tinfoil\.emptydir" >nul 2>&1
IF EXIST "%volume_letter%\folder_version.txt" del /q "%volume_letter%\folder_version.txt">nul 2>&1
IF EXIST "%volume_letter%\switch\folder_version.txt" del /q "%volume_letter%\switch\folder_version.txt" >nul 2>&1
IF /I "%mariko_console%"=="o" (
	IF EXIST "%volume_letter%\switch\ChoiDuJourNX" rmdir /s /q "%volume_letter%\switch\ChoiDuJourNX"
)
IF EXIST "%volume_letter%\switch\ChoiDuJourNX.nro" del /q "%volume_letter%\switch\ChoiDuJourNX.nro" >nul
IF /i "%sx_core_lite_chip%"=="o" (
	IF EXIST "%volume_letter%\0" rmdir /s /q "%volume_letter%\0"
	IF EXIST "%volume_letter%\start.bin" del  /q "%volume_letter%\start.bin" >nul
)
IF EXIST "%volume_letter%\sept\payload.bin" del /q "%volume_letter%\sept\payload.bin" >nul
set prepare_another_sd=
call "%associed_language_script%" "copying_end"
IF NOT "%prepare_another_sd%"=="" set prepare_another_sd=%prepare_another_sd:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "prepare_another_sd" "o/n_choice"
IF /i "%prepare_another_sd%"=="o" (
	endlocal
	goto:begin_script
) else (
	goto:endscript2
)

:verif_updatable_modules
IF "%~1"=="atmosphere" (
	set temp_sd_modules_path=%volume_letter%\atmosphere\contents
	set temp_updatable_modules_file=templogs\atmosphere_modules_update.txt
) else IF "%~1"=="reinx" (
	set temp_sd_modules_path=%volume_letter%\ReiNX\contents
	set temp_updatable_modules_file=templogs\reinx_modules_update.txt
) else IF "%~1"=="sxos" (
	set temp_sd_modules_path=%volume_letter%\sxos\titles
	set temp_updatable_modules_file=templogs\sxos_modules_update.txt
)
IF NOT EXIST "%temp_sd_modules_path%\*.*" exit /b
set /a tempcount=0
for /d %%f in ("%temp_sd_modules_path%\*") do (
	set tmp_module_test=%%f
	set tmp_module_test=!tmp_module_test:~-16!
	for /d %%g in ("tools\sd_switch\modules\pack\*") do (
		set tmp_module_test_2_name=%%~ng
		for /d %%h in ("%%g\titles\*") do (
			set tmp_module_test_2=%%h
			set tmp_module_test_2=!tmp_module_test_2:~-16!
			IF "!tmp_module_test!"=="!tmp_module_test_2!" (
				set /a tempcount=!tempcount!+1
				IF !temp_count! EQU 1 (
					echo !tmp_module_test_2_name!>%temp_updatable_modules_file%
				) else (
					echo !tmp_module_test_2_name!>>%temp_updatable_modules_file%
				)
			)
		)
	)
)
"tools\gnuwin32\bin\sort.exe" -u -o "%temp_updatable_modules_file%2" "%temp_updatable_modules_file%"
del /q "%temp_updatable_modules_file%" >nul
move "%temp_updatable_modules_file%2" "%temp_updatable_modules_file%" >nul
IF %temp_count% NEQ 0 (
	IF "%~1"=="atmosphere" (
		set tmp_pass_copy_modules_pack=%atmosphere_pass_copy_modules_pack%
		set tmp_modules_profile_path=%atmosphere_modules_profile_path%
		set atmosphere_pass_copy_modules_pack=n
		set atmosphere_modules_profile_path=%temp_updatable_modules_file%
		call :copy_modules_pack "atmosphere"
		set atmosphere_pass_copy_modules_pack=!tmp_pass_copy_modules_pack!
		set atmosphere_modules_profile_path=!tmp_modules_profile_path!
	) else IF "%~1"=="reinx" (
		set tmp_pass_copy_modules_pack=%reinx_pass_copy_modules_pack%
		set tmp_modules_profile_path=%reinx_modules_profile_path%
		set reinx_pass_copy_modules_pack=n
		set reinx_modules_profile_path=%temp_updatable_modules_file%
		call :copy_modules_pack "reinx"
		set reinx_pass_copy_modules_pack=!tmp_pass_copy_modules_pack!
		set reinx_modules_profile_path=!tmp_modules_profile_path!
	) else IF "%~1"=="sxos" (
		set tmp_pass_copy_modules_pack=%sxos_pass_copy_modules_pack%
		set tmp_modules_profile_path=%sxos_modules_profile_path%
		set sxos_pass_copy_modules_pack=n
		set sxos_modules_profile_path=%temp_updatable_modules_file%
		call :copy_modules_pack "sxos"
		set sxos_pass_copy_modules_pack=!tmp_pass_copy_modules_pack!
		set sxos_modules_profile_path=!tmp_modules_profile_path!
	)
)
exit /b

:copy_modules_pack
IF "%~1"=="atmosphere" (
	IF "%atmosphere_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%\atmosphere\contents
	set temp_modules_profile_path=%atmosphere_modules_profile_path%
)
IF "%~1"=="reinx" (
	IF "%reinx_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%\ReiNX\contents
	set temp_modules_profile_path=%reinx_modules_profile_path%
)
IF "%~1"=="sxos" (
	IF "%sxos_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%\sxos\titles
	set temp_modules_profile_path=%sxos_modules_profile_path%
)
tools\gnuwin32\bin\grep.exe -c "" <"%temp_modules_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	set temp_special_module=N
	set one_cfw_chosen=n
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%temp_modules_profile_path%" >templogs\tempvar.txt
	set /p temp_module=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\modules\pack\!temp_module!\folder_version.txt" (
		IF "!temp_module!"=="uLaunch" (
			rem IF "%~1"=="sxos" (
				rem set temp_special_module=Y
				rem call "%associed_language_script%" "sxos_force_disable_stealth_mode_for_uLaunch"
				rem IF EXIST "%volume_letter%\sxos\config\stealth_enable" rename "%volume_letter%\sxos\config\stealth_enable" "stealth_disable"
			rem )
			IF EXIST "%temp_modules_copy_path%\01008BB00013C000" rmdir /s /q "%temp_modules_copy_path%\01008BB00013C000"
			IF EXIST "%temp_modules_copy_path%\010000000000100B" rmdir /s /q "%temp_modules_copy_path%\010000000000100B"
			IF EXIST "%temp_modules_copy_path%\0100000000001001" rmdir /s /q "%temp_modules_copy_path%\0100000000001001"
			IF EXIST "%volume_letter%\ulaunch\bin\QMenu" rmdir /s /q "%volume_letter%\ulaunch\bin\QMenu"
		)
		IF "!temp_module!"=="Ovl-menu" (
			IF EXIST "%temp_modules_copy_path%\010000000007E51A\exefs.nsp" rmdir /s /q "%temp_modules_copy_path%\010000000007E51A"
		)
		IF NOT "!temp_special_module!"=="Y" (
			dir /b "tools\sd_switch\modules\pack\!temp_module!\titles">templogs\tempvar.txt
			set /p temp_module_title_id=<templogs\tempvar.txt
			IF "!temp_module!"=="EdiZon" (
				set temp_module_title_id=054e4f4558454000
			)
			"%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\titles " "%temp_modules_copy_path%" /e >nul
			IF EXIST "tools\sd_switch\modules\pack\!temp_module!\others" "%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\others " "%volume_letter%\ " /e >nul
			IF "!temp_module!"=="Nx-btred" (
				set temp_module=MissionControl
				"%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\titles " "%temp_modules_copy_path%" /e >nul
				IF EXIST "tools\sd_switch\modules\pack\!temp_module!\others" "%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\others " "%volume_letter%\ " /e >nul
			)
			IF "!temp_module!"=="MissionControl" (
				IF "%~1"=="atmosphere" "%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\patches " "%volume_letter%\atmosphere\ " /e >nul
				IF "%~1"=="sxos" "%windir%\System32\Robocopy.exe" "tools\sd_switch\modules\pack\!temp_module!\patches " "%volume_letter%\sxos\ " /e >nul
				IF EXIST "%volume_letter%\atmosphere\config_templates\missioncontrol.ini" del /q "%volume_letter%\atmosphere\config_templates\missioncontrol.ini"
				IF EXIST "%volume_letter%\atmosphere\config\missioncontrol.ini" del /q "%volume_letter%\atmosphere\config\missioncontrol.ini"
			)
			rem IF "%~1"=="sxos" (
			rem IF EXIST "%temp_modules_copy_path%\!temp_module_title_id!\toolbox.json" del /q "%temp_modules_copy_path%\!temp_module_title_id!\toolbox.json"
			rem )
		)
		IF "!temp_module!"=="Emuiibo" (
			call :force_copy_overlays_base_files "%~1"
			IF EXIST "%volume_letter%\switch\AmiiSwap\*.*" rmdir /s /q "%volume_letter%\switch\AmiiSwap"
		)
			IF "!temp_module!"=="Ldn_mitm" (
			call :force_copy_overlays_base_files "%~1"
		)
		IF "!temp_module!"=="Sys-clk" (
			call :force_copy_overlays_base_files "%~1"
			IF EXIST "%volume_letter%\switch\sys-clk-Editor\*.*" rmdir /s /q "%volume_letter%\switch\sys-clk-Editor"
		)
			IF "!temp_module!"=="Sys-tune" (
			call :force_copy_overlays_base_files "%~1"
		)
		IF "!temp_module!"=="Slidenx" (
			IF EXIST "%volume_letter%\SlideNX\attach.mp3" del /q "%volume_letter%\SlideNX\attach.mp3"
			IF EXIST "%volume_letter%\SlideNX\detach.mp3" del /q "%volume_letter%\SlideNX\detach.mp3"
		)
		IF "!temp_module!"=="Sys-FTPD" (
			IF EXIST "%volume_letter%\config\sys-ftpd\*.mp3" del /q "%volume_letter%\config\sys-ftpd\*.mp3"
		)
		IF "!temp_module!"=="BootSoundNX" (
			IF EXIST "%volume_letter%\bootloader\sound\bootsound.mp3" rmdir /s /q "%volume_letter%\bootloader\sound"
			IF EXIST "%volume_letter%\config\BootSoundNX\bootsound.mp3" del /q "%volume_letter%\config\BootSoundNX\bootsound.mp3" >nul
			IF EXIST "%temp_modules_copy_path%\AA200000000002AA\exefs.nsp" rmdir /s /q ""%temp_modules_copy_path%\AA200000000002AA""
		)
		IF "!temp_module!"=="Sys-tune" (
			call :force_copy_overlays_base_files "%~1"
		)
		IF "!temp_module!"=="EdiZon" (
			IF EXIST "%volume_letter%\EdiZon" move "%volume_letter%\EdiZon" "%volume_letter%\switch\EdiZon" >nul
			call :force_copy_overlays_base_files "%~1"
		)
		IF "!temp_module!"=="Fizeau" (
			call :force_copy_overlays_base_files "%~1"
		)
	) else (
		tools\gnuwin32\bin\sed.exe -i !temp_line!d "%temp_modules_profile_path%"
		set /a temp_line=!temp_line! - 1
		call "%associed_language_script%" "module_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
:skip_copy_modules_pack
exit /b

:force_copy_overlays_base_files
IF "%~1"=="atmosphere" (
	set temp_modules_copy_path=%volume_letter%\atmosphere\contents
)
IF "%~1"=="reinx" (
	set temp_modules_copy_path=%volume_letter%\ReiNX\titles
)
IF "%~1"=="sxos" (
	set temp_modules_copy_path=%volume_letter%\sxos\titles
)
IF EXIST "%temp_modules_copy_path%\010000000007E51A\exefs.nsp" rmdir /s /q "%temp_modules_copy_path%\010000000007E51A"
%windir%\System32\Robocopy.exe "tools\sd_switch\modules\pack\Ovl-menu\titles " "%temp_modules_copy_path%" /e >nul
%windir%\System32\Robocopy.exe "tools\sd_switch\modules\pack\Ovl-menu\others " "%volume_letter%\ " /e >nul
exit /b

:force_copy_salty-nx_base_files
IF "%~1"=="atmosphere" (
	set temp_modules_copy_path=%volume_letter%\atmosphere\contents
)
IF "%~1"=="reinx" (
	set temp_modules_copy_path=%volume_letter%\ReiNX\titles
)
IF "%~1"=="sxos" (
	set temp_modules_copy_path=%volume_letter%\sxos\titles
)
%windir%\System32\Robocopy.exe "tools\sd_switch\modules\pack\Salty-nx\titles " "%temp_modules_copy_path%" /e >nul
%windir%\System32\Robocopy.exe "tools\sd_switch\modules\pack\Salty-nx\others " "%volume_letter%\ " /e >nul
exit /b

:copy_mixed_pack
%windir%\System32\Robocopy.exe "tools\sd_switch\mixed\base " "%volume_letter%\ " /e >nul
IF "%pass_copy_mixed_pack%"=="Y" goto:skip_copy_mixed_pack
tools\gnuwin32\bin\grep.exe -c "" <"%mixed_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	set temp_special_homebrew=N
	set one_cfw_chosen=n
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%mixed_profile_path%" >templogs\tempvar.txt
	set /p temp_homebrew=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\mixed\modular\!temp_homebrew!\folder_version.txt" (
		IF "!temp_homebrew!"=="Switch-cheats-updater" (
			IF EXIST "%volume_letter%\config\cheats-updater\exclude.txt" rename "%volume_letter%\config\cheats-updater\exclude.txt" "exclude.txt.bak" >nul
		)
				IF "!temp_homebrew!"=="Incognito" (
			IF /i "%mariko_console%"=="o" (
				set temp_special_homebrew=Y
			)
		)
		IF "!temp_homebrew!"=="ChoiDuJourNX" (
			IF /i "%mariko_console%"=="o" (
				set temp_special_homebrew=Y
			) else (
				call "%associed_language_script%" "choidujournx_alert_message"
			)
		)
		IF "!temp_homebrew!"=="MiiPort" (
			IF EXIST "%volume_letter%\MiiPort\qrkey.txt" (
				"tools\python3_scripts\Keys_management\Keys_management.exe" test_mii_qr_key_file "%volume_letter%\MiiPort\qrkey.txt" >nul
				IF !errorlevel! NEQ 0 rename "%volume_letter%\MiiPort\qrkey.txt" "qrkey.txt.bak" >nul
			)
		)
				IF "!temp_homebrew:~0,16!"=="Payload_Launcher" (
			IF /i NOT "%mariko_console%"=="o" (
				IF NOT EXIST "%volume_letter%\payloads\*.*" mkdir "%volume_letter%\payloads"
				copy /V /B "TOOLS\sd_switch\payloads\Lockpick_RCM.bin" "%volume_letter%\payloads\Lockpick_RCM.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\Incognito_RCM.bin" "%volume_letter%\payloads\Incognito_RCM.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\prodinfo_gen.bin" "%volume_letter%\payloads\Prodinfo_gen.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\TegraExplorer.bin" "%volume_letter%\payloads\TegraExplorer.bin" >nul
				IF /i "%copy_atmosphere_pack%"=="o" (
					copy /V /B "TOOLS\sd_switch\payloads\Atmosphere_fusee.bin" "%volume_letter%\payloads\Atmosphere_fusee.bin" >nul
					copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\payloads\Hekate.bin" >nul
					IF EXIST "%volume_letter%\bootloader\sys\switchboot.txt" copy /v /b "tools\Switchboot\tegrarcm\hekate_switchboot_mod.bin" "%volume_letter%\payloads\hekate_switchboot_mod.bin" >nul
				)
				IF /i "%copy_reinx_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\payloads\ReiNX.bin" >nul
				IF /i "%copy_sxos_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\payloads\SXOS.bin" >nul
				IF /i "%copy_memloader%"=="o" copy /V /B "TOOLS\sd_switch\payloads\memloader.bin" "%volume_letter%\payloads\memloader.bin" >nul
			) else (
				set temp_special_homebrew=Y
			)
		)
		IF "!temp_special_homebrew!"=="N" %windir%\System32\Robocopy.exe "tools\sd_switch\mixed\modular\!temp_homebrew! " "%volume_letter%\ " /e >nul
		IF "!temp_homebrew!"=="MiiPort" (
			IF EXIST "%volume_letter%\MiiPort\qrkey.txt.bak" (
				del "%volume_letter%\MiiPort\qrkey.txt" >nul
				rename "%volume_letter%\MiiPort\qrkey.txt.bak" "qrkey.txt" >nul
			) else (
				call "%associed_language_script%" "miiport_alert_message"
			)
			IF EXIST "%volume_letter%\atmosphere\config\system_settings.ini" (
				echo.>>"%volume_letter%\atmosphere\config\system_settings.ini"
				echo [mii]>>"%volume_letter%\atmosphere\config\system_settings.ini"
			) else (
				echo [mii]>"%volume_letter%\atmosphere\config\system_settings.ini"
			)
			echo is_db_test_mode_enabled=u8^^!0x^1>>"%volume_letter%\atmosphere\config\system_settings.ini"
		)
		IF "!temp_homebrew!"=="Switch-cheats-updater" (
			IF EXIST "%volume_letter%\config\cheats-updater\exclude.txt.bak" (
				del /q "%volume_letter%\config\cheats-updater\exclude.txt" >nul
				rename "%volume_letter%\config\cheats-updater\exclude.txt.bak" "exclude.txt" >nul
			)
		)
		IF "!temp_homebrew!"=="Nxdumptool" (
			IF EXIST "%volume_letter%\switch\gcdumptool\*.*" rmdir /s /q "%volume_letter%\switch\gcdumptool"
			IF EXIST "%volume_letter%\switch\gcdumptool.nro" del /q "%volume_letter%\switch\gcdumptool.nro"
		)
		IF "!temp_homebrew!"=="Aio-switch-updater" (
			IF /i NOT "%mariko_console%"=="o" (
				IF NOT EXIST "%volume_letter%\payloads\*.*" mkdir "%volume_letter%\payloads"
				copy /V /B "TOOLS\sd_switch\payloads\Lockpick_RCM.bin" "%volume_letter%\payloads\Lockpick_RCM.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\Incognito_RCM.bin" "%volume_letter%\payloads\Incognito_RCM.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\prodinfo_gen.bin" "%volume_letter%\payloads\Prodinfo_gen.bin" >nul
				copy /V /B "TOOLS\sd_switch\payloads\TegraExplorer.bin" "%volume_letter%\payloads\TegraExplorer.bin" >nul
				IF /i "%copy_atmosphere_pack%"=="o" (
					copy /V /B "TOOLS\sd_switch\payloads\Atmosphere_fusee.bin" "%volume_letter%\payloads\Atmosphere_fusee.bin" >nul
					copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\payloads\Hekate.bin" >nul
					IF EXIST "%volume_letter%\bootloader\sys\switchboot.txt" copy /v /b "tools\Switchboot\tegrarcm\hekate_switchboot_mod.bin" "%volume_letter%\payloads\hekate_switchboot_mod.bin" >nul
				)
				IF /i "%copy_reinx_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\payloads\ReiNX.bin" >nul
				IF /i "%copy_sxos_pack%"=="o" copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\payloads\SXOS.bin" >nul
				IF /i "%copy_memloader%"=="o" copy /V /B "TOOLS\sd_switch\payloads\memloader.bin" "%volume_letter%\payloads\memloader.bin" >nul
			)
		)
	) else (
	tools\gnuwin32\bin\sed.exe -i !temp_line!d "%mixed_profile_path%"
	set /a temp_line=!temp_line! - 1
	call "%associed_language_script%" "homebrew_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
:skip_copy_mixed_pack
exit /b

:copy_overlays_pack
IF "%pass_copy_overlays_pack%"=="Y" goto:skip_copy_overlays_pack
tools\gnuwin32\bin\grep.exe -c "" <"%overlays_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	set temp_special_overlay=N
	set one_cfw_chosen=n
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%overlays_profile_path%" >templogs\tempvar.txt
	set /p temp_overlay=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\overlays\pack\!temp_overlay!\folder_version.txt" (
		IF "!temp_overlay!"=="FastCFWswitch" (
			IF /i NOT "%mariko_console%"=="o" (
				IF /i "%erase_fastcfwswitch_config%"=="o" (
					IF NOT EXIST "%volume_letter%\payloads\*.*" mkdir "%volume_letter%\payloads"
					IF NOT EXIST "%volume_letter%\config\*.*" mkdir "%volume_letter%\config"
					IF NOT EXIST "%volume_letter%\config\fastCFWSwitch\*.*" mkdir "%volume_letter%\config\fastCFWSwitch"
					echo [payloads]>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo type=section>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo name=Payloads>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					copy /V /B "TOOLS\sd_switch\payloads\Lockpick_RCM.bin" "%volume_letter%\payloads\Lockpick_RCM.bin" >nul
					echo [Lockpick-RCM]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo name=Lockpick-RCM>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo path=/payloads/Lockpick_RCM.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					copy /V /B "TOOLS\sd_switch\payloads\Incognito_RCM.bin" "%volume_letter%\payloads\Incognito_RCM.bin" >nul
					echo [Incognito-RCM]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo name=Incognito-RCM>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo path=/payloads/Incognito_RCM.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					copy /V /B "TOOLS\sd_switch\payloads\prodinfo_gen.bin" "%volume_letter%\payloads\Prodinfo_gen.bin" >nul
					echo [Prodinfo_gen]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo name=Prodinfo_gen>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo path=/payloads/Prodinfo_gen.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					copy /V /B "TOOLS\sd_switch\payloads\TegraExplorer.bin" "%volume_letter%\payloads\TegraExplorer.bin" >nul
					echo [TegraExplorer]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo name=TegraExplorer>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo path=/payloads/TegraExplorer.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					IF /i "%copy_memloader%"=="o" (
						copy /V /B "TOOLS\sd_switch\payloads\memloader.bin" "%volume_letter%\payloads\memloader.bin" >nul
						echo [Memloader]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=Memloader>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/memloader.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					)
					IF /i "%copy_atmosphere_pack%"=="o" (
						set one_cfw_chosen=Y
						copy /V /B "TOOLS\sd_switch\payloads\Atmosphere_fusee.bin" "%volume_letter%\payloads\Atmosphere_fusee.bin" >nul
						copy /V /B "TOOLS\sd_switch\payloads\Hekate.bin" "%volume_letter%\payloads\Hekate.bin" >nul
						echo [Hekate]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=Hekate>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [UMS]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo type=section>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=UMS>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [SD]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=SD>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=sd>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [rawnand_sysnand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=Rawnand sysnand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emmc_gpt>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [boot0_sysnand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=BOOT0 sysnand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emmc_boot0>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [boot1_sysnand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=BOOT1 sysnand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emmc_boot1>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [rawnand_emunand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=Rawnand emunand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emu_gpt>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [boot0_emunand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=BOOT0 emunand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emu_boot0>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [boot1_emunand]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=BOOT1 emunand>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo ums=emu_boot1>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [CFWs]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo type=section>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=CFWs>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [Atmosphere_Fusee_Primary]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=Atmosphere_Fusee_Primary>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/Atmosphere_fusee.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [sysnand_Atmosphere_via_hekate]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=sysnand_Atmosphere_via_hekate>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo bootId=AmsS>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						rem echo bootPos=^4>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [emunand_Atmosphere_via_hekate]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=emunand_Atmosphere_via_hekate>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo bootId=AmsE>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						rem echo bootPos=^2>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo [OFW_via_hekate]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=OFW_via_hekate>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/hekate.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo bootId=Ofw>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						rem echo bootPos=^5>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
					)
					IF /i "%copy_reinx_pack%"=="o" (
						copy /V /B "TOOLS\sd_switch\payloads\ReiNX.bin" "%volume_letter%\payloads\ReiNX.bin" >nul
						IF NOT "!one_cfw_chosen!"=="Y" (
							echo [CFWs]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo type=section>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo name=CFWs>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						)
						echo [ReiNX]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=ReiNX>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/ReiNX.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						set one_cfw_chosen=Y
					)
					IF /i "%copy_sxos_pack%"=="o" (
						copy /V /B "TOOLS\sd_switch\payloads\SXOS.bin" "%volume_letter%\payloads\SXOS.bin" >nul
						IF NOT "!one_cfw_chosen!"=="Y" (
							echo [CFWs]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo type=section>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo name=CFWs>>"%volume_letter%\config\fastCFWSwitch\config.ini"
							echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						)
						echo [SXOS]>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo name=SXOS>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo path=/payloads/SXOS.bin>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						echo.>>"%volume_letter%\config\fastCFWSwitch\config.ini"
						set one_cfw_chosen=Y
					)
				)
			) else (
				set temp_special_overlay=Y
			)
		)
		IF "!temp_special_overlay!"=="N" %windir%\System32\Robocopy.exe "tools\sd_switch\overlays\pack\!temp_overlay! " "%volume_letter%\ " /e >nul
	) else (
		tools\gnuwin32\bin\sed.exe -i !temp_line!d "%overlays_profile_path%"
		set /a temp_line=!temp_line! - 1
		call "%associed_language_script%" "overlay_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
:skip_copy_overlays_pack
exit /b

:copy_salty-nx_pack
IF "%pass_copy_salty-nx_pack%"=="Y" goto:skip_copy_salty-nx_pack
tools\gnuwin32\bin\grep.exe -c "" <"%salty-nx_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	set temp_special_salty-nx=N
	set one_cfw_chosen=n
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%salty-nx_profile_path%" >templogs\tempvar.txt
	set /p temp_salty-nx=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\salty-nx\pack\!temp_salty-nx!\folder_version.txt" (
		IF "!temp_salty-nx!"=="UnityGraphics" (
			set temp_special_salty-nx=Y
			IF EXIST "%volume_letter%\atmosphere\contents" (
				set one_cfw_chosen=Y
				call :force_copy_overlays_base_files "atmosphere"
			)
			IF EXIST "%volume_letter%\sxos\titles" (
				set one_cfw_chosen=Y
				call :force_copy_overlays_base_files "sxos"
			)
			IF EXIST "%volume_letter%\boot.dat" (
				IF NOT "%sx_gear_present_on_sd%"=="Y" (
					set one_cfw_chosen=Y
					IF NOT EXIST "%volume_letter%\sxos" (
						mkdir "%volume_letter%\sxos"
						mkdir "%volume_letter%\sxos\titles"
					)
					call :force_copy_overlays_base_files "sxos"
				)
			)
			IF /i "%copy_atmosphere_pack%"=="o" (
				set one_cfw_chosen=Y
				IF NOT EXIST "%volume_letter%\atmosphere" (
					mkdir "%volume_letter%\atmosphere"
					mkdir "%volume_letter%\contents
				)
				call :force_copy_overlays_base_files "atmosphere"
			)
			IF /i "%copy_sxos_pack%"=="o" (
				set one_cfw_chosen=Y
				IF NOT EXIST "%volume_letter%\sxos" (
					mkdir "%volume_letter%\sxos"
					mkdir "%volume_letter%\sxos\titles"
				)
				call :force_copy_overlays_base_files "sxos"
			)
			IF "!one_cfw_chosen!"=="Y" (
				%windir%\System32\Robocopy.exe "tools\sd_switch\salty-nx\pack\!temp_salty-nx! " "%volume_letter%\ " /e >nul
			) else (
				call "%associed_language_script%" "homebrew_should_be_associed_with_at_least_one_cfw_error"
			)
		)
		IF "!temp_special_salty-nx!"=="N" %windir%\System32\Robocopy.exe "tools\sd_switch\salty-nx\pack\!temp_salty-nx! " "%volume_letter%\ " /e >nul
	) else (
		tools\gnuwin32\bin\sed.exe -i !temp_line!d "%salty-nx_profile_path%"
		set /a temp_line=!temp_line! - 1
		call "%associed_language_script%" "salty-nx_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
:skip_copy_salty-nx_pack
exit /b

:copy_emu_pack
IF /i NOT "%copy_emu%"=="o" (
	goto:skip_copy_emu_pack
) else (
	IF "%pass_copy_emu_pack%"=="Y" goto:skip_copy_emu_pack
)
IF EXIST "%volume_letter%\switch\pfba\skin\config.cfg" move "%volume_letter%\switch\pfba\skin\config.cfg" "%volume_letter%\switch\pfba\skin\config.cfg.bak" >nul
IF EXIST "%volume_letter%\switch\pnes\skin\config.cfg" move "%volume_letter%\switch\pnes\skin\config.cfg" "%volume_letter%\switch\pnes\skin\config.cfg.bak" >nul
IF EXIST "%volume_letter%\switch\psnes\skin\config.cfg" move "%volume_letter%\switch\psnes\skin\config.cfg" "%volume_letter%\switch\psnes\skin\config.cfg.bak" >nul
tools\gnuwin32\bin\grep.exe -c "" <"%emu_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	set temp_special_emulator=N
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%emu_profile_path%" >templogs\tempvar.txt
	set /p temp_emulator=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\emulators\pack\!temp_emulator!\folder_version.txt" (
		IF "!temp_emulator!"=="Nes_Classic_Edition" (
			IF NOT EXIST "tools\sd_switch\emulators\pack\Nes_Classic_Edition\switch\clover\user\data.json" (
				set config_nes_classic=
				call "%associed_language_script%" "config_nes_classic_choice"
				IF NOT "!config_nes_classic!"=="" set config_nes_classic=!config_nes_classic:~0,1!
				call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "config_nes_classic" "o/n_choice"
				IF /i "!config_nes_classic!"=="o" (
					call tools\NES_Injector\NES_Injector.bat
					call "%associed_language_script%" "display_title"
				)
			)
			IF NOT EXIST "tools\sd_switch\emulators\pack\Nes_Classic_Edition\switch\clover\user\data.json" (
				call "%associed_language_script%" "config_nes_classic_error"
				set temp_special_emulator=Y
			)
			IF NOT "!temp_special_emulator!"=="Y" (
				IF EXIST "%volume_letter%\switch\clover\user\boxart" rmdir /s /q "%volume_letter%\switch\clover\user\boxart"
				IF EXIST "%volume_letter%\switch\clover\user\rom" rmdir /s /q "%volume_letter%\switch\clover\user\rom"
				IF EXIST "%volume_letter%\switch\clover\user\thumbnail" rmdir /s /q "%volume_letter%\switch\clover\user\thumbnail"
				IF EXIST "%volume_letter%\switch\clover\user\data.json" del /q "%volume_letter%\switch\clover\user\data.json"
			)
		)
		IF "!temp_emulator!"=="Snes_Classic_Edition" (
			IF NOT EXIST "tools\sd_switch\emulators\pack\Snes_Classic_Edition\switch\snes_classic\game\database.json" (
				set config_snes_classic=
				call "%associed_language_script%" "config_snes_classic_choice"
				IF NOT "!config_snes_classic!"=="" set config_snes_classic=!config_snes_classic:~0,1!
				call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "config_snes_classic" "o/n_choice"
				IF /i "!config_snes_classic!"=="o" (
					call tools\SNES_Injector\SNES_Injector.bat
					call "%associed_language_script%" "display_title"
				)
			)
			IF NOT EXIST "tools\sd_switch\emulators\pack\Snes_Classic_Edition\switch\snes_classic\game\database.json" (
				call "%associed_language_script%" "config_snes_classic_error"
				set temp_special_emulator=Y
			)
			IF NOT "!temp_special_emulator!"=="Y" (
				IF EXIST "%volume_letter%\switch\snes_classic\game\boxart" rmdir /s /q "%volume_letter%\switch\snes_classic\game\boxart"
				IF EXIST "%volume_letter%\switch\snes_classic\game\rom" rmdir /s /q "%volume_letter%\switch\snes_classic\game\rom"
				IF EXIST "%volume_letter%\switch\snes_classic\game\thumbnail" rmdir /s /q "%volume_letter%\switch\snes_classic\game\thumbnail"
				IF EXIST "%volume_letter%\switch\snes_classic\game\database.json" del /q "%volume_letter%\switch\snes_classic\game\database.json"
			)
		)
		IF "!temp_emulator!"=="RetroArch" (
			set temp_special_emulator=Y
			IF NOT EXIST "tools\sd_switch\emulators\pack\RetroArch\RetroArch.7z" (
				call tools\storage\update_manager.bat "retroarch_update"
			)
			IF NOT EXIST "tools\sd_switch\emulators\pack\!temp_emulator!" (
				call "%associed_language_script%" "retroarch_not_exist_error"
			) else (
				tools\7zip\7za.exe x -y -sccUTF-8 "tools\sd_switch\emulators\pack\RetroArch\RetroArch.7z" -o"%volume_letter%\" -r
				IF NOT EXIST "%volume_letter%\switch\retroarch_switch" mkdir "%volume_letter%\switch\retroarch_switch"
				move "%volume_letter%\switch\retroarch_switch.nro" "%volume_letter%\switch\retroarch_switch\retroarch_switch.nro" >nul
			)
		)
		IF NOT "!temp_special_emulator!"=="Y" %windir%\System32\Robocopy.exe "tools\sd_switch\emulators\pack\!temp_emulator! " "%volume_letter%\ " /e >nul
	) else (
		tools\gnuwin32\bin\sed.exe -i !temp_line!d "%emu_profile_path%"
		set /a temp_line=!temp_line! - 1
		call "%associed_language_script%" "emulator_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
IF /i "%keep_emu_configs%"=="o" (
	del /q "%volume_letter%\switch\pfba\skin\config.cfg" >nul
	move "%volume_letter%\switch\pfba\skin\config.cfg.bak" "%volume_letter%\switch\pfba\skin\config.cfg" >nul
	del /q "%volume_letter%\switch\pnes\skin\config.cfg" >nul
	move "%volume_letter%\switch\pnes\skin\config.cfg.bak" "%volume_letter%\switch\pnes\skin\config.cfg" >nul
	del /q "%volume_letter%\switch\psnes\skin\config.cfg" >nul
	move "%volume_letter%\switch\psnes\skin\config.cfg.bak" "%volume_letter%\switch\psnes\skin\config.cfg" >nul
) else (
	IF EXIST "%volume_letter%\switch\pfba\skin\config.cfg.bak" del /q "%volume_letter%\switch\pfba\skin\config.cfg.bak"
	IF EXIST "%volume_letter%\switch\pnes\skin\config.cfg.bak" del /q "%volume_letter%\switch\pnes\skin\config.cfg.bak"
	IF EXIST "%volume_letter%\switch\psnes\skin\config.cfg.bak" del /q "%volume_letter%\switch\psnes\skin\config.cfg.bak"
)
:skip_copy_emu_pack
exit /b

:copy_cheats_profile
IF "%~1"=="atmosphere" set temp_cheats_copy_path=%volume_letter%\atmosphere\contents
IF "%~1"=="sxos" set temp_cheats_copy_path=%volume_letter%\sxos\titles
tools\gnuwin32\bin\grep.exe -c "" <"%cheats_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
set /a temp_line=1
for /l %%i in (1,1,%temp_count%) do (
	TOOLS\gnuwin32\bin\sed.exe -n !temp_line!p <"%cheats_profile_path%" >templogs\tempvar.txt
	set /p temp_cheat=<templogs\tempvar.txt
	IF EXIST "tools\sd_switch\cheats\titles\!temp_cheat!\*.*" (
		IF NOT EXIST "%temp_cheats_copy_path%\!temp_cheat!" mkdir "%temp_cheats_copy_path%\!temp_cheat!"
		%windir%\System32\Robocopy.exe "tools\sd_switch\cheats\titles\!temp_cheat! " "%temp_cheats_copy_path%\!temp_cheat!" /e >nul
	) else (
		tools\gnuwin32\bin\sed.exe -i !temp_line!d "%cheats_profile_path%"
		set /a temp_line=!temp_line! - 1
		call "%associed_language_script%" "cheat_not_exist_warning"
	)
	set /a temp_line=!temp_line! + 1
)
exit /b

:delete_cfw_files
IF EXIST "%volume_letter%\atmosphere" rmdir /s /q "%volume_letter%\atmosphere"
IF EXIST "%volume_letter%\bootloader" rmdir /s /q "%volume_letter%\bootloader"
IF EXIST "%volume_letter%\config" rmdir /s /q "%volume_letter%\config"
rem IF EXIST "%volume_letter%\emummc\emummc.ini" del /q "%volume_letter%\emummc\emummc.ini"
IF EXIST "%volume_letter%\ftpd" rmdir /s /q "%volume_letter%\ftpd"
IF EXIST "%volume_letter%\modules" rmdir /s /q "%volume_letter%\modules"
IF EXIST "%volume_letter%\ReiNX" rmdir /s /q "%volume_letter%\ReiNX"
IF EXIST "%volume_letter%\sept" rmdir /s /q "%volume_letter%\sept"
IF EXIST "%volume_letter%\SlideNX" rmdir /s /q "%volume_letter%\SlideNX"
IF EXIST "%volume_letter%\sxos\titles" rmdir /s /q "%volume_letter%\sxos\titles"
IF EXIST "%volume_letter%\boot.dat" del /q "%volume_letter%\boot.dat"
IF EXIST "%volume_letter%\hbmenu.nro" del /q "%volume_letter%\hbmenu.nro"
IF EXIST "%volume_letter%\xor.play.json" del /q "%volume_letter%\xor.play.json"
IF EXIST "%volume_letter%\switch\HekateBrew" rmdir /s /q "%volume_letter%\switch\HekateBrew"
IF EXIST "%volume_letter%\switch\atmosphere-updater" rmdir /s /q "%volume_letter%\switch\atmosphere-updater"
IF EXIST "%volume_letter%\switch\Kip_Select" rmdir /s /q "%volume_letter%\switch\Kip_Select"
IF EXIST "%volume_letter%\switch\Kosmos-Toolbox" rmdir /s /q "%volume_letter%\switch\Kosmos-Toolbox"
IF EXIST "%volume_letter%\switch\KosmosUpdater" rmdir /s /q "%volume_letter%\switch\KosmosUpdater"
IF EXIST "%volume_letter%\switch\ldnmitm_config" rmdir /s /q "%volume_letter%\switch\ldnmitm_config"
IF EXIST "%volume_letter%\switch\ReiNXToolkit" rmdir /s /q "%volume_letter%\switch\ReiNXToolkit"
IF EXIST "%volume_letter%\switch\ROMMENU" rmdir /s /q "%volume_letter%\switch\ROMMENU"
IF EXIST "%volume_letter%\switch\reboot_to_payload" rmdir /s /q "%volume_letter%\switch\reboot_to_payload"
IF EXIST "%volume_letter%\switch\sigpatch-updater" rmdir /s /q "%volume_letter%\switch\sigpatch-updater"
IF EXIST "%volume_letter%\switch\sigpatches-updater" rmdir /s /q "%volume_letter%\switch\sigpatches-updater"
IF EXIST "%volume_letter%\switch\SimpleModManager" rmdir /s /q "%volume_letter%\switch\SimpleModManager"
IF EXIST "%volume_letter%\switch\sx_installer" rmdir /s /q "%volume_letter%\switch\sx_installer"
IF EXIST "%volume_letter%\switch\SXDUMPER" rmdir /s /q "%volume_letter%\switch\SXDUMPER"
exit /b

:copy_atmosphere_configuration
Setlocal disabledelayedexpansion
IF /i "%atmo_upload_enabled%"=="o" (
	set atmo_upload_enabled=0x1
) else (
	set atmo_upload_enabled=0x0
)
IF /i "%atmo_usb30_force_enabled%"=="o" (
	set atmo_usb30_force_enabled=0x1
) else (
	set atmo_usb30_force_enabled=0x0
)
IF /i "%atmo_ease_nro_restriction%"=="o" (
	set atmo_ease_nro_restriction=0x1
) else (
	set atmo_ease_nro_restriction=0x0
)
IF /i "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
	set atmo_dmnt_cheats_enabled_by_default=0x1
) else (
	set atmo_dmnt_cheats_enabled_by_default=0x0
)
IF /i "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
	set atmo_dmnt_always_save_cheat_toggles=0x1
) else (
	set atmo_dmnt_always_save_cheat_toggles=0x0
)
IF /i "%atmo_enable_hbl_bis_write%"=="o" (
	set atmo_enable_hbl_bis_write=0x1
) else (
	set atmo_enable_hbl_bis_write=0x0
)
IF /i "%atmo_enable_hbl_cal_read%"=="o" (
	set atmo_enable_hbl_cal_read=0x1
) else (
	set atmo_enable_hbl_cal_read=0x0
)
IF /i "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
	set atmo_fsmitm_redirect_saves_to_sd=0x1
) else (
	set atmo_fsmitm_redirect_saves_to_sd=0x0
)
IF /i "%atmo_enable_am_debug_mode%"=="o" (
	set atmo_enable_am_debug_mode=0x1
) else (
	set atmo_enable_am_debug_mode=0x0
)
IF /i "%atmo_enable_dns_mitm%"=="o" (
	set atmo_enable_dns_mitm=0x1
) else (
	set atmo_enable_dns_mitm=0x0
)
IF /i "%atmo_add_defaults_to_dns_hosts%"=="o" (
	set atmo_add_defaults_to_dns_hosts=0x1
) else (
	set atmo_add_defaults_to_dns_hosts=0x0
)
IF /i "%atmo_enable_dns_mitm_debug_log%"=="o" (
	set atmo_enable_dns_mitm_debug_log=0x1
) else (
	set atmo_enable_dns_mitm_debug_log=0x0
)
IF /i "%atmo_enable_htc%"=="o" (
	set atmo_enable_htc=0x1
	set atmo_enable_log_manager=o
) else (
	set atmo_enable_htc=0x0
)
IF /i "%atmo_enable_log_manager%"=="o" (
	set atmo_enable_log_manager=0x1
) else (
	set atmo_enable_log_manager=0x0
)
IF /i "%atmo_enable_sd_card_logging%"=="o" (
	set atmo_enable_sd_card_logging=0x1
) else (
	set atmo_enable_sd_card_logging=0x0
)
IF /i "%atmo_sd_card_log_output_directory%"=="" (
	set atmo_sd_card_log_output_directory=atmosphere/binlogs
) else (
	set atmo_sd_card_log_output_directory=%atmo_sd_card_log_output_directory%
)
IF "%atmo_fatal_auto_reboot_interval%"=="" (
	set atmo_fatal_auto_reboot_interval=0x0
) else (
	set atmo_fatal_auto_reboot_interval=0x%atmo_fatal_auto_reboot_interval%
)
IF "%atmo_power_menu_reboot_function%"=="1" (
set atmo_power_menu_reboot_function=payload
) else IF "%atmo_power_menu_reboot_function%"=="2" (
set atmo_power_menu_reboot_function=rcm
) else IF "%atmo_power_menu_reboot_function%"=="3" (
set atmo_power_menu_reboot_function=normal
) else (
	set atmo_power_menu_reboot_function=payload
)
IF "%atmo_applet_heap_size%"=="" (
	set atmo_applet_heap_size=0x0
) else (
	set atmo_applet_heap_size=0x%atmo_applet_heap_size%
)
IF "%atmo_applet_heap_reservation_size%"=="" (
	set atmo_applet_heap_reservation_size=0x8600000
) else (
	set atmo_applet_heap_reservation_size=0x%atmo_applet_heap_reservation_size%
)
IF "%atmo_hbl_override_key%"=="" (
	set atmo_hbl_override_key=R
) else (
	IF "%inverted_atmo_hbl_override_key%"=="Y" set atmo_hbl_override_key=!%atmo_hbl_override_key%
)
IF "%atmo_override_address_space%"=="" (
	set atmo_override_address_space=39_bit
) else (
	set atmo_override_address_space=%atmo_override_address_space%_bit
)
IF "%atmo_hbl_override_any_app_key%"=="" (
	set atmo_hbl_override_any_app_key=R
) else (
	IF "%inverted_atmo_hbl_override_any_app_key%"=="Y" set atmo_hbl_override_any_app_key=!%atmo_hbl_override_any_app_key%
)
IF "%atmo_override_any_app_address_space%"=="" (
	set atmo_override_any_app_address_space=39_bit
) else (
	set atmo_override_any_app_address_space=%atmo_override_any_app_address_space%_bit
)
IF "%atmo_layeredfs_override_key%"=="" (
	set inverted_atmo_layeredfs_override_key=Y
	set atmo_layeredfs_override_key=L
)
	IF "%inverted_atmo_layeredfs_override_key%"=="Y" set atmo_layeredfs_override_key=!%atmo_layeredfs_override_key%
IF "%atmo_cheats_override_key%"=="" (
	set inverted_atmo_cheats_override_key=Y
	set atmo_cheats_override_key=L
)
	IF "%inverted_atmo_cheats_override_key%"=="Y" set atmo_cheats_override_key=!%atmo_cheats_override_key%
echo ; Disable uploading error reports to Nintendo>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [eupld]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo upload_enabled = u8!%atmo_upload_enabled%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Enable USB 3.0 superspeed for homebrew>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [usb]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo usb30_force_enabled = u8!%atmo_usb30_force_enabled%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Control whether RO should ease its validation of NROs.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; (note: this is normally not necessary, and ips patches can be used.)>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [ro]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ease_nro_restriction = u8!%atmo_ease_nro_restriction%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [lm]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Control whether lm should log to the SD card.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Note that this setting does nothing when log manager is not enabled.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_sd_card_logging = u8!%atmo_enable_sd_card_logging%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Control the output directory for SD card logs.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Note that this setting does nothing when log manager is not enabled/sd card logging is not enabled.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo sd_card_log_output_directory = str!%atmo_sd_card_log_output_directory%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Atmosphere custom settings>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [atmosphere]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Reboot from fatal automatically after some number of milliseconds.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; If field is not present or 0, fatal will wait indefinitely for user input.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo fatal_auto_reboot_interval = u64!%atmo_fatal_auto_reboot_interval%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Make the power menu's "reboot" button reboot to payload.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Set to "payload" to reboot to "/atmosphere\reboot_payload.bin" payload, "normal" for normal reboot, "rcm" for rcm reboot.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo power_menu_reboot_function = str!%atmo_power_menu_reboot_function%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether dmnt cheats should be toggled on or off by >>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; default. 1 = toggled on by default, 0 = toggled off by default.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo dmnt_cheats_enabled_by_default = u8!%atmo_dmnt_cheats_enabled_by_default%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether dmnt should always save cheat toggle state>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; for restoration on new game launch. 1 = always save toggles,>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = only save toggles if toggle file exists.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo dmnt_always_save_cheat_toggles = u8!%atmo_dmnt_always_save_cheat_toggles%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Enable writing to BIS partitions for HBL.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; This is probably undesirable for normal usage.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_hbl_bis_write = u8!%atmo_enable_hbl_bis_write%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Enable reading the CAL0 partition for HBL.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; This is probably undesirable for normal usage.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_hbl_cal_read = u8!%atmo_enable_hbl_cal_read%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether fs.mitm should redirect save files>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; to directories on the sd card.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Do not redirect, 1 = Redirect.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; NOTE: EXPERIMENTAL>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; If you do not know what you are doing, do not touch this yet.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo fsmitm_redirect_saves_to_sd = u8!%atmo_fsmitm_redirect_saves_to_sd%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether am sees system settings "DebugModeFlag" as>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; enabled or disabled.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled (not debug mode), 1 = Enabled (debug mode)>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_am_debug_mode = u8!%atmo_enable_am_debug_mode%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether dns.mitm is enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled, 1 = Enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_dns_mitm = u8!%atmo_enable_dns_mitm%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether dns.mitm uses the default redirections in addition to>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; whatever is specified in the user's hosts file.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled (use hosts file contents), 1 = Enabled (use defaults and hosts file contents)>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo add_defaults_to_dns_hosts = u8!%atmo_add_defaults_to_dns_hosts%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether dns.mitm logs to the sd card for debugging>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled, 1 = Enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_dns_mitm_debug_log = u8!%atmo_enable_dns_mitm_debug_log%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; ; Controls whether htc is enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled, 1 = Enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_htc = u8!%atmo_enable_htc%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls whether atmosphere's log manager is enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Note that this setting is ignored (and treated as 1) when htc is enabled.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; 0 = Disabled, 1 = Enabled>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo enable_log_manager = u8!%atmo_enable_log_manager%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo [hbloader]>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls the size of the homebrew heap when running as applet.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; If set to zero, all available applet memory is used as heap.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; The default is zero.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo applet_heap_size = u64!%atmo_applet_heap_size%>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; Controls the amount of memory to reserve when running as applet>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; for usage by other applets. This setting has no effect if>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo ; applet_heap_size is non-zero. The default is zero.>>"%volume_letter%\atmosphere\config\system_settings.ini"
echo applet_heap_reservation_size = u64!%atmo_applet_heap_reservation_size%>>"%volume_letter%\atmosphere\config\system_settings.ini"

echo [hbl_config]>%volume_letter%\atmosphere\config\override_config.ini
echo ; Program Specific Config>>%volume_letter%\atmosphere\config\override_config.ini
echo ; Up to 8 program-specific configurations can be set.>>%volume_letter%\atmosphere\config\override_config.ini
echo ; These use `program_id_#` and `override_key_#`>>%volume_letter%\atmosphere\config\override_config.ini
echo ; where # is in range [0,7].>>%volume_letter%\atmosphere\config\override_config.ini
echo program_id_0=010000000000100D>>%volume_letter%\atmosphere\config\override_config.ini
echo override_address_space_0=%atmo_override_address_space%>>%volume_letter%\atmosphere\config\override_config.ini
echo override_key_0=%atmo_hbl_override_key%>>%volume_letter%\atmosphere\config\override_config.ini
echo.>>%volume_letter%\atmosphere\config\override_config.ini
echo ; Any Application Config>>%volume_letter%\atmosphere\config\override_config.ini
echo ; Note that this will only apply to program IDs that>>%volume_letter%\atmosphere\config\override_config.ini
echo ; are both applications and not specified above>>%volume_letter%\atmosphere\config\override_config.ini
echo ; by a program specific config.>>%volume_letter%\atmosphere\config\override_config.ini
echo override_any_app=true>>%volume_letter%\atmosphere\config\override_config.ini
echo override_any_app_key=%atmo_hbl_override_any_app_key%>>%volume_letter%\atmosphere\config\override_config.ini
echo override_any_app_address_space=%atmo_override_any_app_address_space%>>%volume_letter%\atmosphere\config\override_config.ini
echo path=atmosphere/hbl.nsp>>%volume_letter%\atmosphere\config\override_config.ini
echo.>>%volume_letter%\atmosphere\config\override_config.ini
echo [default_config]>>%volume_letter%\atmosphere\config\override_config.ini
echo override_key=%atmo_layeredfs_override_key%>>%volume_letter%\atmosphere\config\override_config.ini
echo cheat_enable_key=%atmo_cheats_override_key%>>%volume_letter%\atmosphere\config\override_config.ini
endlocal
exit /b

:daybreak_convertion
rem set /a count_loop = 0
for /d %%f in ("%~1\*.nca") do (
	move "%%f" "%%f.bak" >nul
	move "%%f.bak\00" "%%f" >nul
	rmdir "%%f.bak"
)
for %%f in ("%~1\*.nca") do (
	set temp_file_size=%%~zf
	IF NOT EXIST "%%f\*.*" (
		set temp_file_name=%%f
		IF NOT "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			IF !temp_file_size! LEQ 8192 (
				rem echo Meta trouvé.
				move "!temp_file_name!" "!temp_file_name:~0,-3!cnmt.nca" >nul
			)
		) else IF "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			IF NOT !temp_file_size! LEQ 8192 (
				rem echo %%f
				rem echo NCA mal nommé.
				move "!temp_file_name!" "!temp_file_name:~0,-8!nca" >nul
			)
		)
	)
)
rem echo %count_loop%
exit /b

:endscript
pause
:endscript2
rmdir /s /q templogs
IF EXIST firmware_temp rmdir /s /q firmware_temp
endlocal