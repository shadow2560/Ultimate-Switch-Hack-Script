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
IF NOT EXIST "tools\sd_switch\atmosphere_emummc_profiles\*.*" mkdir "tools\sd_switch\atmosphere_emummc_profiles"

:define_action_choice
cls
call "%associed_language_script%" "display_title"
set action_choice=
call "%associed_language_script%" "main_action_choice"
IF "%action_choice%"=="1" cls & goto:create_profile
IF "%action_choice%"=="2" cls & goto:modify_profile
IF "%action_choice%"=="3" cls & goto:remove_profile
IF "%action_choice%"=="0" cls & goto:info_profile
goto:end_script

:info_profile
call "%associed_language_script%" "intro_info_profile"
call :select_profile
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "info_no_profile_exist_error"
	pause
	goto:define_action_choice
)
echo.
call "%associed_language_script%" "info_profile"
call :parse_emummc.ini_file "%profile_selected%" "display"
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
			set new_profile_name=
			goto:define_new_profile_name
		)
	)
	set /a i+=1
	goto:check_chars_new_profile_name
)
copy nul "tools\sd_switch\atmosphere_emummc_profiles\%new_profile_name%.ini" >nul
call "%associed_language_script%" "create_profile_success"
set profile_selected=%new_profile_name%.ini
goto:skip_modify_select_profile

:modify_profile
call "%associed_language_script%" "intro_modify_profile"
echo.
call :select_profile
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "modify_no_profile_exist_error"
	pause
	goto:define_action_choice
)
:skip_modify_select_profile
IF %errorlevel% EQU 0 (
	call :emunand_config "%profile_selected%"
) else (
	goto:define_action_choice
)
goto:define_action_choice

:remove_profile
call "%associed_language_script%" "intro_delete_profile"
echo.
call :select_profile
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "delete_no_profile_exist_error"
	pause
	goto:define_action_choice
)
IF %errorlevel% EQU 0 (
	Setlocal enabledelayedexpansion
	cd tools\sd_switch\profiles
	set /a temp_count=0
	for %%p in (*.bat) do (
		..\..\gnuwin32\bin\grep.exe -c "atmosphere_emummc_profile_path=tools\\sd_switch\\atmosphere_emummc_profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
		set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
		IF "!temp_test_profile!"=="1" (
			set /a temp_count+=1
			set temp_used_profile_list_!temp_count!=%%p
		) else (
			..\..\gnuwin32\bin\grep.exe -c "reinx_emummc_profile_path=tools\\sd_switch\\atmosphere_emummc_profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
			set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
			IF "!temp_test_profile!"=="1" (
				set /a temp_count+=1
				set temp_used_profile_list_!temp_count!=%%p
			)
		)
	)
	cd ..\..\..
	IF !temp_count! EQU 0 (
		goto:removing_profile
	) else (
		call "%associed_language_script%" "delete_profile_finded_in_general_profile"
		for /l %%k in (1,1,!temp_count!) do (
			echo !temp_used_profile_list_%%k:~0,-4!
		)
	)
	echo.
	set define_del_profile=
	call "%associed_language_script%" "delete_profile_finded_in_general_profile2"
	IF NOT "!define_del_profile!"=="" set define_del_profile=!define_del_profile:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "define_del_profile" "o/n_choice"
	IF /i "!define_del_profile!"=="o" (
		for /l %%k in (1,1,!temp_count!) do (
			del /q tools\sd_switch\profiles\!temp_used_profile_list_%%k!
		)
	) else (
		call "%associed_language_script%" "canceled"
		endlocal
		pause
		goto:define_action_choice
	)
	:removing_profile
	del /q "tools\sd_switch\atmosphere_emummc_profiles\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	endlocal
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\sd_switch\atmosphere_emummc_profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\atmosphere_emummc_profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
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
exit /b

:parse_emummc.ini_file
set temp_profile_path=tools\sd_switch\atmosphere_emummc_profiles\%~1
set emunand_enable=
set emummc_id=
set emummc_title=
set emummc_sector=
set emummc_path=
set emummc_nintendo_path=
tools\gnuwin32\bin\grep.exe -E "^^enabled =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emunand_enable=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emunand_enable%"=="" set emunand_enable=%emunand_enable:~1%
IF "%emunand_enable%"=="1" (
	set emunand_enable=o
) else (
	set emunand_enable=n
)
tools\gnuwin32\bin\grep.exe -E "^^id =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_id=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_id%"=="" set emummc_id=%emummc_id:~1%
tools\gnuwin32\bin\grep.exe -E "^^title =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_title=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_title%"=="" set emummc_title=%emummc_title:~1%
tools\gnuwin32\bin\grep.exe -E "^^sector =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_sector=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_sector%"=="" set emummc_sector=%emummc_sector:~1%
tools\gnuwin32\bin\grep.exe -E "^^path =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_path=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_path%"=="" set emummc_path=%emummc_path:~1%
tools\gnuwin32\bin\grep.exe -E "^^nintendo_path =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_nintendo_path=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_nintendo_path%"=="" set emummc_nintendo_path=%emummc_nintendo_path:~1%
IF NOT "%~2"=="display" (
	exit /b
) else (
	call "%associed_language_script%" "display_emummc_config_parsed"
)
exit /b

:emunand_config
echo.
set emunand_enable=
call "%associed_language_script%" "emummc_config_enable_choice"
IF NOT "%emunand_enable%"=="" set emunand_enable=%emunand_enable:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "emunand_enable" "o/n_choice"
IF /i NOT "%emunand_enable%"=="o" goto:skip_emunand_config
:define_emummc_id
set emummc_id=
call "%associed_language_script%" "emummc_config_enable_choice"
IF "%emummc_id%"=="" goto:skip_define_emummc_id
call TOOLS\Storage\functions\strlen.bat nb "%emummc_id%"
IF %nb% GTR 4 (
	call "%associed_language_script%" "emummc_id_size_error"
	goto:define_emummc_id
)
call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat emummc_id
set i=0
:check_chars_emummc_id
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
		IF "!emummc_id:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_emummc_id
		)
	)
	call "%associed_language_script%" "emummc_id_char_error"
	goto:define_emummc_id
)
:skip_define_emummc_id
:define_emummc_title
set emummc_title=
call "%associed_language_script%" "emummc_title_choice"
:define_emummc_sector
set emummc_sector=
call "%associed_language_script%" "emummc_sector_choice"
IF "%emummc_sector%"=="" goto:skip_define_emummc_sector
call TOOLS\Storage\functions\strlen.bat nb "%emummc_sector%"
call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat emummc_sector
set i=0
:check_chars_emummc_sector
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
		IF "!emummc_sector:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_emummc_sector
		)
	)
	call "%associed_language_script%" "emummc_sector_char_error"
	goto:define_emummc_sector
)
goto:define_emummc_nintendo_path
:skip_define_emummc_sector
set emummc_path=
call "%associed_language_script%" "emummc_path_choice"
IF "%emummc_path%"=="" (
	call "%associed_language_script%" "emummc_no_sector_or_path_error"
	set emunand_enable=n
	goto:skip_emunand_config
)
:define_emummc_nintendo_path
set emummc_nintendo_path=
call "%associed_language_script%" "emummc_nintendo_path_choice"
:skip_emunand_config
:copy_atmosphere_emummc_configuration
echo [emummc]>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
IF /i "%emunand_enable%"=="o" (
	echo enabled = ^1>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
) else (
	echo enabled = ^0>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_id%"=="" (
	echo id = 0x%emummc_id%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_title%"=="" (
	echo title = %emummc_title%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_sector%"=="" (
	echo sector = 0x%emummc_sector%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_path%"=="" (
	echo path = %emummc_path%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_nintendo_path%"=="" (
	echo nintendo_path = %emummc_nintendo_path%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
echo.
call "%associed_language_script%" "emummc_config_success"
pause
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal