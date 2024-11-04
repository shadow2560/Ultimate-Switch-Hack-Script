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
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
IF NOT "%~1"=="" (
	IF EXIST "%~1\*.*" (
		set update_file_path=%~1
		set update_type=1
	) else (
		call "%associed_language_script%" "folder_script_param_error"
		goto:endscript
	)
)
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
echo.
call "%associed_language_script%" "keys_file_selection"
set /p keys_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:endscript
)
IF NOT "%update_file_path%"=="" goto:skip_hfs0_select
set launch_xci_explorer=
call "%associed_language_script%" "launch_xci_explorer_choice"
IF NOT "%launch_xci_explorer%"=="" set launch_xci_explorer=%launch_xci_explorer:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "launch_xci_explorer" "o/n_choice"
IF /i "%launch_xci_explorer%"=="o" XCI-Explorer.exe
:update_package_select
call "%associed_language_script%" "package_folder_select"
set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
IF "%update_file_path%"=="" (
	call "%associed_language_script%" "no_source_selected_error"
	goto:endscript
)
set update_file_path=%update_file_path:\\=\%
:skip_hfs0_select
cd "%this_script_dir%"
set no_exfat=
IF "%~2"=="exfat_force" goto:skip_exfat_param_choice
call "%associed_language_script%" "noexfat_param_choice"
IF NOT "%no_exfat%"=="" set no_exfat=%no_exfat:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "no_exfat" "o/n_choice"
:skip_exfat_param_choice
IF /i "%no_exfat%"=="o" set no_exfat_param=--no-exfat
call "%associed_language_script%" "patched_console_choice"
IF NOT "%patched_console%"=="" set patched_console=%patched_console:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "patched_console" "o/n_choice"
set mariko_console=
IF /i "%patched_console%"=="o" (
	call "%associed_language_script%" "mariko_console_param_choice"
	IF NOT "!mariko_console!"=="" set mariko_console=!mariko_console:~0,1!
	call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "mariko_console" "o/n_choice"
	IF /i "!mariko_console!"=="o" set mariko_console_param=--mariko
)
set autorcm=
IF /i NOT "%mariko_console%"=="o" (
	IF /i NOT "%patched_console%"=="o" (
		call "%associed_language_script%" "autorcm_param_choice"
		IF NOT "!autorcm!"=="" set autorcm=!autorcm:~0,1!
		call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "autorcm" "o/n_choice"
		IF /i "!autorcm!"=="o" set autorcm_param=--no-autorcm
	) else (
		set autorcm_param=--no-autorcm
	)
)
:start_update_creation
IF NOT EXIST "%calling_script_dir%\update_packages\*.*" (
	del /q "%calling_script_dir%\update_packages" 2>nul
	mkdir "%calling_script_dir%\update_packages"
)
%calling_script_dir:~0,1%:
cd "%calling_script_dir%\update_packages"
goto:skip_old_emmchacgen_file_copy
:old_emmchacgen_file_copy
copy /v "%this_script_dir%\..\EmmcHaccGen_old\save.stub.v4" save.stub.v4 >nul
copy /v "%this_script_dir%\..\EmmcHaccGen_old\save.stub.v5" save.stub.v5 >nul
IF /i NOT "%mariko_console%"=="o" (
	"%this_script_dir%\..\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %autorcm_param% --fw "%update_file_path%"
) else (
	"%this_script_dir%\..\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %mariko_console_param% --fw "%update_file_path%"
)
:skip_old_emmchacgen_file_copy
set winget_use=n
winget -v >nul 2>&1
IF %errorlevel% EQU 0 (
	"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
	IF !errorlevel! EQU 0 (
		set winget_use=Y
	)
)
IF /i NOT "%mariko_console%"=="o" (
	"%this_script_dir%\..\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %autorcm_param% --fw "%update_file_path%"
) else (
	"%this_script_dir%\..\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %mariko_console_param% --fw "%update_file_path%"
)
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "package_creation_success"
	goto:endscript
) else (
	call "%associed_language_script%" "emmchaccgen_package_creation_first_error"
	if !errorlevel! EQU 1 (
		if "%winget_use%"=="Y" (
			winget install Microsoft.DotNet.DesktopRuntime.7
		) else (
			if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
				"%this_script_dir%\..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x64.exe" /passive
			) else (
				"%this_script_dir%\..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x86.exe" /passive
			)
		)
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "netfx7_install_error"
			cd ..
			rmdir /s /q "firmware_temp"
			rmdir /s /q "update_packages"
			goto:endscript
		) else (
			if "%winget_use%"=="Y" (
				winget install Microsoft.DotNet.AspNetCore.7
			) else (
				if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
					"%this_script_dir%\..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x64.exe" /passive
				) else (
					"%this_script_dir%\..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x86.exe" /passive
				)
			)
			IF !errorlevel! NEQ 0 (
				call "%associed_language_script%" "netfx7_install_error"
				cd ..
				rmdir /s /q "firmware_temp"
				rmdir /s /q "update_packages"
				goto:endscript
			)
		)
		IF /i NOT "%mariko_console%"=="O" (
			"%this_script_dir%\..\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %autorcm_param%--fw "%update_file_path%"
		) else (
			"%this_script_dir%\..\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %mariko_console_param% --fw "%update_file_path%"
		)
		IF !errorlevel! EQU 0 (
			call "%associed_language_script%" "package_creation_success"
			goto:endscript
		) else (
			call "%associed_language_script%" "emmchaccgen_package_creation_second_error"
			cd ..
			rmdir /s /q "firmware_temp"
			rmdir /s /q "update_packages"
			goto:endscript
		)
	) else (
		cd ..
		rmdir /s /q "firmware_temp"
		rmdir /s /q "update_packages"
		goto:endscript2
	)
)
:old_emmchacgen_process
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "package_creation_success"
) else (
	call "%associed_language_script%" "old_emmchaccgen_package_creation_first_error"
	if !errorlevel! EQU 1 (
		IF /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
			"%this_script_dir%\..\EmmcHaccGen_old\dotnet-runtime-3.1.12-win-x64.exe" /install /passive
		) else (
			"%this_script_dir%\..\EmmcHaccGen_old\dotnet-runtime-3.1.12-win-x86.exe" /install /passive
		)
		if !error_level! NEQ 0 (
			call "%associed_language_script%" "netfx3_install_error"
			cd ..
			rmdir /s /q "firmware_temp"
			rmdir /s /q "update_packages"
			goto:endscript
		) else (
			IF /i NOT "%mariko_console%"=="O" (
				"%this_script_dir%\..\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %autorcm_param%--fw "%update_file_path%"
			) else (
				"%this_script_dir%\..\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" %no_exfat_param% %mariko_console_param% --fw "%update_file_path%"
			)
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "package_creation_success"
			) else (
				call "%associed_language_script%" "emmchaccgen_package_creation_second_error"
				cd ..
				rmdir /s /q "firmware_temp"
				rmdir /s /q "update_packages"
				goto:endscript
			)
		)
	) else (
		cd ..
		rmdir /s /q "firmware_temp"
		rmdir /s /q "update_packages"
		goto:endscript2
	)
)
del /q save.stub.v4 >nul
del /q save.stub.v5 >nul
:skip_old_emmchacgen_process
:endscript
pause
:endscript2
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal