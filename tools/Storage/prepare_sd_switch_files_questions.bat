::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
set this_script_full_path2=%~0
set associed_language_script2=%language_path%\!this_script_full_path2:%ushs_base_path%=!
set associed_language_script2=%ushs_base_path%%associed_language_script2%
set language_important_error=
IF NOT EXIST "%associed_language_script2%" (
	set associed_language_script2=languages\FR_fr\!this_script_full_path2:%ushs_base_path%=!
	set associed_language_script2=%ushs_base_path%!associed_language_script2!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script2%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	set language_important_error=Y
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version2=<"%~0.version
) else (
	set this_script_version2=1.00.00
)
call "%associed_language_script2%" "display_title"
echo.
call "%associed_language_script2%" "launch_manual_choice"
IF NOT "%launch_manual%"=="" set launch_manual=%launch_manual:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_manual" "o/n_choice"
IF /i "%launch_manual%"=="o" (
	start "" "%language_path%\doc\files\sd_prepare.html"
)

echo.
call "%associed_language_script2%" "copy_atmosphere_pack_choice"
IF NOT "%copy_atmosphere_pack%"=="" set copy_atmosphere_pack=%copy_atmosphere_pack:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_atmosphere_pack" "o/n_choice"
IF /i NOT "%copy_atmosphere_pack%"=="o" goto:skip_ask_cheats_atmosphere
:ask_nogc_atmosphere
echo.
call "%associed_language_script2%" "atmosphere_nogc_patch_choice"
IF NOT "%atmosphere_enable_nogc_patch%"=="" set atmosphere_enable_nogc_patch=%atmosphere_enable_nogc_patch:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmosphere_enable_nogc_patch" "o/n_choice"
:skip_ask_nogc_atmosphere
echo.
set atmosphere_manual_config=
call "%associed_language_script2%" "atmosphere_manual_config_choice"
IF NOT "%atmosphere_manual_config%"=="" set atmosphere_manual_config=%atmosphere_manual_config:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmosphere_manual_config" "o/n_choice"
IF /i "%atmosphere_manual_config%"=="o" call :set_atmosphere_configs
call :emummc_profile_choice "atmosphere"
call :modules_profile_choice "atmosphere"
IF "%cheats_update_error%"=="Y" goto:skip_ask_cheats_atmosphere
:ask_cheats_atmosphere
echo.
call "%associed_language_script2%" "atmosphere_copy_cheats_choice"
IF NOT "%atmosphere_enable_cheats%"=="" set atmosphere_enable_cheats=%atmosphere_enable_cheats:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmosphere_enable_cheats" "o/n_choice"
:skip_ask_cheats_atmosphere

echo.
rem IF /i "%copy_atmosphere_pack%"=="o" (
	rem call "%associed_language_script2%" "reinx_warning_if_atmosphere_chosen"
rem )
rem call "%associed_language_script2%" "copy_reinx_pack_choice"
IF NOT "%copy_reinx_pack%"=="" set copy_reinx_pack=%copy_reinx_pack:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_reinx_pack" "o/n_choice"
IF /i NOT "%copy_reinx_pack%"=="o" goto:skip_copy_reinx_pack
echo.
call "%associed_language_script2%" "reinx_nogc_patch_choice"
IF NOT "!reinx_enable_nogc_patch!"=="" set reinx_enable_nogc_patch=!reinx_enable_nogc_patch:~0,1!
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "reinx_enable_nogc_patch" "o/n_choice"
call :modules_profile_choice "reinx"
:skip_copy_reinx_pack

echo.
call "%associed_language_script2%" "copy_memloader_pack_choice"
IF NOT "%copy_memloader%"=="" set copy_memloader=%copy_memloader:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_memloader" "o/n_choice"

echo.
call "%associed_language_script2%" "copy_sxos_pack_choice"
IF NOT "%copy_sxos_pack%"=="" set copy_sxos_pack=%copy_sxos_pack:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_sxos_pack" "o/n_choice"
IF /i NOT "%copy_sxos_pack%"=="o" goto:skip_ask_cheats_sxos
call "%associed_language_script2%" "sxos_remove_sx_autoloader"
IF NOT "!remove_sx_autoloader!"=="" set remove_sx_autoloader=!remove_sx_autoloader:~0,1!
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "remove_sx_autoloader" "o/n_choice"
call "%associed_language_script2%" "sxos_copy_selected_payloads_sd_root_choice"
IF NOT "!copy_payloads!"=="" set copy_payloads=!copy_payloads:~0,1!
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_payloads" "o/n_choice"
call :modules_profile_choice "sxos"
IF "%cheats_update_error%"=="Y" goto:skip_ask_cheats_sxos
:ask_cheats_sxos
echo.
call "%associed_language_script2%" "sxos_cheats_copy_choice"
IF NOT "%sxos_enable_cheats%"=="" set sxos_enable_cheats=%sxos_enable_cheats:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "sxos_enable_cheats" "o/n_choice"
:skip_ask_cheats_sxos

echo.
call "%associed_language_script2%" "copy_emulators_pack_choice"
IF NOT "%copy_emu%"=="" set copy_emu=%copy_emu:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_emu" "o/n_choice"
IF /i "%copy_emu%"=="o" (
	IF /i NOT "%del_files_dest_copy%"=="o" (
		call "%associed_language_script2%" "emulators_kip_configs_choice"
		IF NOT "!keep_emu_configs!"=="" set keep_emu_configs=!keep_emu_configs:~0,1!
		call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "keep_emu_configs" "o/n_choice"
	)
) else (
	goto:skip_verif_emu_profile
)
:define_emu_select_profile
echo.
set emu_profile_path=
set emu_profile=
call "%associed_language_script2%" "emulators_profile_select_begin"
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\emulators\profiles\*.ini" (
	goto:emu_no_profile_created
)
cd tools\sd_switch\emulators\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:emu_no_profile_created
IF EXIST "tools\default_configs\emu_profile_all.ini" (
	call "%associed_language_script2%" "emulators_profile_all"
) else (
	set /a temp_count-=1
	set emu_no_default_config=Y
)
call "%associed_language_script2%" "emulators_profile_choice"
IF "%emu_profile%"=="" (
	set pass_copy_emu_pack=Y
	goto:skip_verif_emu_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%emu_profile%"
set i=0
:check_chars_emu_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!emu_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_emu_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_emu_pack=Y
		goto:skip_verif_emu_profile
	)
)
IF %emu_profile% GTR %temp_count% (
	set pass_copy_emu_pack=Y
		goto:skip_verif_emu_profile
)
IF "%emu_profile%"=="0" (
	call tools\Storage\emulators_pack_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_emu_select_profile
)
IF %emu_profile% EQU %temp_count% (
	IF NOT "%emu_no_default_config%"=="Y" (
		set emu_profile_path=tools\default_configs\emu_profile_all.ini
		goto:skip_verif_emu_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %emu_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p emu_profile_path=<templogs\tempvar.txt
set emu_profile_path=tools\sd_switch\emulators\profiles\%emu_profile_path%
:skip_verif_emu_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF /i NOT "%copy_emu%"=="o" goto:skip_retroarch_update_question
IF "%pass_copy_emu_pack%"=="Y" goto:skip_retroarch_update_question
set temp_count=0
tools\gnuwin32\bin\grep.exe -c "RetroArch" <"%emu_profile_path%" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="0" goto:skip_retroarch_update_question
set update_retroarch=
call "%associed_language_script2%" "retroarch_update_choice"
IF NOT "%update_retroarch%"=="" set update_retroarch=%update_retroarch:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "update_retroarch" "o/n_choice"
:skip_retroarch_update_question

:define_select_profile
echo.
set mixed_profile_path=
set mixed_profile=
call "%associed_language_script2%" "homebrews_profile_choice_begin"
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\mixed\profiles\*.ini" (
	goto:no_profile_created
)
cd tools\sd_switch\mixed\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:no_profile_created
IF EXIST "tools\default_configs\mixed_profile_all.ini" (
	call "%associed_language_script2%" "homebrews_profile_all"
) else (
	set /a temp_count-=1
	set no_default_config=Y
)
call "%associed_language_script2%" "homebrews_profile_choice"
IF "%mixed_profile%"=="" (
	set pass_copy_mixed_pack=Y
	goto:skip_verif_mixed_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%mixed_profile%"
set i=0
:check_chars_mixed_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!mixed_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_mixed_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_mixed_pack=Y
		goto:skip_verif_mixed_profile
	)
)
IF %mixed_profile% GTR %temp_count% (
	set pass_copy_mixed_pack=Y
		goto:skip_verif_mixed_profile
)
IF "%mixed_profile%"=="0" (
	call tools\Storage\mixed_pack_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_select_profile
)
IF %mixed_profile% EQU %temp_count% (
	IF NOT "%no_default_config%"=="Y" (
		set mixed_profile_path=tools\default_configs\mixed_profile_all.ini
		goto:skip_verif_mixed_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %mixed_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p mixed_profile_path=<templogs\tempvar.txt
set mixed_profile_path=tools\sd_switch\mixed\profiles\%mixed_profile_path%
:skip_verif_mixed_profile
del /q templogs\profiles_list.txt >nul

:define_select_overlays_profile
echo.
set overlays_profile_path=
set overlays_profile=
call "%associed_language_script2%" "overlays_profile_choice_begin"
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\overlays\profiles\*.ini" (
	goto:no_overlays_profile_created
)
cd tools\sd_switch\overlays\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:no_overlays_profile_created
IF EXIST "tools\default_configs\overlays_profile_all.ini" (
	call "%associed_language_script2%" "overlays_profile_all"
) else (
	set /a temp_count-=1
	set no_default_config=Y
)
call "%associed_language_script2%" "overlays_profile_choice"
IF "%overlays_profile%"=="" (
	set pass_copy_overlays_pack=Y
	goto:skip_verif_overlays_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%overlays_profile%"
set i=0
:check_chars_overlays_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!overlays_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_overlays_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_overlays_pack=Y
		goto:skip_verif_overlays_profile
	)
)
IF %overlays_profile% GTR %temp_count% (
	set pass_copy_overlays_pack=Y
		goto:skip_verif_overlays_profile
)
IF "%overlays_profile%"=="0" (
	call tools\Storage\overlays_pack_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_select_overlays_profile
)
IF %overlays_profile% EQU %temp_count% (
	IF NOT "%no_default_config%"=="Y" (
		set overlays_profile_path=tools\default_configs\overlays_profile_all.ini
		goto:skip_verif_overlays_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %overlays_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p overlays_profile_path=<templogs\tempvar.txt
set overlays_profile_path=tools\sd_switch\overlays\profiles\%overlays_profile_path%
:skip_verif_overlays_profile
del /q templogs\profiles_list.txt >nul

:define_select_cheats_profile
set cheats_profile_path=
set cheats_profile_name=
set cheats_profile=
set copy_cheats=
copy nul templogs\profiles_list.txt >nul
IF /i "%atmosphere_enable_cheats%"=="o" set copy_cheats=Y
IF /i "%sxos_enable_cheats%"=="o" set copy_cheats=Y
IF NOT "%copy_cheats%"=="Y" goto:skip_verif_cheats_profile
echo.
call "%associed_language_script2%" "cheats_profile_choice_begin"
set /a temp_count=1
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.ini" (
	goto:no_cheats_profile_created
)
cd tools\sd_switch\cheats\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:no_cheats_profile_created
call "%associed_language_script2%" "cheats_profile_choice"
IF "%cheats_profile%"=="" (
	set copy_all_cheats_pack=Y
	goto:skip_verif_cheats_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%cheats_profile%"
set i=0
:check_chars_cheats_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!cheats_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_cheats_profile
		)
	)
	IF "!check_chars!"=="0" (
		set copy_all_cheats_pack=Y
		goto:skip_verif_cheats_profile
	)
)
IF %cheats_profile% GTR %temp_count% (
	set copy_all_cheats_pack=Y
		goto:skip_verif_cheats_profile
)
IF "%cheats_profile%"=="0" (
	call tools\Storage\cheats_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_select_cheats_profile
)
TOOLS\gnuwin32\bin\sed.exe -n %cheats_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p cheats_profile_path=<templogs\tempvar.txt
set cheats_profile_name=%cheats_profile_path:~0,-4%
set cheats_profile_path=tools\sd_switch\cheats\profiles\%cheats_profile_path%
:skip_verif_cheats_profile
del /q templogs\profiles_list.txt >nul

:define_del_files_dest_copy
set del_files_dest_copy=
IF /i NOT "%format_choice%"=="o" (
	echo.
	call "%associed_language_script2%" "del_files_dest_copy_choice"
) else (
	set del_files_dest_copy=0
)
IF "%del_files_dest_copy%"=="1" goto:confirm_settings
IF "%del_files_dest_copy%"=="2" goto:confirm_settings
IF "%del_files_dest_copy%"=="0" goto:confirm_settings
call "%associed_language_script2%" "bad_choice"
goto:define_del_files_dest_copy

:confirm_settings
call tools\Storage\prepare_sd_switch_infos.bat
call "%associed_language_script2%" "display_title"
set confirm_copy=
call "%associed_language_script2%" "confirm_script_settings"
IF NOT "%confirm_copy%"=="" set confirm_copy=%confirm_copy:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "confirm_copy" "o/n_choice"
IF /i "%confirm_copy%"=="o" (
	set errorlevel=200
	goto:endscript
	
) else IF /i "%confirm_copy%"=="n" (
	call "%associed_language_script2%" "canceled"
	pause
	set errorlevel=400
	goto:endscript
) else (
	call "%associed_language_script2%" "bad_choice"
	goto:confirm_settings
)

:modules_profile_choice
:define_modules_select_profile
echo.
set modules_profile_path=
set modules_profile=
set pass_copy_modules_pack=
call "%associed_language_script2%" "modules_profile_choice_begin" "%~1"
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\modules\profiles\*.ini" (
	goto:modules_no_profile_created
)
cd tools\sd_switch\modules\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:modules_no_profile_created
IF EXIST "tools\default_configs\modules_profile_all.ini" (
	call "%associed_language_script2%" "modules_profile_all"
	set modules_no_default_config=N
) else (
	set /a temp_count-=1
	set modules_no_default_config=Y
)
call "%associed_language_script2%" "modules_profile_choice"
IF "%modules_profile%"=="" (
	set pass_copy_modules_pack=Y
	goto:skip_verif_modules_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%modules_profile%"
set i=0
:check_chars_modules_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!modules_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_modules_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_modules_pack=Y
		goto:skip_verif_modules_profile
	)
)
IF %modules_profile% GTR %temp_count% (
	set pass_copy_modules_pack=Y
		goto:skip_verif_modules_profile
)
IF "%modules_profile%"=="0" (
	call tools\Storage\modules_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_modules_select_profile
)
IF %modules_profile% EQU %temp_count% (
	IF NOT "%modules_no_default_config%"=="Y" (
		set modules_profile_path=tools\default_configs\modules_profile_all.ini
		goto:skip_verif_modules_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %modules_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p modules_profile_path=<templogs\tempvar.txt
set modules_profile_path=tools\sd_switch\modules\profiles\%modules_profile_path%
:skip_verif_modules_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF "%~1"=="atmosphere" (
	set atmosphere_modules_profile_path=%modules_profile_path%
	set atmosphere_pass_copy_modules_pack=%pass_copy_modules_pack%
)
IF "%~1"=="reinx" (
	set reinx_modules_profile_path=%modules_profile_path%
	set reinx_pass_copy_modules_pack=%pass_copy_modules_pack%
)
IF "%~1"=="sxos" (
	set sxos_modules_profile_path=%modules_profile_path%
	set sxos_pass_copy_modules_pack=%pass_copy_modules_pack%
)
exit /b

:set_atmosphere_configs
call "%associed_language_script2%" "atmosphere_manual_config_intro"
echo.
set atmo_upload_enabled=
call "%associed_language_script2%" "atmosphere_manual_config_upload_param_choice"
IF NOT "%atmo_upload_enabled%"=="" set atmo_upload_enabled=%atmo_upload_enabled:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_upload_enabled" "o/n_choice"
set atmo_usb30_force_enabled=
call "%associed_language_script2%" "atmosphere_manual_config_usb3_param_choice"
IF NOT "%atmo_usb30_force_enabled%"=="" set atmo_usb30_force_enabled=%atmo_usb30_force_enabled:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_usb30_force_enabled" "o/n_choice"
set atmo_ease_nro_restriction=
call "%associed_language_script2%" "atmosphere_manual_config_nro-restrict_param_choice"
IF NOT "%atmo_ease_nro_restriction%"=="" set atmo_ease_nro_restriction=%atmo_ease_nro_restriction:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_ease_nro_restriction" "o/n_choice"
:define_atmo_fatal_auto_reboot_interval
set atmo_fatal_auto_reboot_interval=
call "%associed_language_script2%" "atmosphere_manual_config_fatal-reboot_interval_param_choice"
IF "%atmo_fatal_auto_reboot_interval%"=="" set atmo_fatal_auto_reboot_interval=0
call TOOLS\Storage\functions\strlen.bat nb "%atmo_fatal_auto_reboot_interval%"
set i=0
:check_chars_atmo_fatal_auto_reboot_interval
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!atmo_fatal_auto_reboot_interval:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_atmo_fatal_auto_reboot_interval
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script2%" "bad_value"
		goto:define_atmo_fatal_auto_reboot_interval
	)
)
	IF %atmo_fatal_auto_reboot_interval% EQU 0 goto:skip_define_atmo_fatal_auto_reboot_interval
IF %atmo_fatal_auto_reboot_interval% LSS 10 (
	call "%associed_language_script2%" "atmosphere_manual_config_fatal-reboot-interval_param_too_low_error"
	goto:define_atmo_fatal_auto_reboot_interval
)
:skip_define_atmo_fatal_auto_reboot_interval
:set_atmo_power_menu_reboot_function
set atmo_power_menu_reboot_function=
call "%associed_language_script2%" "atmosphere_manual_config_reboot-method_param_choice"
IF "%atmo_power_menu_reboot_function%"=="" (
	call "%associed_language_script2%" "empty_value_error"
	goto:set_atmo_power_menu_reboot_function
)
IF "%atmo_power_menu_reboot_function%"=="1" goto:skip_set_atmo_power_menu_reboot_function
IF "%atmo_power_menu_reboot_function%"=="2" goto:skip_set_atmo_power_menu_reboot_function
IF "%atmo_power_menu_reboot_function%"=="3" goto:skip_set_atmo_power_menu_reboot_function
call "%associed_language_script2%" "bad_choice"
goto:set_atmo_power_menu_reboot_function
:skip_set_atmo_power_menu_reboot_function
set atmo_dmnt_cheats_enabled_by_default=
call "%associed_language_script2%" "atmosphere_manual_config_cheats-default-state_param_choice"
IF NOT "%atmo_dmnt_cheats_enabled_by_default%"=="" set atmo_dmnt_cheats_enabled_by_default=%atmo_dmnt_cheats_enabled_by_default:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_dmnt_cheats_enabled_by_default" "o/n_choice"
set atmo_dmnt_always_save_cheat_toggles=
call "%associed_language_script2%" "atmosphere_manual_config_cheats-save-state_param_choice"
IF NOT "%atmo_dmnt_always_save_cheat_toggles%"=="" set atmo_dmnt_always_save_cheat_toggles=%atmo_dmnt_always_save_cheat_toggles:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_dmnt_always_save_cheat_toggles" "o/n_choice"
set atmo_enable_hbl_bis_write=
call "%associed_language_script2%" "atmosphere_manual_enable_hbl_bis_write"
IF NOT "%atmo_enable_hbl_bis_write%"=="" set atmo_enable_hbl_bis_write=%atmo_enable_hbl_bis_write:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_enable_hbl_bis_write" "o/n_choice"
set atmo_enable_hbl_cal_read=
call "%associed_language_script2%" "atmosphere_manual_enable_hbl_cal_read"
IF NOT "%atmo_enable_hbl_cal_read%"=="" set atmo_enable_hbl_cal_read=%atmo_enable_hbl_cal_read:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_enable_hbl_cal_read" "o/n_choice"
set atmo_fsmitm_redirect_saves_to_sd=
call "%associed_language_script2%" "atmosphere_manual_config_gamesave-on-sd_param_choice"
IF NOT "%atmo_fsmitm_redirect_saves_to_sd%"=="" set atmo_fsmitm_redirect_saves_to_sd=%atmo_fsmitm_redirect_saves_to_sd:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_fsmitm_redirect_saves_to_sd" "o/n_choice"
set atmo_enable_deprecated_hid_mitm=
call "%associed_language_script2%" "atmosphere_manual_enable_deprecated_hid_mitm_param_choice"
IF NOT "%atmo_enable_deprecated_hid_mitm%"=="" set atmo_enable_deprecated_hid_mitm=%atmo_enable_deprecated_hid_mitm:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "atmo_enable_deprecated_hid_mitm" "o/n_choice"
:define_atmo_applet_heap_size
set atmo_applet_heap_size=
call "%associed_language_script2%" "atmosphere_manual_config_applet-heap-size_param_choice"
IF "%atmo_applet_heap_size%"=="" set atmo_applet_heap_size=0
call TOOLS\Storage\functions\strlen.bat nb "%atmo_applet_heap_size%"
set i=0
:check_chars_atmo_applet_heap_size
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!atmo_applet_heap_size:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_atmo_applet_heap_size
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script2%" "bad_value"
		goto:define_atmo_applet_heap_size
	)
)
IF %atmo_applet_heap_size% NEQ 0 (
	set atmo_applet_heap_reservation_size=8000000
	goto:skip_define_atmo_applet_heap_reservation_size
)
:skip_define_atmo_applet_heap_size
:define_atmo_applet_heap_reservation_size
set atmo_applet_heap_reservation_size=
call "%associed_language_script2%" "atmosphere_manual_config_applet-heap-reservation-size_param_choice"
IF "%atmo_applet_heap_reservation_size%"=="" set atmo_applet_heap_reservation_size=8600000
call TOOLS\Storage\functions\strlen.bat nb "%atmo_applet_heap_reservation_size%"
set i=0
:check_chars_atmo_applet_heap_reservation_size
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!atmo_applet_heap_reservation_size:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_atmo_applet_heap_reservation_size
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script2%" "bad_value"
		goto:define_atmo_applet_heap_reservation_size
	)
)
:skip_define_atmo_applet_heap_reservation_size
echo.
call "%associed_language_script2%" "atmosphere_manual_config_buttons_functions_activation_infos"
echo.

:set_atmo_hbl_override_key
set atmo_hbl_override_key=
call "%associed_language_script2%" "atmosphere_manual_config_hbl_button_param_choice"
Setlocal disabledelayedexpansion
IF "%atmo_hbl_override_key%"=="" (
	call "%associed_language_script2%" "empty_value_error"
	endlocal
	goto:set_atmo_hbl_override_key
)
call TOOLS\Storage\functions\strlen.bat nb "%atmo_hbl_override_key%"
IF "%atmo_hbl_override_key:~0,1%"=="!" (
	IF %nb% EQU 1 (
		call "%associed_language_script2%" "value_not_accepted_error"
		endlocal
		goto:set_atmo_hbl_override_key
	)
	set inverted_atmo_hbl_override_key=Y
) else (
set inverted_atmo_hbl_override_key=N
)
echo %inverted_atmo_hbl_override_key%>templogs\tempvar.txt
endlocal
set /p inverted_atmo_hbl_override_key=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
IF "%inverted_atmo_hbl_override_key%"=="Y" (
	echo "%atmo_hbl_override_key:~1%">templogs\tempvar.txt
) else (
	echo "%atmo_hbl_override_key%">templogs\tempvar.txt
)
endlocal
set /p atmo_hbl_override_key=<templogs\tempvar.txt
set atmo_hbl_override_key=%atmo_hbl_override_key:"=%
:check_atmo_hbl_override_key
set check_chars=0
FOR %%z in (A B X Y L R ZL ZR LS RS SL SR + - DLEFT DUP DRIGHT DDOWN) do (
	IF "%atmo_hbl_override_key%"=="%%z" (
		set check_chars=1
		goto:skip_check_atmo_hbl_override_key
	)
)
IF "%check_chars%"=="0" (
	call "%associed_language_script2%" "bad_value"
	goto:set_atmo_hbl_override_key
)
:skip_check_atmo_hbl_override_key

:set_atmo_hbl_override_any_app_key
set atmo_hbl_override_any_app_key=
call "%associed_language_script2%" "atmosphere_manual_config_hbl_app_button_param_choice"
Setlocal disabledelayedexpansion
IF "%atmo_hbl_override_any_app_key%"=="" (
	call "%associed_language_script2%" "empty_value_error"
	endlocal
	goto:set_atmo_hbl_override_any_app_key
)
call TOOLS\Storage\functions\strlen.bat nb "%atmo_hbl_override_any_app_key%"
IF "%atmo_hbl_override_any_app_key:~0,1%"=="!" (
	IF %nb% EQU 1 (
		call "%associed_language_script2%" "value_not_accepted_error"
		endlocal
		goto:set_atmo_hbl_override_any_app_key
	)
	set inverted_atmo_hbl_override_any_app_key=Y
) else (
set inverted_atmo_hbl_override_any_app_key=N
)
echo %inverted_atmo_hbl_override_any_app_key%>templogs\tempvar.txt
endlocal
set /p inverted_atmo_hbl_override_any_app_key=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
IF "%inverted_atmo_hbl_override_any_app_key%"=="Y" (
	echo "%atmo_hbl_override_any_app_key:~1%">templogs\tempvar.txt
) else (
	echo "%atmo_hbl_override_any_app_key%">templogs\tempvar.txt
)
endlocal
set /p atmo_hbl_override_any_app_key=<templogs\tempvar.txt
set atmo_hbl_override_any_app_key=%atmo_hbl_override_any_app_key:"=%
:check_atmo_hbl_override_any_app_key
set check_chars=0
FOR %%z in (A B X Y L R ZL ZR LS RS SL SR + - DLEFT DUP DRIGHT DDOWN) do (
	IF "%atmo_hbl_override_any_app_key%"=="%%z" (
		set check_chars=1
		goto:skip_check_atmo_hbl_override_any_app_key
	)
)
IF "%check_chars%"=="0" (
	call "%associed_language_script2%" "bad_value"
	goto:set_atmo_hbl_override_any_app_key
)
:skip_check_atmo_hbl_override_any_app_key

:set_atmo_cheats_override_key
set atmo_cheats_override_key=
call "%associed_language_script2%" "atmosphere_manual_config_cheats_button_param_choice"
Setlocal disabledelayedexpansion
IF "%atmo_cheats_override_key%"=="" (
	call "%associed_language_script2%" "empty_value_error"
	endlocal
	goto:set_atmo_cheats_override_key
)
call TOOLS\Storage\functions\strlen.bat nb "%atmo_cheats_override_key%"
IF "%atmo_cheats_override_key:~0,1%"=="!" (
	IF %nb% EQU 1 (
		call "%associed_language_script2%" "value_not_accepted_error"
		endlocal
		goto:set_atmo_cheats_override_key
	)
	set inverted_atmo_cheats_override_key=Y
) else (
set inverted_atmo_cheats_override_key=N
)
echo %inverted_atmo_cheats_override_key%>templogs\tempvar.txt
endlocal
set /p inverted_atmo_cheats_override_key=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
IF "%inverted_atmo_cheats_override_key%"=="Y" (
	echo "%atmo_cheats_override_key:~1%">templogs\tempvar.txt
) else (
	echo "%atmo_cheats_override_key%">templogs\tempvar.txt
)
endlocal
set /p atmo_cheats_override_key=<templogs\tempvar.txt
set atmo_cheats_override_key=%atmo_cheats_override_key:"=%
:check_atmo_cheats_override_key
set check_chars=0
FOR %%z in (A B X Y L R ZL ZR LS RS SL SR + - DLEFT DUP DRIGHT DDOWN) do (
	IF "%atmo_cheats_override_key%"=="%%z" (
		set check_chars=1
		goto:skip_check_atmo_cheats_override_key
	)
)
IF "%check_chars%"=="0" (
	call "%associed_language_script2%" "bad_value"
	goto:set_atmo_cheats_override_key
)
:skip_check_atmo_cheats_override_key

:set_atmo_layeredfs_override_key
set atmo_layeredfs_override_key=
call "%associed_language_script2%" "atmosphere_manual_config_layeredfs_button_param_choice"
Setlocal disabledelayedexpansion
IF "%atmo_layeredfs_override_key%"=="" (
	call "%associed_language_script2%" "empty_value_error"
	endlocal
	goto:set_atmo_layeredfs_override_key
)
call TOOLS\Storage\functions\strlen.bat nb "%atmo_layeredfs_override_key%"
IF "%atmo_layeredfs_override_key:~0,1%"=="!" (
	IF %nb% EQU 1 (
		call "%associed_language_script2%" "value_not_accepted_error"
		endlocal
		goto:set_atmo_layeredfs_override_key
	)
	set inverted_atmo_layeredfs_override_key=Y
) else (
set inverted_atmo_layeredfs_override_key=N
)
echo %inverted_atmo_layeredfs_override_key%>templogs\tempvar.txt
endlocal
set /p inverted_atmo_layeredfs_override_key=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
IF "%inverted_atmo_layeredfs_override_key%"=="Y" (
	echo "%atmo_layeredfs_override_key:~1%">templogs\tempvar.txt
) else (
	echo "%atmo_layeredfs_override_key%">templogs\tempvar.txt
)
endlocal
set /p atmo_layeredfs_override_key=<templogs\tempvar.txt
set atmo_layeredfs_override_key=%atmo_layeredfs_override_key:"=%
:check_atmo_layeredfs_override_key
set check_chars=0
FOR %%z in (A B X Y L R ZL ZR LS RS SL SR + - DLEFT DUP DRIGHT DDOWN) do (
	IF "%atmo_layeredfs_override_key%"=="%%z" (
		set check_chars=1
		goto:skip_check_atmo_layeredfs_override_key
	)
)
IF "%check_chars%"=="0" (
	call "%associed_language_script2%" "bad_value"
	goto:set_atmo_layeredfs_override_key
)
:skip_check_atmo_layeredfs_override_key
exit /b

:emummc_profile_choice
:define_emummc_select_profile
echo.
set emummc_profile_path=
set emummc_profile=
set pass_copy_emummc_pack=
call "%associed_language_script2%" "emummc_profile_choice_begin" "%~1"
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\atmosphere_emummc_profiles\*.ini" (
	goto:emummc_no_profile_created
)
cd tools\sd_switch\atmosphere_emummc_profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..
:emummc_no_profile_created
IF EXIST "tools\default_configs\emummc_profile_sxos_partition_share.ini" (
	call "%associed_language_script2%" "emummc_profile_partition_sxos_and_atmosphere"
	set emummc_no_default_config=N
) else (
	set /a temp_count-=1
	set emummc_no_default_config=Y
)
call "%associed_language_script2%" "emummc_profile_choice"
IF "%emummc_profile%"=="" (
	set pass_copy_emummc_pack=Y
	goto:skip_verif_emummc_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%emummc_profile%"
set i=0
:check_chars_emummc_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!emummc_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_emummc_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_emummc_pack=Y
		goto:skip_verif_emummc_profile
	)
)
IF %emummc_profile% GTR %temp_count% (
	set pass_copy_emummc_pack=Y
		goto:skip_verif_emummc_profile
)
IF "%emummc_profile%"=="0" (
	call tools\Storage\emummc_profiles_management.bat
	call "%associed_language_script2%" "display_title"
	goto:define_emummc_select_profile
)
IF %emummc_profile% EQU %temp_count% (
	IF NOT "%emummc_no_default_config%"=="Y" (
		set emummc_profile_path=tools\default_configs\emummc_profile_sxos_partition_share.ini
		goto:skip_verif_emummc_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %emummc_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p emummc_profile_path=<templogs\tempvar.txt
set emummc_profile_path=tools\sd_switch\atmosphere_emummc_profiles\%emummc_profile_path%
:skip_verif_emummc_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF "%~1"=="atmosphere" (
	set atmosphere_emummc_profile_path=%emummc_profile_path%
	set atmosphere_pass_copy_emummc_pack=%pass_copy_emummc_pack%
)
IF "%~1"=="reinx" (
	set reinx_emummc_profile_path=%emummc_profile_path%
	set reinx_pass_copy_emummc_pack=%pass_copy_emummc_pack%
)
exit /b

:endscript