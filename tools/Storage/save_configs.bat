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
:define_filename
set filename=
call "%associed_language_script%" "filename_choice"
IF "%filename%"=="" (
	call "%associed_language_script%" "filename_empty_error"
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call tools\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "filename_char_error"
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
call "%associed_language_script%" "output_folder_choice"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" set filepath=%filepath:\\=\%
set copy_firmwares=
call "%associed_language_script%" "copy_firmwares_choice"
IF NOT "%copy_firmwares%"=="" set copy_firmwares=%copy_firmwares:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "copy_firmwares" "o/n_choice"
echo.
call "%associed_language_script%" "save_begin"
IF NOT EXIST KEY_SAVES mkdir KEY_SAVES
IF EXIST "Ultimate-Switch-Hack-Script.bat.lng" copy /v "Ultimate-Switch-Hack-Script.bat.lng" "KEY_SAVES\Ultimate-Switch-Hack-Script.bat.lng" >nul 2>&1
IF NOT EXIST KEY_SAVES\languages mkdir KEY_SAVES\languages
cd languages
for /d %%p in ("*") do (
	IF EXIST "%%p\script_general_config.bat" (
		IF NOT EXIST "..\KEY_SAVES\languages\%%p" mkdir "..\KEY_SAVES\languages\%%p"
		copy /v "%%p\script_general_config.bat" "..\KEY_SAVES\languages\%%p\script_general_config.bat" >nul 2>&1
	)
)
cd ..
IF NOT EXIST KEY_SAVES\tools mkdir KEY_SAVES\tools
IF NOT EXIST "KEY_SAVES\tools\Hactool_based_programs" mkdir "KEY_SAVES\tools\Hactool_based_programs"
copy /V tools\Hactool_based_programs\keys.txt KEY_SAVES\tools\Hactool_based_programs\keys.txt >nul 2>&1
copy /V tools\Hactool_based_programs\keys.dat KEY_SAVES\tools\Hactool_based_programs\keys.dat >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\megatools" mkdir "KEY_SAVES\tools\megatools"
copy /V "tools\megatools\mega.ini" "KEY_SAVES\tools\megatools\mega.ini" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\netplay" mkdir "KEY_SAVES\tools\netplay"
copy /v tools\netplay\servers_list.txt KEY_SAVES\tools\netplay\servers_list.txt >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\NSC_Builder" mkdir "KEY_SAVES\tools\NSC_Builder"
copy /V tools\NSC_Builder\keys.txt KEY_SAVES\tools\NSC_Builder\keys.txt >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch" mkdir "KEY_SAVES\tools\sd_switch"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed" mkdir "KEY_SAVES\tools\sd_switch\mixed"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed\profiles" mkdir "KEY_SAVES\tools\sd_switch\mixed\profiles"
copy /V "tools\sd_switch\mixed\profiles\*.ini" "KEY_SAVES\tools\sd_switch\mixed\profiles\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles" mkdir "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles"
copy /V "tools\sd_switch\atmosphere_emummc_profiles\*.ini" "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats" mkdir "KEY_SAVES\tools\sd_switch\cheats"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats\profiles" mkdir "KEY_SAVES\tools\sd_switch\cheats\profiles"
copy /V "tools\sd_switch\cheats\profiles\*.ini" "KEY_SAVES\tools\sd_switch\cheats\profiles\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators" mkdir "KEY_SAVES\tools\sd_switch\emulators"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators\profiles" mkdir "KEY_SAVES\tools\sd_switch\emulators\profiles"
copy /V "tools\sd_switch\emulators\profiles\*.ini" "KEY_SAVES\tools\sd_switch\emulators\profiles\">nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules" mkdir "KEY_SAVES\tools\sd_switch\modules"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules\profiles" mkdir "KEY_SAVES\tools\sd_switch\modules\profiles"
copy /V "tools\sd_switch\modules\profiles\*.ini" "KEY_SAVES\tools\sd_switch\modules\profiles\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\overlays" mkdir "KEY_SAVES\tools\sd_switch\overlays"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\overlays\profiles" mkdir "KEY_SAVES\tools\sd_switch\overlays\profiles"
copy /V "tools\sd_switch\overlays\profiles\*.ini" "KEY_SAVES\tools\sd_switch\overlays\profiles\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\sd_switch\profiles" mkdir "KEY_SAVES\tools\sd_switch\profiles"
copy /V "tools\sd_switch\profiles\*.bat" "KEY_SAVES\tools\sd_switch\profiles\" >nul 2>&1
IF NOT EXIST KEY_SAVES\tools\toolbox mkdir KEY_SAVES\tools\toolbox
%windir%\System32\Robocopy.exe tools\toolbox KEY_SAVES\tools\toolbox\ /e >nul 2>&1
cd KEY_SAVES
IF NOT "%filepath%"=="" (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".ushs  -r >nul 2>&1
	IF !errorlevel! NEQ 0 (
		del /q "%filepath%%filename%.ushs" >nul
		call "%associed_language_script%" "save_create_error"
		cd ..
		goto:end_script
	)
	IF /i "%copy_firmwares%"=="o" (
		IF EXIST "..\downloads\*.*" ..\tools\7zip\7za.exe a -y -tzip -sccUTF-8 "%filepath%%filename%".ushs "..\downloads" -r >nul 2>&1
		IF !errorlevel! NEQ 0 (
			del /q "%filepath%%filename%.ushs" >nul
			call "%associed_language_script%" "save_create_error"
			cd ..
			goto:end_script
		)
	)
) else (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%filename%".ushs  -r >nul 2>&1
	IF !errorlevel! NEQ 0 (
		del /q "..\%filename%.ushs" >nul
		call "%associed_language_script%" "save_create_error"
		cd ..
		goto:end_script
	)
	IF /i "%copy_firmwares%"=="o" (
		IF EXIST "..\downloads\*.*" ..\tools\7zip\7za.exe a -y -tzip -sccUTF-8 "..\%filename%".ushs "..\downloads" -r >nul 2>&1
		IF !errorlevel! NEQ 0 (
			del /q "..\%filename%.ushs" >nul
			call "%associed_language_script%" "save_create_error"
			cd ..
			goto:end_script
		)
	)
)
cd ..
call "%associed_language_script%" "save_end"
:end_script
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause 
endlocal