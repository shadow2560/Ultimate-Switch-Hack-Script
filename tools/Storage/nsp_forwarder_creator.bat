::Script modified by Shadow256, based on the project on
::https://gbatemp.net/threads/nsp-forwarder-tool-for-12.587936/
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
:define_action_choice
cls
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" (
	set nsp_type=nro
	goto:pass_action_choice
)
IF "%action_choice%"=="2" (
	set nsp_type=rom
	goto:pass_action_choice
)
IF "%action_choice%"=="3" (
	cd "tools\nsp_forwarder_creator"
	start "" "..\AutoIt3\AutoIt3.exe" "Menu.au3"
	cd ..\..
)
goto:end_script2
:pass_action_choice
:id_set
echo.
set id=
call "%associed_language_script%" "set_id"
IF "%id%"=="" (
	call :randomize_id
	goto:pass_id_set
)
IF "%id:~0,2%" == "00" (
	call "%associed_language_script%" "id_too_small_error"
	goto:id_set
)
call tools\storage\functions\strlen.bat nb "%id%"
IF %nb% NEQ 16 (
	call "%associed_language_script%" "id_length_error"
	goto:id_set
)
call tools\storage\functions\CONV_VAR_to_MAJ.bat "id"
set i=0
:check_chars_id_value
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
		IF "!id:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_id_value
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "bad_char_error"
	goto:id_set
	)
)
:pass_id_set
:name_set
echo.
set name=
call "%associed_language_script%" "set_name"
IF "%name%"=="" (
	call "%associed_language_script%" "could_not_be_empty_error"
	goto:name_set
)
:icon_path_set
echo.
set icon_path=
set resize_icon_image=
call "%associed_language_script%" "set_icon_path"
set /p icon_path=<templogs\tempvar.txt
IF "%icon_path%"=="" (
	goto:end_script2
)
echo.
call "%associed_language_script%" "set_resize_icon_image"
IF NOT "%resize_icon_image%"=="" set resize_icon_image=%resize_icon_image:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "resize_icon_image" "o/n_choice"
:logo_path_set
echo.
set logo_path=
set resize_logo_image=
call "%associed_language_script%" "set_logo_path"
set /p logo_path=<templogs\tempvar.txt
IF "%logo_path%"=="" (
	goto:pass_logo_path_set
)
echo.
call "%associed_language_script%" "set_resize_logo_image"
IF NOT "%resize_logo_image%"=="" set resize_logo_image=%resize_logo_image:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "resize_logo_image" "o/n_choice"
:pass_logo_path_set
:nro_path_set
echo.
set nro_path=
call "%associed_language_script%" "set_nro_path"
IF "%nro_path%"=="" (
	call "%associed_language_script%" "could_not_be_empty_error"
	goto:nro_path_set
)
:rom_path_set
IF "%nsp_type%"=="rom" (
	echo.
	set rom_path=
	call "%associed_language_script%" "set_rom_path"
	IF "!rom_path!"=="" (
		call "%associed_language_script%" "could_not_be_empty_error"
		goto:rom_path_set
	)
)
:author_set
echo.
set author=No specified
call "%associed_language_script%" "set_author"
:version_set
echo.
set version=1.0
call "%associed_language_script%" "set_version"
:keys_path_set
echo.
set keys_path=
call "%associed_language_script%" "set_keys_path"
set /p keys_path=<templogs\tempvar.txt
IF "%keys_path%"=="" (
	goto:end_script2
)
:nsp_path_set
echo.
set nsp_path=
call "%associed_language_script%" "set_nsp_path"
set /p nsp_path=<templogs\tempvar.txt
IF "%nsp_path%"=="" (
	goto:end_script2
) else (
	set nsp_path=%nsp_path%\
	set nsp_path=!nsp_path:\\=\!
)
IF EXIST "%nsp_path%%name%_%id%.nsp" (
	echo.
	call "%associed_language_script%" "set_confirm_nsp_duplicated_deletion"
	IF !errorlevel! NEQ 1 (
		goto:end_script2
	) else (
		del /q "%nsp_path%%name%_%id%.nsp" >nul
	)
)
:confirm_nsp_creation
echo.
call "%associed_language_script%" "set_confirm_nsp_creation"
IF %errorlevel% NEQ 1 goto:end_script2

call "%associed_language_script%" "nsp_build_begin"
rmdir /s /q tools\nsp_forwarder_creator\control >nul
rmdir /s /q tools\nsp_forwarder_creator\exefs >nul
rmdir /s /q tools\nsp_forwarder_creator\logo >nul
rmdir /s /q tools\nsp_forwarder_creator\romfs >nul
%windir%\System32\Robocopy.exe tools\nsp_forwarder_creator\default_files tools\nsp_forwarder_creator /e >nul
IF /i "%resize_icon_image%"=="o" (
	tools\ImageMagick\magick.exe "%icon_path%" -resize 256x256^^ -gravity center -extent 256x256 "tools\nsp_forwarder_creator\control\icon.bmp"
) else (
	tools\ImageMagick\magick.exe "%icon_path%" "tools\nsp_forwarder_creator\control\icon.bmp"
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "icon_convert_error"
	goto:end_script
)
tools\ImageMagick\magick.exe "tools\nsp_forwarder_creator\control\icon.bmp" "tools\nsp_forwarder_creator\control\icon.jpg"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "icon_convert_error"
	del /q "tools\nsp_forwarder_creator\control\icon.bmp" >nul
	goto:end_script
)
del /q "tools\nsp_forwarder_creator\control\icon.bmp" >nul
rename "tools\nsp_forwarder_creator\control\icon.jpg" "icon_AmericanEnglish.dat" >NUL
IF NOT "%logo_path%"=="" (
	del /q "tools\nsp_forwarder_creator\logo\NintendoLogo.png" >nul
		IF /i "%resize_logo_image%"=="o" (
		tools\ImageMagick\magick.exe "%logo_path%" -resize 160x40^^ -gravity center -extent 160x40 "tools\nsp_forwarder_creator\logo\logo.bmp"
	) else (
		tools\ImageMagick\magick.exe "%logo_path%" "tools\nsp_forwarder_creator\logo\logo.bmp"
	)
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "logo_convert_error"
		goto:end_script
	)
	tools\ImageMagick\magick.exe "tools\nsp_forwarder_creator\logo\logo.bmp" "tools\nsp_forwarder_creator\logo\NintendoLogo.png"
		IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "logo_convert_error"
		del /q "tools\nsp_forwarder_creator\logo\logo.bmp" >nul
		goto:end_script
	)
	del /q "tools\nsp_forwarder_creator\logo\logo.bmp" >nul
)
IF "%nsp_type%"=="nro" (
	echo|set /p="sdmc:/%nro_path:\=/%"> tools\nsp_forwarder_creator\romfs\nextArgv
) else IF "%nsp_type%"=="rom" (
	echo|set /p="sdmc:/%nro_path:\=/% ^"sdmc:/%rom_path%^""> tools\nsp_forwarder_creator\romfs\nextArgv
)
echo|set /p="sdmc:/%nro_path:\=/%"> tools\nsp_forwarder_creator\romfs\nextNroPath
cd tools\nsp_forwarder_creator
"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t npdm -d %id% -i exefs\main.npdm >nul
"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t nacp -n "%name%" -a "%author%" -v "%version%" -i control\control.nacp >nul
hacbrewpack.exe --titleid %id% --titlename "%name%" --titlepublisher "%author%" --nspdir "%nsp_path:\=\\%" --keyset "%keys_path:\=\\%"
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "forwarder_build_error"
	rmdir /S/Q hacbrewpack_backup >nul 2>&1
	del control\icon_AmericanEnglish.dat >nul 2>&1
	cd ..\..
	goto:end_script
)
rmdir /S/Q hacbrewpack_backup >nul
del control\icon_AmericanEnglish.dat >nul
cd ..\..

rename "%nsp_path%%id%.nsp" "%name%_%id%.nsp" >nul
echo.
call "%associed_language_script%" "forwarder_build_success"
goto:end_script

:randomize_id
for /l %%n in (1,1,12) do (
	set rand=
	set /A rand=!RANDOM!%%16+1
	if !rand!==1 set rand%%n=a
	if !rand!==2 set rand%%n=b
	if !rand!==3 set rand%%n=c
	if !rand!==4 set rand%%n=d
	if !rand!==5 set rand%%n=e
	if !rand!==6 set rand%%n=f
	if !rand!==7 set rand%%n=1
	if !rand!==8 set rand%%n=2
	if !rand!==9 set rand%%n=3
	if !rand!==10 set rand%%n=4
	if !rand!==11 set rand%%n=5
	if !rand!==12 set rand%%n=6
	if !rand!==13 set rand%%n=7
	if !rand!==14 set rand%%n=8
	if !rand!==15 set rand%%n=9
	if !rand!==16 set rand%%n=0
)
set id=01%rand1%%rand2%%rand3%%rand4%%rand5%%rand6%%rand7%%rand8%%rand9%%rand10%%rand11%000
exit /b

:end_script
pause
:end_script2
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal