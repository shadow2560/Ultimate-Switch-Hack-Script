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
chcp 1252 > nul
call "%associed_language_script%" "display_title"
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "intro"
pause
:select_install
cls
set install_choice=
call "%associed_language_script%" "first_action_choice"
IF NOT "%install_choice%"=="" set install_choice=%install_choice:~0,1%
IF "%install_choice%"=="1" goto:launch_client
IF "%install_choice%"=="2" goto:install_winpcap
IF "%install_choice%"=="0" goto:launch_doc
goto:finish_script
:launch_client
call "%associed_language_script%" "launch_client_choice"
echo.
IF NOT "%launch_client_choice%"=="" set launch_client_choice=%launch_client_choice:~0,1%
IF "%launch_client_choice%"=="1" goto:load_client
IF "%launch_client_choice%"=="2" goto:server_select
IF "%launch_client_choice%"=="3" goto:servers_manage
goto:select_install
:server_select
set server_name=
set server_addr=
set selected_server=
IF NOT EXIST "tools\netplay\servers_list.txt" (
	call "%associed_language_script%" "no_server_list_error"
	pause
	goto:load_client
)
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\netplay\servers_list.txt > templogs\tempvar.txt
set /p count_server=<templogs\tempvar.txt
IF %count_server% EQU 0 (
	IF "%launch_client_choice%"=="2" (
		goto:load_client
	) else IF "%launch_client_choice%"=="3" (
		goto:servers_manage
	)
)
echo.
set selected_server=
call "%associed_language_script%" "choose_server_first_part"
echo.
set /a temp_count=0
:server_listing
set /a temp_count+=1
IF %temp_count% GTR %count_server% (
	goto:finish_server_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <tools\netplay\servers_list.txt >templogs\tempvar.txt
set /p temp_server=<templogs\tempvar.txt
echo %temp_count%: %temp_server%
goto:server_listing
:finish_server_listing
IF "%launch_client_choice%"=="2" call "%associed_language_script%" "launch_client_in_interactive_mode_message"
IF "%launch_client_choice%"=="3" call "%associed_language_script%" "go_back_message"
echo.
call "%associed_language_script%" "select_server_choice"
IF "%launch_client_choice%"=="2" (
	IF "%selected_server%"=="" goto:load_client
) else IF "%launch_client_choice%"=="3" (
	IF "%selected_server%"=="" goto:servers_manage
)
call TOOLS\Storage\functions\strlen.bat nb "%selected_server%"
set i=0
:check_chars_selected_server
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!selected_server:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_server
		)
	)
	IF "%launch_client_choice%"=="2" (
		IF "!check_chars!"=="0" (
			goto:load_client
		)
	else IF "%launch_client_choice%"=="3" (
		IF "!check_chars!"=="0" (
			goto:servers_manage
		)
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %selected_server%p <tools\netplay\servers_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p server_addr=<templogs\tempvar.txt
IF NOT "%server_addr%"=="" (
	set server_addr=%server_addr:~1%
	IF "%launch_client_choice%"=="2" (
		set server_addr=--relay-server-addr !server_addr!
	) else IF "%launch_client_choice%"=="3" (
		TOOLS\gnuwin32\bin\sed.exe -n %selected_server%p <tools\netplay\servers_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
		set /p server_name=<templogs\tempvar.txt
	)
) else (
	IF "%launch_client_choice%"=="2" (
		call "%associed_language_script%" "server_choice_not_exist_in_list_error"
		pause
		goto:load_client
	) else IF "%launch_client_choice%"=="3" (
		call "%associed_language_script%" "server_choice_not_exist_in_list_error2"
		pause
		goto:servers_manage
	)
)
IF "%launch_client_choice%"=="3" (
	IF "%manage_choice%"=="2" goto:modify_server
	IF "%manage_choice%"=="3" goto:del_server
)
:load_client
start /i "" tools\netplay\lan-play.exe %server_addr%
goto:select_install
:servers_manage
set manage_choice=
set install_choice=
set new_server_name=
set new_server_addr=
IF NOT EXIST "tools\netplay\servers_list.txt" (
	copy nul "tools\netplay\servers_list.txt"
)
cls
call "%associed_language_script%" "manage_servers_choice"
IF NOT "%manage_choice%"=="" set manage_choice=%manage_choice:~0,1%
IF "%manage_choice%"=="1" goto:add_server
IF "%manage_choice%"=="2" goto:server_select
IF "%manage_choice%"=="3" goto:server_select
goto:select_install
:add_server
call "%associed_language_script%" "server_name_choice"
IF "%new_server_name%"=="" (
	call "%associed_language_script%" "server_name_empty_error"
	pause
	goto:servers_manage
)
set "new_server_name=%new_server_name:"=%"
set "new_server_name=%new_server_name:;=%"
set "new_server_name=%new_server_name:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_name%"
set i=0
:check_chars_new_server_name_1
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		::echo %%z !new_server_name:~%i%,1!
		IF "!new_server_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "server_name_char_error"
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_name_1
)
call "%associed_language_script%" "server_addr_choice"
IF "%new_server_addr%"=="" (
	call "%associed_language_script%" "server_addr_empty_error"
	pause
	goto:servers_manage
)
set "new_server_addr=%new_server_addr:"=%"
set "new_server_addr=%new_server_addr:;=%"
set "new_server_addr=%new_server_addr:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_addr%"
set i=0
:check_chars_new_server_addr_1
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_addr:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "server_addr_char_error"
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_addr_1
)
echo %new_server_name%; %new_server_addr%>> tools\netplay\servers_list.txt
call "%associed_language_script%" "add_server_success"
pause
set manage_choice=
goto:servers_manage
:modify_server
call "%associed_language_script%" "modify_server_name_choice"
IF "%new_server_name%"=="" (
	set new_server_name=%server_name%
)
set "new_server_name=%new_server_name:"=%"
set "new_server_name=%new_server_name:;=%"
set "new_server_name=%new_server_name:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_name%"
set i=0
:check_chars_new_server_name_2
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "server_name_char_error"
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_name_2
)
call "%associed_language_script%" "modify_server_addr_choice"
IF "%new_server_addr%"=="" (
	set new_server_addr=%server_addr%
)
set "new_server_addr=%new_server_addr:"=%"
set "new_server_addr=%new_server_addr:;=%"
set "new_server_addr=%new_server_addr:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_addr%"
set i=0
:check_chars_new_server_addr_2
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_addr:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "server_addr_char_error"
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_addr_2
)
TOOLS\gnuwin32\bin\sed.exe "%selected_server%s/%server_name%; %server_addr:/=\/%/%new_server_name%; %new_server_addr:/=\/%/" tools\netplay\servers_list.txt > tools\netplay\servers_list_new.txt
del tools\netplay\servers_list.txt
rename tools\netplay\servers_list_new.txt servers_list.txt
call "%associed_language_script%" "modify_server_success"
pause
set manage_choice=
goto:servers_manage
:del_server
TOOLS\gnuwin32\bin\sed.exe -re "%selected_server%d" tools\netplay\servers_list.txt > tools\netplay\servers_list_new.txt
del tools\netplay\servers_list.txt
rename tools\netplay\servers_list_new.txt servers_list.txt
call "%associed_language_script%" "delete_server_success"
pause
set manage_choice=
goto:servers_manage
:install_winpcap
set install_choice=
call "%associed_language_script%" "winpcap_install_instructions"
pause
echo.
start tools\netplay\WinPcap.exe
goto:select_install
:launch_doc
set install_choice=
echo.
start "" "%language_path%\doc\files\netplay.html"
goto:select_install
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
chcp 65001 >nul
endlocal