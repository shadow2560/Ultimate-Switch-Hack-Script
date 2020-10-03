::script by shadow256
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
:set_nereba_choice
set nereba_choice=
echo.
call "%associed_language_script%" "first_action_choice"
IF "%nereba_choice%"=="1" (
	call :prepare_sd
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="2" (
	call :launch_server
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="3" (
	call :prepare_sd
	call :launch_server
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="0" (
	call tools\storage\prepare_sd_switch.bat
	call "%associed_language_script%" "display_title"
	mkdir templogs
	goto:set_nereba_choice
)
goto:end_script

:prepare_sd
:define_volume_letter
set volume_letter=
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
set disk_not_finded_choice=
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "disk_not_finded_choice" "o/n_choice"
	IF /i "!disk_not_finded_choice!"=="o" (
		goto:define_volume_letter
	) else (
		goto:end_script
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
echo.
echo.
call "%associed_language_script%" "disk_choice"
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	call "%associed_language_script%" "disk_choice_empty_error"
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:set_nereba_choice
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
	call "%associed_language_script%" "disk_choice_not_in_list_error"
	goto:define_volume_letter
)
:list_payloads
echo.
call "%associed_language_script%" "payload_choice_begin"
copy nul templogs\payload_list.txt
set max_payload=1
cd Payloads
for %%z in (*.bin) do (
	echo !max_payload!: %%z >>..\templogs\payloads_list.txt
	set /a max_payload+=1
)
cd ..
:select_payload
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\payloads_list.txt
set payload_number=
call "%associed_language_script%" "payload_choice"
IF "%payload_number%"=="" goto:set_nereba_choice
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
		goto:set_nereba_choice
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
	goto:copy_nereba
)
TOOLS\gnuwin32\bin\grep.exe "%payload_number%: " <templogs\payloads_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p payload_path=<templogs\tempvar.txt
IF "%payload_path%"=="" (
	goto:set_nereba_choice
)
set payload_path=%payload_path:~1,-1%
set integrate_pegascape_official=
call "%associed_language_script%" "payload_for_pegascape_official_choice"
IF NOT "%integrate_pegascape_official%"=="" set integrate_pegascape_official=%integrate_pegascape_official:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "integrate_pegascape_official" "o/n_choice"
:copy_nereba
"%windir%\system32\robocopy.exe" tools\sd_switch\pegaswitch %volume_letter%:\ /e >nul
IF NOT EXIST "%volume_letter%:\nereba\*.*" mkdir "%volume_letter%:\nereba" >nul
copy /v "%payload_path%" "%volume_letter%:\nereba\nereba.bin" >nul
copy /v "tools\sd_switch\mixed\base\hbmenu.nro" %volume_letter%:\ >nul
copy /v "tools\sd_switch\atmosphere\atmosphere\hbl.nsp" "%volume_letter%:\pegascape"
IF /i "%integrate_pegascape_official%"=="o" (
	IF NOT EXIST "%volume_letter%:\atmosphere\*.*" mkdir "%volume_letter%:\atmosphere" >nul
	IF NOT EXIST "%volume_letter%:\atmosphere\hbl.nsp" copy /v "tools\sd_switch\atmosphere\atmosphere\hbl.nsp" "%volume_letter%:\atmosphere"
	IF NOT EXIST "%volume_letter%:\atmosphere\reboot_payload.bin" copy /v "%payload_path%" "%volume_letter%:\atmosphere\reboot_payload.bin"
)
call "%associed_language_script%" "end_prepare_sd"
pause
exit /b

:launch_server
set pegaswitch_server_type=
call "%associed_language_script%" "server_choice"
IF "%pegaswitch_server_type%"=="1" goto:define_pegaswitch_launch_mode
IF "%pegaswitch_server_type%"=="2" goto:define_pegaswitch_launch_mode
exit /b
:define_pegaswitch_launch_mode
set pegaswitch_launch_mode=
call "%associed_language_script%" "server_launch_mode_choice"
IF "%pegaswitch_launch_mode%"=="1" goto:continue_launch_server
IF "%pegaswitch_launch_mode%"=="2" goto:continue_launch_server
exit /b
:continue_launch_server
call "%associed_language_script%" "begin_launch_server"
call :write_begin_node.js_launch_file
IF "%pegaswitch_server_type%"=="1" echo cd Pegascape>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_server_type%"=="2" echo cd Pegaswitch>>tools\Node.js_programs\App\Server.cmd
echo npm.cmd install>>tools\Node.js_programs\App\Server.cmd
tools\Node.js_programs\NodeJSPortable.exe
call :write_begin_node.js_launch_file
IF "%pegaswitch_server_type%"=="1" echo cd Pegascape>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_server_type%"=="2" echo cd Pegaswitch>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_launch_mode%"=="1" echo npm.cmd start>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_launch_mode%"=="2" echo npm.cmd start --webapplet>>tools\Node.js_programs\App\Server.cmd
start /i "" tools\Node.js_programs\NodeJSPortable.exe
call "%associed_language_script%" "end_launch_server"
pause
del /q tools\Node.js_programs\App\Server.cmd
copy tools\Node.js_programs\App\Server.cmd.orig tools\Node.js_programs\App\Server.cmd >nul
exit /b

:write_begin_node.js_launch_file
echo @echo off>tools\Node.js_programs\App\Server.cmd
echo title NodeJS>>tools\Node.js_programs\App\Server.cmd
echo cls>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
echo echo Node>>tools\Node.js_programs\App\Server.cmd
echo node --version>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal