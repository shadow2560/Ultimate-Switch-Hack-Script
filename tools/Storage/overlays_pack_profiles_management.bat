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
IF NOT EXIST "tools\sd_switch\overlays\profiles\*.*" mkdir "tools\sd_switch\overlays\profiles"

:define_action_choice
cls
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
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "info_no_profile_exist_error"
	pause
	goto:define_action_choice
)
echo.
call "%associed_language_script%" "info_profile"
call :list_overlays_in_profile "%profile_selected%"
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
copy nul "tools\sd_switch\overlays\profiles\%new_profile_name%.ini" >nul
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
	call :add_del_overlay_in_profile "%profile_selected%"
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
		..\..\gnuwin32\bin\grep.exe -c "overlays_profile_path=tools\\sd_switch\\overlays\\profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
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
		goto:define_action_choice
	)
	:removing_profile
	del /q "tools\sd_switch\overlays\profiles\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	endlocal
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\sd_switch\overlays\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\overlays\profiles
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

:list_overlays_in_profile
Setlocal disabledelayedexpansion
copy nul templogs\overlays_list.txt >nul
tools\gnuwin32\bin\grep.exe -c "" <"tools\sd_switch\overlays\profiles\%~1" > templogs\tempvar.txt
set /p count_overlays=<templogs\tempvar.txt
IF %count_overlays% EQU 0 (
	call "%associed_language_script%" "no_overlays_in_profile_error"
	endlocal
	exit /b
)
%windir%\System32\sort.exe /l C <"tools\sd_switch\overlays\profiles\%~1" /o "templogs\overlays_list.txt"
type "templogs\overlays_list.txt"
del /q templogs\overlays_list.txt
endlocal
exit /b

:add_del_overlay_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\overlays\profiles\%~1
set /a selected_page=1
call :overlays_list
IF %errorlevel% EQU 404 (
	del /q templogs\overlays_list.txt
	exit /b 400
)
set /a page_number=%count_overlays%/20
IF %count_overlays% LEQ 20 (
	set /a modulo=0
	set /a page_number=1
	goto:skip:modulo_calc
)
set mod_a=!count_overlays!
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
:recall_add_remove_overlay
IF %count_overlays% LEQ 20 (
	call "%associed_language_script%" "intro_overlays_one_page"
) else (
	call "%associed_language_script%" "intro_overlays_multi_page"
)
echo.
call "%associed_language_script%" "add_remove_overlays_info"
echo.
IF %modulo% NEQ 0 (
	IF %selected_page% EQU %page_number% (
		set /a temp_max_display_overlays=%count_overlays%
		set /a temp_min_display_overlays=%count_overlays%-%modulo%+1
	) else (
		set /a temp_max_display_overlays=%selected_page%*20
		set /a temp_min_display_overlays=!temp_max_display_overlays!-19
	)
) else (
	IF %count_overlays% LEQ 20 (
		set /a temp_max_display_overlays=%count_overlays%
		set /a temp_min_display_overlays=1
	) else (
		set /a temp_max_display_overlays=%selected_page%*20
		set /a temp_min_display_overlays=!temp_max_display_overlays!-19
	)
)
for /l %%i in (%temp_min_display_overlays%,1,%temp_max_display_overlays%) do (
	tools\gnuwin32\bin\grep.exe -c "!overlays_list_%%i_0!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_overlays=<templogs\tempvar.txt
	IF !temp_count_overlays! EQU 0 (
		echo %%i: !overlays_list_%%i_0!
	) else (
		echo %%i: *!overlays_list_%%i_0!
	)
)
IF %count_overlays% GTR 20 call "%associed_language_script%" "change_page_info"
set overlay_choice=
call "%associed_language_script%" "add_remove_overlays_choice_ending"
IF "%overlay_choice%"=="" set /a overlay_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%overlay_choice%"
IF /i "%overlay_choice:~0,1%"=="p" (
	set change_page=Y
	IF %nb% equ 1 (
		set overlay_choice=0
	) else (
		set overlay_choice=%overlay_choice:~1%
	)
	)
call TOOLS\Storage\functions\strlen.bat nb "%overlay_choice%"
set i=0
:check_chars_overlay_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!overlay_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_overlay_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF "%change_page%"=="Y" (
	IF %overlay_choice% GTR %page_number% (
		call "%associed_language_script%" "page_not_exist_error"
		set change_page=
		goto:recall_add_remove_overlay
	) else IF %overlay_choice% LEQ 0 (
	call "%associed_language_script%" "page_not_exist_error"
	set change_page=
	goto:recall_add_remove_overlay
	) else (
		set selected_page=%overlay_choice%
		set change_page=
		goto:recall_add_remove_overlay
	)
)
IF %overlay_choice% GTR %count_overlays% (
	del /q templogs\overlays_list.txt
	exit /b 400
)
IF %overlay_choice% EQU 0 (
	del /q templogs\overlays_list.txt
	exit /b 400
)
TOOLS\gnuwin32\bin\sed.exe -n %overlay_choice%p <templogs\overlays_list.txt > templogs\tempvar.txt
set /p overlay_selected=<templogs\tempvar.txt
tools\gnuwin32\bin\grep.exe -c "%overlay_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF %temp_count% EQU 0 (
	echo %overlay_selected%>>"%temp_path_profile%"
) else (
	tools\gnuwin32\bin\grep.exe -v "%overlay_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
	del /q "%temp_path_profile%" >nul
	move templogs\tempvar.txt "%temp_path_profile%" >nul
)
goto:recall_add_remove_overlay
exit /b

:overlays_list
copy nul templogs\overlays_list.txt >nul
cd tools\sd_switch\overlays\pack
for /D %%i in (*) do (
	echo %%i>>..\..\..\..\templogs\overlays_list.txt
)
cd ..\..\..\..
tools\gnuwin32\bin\grep.exe -c "" <templogs\overlays_list.txt > templogs\tempvar.txt
set /p count_overlays=<templogs\tempvar.txt
set temp_count=1
:listing_overlays
IF %count_overlays% EQU 0 (
	call "%associed_language_script%" "no_overlays_in_overlays_folder"
	exit /b 404
)
IF %temp_count% GTR %count_overlays% goto:skip_listing_overlays
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\overlays_list.txt > templogs\tempvar.txt
set /p overlays_list_%temp_count%_0=<templogs\tempvar.txt
set /a temp_count+=1
goto:listing_overlays
:skip_listing_overlays
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal