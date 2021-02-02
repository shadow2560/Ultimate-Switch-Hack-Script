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
chcp 1252 >nul
call "%associed_language_script%" "display_title"
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF EXIST tools\toolbox\user_tools.txt\*.* rmdir /s /qtools\toolbox\user_tools.txt
IF NOT EXIST tools\toolbox\user_tools.txt copy nul tools\toolbox\user_tools.txt
call "%associed_language_script%" "intro"
pause
:define_action_choice
cls
set action_choice=
call "%associed_language_script%" "first_action_choice"
IF "%action_choice%"=="1" goto:launch_software
IF "%action_choice%"=="2" goto:launch_working_folder
IF "%action_choice%"=="3" goto:config_softwares_list
goto:end_script

:launch_software
cls
set launch_software_choice=
call "%associed_language_script%" "launch_software_begin"
echo.
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\default_tools.txt > templogs\tempvar.txt
set /p count_software_default=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
set /a temp_count=0
set /a temp_count_default=0
:software_default_listing
set /a temp_count+=1
set /a temp_count_default+=1
IF %temp_count_default% GTR %count_software_default% (
	goto:finish_software_default_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_default%p <tools\toolbox\default_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_default_listing
:finish_software_default_listing
set /a temp_count_user=0
IF %count_software_user% EQU 0 goto:finish_software_user_listing
echo.
call "%associed_language_script%" "software_personal_list_begin"
echo.
set /a temp_count-=1
:software_user_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_listing
:finish_software_user_listing
echo.
call "%associed_language_script%" "launch_software_choice"
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:launch_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:define_action_choice
IF %launch_software_choice% EQU 0 goto:define_action_choice
set software_list_choice=0
IF %launch_software_choice% GTR %count_software_default% (
	set /a launch_software_choice-=%count_software_default%
	set software_list_choice=1
)
IF "%software_list_choice%"=="0" (
	TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\default_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
)
IF "%software_list_choice%"=="1" (
	TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
)
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
call :extract_base_folder "%software_path%"
start "" /d "%software_folder_path%" "%software_path%"
goto:launch_software

:launch_working_folder
cls
set launch_software_choice=
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	call "%associed_language_script%" "no_personal_software_defined_error"
	goto:define_action_choice
)
echo.
call "%associed_language_script%" "software_personal_list_begin"
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_f_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_f_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_f_listing
:finish_software_user_f_listing
echo.
call "%associed_language_script%" "launch_working_dir_choice"
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_f_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_f_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:launch_working_folder
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:define_action_choice
IF %launch_software_choice% EQU 0 goto:define_action_choice
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
call :extract_base_folder "%software_path%"
start explorer.exe "%software_folder_path%"
goto:launch_working_folder

:config_softwares_list
cls
set manage_choice=
call "%associed_language_script%" "manage_action_choice"
IF "%manage_choice%"=="1" goto:add_software
IF "%manage_choice%"=="2" goto:modify_software
IF "%manage_choice%"=="3" goto:del_software
goto:define_action_choice

:add_software
:define_software_name
set software_name=
call "%associed_language_script%" "software_name_choice"
IF "%software_name%"=="" (
	call "%associed_language_script%" "software_name_empty_error"
	goto:define_software_name
) else (
	set software_name=%software_name:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%software_name%"
set i=0
:check_chars_software_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!software_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "software_name_char_error"
			goto:define_software_name
		)
	)
	set /a i+=1
	goto:check_chars_software_name
)
echo.
set software_copy=
call "%associed_language_script%" "software_copy_type_choice"
IF NOT "%software_copy%"=="" set software_copy=%software_copy:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "software_copy" "o/n_choice"
IF /i "%software_copy%"=="o" (
	IF EXIST "tools\toolbox\%software_name%" (
		call "%associed_language_script%" "software_already_exist_error"
		goto:config_softwares_list
	)
)
:define_software_type
IF /i "%software_copy%"=="o" (
	echo.
	set software_type=
	call "%associed_language_script%" "software_type_choice"
)
IF /i "%software_copy%"=="o" (
	IF "%software_type%"=="0" goto:config_softwares_list
	IF "%software_type%"=="1" goto:define_software_path
	IF "%software_type%"=="2" goto:define_software_path
	call "%associed_language_script%" "choice_not_allowed_error"
	goto:define_software_type
)
:define_software_path
echo.
call "%associed_language_script%" "add_software_file_choice"
set /p software_path=<templogs\tempvar.txt
IF "%software_path%"=="" (
	call "%associed_language_script%" "no_software_file_selected_error"
	goto:config_softwares_list
)
IF /i "%software_copy%"=="o" (
	mkdir "tools\toolbox\%software_name%"
	IF "%software_type%"=="1" copy /v /b "%software_path%" "tools\toolbox\%software_name%"
)
call :extract_base_folder "%software_path%"
IF /i "%software_copy%"=="o" (
	IF "%software_type%"=="2" %windir%\System32\Robocopy.exe "%software_path%" "tools\toolbox\%software_name%" /e
)
call :get_software_file_name "%software_path%"
IF /i "%software_copy%"=="o" (
	set software_path=tools\toolbox\%software_name%\%software_file_name%
)
echo %software_name%; %software_path%>> tools\toolbox\user_tools.txt
call "%associed_language_script%" "add_software_success"
pause
goto:config_softwares_list

:modify_software
set launch_software_choice=
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	call "%associed_language_script%" "no_personal_software_defined_error"
	goto:config_softwares_list
)
echo.
call "%associed_language_script%" "software_personal_list_begin"
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_m_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_m_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_m_listing
:finish_software_user_m_listing
echo.
call "%associed_language_script%" "modify_software_choice"
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_m_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_m_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:modify_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:config_softwares_list
IF %launch_software_choice% EQU 0 goto:config_softwares_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p software_name=<templogs\tempvar.txt
:define_new_software_name
echo.
set new_software_name=
call "%associed_language_script%" "modify_software_name_choice"
IF "%new_software_name%"=="" (
	call "%associed_language_script%" "modify_software_not_renamed_error"
	goto:config_softwares_list
) else IF "%new_software_name%"=="%software_name%" (
	call "%associed_language_script%" "modify_software_not_renamed_error"
	goto:config_softwares_list
	) else (
	set new_software_name=%new_software_name:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%new_software_name%"
set i=0
:check_chars_new_software_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!new_software_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "software_name_char_error"
			goto:define_new_software_name
		)
	)
	set /a i+=1
	goto:check_chars_new_software_name
)
IF "%software_path:~0,14%"=="tools\toolbox\" (
	set rename_software_folder=O
	call :get_software_file_name "%software_path%"
) else (
	set new_software_path=%software_path%
	goto:renaming_in_list
)
move "tools\toolbox\%software_name%" "tools\toolbox\%new_software_name%"
set new_software_path=tools\toolbox\%new_software_name%\%software_file_name%
:renaming_in_list
TOOLS\gnuwin32\bin\sed.exe -re "%launch_software_choice%s/%software_name%; %software_path:\=\\%/%new_software_name%; %new_software_path:\=\\%/" tools\toolbox\user_tools.txt > tools\toolbox\user_tools_new.txt
del tools\toolbox\user_tools.txt
rename tools\toolbox\user_tools_new.txt user_tools.txt
call "%associed_language_script%" "modify_software_success"
pause
goto:config_softwares_list

:del_software
set launch_software_choice=
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	call "%associed_language_script%" "no_personal_software_defined_error"
	goto:config_softwares_list
)
echo.
call "%associed_language_script%" "software_personal_list_begin"
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_d_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_d_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_d_listing
:finish_software_user_d_listing
echo.
call "%associed_language_script%" "modify_software_choice"
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_d_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_d_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:del_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:config_softwares_list
IF %launch_software_choice% EQU 0 goto:config_softwares_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
IF NOT "%software_path:~0,14%"=="tools\toolbox\" goto:del_from_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p software_name=<templogs\tempvar.txt
rmdir /s /q tools\toolbox\%software_name% 2>nul
:del_from_list
TOOLS\gnuwin32\bin\sed.exe -i %launch_software_choice%d "tools\toolbox\user_tools.txt"
call "%associed_language_script%" "del_software_success"
pause
goto:config_softwares_list

:extract_base_folder
set software_folder_path=%~dp1
exit /B

:get_software_file_name
set software_file_name=%~nx1
exit /B
:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
chcp 65001 >nul
endlocal