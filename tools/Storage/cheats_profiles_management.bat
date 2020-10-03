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
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.*" mkdir "tools\sd_switch\cheats\profiles"

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
call :list_cheats_in_profile "%profile_selected%"
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
copy nul "tools\sd_switch\cheats\profiles\%new_profile_name%.ini" >nul
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
	call :add_del_cheat_in_profile "%profile_selected%"
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
	goto:define_action_choice
)
IF %errorlevel% EQU 0 (
	Setlocal enabledelayedexpansion
	cd tools\sd_switch\profiles
	set /a temp_count=0
	for %%p in (*.bat) do (
		..\..\gnuwin32\bin\grep.exe -c "cheats_profile_path=tools\\sd_switch\\cheats\\profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
		set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
		IF "!temp_test_profile!"=="1" (
			set /a temp_count+=1
			set temp_used_profile_list_!temp_count!=%%p
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
	del /q "tools\sd_switch\cheats\profiles\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	endlocal
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\cheats\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
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

:list_cheats_in_profile
Setlocal disabledelayedexpansion
copy nul templogs\cheats_list.txt >nul
tools\gnuwin32\bin\grep.exe -c "" <"tools\sd_switch\cheats\profiles\%~1" > templogs\tempvar.txt
set /p count_cheats=<templogs\tempvar.txt
set temp_count=1
:listing_cheats_in_profile
IF %count_cheats% EQU 0 (
	call "%associed_language_script%" "no_cheat_in_profile_error"
	endlocal
	exit /b
)
IF %temp_count% GTR %count_cheats% goto:skip_listing_cheats_in_profile
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <"tools\sd_switch\cheats\profiles\%~1" > templogs\tempvar.txt
set /p temp_cheat_id=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat_id%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 2 > templogs\tempvar.txt
set /p temp_cheat_name=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat_id%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 4 | TOOLS\gnuwin32\bin\cut.exe -d ^! -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^( -f 1 > templogs\tempvar.txt
set /p temp_cheat_region=<templogs\tempvar.txt
echo %temp_cheat_name% %temp_cheat_region%: %temp_cheat_id%>>templogs\cheats_list.txt
set /a temp_count+=1
goto:listing_cheats_in_profile
:skip_listing_cheats_in_profile
%windir%\System32\sort.exe /l C <"templogs\cheats_list.txt" /o "templogs\cheats_list.txt"
type "templogs\cheats_list.txt"
del /q templogs\cheats_list.txt
endlocal
exit /b

:add_del_cheat_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\cheats\profiles\%~1
set /a selected_page=1
call :cheats_list
IF %errorlevel% EQU 404 (
	del /q templogs\cheats_list.txt
	exit /b 400
)
set /a page_number=%count_cheats%/20
IF %count_cheats% LEQ 20 (
	set /a modulo=0
	set /a page_number=1
	goto:skip:modulo_calc
)
set mod_a=!count_cheats!
set mod_b=20
set mod_counter=0
for /l %%k in (1,1,!mod_a!) do (
    set /a mod_counter+=1
    set /a mod_a-=1
    if !mod_counter!==!mod_b! set /a mod_counter=0
    if !mod_a!==0 set modulo=!mod_counter!
)
if not defined modulo set modulo=0
IF %modulo% NEQ 0 set /a page_number+=1
:skip:modulo_calc
:recall_add_remove_cheat
IF %count_cheats% LEQ 20 (
	call "%associed_language_script%" "intro_cheats_one_page"
) else (
	call "%associed_language_script%" "intro_cheats_multi_page"
)
echo.
call "%associed_language_script%" "add_remove_cheats_info"
echo.
IF %modulo% NEQ 0 (
	IF %selected_page% EQU %page_number% (
		set /a temp_max_display_cheats=%count_cheats%
		set /a temp_min_display_cheats=%count_cheats%-%modulo%+1
	) else (
		set /a temp_max_display_cheats=%selected_page%*20
		set /a temp_min_display_cheats=!temp_max_display_cheats!-19
	)
) else (
	IF %count_cheats% LEQ 20 (
		set /a temp_max_display_cheats=%count_cheats%
		set /a temp_min_display_cheats=1
	) else (
		set /a temp_max_display_cheats=%selected_page%*20
		set /a temp_min_display_cheats=!temp_max_display_cheats!-19
	)
)
for /l %%i in (%temp_min_display_cheats%,1,%temp_max_display_cheats%) do (
	tools\gnuwin32\bin\grep.exe -c "!cheats_list_%%i_0!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_cheats=<templogs\tempvar.txt
	IF !temp_count_cheats! EQU 0 (
		echo %%i: !cheats_list_%%i_0!; !cheats_list_%%i_1! !cheats_list_%%i_2!
	) else (
		echo %%i: *!cheats_list_%%i_0!; !cheats_list_%%i_1! !cheats_list_%%i_2!
	)
)
IF %count_cheats% GTR 20 call "%associed_language_script%" "change_page_info"
set cheat_choice=
call "%associed_language_script%" "add_remove_cheats_choice_ending"
IF "%cheat_choice%"=="" set /a cheat_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%cheat_choice%"
IF /i "%cheat_choice:~0,1%"=="p" (
	set change_page=Y
	IF %nb% equ 1 (
		set cheat_choice=0
	) else (
		set cheat_choice=%cheat_choice:~1%
	)
	)
	call TOOLS\Storage\functions\strlen.bat nb "%cheat_choice%"
set i=0
:check_chars_cheat_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!cheat_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_cheat_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF "%change_page%"=="Y" (
	IF %cheat_choice% GTR %page_number% (
		call "%associed_language_script%" "page_not_exist_error"
		set change_page=
		goto:recall_add_remove_cheat
	) else IF %cheat_choice% LEQ 0 (
	call "%associed_language_script%" "page_not_exist_error"
	set change_page=
	goto:recall_add_remove_cheat
	) else (
		set selected_page=%cheat_choice%
		set change_page=
		goto:recall_add_remove_cheat
	)
)
IF %cheat_choice% GTR %count_cheats% (
	del /q templogs\cheats_list.txt
	exit /b 400
)
IF %cheat_choice% EQU 0 (
	del /q templogs\cheats_list.txt
	exit /b 400
)
TOOLS\gnuwin32\bin\sed.exe -n %cheat_choice%p <templogs\cheats_list.txt > templogs\tempvar.txt
set /p cheat_selected=<templogs\tempvar.txt
tools\gnuwin32\bin\grep.exe -c "%cheat_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF %temp_count% EQU 0 (
	echo %cheat_selected%>>"%temp_path_profile%"
) else (
	tools\gnuwin32\bin\grep.exe -v "%cheat_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
	del /q "%temp_path_profile%" >nul
	move templogs\tempvar.txt "%temp_path_profile%" >nul
)
goto:recall_add_remove_cheat
exit /b

:cheats_list
copy nul templogs\cheats_list.txt >nul
::copy nul cheats_list.txt >nul
cd tools\sd_switch\cheats\titles
for /D %%i in (*) do (
	echo %%i>>..\..\..\..\templogs\cheats_list.txt
)
cd ..\..\..\..
tools\gnuwin32\bin\grep.exe -c "" <templogs\cheats_list.txt > templogs\tempvar.txt
set /p count_cheats=<templogs\tempvar.txt
set temp_count=1
:listing_cheats
IF %count_cheats% EQU 0 (
	call "%associed_language_script%" "no_cheats_in_cheats_folder"
	exit /b 404
)
IF %temp_count% GTR %count_cheats% goto:skip_listing_cheats
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\cheats_list.txt > templogs\tempvar.txt
set /p cheats_list_%temp_count%_0=<templogs\tempvar.txt
set /p temp_cheat=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 2 > templogs\tempvar.txt
endlocal
set /p cheats_list_%temp_count%_1=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 4 | TOOLS\gnuwin32\bin\cut.exe -d ^! -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^( -f 1 > templogs\tempvar.txt
endlocal
set /p cheats_list_%temp_count%_2=<templogs\tempvar.txt
::echo !cheats_list_%temp_count%_0!: !cheats_list_%temp_count%_1! !cheats_list_%temp_count%_2! >>cheats_list.txt
set /a temp_count+=1
goto:listing_cheats
:skip_listing_cheats
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal