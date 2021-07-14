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
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
echo.
:define_action_type
cls
set action_choice=
call "%associed_language_script%" "main_action_choice"
IF "%action_choice%"=="1" call "tools\Storage\launch_payload.bat" "tools\Switchboot\tegrarcm\Samd21_Update.bin"
IF "%action_choice%"=="2" call "tools\Storage\launch_payload.bat" "tools\Switchboot\tegrarcm\hekate_switchboot_mod.bin"
IF "%action_choice%"=="3" goto:flash_UF2_file
IF "%action_choice%"=="4" goto:flash_fusee_suite
IF "%action_choice%"=="5" goto:manage_payloads_switchboot
IF "%action_choice%"=="6" goto:sx_core_lite_flash
IF "%action_choice%"=="7" goto:flash_switchboot
IF "%action_choice%"=="8" goto:prepare_base_switchboot
IF "%action_choice%"=="0" (
	start https://gbatemp.net/threads/trinket-rebug-others-modchip-software-new-fusee_suite-uf2-packages.553998/
	goto:define_action_type
)
IF "%action_choice%"=="00" (
	start https://gbatemp.net/threads/trinket-rebug-others-switchboot_uf2-fusee_uf2-modchip-software.526607/
	goto:define_action_type
)
goto:end_script

:flash_UF2_file
call "%associed_language_script%" "select_uf2_file"
set /p uf2_file=<templogs\tempvar.txt
IF "%uf2_file%"=="" (
	call "%associed_language_script%" "uf2_file_empty_error"
	pause
	goto:define_action_type
)
call "%associed_language_script%" "select_uf2_device"
call :define_volume_letter "uf2"
IF "%uf2_volume_letter%"=="" goto:define_action_type
call :copy_uf2_file_on_uf2_device
goto:define_action_type

:flash_switchboot
:switchboot_part2_choice
set modchip_choice=
call "%associed_language_script%" "select_modchip_device"
IF "%modchip_choice%"=="1" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\Feather M0 Express\Part_1_FEATHER_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\Feather M0 Express\Part_1_FEATHER_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\Feather M0 Express\Part_2_FEATHER_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\Feather M0 Express\\Part_2_FEATHER_SWITCHBOOT_PART2_LATEST.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="2" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\Gemma M0\Part_1_GEMMA_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\Gemma M0\Part_1_GEMMA_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\Gemma M0\Part_2_GEMMA_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\Gemma M0\Part_2_GEMMA_SWITCHBOOT_PART2_LATEST.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="3" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\Itsybitsy M0\Part_1_ITSY_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\Itsybitsy M0\Part_1_ITSY_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\Itsybitsy M0\Part_2_ITSY_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\Itsybitsy M0\Part_2_ITSY_SWITCHBOOT_PART2_LATEST.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="4" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\RCM-X86\Part_1_RCMX86_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\RCM-X86\Part_1_RCMX86_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\RCM-X86\Part_2_RCMX86_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\RCM-X86\Part_2_RCMX86_SWITCHBOOT_PART2_LATEST.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="5" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\Rebug SwitchME\Part_1_REBUG_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\Rebug SwitchME\Part_1_REBUG_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\Rebug SwitchME\Part_2_REBUG_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\Rebug SwitchME\Part_2_REBUG_SWITCHBOOT_PART2_Latest.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="6" (
	set switchboot_part1_type=
	call "%associed_language_script%" "switchboot_part1_type"
	IF "!switchboot_part1_type!"=="1" (
		set uf2_part1=tools\Switchboot\part1\Trinket M0\Part_1_TRINKET_PERMA_CFW_Latest.uf2
	) else IF "!switchboot_part1_type!"=="2" (
		set uf2_part1=tools\Switchboot\part1\Trinket M0\Part_1_TRINKET_DUAL_BOOT_Latest.uf2
	) else (
		goto:define_action_type
	)
	set switchboot_part2_type=
	call "%associed_language_script%" "switchboot_part2_type"
	IF "!switchboot_part2_type!"=="1" (
		set uf2_part2=tools\Switchboot\part2\Trinket M0\Part_2_TRINKET_FUSEE_UF2_Latest.UF2
	) else IF "!switchboot_part2_type!"=="2" (
		set uf2_part2=tools\Switchboot\part2\Trinket M0\Part_2_TRINKET_SWITCHBOOT_PART2_LATEST.UF2
	) else (
		goto:define_action_type
	)
) ELSE IF "%modchip_choice%"=="7" (
	set uf2_part1=tools\Switchboot\dongles\GENERIC_GEMMA_DONGLE.UF2
	set uf2_part2=
) ELSE IF "%modchip_choice%"=="8" (
	set uf2_part1=tools\Switchboot\dongles\GENERIC_TRINKET_DONGLE.UF2
	set uf2_part2=
) ELSE IF "%modchip_choice%"=="9" (
	set uf2_part1=tools\Switchboot\dongles\RCMX86.UF2
	set uf2_part2=
) ELSE (
	goto:define_action_type
)
call "%associed_language_script%" "select_uf2_device"
call :define_volume_letter "uf2"
IF "%uf2_volume_letter%"=="" goto:define_action_type
set uf2_file=%uf2_part1%
call :copy_uf2_file_on_uf2_device
IF "%uf2_part2%"=="" goto:end_flash_switchboot
call "%associed_language_script%" "select_uf2_device_again"
call :define_volume_letter "uf2"
IF "%uf2_volume_letter%"=="" goto:define_action_type
set uf2_file=%uf2_part2%
call :copy_uf2_file_on_uf2_device
:end_flash_switchboot
call "%associed_language_script%" "switchboot_flash_end"
pause
goto:define_action_type

:flash_fusee_suite
:fusee_suite_part2_choice
set modchip_choice=
call "%associed_language_script%" "select_modchip_device" "fusee_suite"
IF "%modchip_choice%"=="1" (
	set uf2_part1=tools\Fusee_Suite\part1\Feather M0 Express\FUSEE_SUITE_FEATHER.uf2
	set uf2_part2=tools\Fusee_Suite\part2\Feather M0 Express\\FEATHER.UF2
) ELSE IF "%modchip_choice%"=="2" (
	set uf2_part1=tools\Fusee_Suite\part1\Gemma M0\FUSEE_SUITE_GEMMA.uf2
	set uf2_part2=tools\Fusee_Suite\part2\Gemma M0\GEMMAM0.UF2
) ELSE IF "%modchip_choice%"=="3" (
	set uf2_part1=tools\Fusee_Suite\part1\Itsybitsy M0\FUSEE_SUITE_ITSYBITSY.uf2
	set uf2_part2=tools\Fusee_Suite\part2\Itsybitsy M0\ITSYBIT.UF2
) ELSE IF "%modchip_choice%"=="4" (
	set uf2_part1=tools\Fusee_Suite\part1\RCM-X86\FUSEE_SUITE_RCMX86.uf2
	set uf2_part2=tools\Fusee_Suite\part2\RCM-X86\RCM_X86.UF2
) ELSE IF "%modchip_choice%"=="5" (
	set uf2_part1=tools\Fusee_Suite\part1\Rebug SwitchME\FUSEE_SUITE_REBUG.uf2
	set uf2_part2=tools\Fusee_Suite\part2\Rebug SwitchME\REBUG_S.UF2
) ELSE IF "%modchip_choice%"=="6" (
	set uf2_part1=tools\Fusee_Suite\part1\Trinket M0\FUSEE_SUITE_TRINKET.uf2
	set uf2_part2=tools\Fusee_Suite\part2\Trinket M0\TRINKET.UF2
) ELSE (
	goto:define_action_type
)
call "%associed_language_script%" "select_uf2_device"
call :define_volume_letter "uf2"
IF "%uf2_volume_letter%"=="" goto:define_action_type
set uf2_file=%uf2_part1%
call :copy_uf2_file_on_uf2_device
call "%associed_language_script%" "select_uf2_device_again"
call :define_volume_letter "uf2"
IF "%uf2_volume_letter%"=="" goto:define_action_type
set uf2_file=%uf2_part2%
call :copy_uf2_file_on_uf2_device
call "%associed_language_script%" "switchboot_flash_end"
pause
goto:define_action_type

:prepare_base_switchboot
call "%associed_language_script%" "select_sd_device"
call :define_volume_letter "sd"
IF "%sd_volume_letter%"=="" goto:define_action_type
		IF NOT EXIST "%sd_volume_letter%:\bootloader" mkdir "%sd_volume_letter%:\bootloader"
		%windir%\System32\Robocopy.exe TOOLS\Switchboot\tegrarcm\bootloader %sd_volume_letter%:\bootloader /e >nul
		%windir%\System32\Robocopy.exe TOOLS\Switchboot\Tidy_Memloader %sd_volume_letter%:\ /e >nul
		IF NOT EXIST "%sd_volume_letter%:\bootloader\payloads\*.*" mkdir "%sd_volume_letter%:\bootloader\payloads"
		copy /v /b "TOOLS\Switchboot\tegrarcm\hekate_switchboot_mod.bin" "%sd_volume_letter%:\bootloader\payloads\hekate_switchboot_mod.bin" >nul
call "%associed_language_script%" "copy_base_switchboot_on_sd_finished"
pause
set sd_volume_letter=
goto:define_action_type

:manage_payloads_switchboot
set switchboot_payload_number=
call "%associed_language_script%" "select_switchboot_payload_number"
IF "%switchboot_payload_number%"=="" goto:define_action_type
call TOOLS\Storage\functions\strlen.bat nb "%switchboot_payload_number%"
IF %nb% NEQ 1 (
	call "%associed_language_script%" "switchboot_payload_number_select_error"
	pause
	goto:manage_payloads_switchboot
)
set i=0
:check_chars_switchboot_payload_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (1 2 3 4 5 6 7 8) do (
		IF "!switchboot_payload_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_switchboot_payload_number
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "switchboot_payload_number_select_error"
		pause
		goto:manage_payloads_switchboot
	)
)
IF %switchboot_payload_number% EQU 1 (
	call "%associed_language_script%" "select_if_payload_1_is_unic"
	IF NOT "!payload1_is_unic!"=="" set payload1_is_unic=!payload1_is_unic:~0,1!
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "payload1_is_unic" "o/n_choice"
)
call :choose_payload
IF "%payload_path%"=="" goto:define_action_type
call "%associed_language_script%" "select_sd_device"
call :define_volume_letter "sd"
IF "%sd_volume_letter%"=="" goto:define_action_type
IF %switchboot_payload_number% EQU 1 (
	IF /i "%payload1_is_unic%"=="O" (
	copy /v /b "%payload_path%" "%sd_volume_letter%:\payload.bin" >nul
	goto:end_manage_payloads_switchboot
	)
)
copy /v /b "%payload_path%" "%sd_volume_letter%:\payload%switchboot_payload_number%.bin" >nul
:end_manage_payloads_switchboot
call "%associed_language_script%" "manage_payloads_switchboot_finished"
pause
set sd_volume_letter=
goto:define_action_type

:sx_core_lite_flash
set sx_core_lite_action_choice=
call "%associed_language_script%" "sx_flasher_launch_intro"
IF "%sx_core_lite_action_choice%"=="1" (
	call "%associed_language_script%" "sx_flasher_launch_infos"
	pause
	start tools\sx_core_lite\sx_flasher\sxflasher.exe
)
IF "%sx_core_lite_action_choice%"=="2" (
	call "%associed_language_script%" "spacecraft_begin_flash"
	tools\SX_Core_Lite\SPACECRAFT\tools\BootloaderUpdater.exe tools\SX_Core_Lite\SPACECRAFT\firmware\bootloader.bin
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "spacecraft_error_flash"
		pause
		goto:sx_core_lite_flash
	)
	timeout /t 15 /nobreak > NUL
	tools\SX_Core_Lite\SPACECRAFT\tools\FirmwareUpdater.exe tools\SX_Core_Lite\SPACECRAFT\firmware\firmware.bin
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "spacecraft_error_flash"
		pause
		goto:sx_core_lite_flash
	)
	call "%associed_language_script%" "spacecraft_end_flash"
)
IF "%sx_core_lite_action_choice%"=="3" (
	call "%associed_language_script%" "sx_bootloader_begin_flash"
	tools\SX_Core_Lite\SPACECRAFT\tools\BootloaderUpdater.exe tools\SX_Core_Lite\firmwares\bootloader.bin
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "sx_bootloader_error_flash"
		pause
		goto:sx_core_lite_flash
	)
	call "%associed_language_script%" "sx_bootloader_end_flash"
)
goto:define_action_type

:choose_payload
copy nul templogs\payload_list.txt >nul
set max_payload=1
cd Payloads
for %%z in (*.bin) do (
	echo !max_payload!: %%z >>..\templogs\payloads_list.txt
	set /a max_payload+=1
)
cd ..
:select_payload
set payload_number=
set payload_path=
call "%associed_language_script%" "begin_payload_choice"
echo.
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\payloads_list.txt 
call "%associed_language_script%" "end_payload_choice"
IF "%payload_number%"=="" exit /b
call TOOLS\Storage\functions\strlen.bat nb "%payload_number%"
set i=0
:check_chars_payload_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!payload_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_payload_number
		)
	)
	IF "!check_chars!"=="0" (
		exit /b 3000
	)
)
IF "%payload_number%"=="0" (
	call "%associed_language_script%" "payload_file_choice"
	set /p payload_path=<templogs\tempvar.txt
)
IF "%payload_number%"=="0" (
	IF "%payload_path%"=="" (
		call "%associed_language_script%" "no_payload_file_selected_error"
		goto:select_payload
	)
	exit /b
)
TOOLS\gnuwin32\bin\grep.exe "%payload_number%: " <templogs\payloads_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p payload_path=<templogs\tempvar.txt
IF "%payload_path%"=="" (
	exit /b
)
set payload_path=%payload_path:~1,-1%
set payload_path=payloads\%payload_path%
exit /b

:define_volume_letter
IF "%~1"=="uf2" set uf2_volume_letter=
IF "%~1"=="sd" set sd_volume_letter=
set volume_letter=
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
set disk_not_finded_choice=
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_compatible_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "disk_not_finded_choice" "o/n_choice"
	IF /i "!disk_not_finded_choice!"=="o" (
		goto:define_volume_letter
	) else (
		exit /b 3000
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
IF "%volume_letter%"=="0" exit /b
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
IF "%~1"=="uf2" set uf2_volume_letter=%volume_letter%
IF "%~1"=="sd" set sd_volume_letter=%volume_letter%
exit /b 0

:copy_uf2_file_on_uf2_device
copy /v /b "%uf2_file%" "%uf2_volume_letter%:\" >nul
call "%associed_language_script%" "reset_uf2_device_to_flash"
set uf2_volume_letter=
set uf2_file=
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal