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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\profiles\*.*" mkdir "tools\sd_switch\profiles"

:define_action_choice
cls
set error_level=0
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "main_action_choice"
IF "%action_choice%"=="1" cls & goto:create_profile
IF "%action_choice%"=="2" cls & goto:modify_profile
IF "%action_choice%"=="3" cls & goto:remove_profile
IF "%action_choice%"=="0" cls & goto:info_profile
goto:end_script

:info_profile
call "%associed_language_script%" "intro_info_profile"
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "info_no_profile_exist_error"
	pause
	goto:define_action_choice
)
call "%associed_language_script%" "info_profile"
call %profile_path%
call tools\Storage\prepare_sd_switch_infos.bat
pause
goto:define_action_choice

:create_profile
:define_new_profile_name
set new_profile_name=
call "%associed_language_script%" "intro_create_profile"
IF "%new_profile_name%"=="" goto:define_action_choice
call TOOLS\Storage\functions\strlen.bat nb "%new_profile_name%"
set i=0
:check_chars_new_profile_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\ ^( ^) ^") do (
		IF "!new_profile_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "char_error_in_profile_name"
			goto:define_new_profile_name
		)
	)
	set /a i+=1
	goto:check_chars_new_profile_name
)
copy nul "tools\sd_switch\profiles\%new_profile_name%.bat" >nul
call "%associed_language_script%" "create_profile_success"
set profile_selected=%new_profile_name%.bat
set /a error_level=0
goto:skip_modify_select_profile

:modify_profile
call "%associed_language_script%" "intro_modify_profile"
echo.
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "modify_no_profile_exist_error"
	pause
	goto:define_action_choice
)
set /a error_level=0
:skip_modify_select_profile
IF %error_level% EQU 0 (
	call tools\Storage\prepare_sd_switch_files_questions.bat
	IF "%language_important_error%"=="Y" goto:define_action_choice
) else (
	goto:define_action_choice
)
IF %error_level% EQU 200 (
	call :save_profile_choices
)
goto:define_action_choice

:remove_profile
call "%associed_language_script%" "intro_delete_profile"
echo.
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "delete_no_profile_exist_error"
	pause
	goto:define_action_choice
)
IF %errorlevel% EQU 0 (
	del /q "tools\sd_switch\profiles\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\sd_switch\profiles\*.bat" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\profiles
for %%p in (*.bat) do (
	IF %%~zp EQU 0 (
		del /q %%p >nul
	) else (
		set temp_profilename=%%p
		set temp_profilename=!temp_profilename:~0,-4!
		echo !temp_count!: !temp_profilename!
		echo %%p>> ..\..\..\templogs\profiles_list.txt
		set /a temp_count+=1
	)
)
cd ..\..\..
set profile_choice=
call "%associed_language_script%" "select_profile_choice"
IF "%profile_choice%"=="" set /a profile_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%profile_choice%"
set i=0
:check_chars_profile_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!profile_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_profile_choice
		)
	)
	IF "!check_chars!"=="0" (
		exit /b 400
	)
)
IF %profile_choice% GEQ %temp_count% exit /b 400
IF %profile_choice% EQU 0 exit /b 400
TOOLS\gnuwin32\bin\sed.exe -n %profile_choice%p <templogs\profiles_list.txt > templogs\tempvar.txt
del /q templogs\profiles_list.txt >nul
set /p profile_selected=<templogs\tempvar.txt
set profile_path=tools\sd_switch\profiles\%profile_selected%
exit /b

:save_profile_choices
IF %error_level% NEQ 200 exit /b
set profile_path=tools\sd_switch\profiles\%profile_selected%
echo set "copy_atmosphere_pack=%copy_atmosphere_pack%">"%profile_path%"
echo set "atmosphere_enable_nogc_patch=%atmosphere_enable_nogc_patch%">>"%profile_path%"
echo set "atmosphere_manual_config=%atmosphere_manual_config%">>"%profile_path%"
echo set "atmo_upload_enabled=%atmo_upload_enabled%">>"%profile_path%"
echo set "atmo_usb30_force_enabled=%atmo_usb30_force_enabled%">>"%profile_path%"
echo set "atmo_ease_nro_restriction=%atmo_ease_nro_restriction%">>"%profile_path%"
echo set "atmo_fatal_auto_reboot_interval=%atmo_fatal_auto_reboot_interval%">>"%profile_path%"
echo set "atmo_power_menu_reboot_function=%atmo_power_menu_reboot_function%">>"%profile_path%"
echo set "atmo_dmnt_cheats_enabled_by_default=%atmo_dmnt_cheats_enabled_by_default%">>"%profile_path%"
echo set "atmo_dmnt_always_save_cheat_toggles=%atmo_dmnt_always_save_cheat_toggles%">>"%profile_path%"
echo set "atmo_enable_hbl_bis_write=%atmo_enable_hbl_bis_write%">>"%profile_path%"
echo set "atmo_enable_hbl_cal_read=%atmo_enable_hbl_cal_read%">>"%profile_path%"
echo set "atmo_fsmitm_redirect_saves_to_sd=%atmo_fsmitm_redirect_saves_to_sd%">>"%profile_path%"
echo set "atmo_enable_deprecated_hid_mitm=%atmo_enable_deprecated_hid_mitm%">>"%profile_path%"
echo set "atmo_enable_am_debug_mode=%atmo_enable_am_debug_mode%">>"%profile_path%"
echo set "atmo_applet_heap_size=%atmo_applet_heap_size%">>"%profile_path%"
echo set "atmo_applet_heap_reservation_size=%atmo_applet_heap_reservation_size%">>"%profile_path%"

echo set "atmo_hbl_override_key=%atmo_hbl_override_key%">>"%profile_path%"
echo set "inverted_atmo_hbl_override_key=%inverted_atmo_hbl_override_key%">>"%profile_path%"
echo set "atmo_override_address_space=%atmo_override_address_space%">>"%profile_path%"
echo set "atmo_hbl_override_any_app_key=%atmo_hbl_override_any_app_key%">>"%profile_path%"
echo set "inverted_atmo_hbl_override_any_app_key=%inverted_atmo_hbl_override_any_app_key%">>"%profile_path%"
echo set "atmo_override_any_app_address_space=%atmo_override_any_app_address_space%">>"%profile_path%"
echo set "atmo_cheats_override_key=%atmo_cheats_override_key%">>"%profile_path%"
echo set "inverted_atmo_cheats_override_key=%inverted_atmo_cheats_override_key%">>"%profile_path%"
echo set "atmo_layeredfs_override_key=%atmo_layeredfs_override_key%">>"%profile_path%"
echo set "inverted_atmo_layeredfs_override_key=%inverted_atmo_layeredfs_override_key%">>"%profile_path%"

echo set "atmosphere_pass_copy_emummc_pack=%atmosphere_pass_copy_emummc_pack%">>"%profile_path%"
echo set "atmosphere_emummc_profile_path=%atmosphere_emummc_profile_path%">>"%profile_path%"
echo set "atmosphere_pass_copy_modules_pack=%atmosphere_pass_copy_modules_pack%">>"%profile_path%"
echo set "atmosphere_modules_profile_path=%atmosphere_modules_profile_path%">>"%profile_path%"
echo set "copy_reinx_pack=%copy_reinx_pack%">>"%profile_path%"
echo set "reinx_enable_nogc_patch=%reinx_enable_nogc_patch%">>"%profile_path%"
echo set "reinx_pass_copy_modules_pack=%reinx_pass_copy_modules_pack%">>"%profile_path%"
echo set "reinx_modules_profile_path=%reinx_modules_profile_path%">>"%profile_path%"
echo set "copy_sxos_pack=%copy_sxos_pack%">>"%profile_path%"
echo set "remove_sx_autoloader=%remove_sx_autoloader%">>"%profile_path%"
echo set "copy_payloads=%copy_payloads%">>"%profile_path%"
echo set "sxos_pass_copy_modules_pack=%sxos_pass_copy_modules_pack%">>"%profile_path%"
echo set "sxos_modules_profile_path=%sxos_modules_profile_path%">>"%profile_path%"
echo set "copy_memloader=%copy_memloader%">>"%profile_path%"
echo set "copy_emu=%copy_emu%">>"%profile_path%"
echo set "keep_emu_configs=%keep_emu_configs%">>"%profile_path%"
echo set "pass_copy_emu_pack=%pass_copy_emu_pack%">>"%profile_path%"
echo set "emu_profile_path=%emu_profile_path%">>"%profile_path%"
echo set "update_retroarch=%update_retroarch%">>"%profile_path%"
echo set "pass_copy_mixed_pack=%pass_copy_mixed_pack%">>"%profile_path%"
echo set "mixed_profile_path=%mixed_profile_path%">>"%profile_path%"
echo set "pass_copy_overlays_pack=%pass_copy_overlays_pack%">>"%profile_path%"
echo set "overlays_profile_path=%overlays_profile_path%">>"%profile_path%"
echo set "pass_copy_salty-nx_pack=%pass_copy_salty-nx_pack%">>"%profile_path%"
echo set "salty-nx_profile_path=%salty-nx_profile_path%">>"%profile_path%"
echo set "copy_cheats=%copy_cheats%">>"%profile_path%"
echo set "copy_all_cheats_pack=%copy_all_cheats_pack%">>"%profile_path%"
echo set "cheats_profile_name=%cheats_profile_name%">>"%profile_path%"
echo set "cheats_profile_path=%cheats_profile_path%">>"%profile_path%"
echo set "atmosphere_enable_cheats=%atmosphere_enable_cheats%">>"%profile_path%"
echo set "sxos_enable_cheats=%sxos_enable_cheats%">>"%profile_path%"
echo set "sd_folder_structure_to_copy_choice=%sd_folder_structure_to_copy_choice%">>"%profile_path%"
echo set "sd_folder_structure_to_copy_path=%sd_folder_structure_to_copy_path%">>"%profile_path%"
echo set "del_files_dest_copy=%del_files_dest_copy%">>"%profile_path%"
call "%associed_language_script%" "values_saved_success"
pause
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal