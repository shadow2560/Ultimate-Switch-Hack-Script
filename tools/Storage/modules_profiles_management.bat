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
IF NOT EXIST "tools\sd_switch\modules\profiles\*.*" mkdir "tools\sd_switch\modules\profiles"

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
call :list_modules_in_profile "%profile_selected%"
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
copy nul "tools\sd_switch\modules\profiles\%new_profile_name%.ini" >nul
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
	call :add_del_module_in_profile "%profile_selected%"
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
		..\..\gnuwin32\bin\grep.exe -c "atmosphere_modules_profile_path=tools\\sd_switch\\modules\\profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
		set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
		IF "!temp_test_profile!"=="1" (
			set /a temp_count+=1
			set temp_used_profile_list_!temp_count!=%%p
		) else (
			..\..\gnuwin32\bin\grep.exe -c "reinx_modules_profile_path=tools\\sd_switch\\modules\\profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
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
		goto:define_action_choice
	)
	:removing_profile
	del /q "tools\sd_switch\modules\profiles\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	endlocal
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\sd_switch\modules\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\modules\profiles
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

:list_modules_in_profile
Setlocal disabledelayedexpansion
copy nul templogs\modules_list.txt >nul
tools\gnuwin32\bin\grep.exe -c "" <"tools\sd_switch\modules\profiles\%~1" > templogs\tempvar.txt
set /p count_modules=<templogs\tempvar.txt
set temp_count=1
:listing_modules_in_profile
IF %count_modules% EQU 0 (
	call "%associed_language_script%" "no_modules_in_profile_error"
	endlocal
	exit /b
)
IF %temp_count% GTR %count_modules% goto:skip_listing_modules_in_profile
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <"tools\sd_switch\modules\profiles\%~1" > templogs\tempvar.txt
set /p temp_module_id=<templogs\tempvar.txt
echo %temp_module_id%>>templogs\modules_list.txt
set /a temp_count+=1
goto:listing_modules_in_profile
:skip_listing_modules_in_profile
%windir%\System32\sort.exe /l C <"templogs\modules_list.txt" /o ""templogs\modules_list.txt"
type "templogs\modules_list.txt"
del /q templogs\modules_list.txt
endlocal
exit /b

:add_del_module_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\modules\profiles\%~1
set /a selected_page=1
call :modules_list
IF %errorlevel% EQU 404 (
	del /q templogs\modules_list.txt
	exit /b 400
)
set /a page_number=%count_modules%/20
IF %count_modules% LEQ 20 (
	set /a modulo=0
	set /a page_number=1
	goto:skip:modulo_calc
)
set mod_a=!count_modules!
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
:recall_add_remove_module
IF %count_modules% LEQ 20 (
	call "%associed_language_script%" "intro_modules_one_page"
) else (
	call "%associed_language_script%" "intro_modules_multi_page"
)
echo.
call "%associed_language_script%" "add_remove_modules_info"
echo.
IF %modulo% NEQ 0 (
	IF %selected_page% EQU %page_number% (
		set /a temp_max_display_modules=%count_modules%
		set /a temp_min_display_modules=%count_modules%-%modulo%+1
	) else (
		set /a temp_max_display_modules=%selected_page%*20
		set /a temp_min_display_modules=!temp_max_display_modules!-19
	)
) else (
	IF %count_modules% LEQ 20 (
		set /a temp_max_display_modules=%count_modules%
		set /a temp_min_display_modules=1
	) else (
		set /a temp_max_display_modules=%selected_page%*20
		set /a temp_min_display_modules=!temp_max_display_modules!-19
	)
)
for /l %%i in (%temp_min_display_modules%,1,%temp_max_display_modules%) do (
	tools\gnuwin32\bin\grep.exe -c "!modules_list_%%i_0!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_modules=<templogs\tempvar.txt
	IF !temp_count_modules! EQU 0 (
		echo %%i: !modules_list_%%i_0!
	) else (
		echo %%i: *!modules_list_%%i_0!
	)
)
IF %count_modules% GTR 20 call "%associed_language_script%" "change_page_info"
set module_choice=
call "%associed_language_script%" "add_remove_modules_choice_ending"
IF "%module_choice%"=="" set /a module_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%module_choice%"
IF /i "%module_choice:~0,1%"=="p" (
	set change_page=Y
	IF %nb% equ 1 (
		set module_choice=0
	) else (
		set module_choice=%module_choice:~1%
	)
	)
	call TOOLS\Storage\functions\strlen.bat nb "%module_choice%"
set i=0
:check_chars_module_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!module_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_module_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF "%change_page%"=="Y" (
	IF %module_choice% GTR %page_number% (
		call "%associed_language_script%" "page_not_exist_error"
		set change_page=
		goto:recall_add_remove_module
	) else IF %module_choice% LEQ 0 (
	call "%associed_language_script%" "page_not_exist_error"
	set change_page=
	goto:recall_add_remove_module
	) else (
		set selected_page=%module_choice%
		set change_page=
		goto:recall_add_remove_module
	)
)
IF %module_choice% GTR %count_modules% (
	del /q templogs\modules_list.txt
	exit /b 400
)
IF %module_choice% EQU 0 (
	del /q templogs\modules_list.txt
	exit /b 400
)
TOOLS\gnuwin32\bin\sed.exe -n %module_choice%p <templogs\modules_list.txt > templogs\tempvar.txt
set /p module_selected=<templogs\tempvar.txt
tools\gnuwin32\bin\grep.exe -c "%module_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF %temp_count% EQU 0 (
	echo %module_selected%>>"%temp_path_profile%"
) else (
	tools\gnuwin32\bin\grep.exe -v "%module_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
	del /q "%temp_path_profile%" >nul
	move templogs\tempvar.txt "%temp_path_profile%" >nul
)
goto:recall_add_remove_module
exit /b

:modules_list
copy nul templogs\modules_list.txt >nul
cd tools\sd_switch\modules\pack
for /D %%i in (*) do (
	echo %%i>>..\..\..\..\templogs\modules_list.txt
)
cd ..\..\..\..
tools\gnuwin32\bin\grep.exe -c "" <templogs\modules_list.txt > templogs\tempvar.txt
set /p count_modules=<templogs\tempvar.txt
set temp_count=1
:listing_modules
IF %count_modules% EQU 0 (
	call "%associed_language_script%" "no_modules_in_modules_folder"
	exit /b 404
)
IF %temp_count% GTR %count_modules% goto:skip_listing_modules
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\modules_list.txt > templogs\tempvar.txt
set /p modules_list_%temp_count%_0=<templogs\tempvar.txt
set /a temp_count+=1
goto:listing_modules
:skip_listing_modules
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal