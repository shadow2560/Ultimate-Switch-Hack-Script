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
:define_action_choice
call "%associed_language_script%" "display_title"
set action_choice=
cls
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="1" goto:save_config
IF "%action_choice%"=="2" goto:restaure_config
IF "%action_choice%"=="3" goto:restaure_default
IF "%action_choice%"=="4" goto:default_auto_update
IF "%action_choice%"=="5" goto:default_toolbox
IF "%action_choice%"=="6" goto:default_switch-lan-play
IF "%action_choice%"=="7" goto:default_keys_nsc_builder
IF "%action_choice%"=="8" goto:default_keys_hactool
IF "%action_choice%"=="9" goto:sd_packs_profiles_management
IF "%action_choice%"=="10" goto:mixed_packs_profiles_management
IF "%action_choice%"=="11" goto:cheats_profiles_management
IF "%action_choice%"=="12" goto:emu_profiles_management
IF "%action_choice%"=="13" goto:modules_profiles_management
IF "%action_choice%"=="14" goto:overlays_profiles_management
IF "%action_choice%"=="15" goto:emummc_profiles_management
IF "%action_choice%"=="16" goto:salty-nx_profiles_management
goto:end_script
:save_config
set action_choice=
echo.
cls
call TOOLS\Storage\save_configs.bat
@echo off
goto:define_action_choice
:restaure_config
set action_choice=
echo.
cls
call TOOLS\Storage\restore_configs.bat
@echo off
goto:define_action_choice
:restaure_default
set action_choice=
echo.
cls
call TOOLS\Storage\restore_default.bat
@echo off
goto:define_action_choice
:default_auto_update
setlocal
echo.
IF NOT EXIST "templogs\*.*" mkdir templogs
tools\gnuwin32\bin\grep.exe -n "set auto_update=" <"%language_path%\script_general_config.bat" >templogs\tempvar.txt
set /p temp_auto_update_line=<templogs\tempvar.txt
IF NOT "%temp_auto_update_line%"=="" (
	echo %temp_auto_update_line%| "tools\gnuwin32\bin\cut.exe" -d : -f 1 >templogs\tempvar.txt
	set /p auto_update_file_param_line=<templogs\tempvar.txt
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d = -f 2 >templogs\tempvar.txt
	set /p ini_auto_update=<templogs\tempvar.txt
)
"tools\gnuwin32\bin\sed.exe" %auto_update_file_param_line%d "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
del /q "%language_path%\script_general_config.bat"
ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
rmdir /s /q templogs
endlocal
call "%associed_language_script%" "auto_update_reset_success"
pause
goto:define_action_choice
:default_toolbox
echo.
rmdir /s /q tools\toolbox
mkdir tools\toolbox
copy tools\default_configs\default_tools.txt tools\toolbox\default_tools.txt >nul
copy nul tools\toolbox\user_tools.txt >nul
call "%associed_language_script%" "toolbox_reset_success"
pause
goto:define_action_choice
:default_switch-lan-play
echo.
copy /v "tools\default_configs\servers_list.txt" "tools\netplay\servers_list.txt"
call "%associed_language_script%" "switchlanplay_reset_success"
pause
goto:define_action_choice
:default_keys_nsc_builder
echo.
del /q "tools\NSC_Builder\keys.txt" 2>nul
call "%associed_language_script%" "nscbuilder_keys_file_reset_success"
pause
goto:define_action_choice
:default_keys_hactool
echo.
del /q "tools\Hactool_based_programs\keys.txt" 2>nul
del /q "tools\Hactool_based_programs\keys.dat" 2>nul
call "%associed_language_script%" "hactool_keys_file_reset_success"
pause
goto:define_action_choice
:sd_packs_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prepare_sd_switch_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch_profiles_management.bat" "force"
)
call TOOLS\Storage\prepare_sd_switch_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:mixed_packs_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\mixed_pack_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_mixed_pack_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_mixed_pack_profiles_management.bat" "force"
)
call TOOLS\Storage\mixed_pack_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:cheats_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\cheats_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_cheats_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_cheats_profiles_management.bat" "force"
)
call TOOLS\Storage\cheats_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:emu_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\emulators_pack_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_emulators_pack_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_emulators_pack_profiles_management.bat" "force"
)
call TOOLS\Storage\emulators_pack_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:modules_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\modules_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_modules_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_modules_profiles_management.bat" "force"
)
call TOOLS\Storage\modules_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:overlays_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\overlays_pack_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_overlays_pack_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_overlays_pack_profiles_management.bat" "force"
)
call TOOLS\Storage\overlays_pack_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:emummc_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\emummc_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_emummc_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_emummc_profiles_management.bat" "force"
)
call TOOLS\Storage\emummc_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:salty-nx_profiles_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\saltynx_pack_profiles_management.bat" (
	call tools\Storage\update_manager.bat "update_saltynx_pack_profiles_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_saltynx_pack_profiles_management.bat" "force"
)
call TOOLS\Storage\saltynx_pack_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:end_script
endlocal