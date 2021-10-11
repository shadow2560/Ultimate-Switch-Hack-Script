::script modified by shadow256
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
IF NOT EXIST "Saturn_emu_inject_datas\*.*" mkdir "Saturn_emu_inject_datas"
IF NOT EXIST "Saturn_emu_inject_datas\games\*.*" mkdir "Saturn_emu_inject_datas\games"
IF NOT EXIST "Saturn_emu_inject_datas\ini\*.*" mkdir "Saturn_emu_inject_datas\ini"

call "%associed_language_script%" "display_title"
:Menu
cls
set begin=
call "%associed_language_script%" "main_menu"
if "%begin%"=="1" (
	cls
	call :Howtouse
	goto:Menu
) else if "%begin%"=="2" (
	cls
	goto:Start
	) else if "%begin%"=="3" (
		start "" /d "Tools\CDmage" "Tools\CDmage\CDmage.exe"
		goto:Menu
) else if "%begin%"=="4" (
	cls
	call :manage_ini_profiles
	goto:Menu
)
) else (
	goto:end_script2
)

:Start
set br=
call "%associed_language_script%" "nsp_source_choice"
set /p br=<%ushs_base_path%templogs\tempvar.txt
IF "%br%"=="" (
	goto:menu
)

:saturn_game_set
echo.
set saturn_game_source=
call "%associed_language_script%" "set_saturn_game_source"
set /p saturn_game_source=<%ushs_base_path%templogs\tempvar.txt
IF "%saturn_game_source%"=="" (
	goto:menu
) else (
	set saturn_game_source=%saturn_game_source%\
	set saturn_game_source=!saturn_game_source:\\=\!
)

:keys_path_set
echo.
set keys_path=
call "%associed_language_script%" "set_keys_path"
set /p keys_path=<%ushs_base_path%templogs\tempvar.txt
IF "%keys_path%"=="" (
	goto:menu
)

:title_keys_path_set
echo.
set title_keys_path=
call "%associed_language_script%" "set_title_keys_path"
set /p title_keys_path=<%ushs_base_path%templogs\tempvar.txt
IF "%title_keys_path%"=="" (
	goto:menu
)

:icon_change_choice
set bs=
set bz=
echo.
call "%associed_language_script%" "set_icon_type_choice"
IF NOT "%bs%"=="" set bs=%bs:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "bs" "o/n_choice"
IF /i "%bs%"=="o" (
	call "%associed_language_script%" "set_icon_path"
	set /p bz=<%ushs_base_path%templogs\tempvar.txt
	IF "!bz!"=="" (
		goto:icon_change_choice
	)
)

:custom_ini_change_choice
set custom_ini_choice=
set custom_ini_path=Tools\config.ini
echo.
call "%associed_language_script%" "set_custom_ini_choice"
IF NOT "%custom_ini_choice%"=="" set custom_ini_choice=%custom_ini_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_ini_choice" "o/n_choice"
IF /i "%custom_ini_choice%"=="o" (
	call "%associed_language_script%" "set_custom_ini_path"
	set /p custom_ini_path=<%ushs_base_path%templogs\tempvar.txt
	IF "!custom_ini_path!"=="" (
		goto:custom_ini_change_choice
	)
)

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
call "%ushs_base_path%tools\storage\functions\strlen.bat" nb "%id%"
IF %nb% NEQ 16 (
	call "%associed_language_script%" "id_length_error"
	goto:id_set
)
call "%ushs_base_path%tools\storage\functions\CONV_VAR_to_MAJ.bat" "id"
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
call "%ushs_base_path%tools\storage\functions\strlen.bat" nb "%name%"
IF %nb% GTR 128 (
	call "%associed_language_script%" "name_length_error"
	goto:name_set
)
:author_set
echo.
set author=No specified
call "%associed_language_script%" "set_author"
call "%ushs_base_path%tools\storage\functions\strlen.bat" nb "%author%"
IF %nb% GTR 64 (
	call "%associed_language_script%" "author_length_error"
	goto:author_set
)
:version_set
echo.
set version=1.0
call "%associed_language_script%" "set_version"
call "%ushs_base_path%tools\storage\functions\strlen.bat" nb "%version%"
IF %nb% GTR 4 (
	call "%associed_language_script%" "version_length_error"
	goto:version_set
)
:nsp_path_set
echo.
set nsp_path=
call "%associed_language_script%" "set_nsp_path"
set /p nsp_path=<%ushs_base_path%templogs\tempvar.txt
IF "%nsp_path%"=="" (
	goto:menu
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

set filename0=Cotton2
set filename1=GuardianForce
set filename2=CottonBoomerang

cd tools\Saturn_emu_inject
echo.
call "%associed_language_script%" "extract_nsp_step"
if not exist "%CD%\nsp" (
	mkdir "%CD%\nsp"
)
"%ushs_base_path%tools\Hactool_based_programs\hactoolnet.exe" --k "%keys_path%" --titlekeys "%title_keys_path%" -t pfs0 --outdir "%CD%\nsp" "%br%" >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)

:START_NCA
echo.
call "%associed_language_script%" "nca_step"
if not exist "%CD%\nca" (
	mkdir "%CD%\nca"
	mkdir "%CD%\nca\control"
	mkdir "%CD%\nca\exefs"
	mkdir "%CD%\nca\romfs"
)

For /R "%CD%\nsp\" %%G in (*.nca) do (
	"%ushs_base_path%tools\Hactool_based_programs\hactoolnet.exe" -k "%keys_path%" --titlekeys "%title_keys_path%" --romfsdir "%CD%\nca\romfs" --exefsdir "%CD%\nca\exefs" "%%G" >nul 2>&1
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "conversion_error"
		pause
		call :del_temp_files
		goto:menu
	)
)
del /q "%CD%\nca\romfs\control.nacp">nul
del /q "%CD%\nca\romfs\*.dat">nul
del /q "%CD%\nca\romfs\*.cnmt">nul

if exist .\nca\control\icon_AmericanEnglish.dat (
	del .\nca\control\icon_AmericanEnglish.dat >nul
)

:replace_game_files
set /a tempcount=0
for /l %%i in (0,1,2) do (
	IF EXIST "%CD%\nca\romfs\!filename%%i!.bin" (
		set game_files=!filename%%i!
		set /a tempcount=!tempcount!+1
	)
)
IF %tempcount% NEQ 1 (
	call "%associed_language_script%" "nsp_source_not_allowed"
	pause
	call :del_temp_files
	goto:menu
)
del /q "%CD%\nca\romfs\%game_files%.bin"
del /q "%CD%\nca\romfs\%game_files%.cue"

rem Saving the decrypted folders for futur use
%windir%\System32\Robocopy.exe "%CD%\nca\ " "%ushs_base_path%Saturn_emu_inject_datas\games\%game_files%" /e >nul

%windir%\System32\Robocopy.exe "%saturn_game_source% " "%CD%\nca\romfs" /e >nul
rename "%CD%\nca\romfs\*.cue" "%game_files%.cue"

:rewrite_ini_file
copy "%custom_ini_path%" "%CD%\nca\romfs\%game_files%_Switch.ini" >nul

echo.
call "%associed_language_script%" "icon_step"
IF /i "%bs%"=="o" (
	goto:Giveyouricon
) else (
	goto:Generic
)

:Giveyouricon
mkdir .\icon
IF /i "%bz:~-3,3%"=="jpg" (
	copy /b "%bz:"=%" .\icon\icon.jpg >nul
) else IF /i "%bz:~-3,3%"=="png" (
	copy /b "%bz:"=%" .\icon\icon.png >nul
) else (
	echo.
	call "%associed_language_script%" "icon_copy_error"
	echo.
	rmdir /s /q .\icon
	goto:Generic
)
if exist .\icon\icon.png (
	ren .\icon\icon.png icon.jpg >nul
)
"%ushs_base_path%tools\ImageMagick\magick.exe" mogrify -resize 256x256! .\icon\icon.jpg
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
move .\icon\icon.jpg .\nca\control\icon_AmericanEnglish.dat >nul
GOTO Next

:Generic
copy .\Tools\control\icon_AmericanEnglish.dat .\nca\control\icon_AmericanEnglish.dat >nul

:Next
echo.
call "%associed_language_script%" "create_game_step"
if exist .\nca\exefs\main.npdm (
	move .\nca\exefs\main.npdm .\ >nul
)
	copy .\Tools\control\control.nacp .\control.nacp >nul

"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t npdm -d %id% -i main.npdm >nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t nacp -n "%name%" -a "%author%" -v "%version%" -i control.nacp >nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)

move .\control.nacp .\nca\control\ >nul
move .\main.npdm .\nca\exefs\ >nul

set td=%id%

mkdir .\nca\out
.\Tools\hacpack.exe -k "%keys_path%" -o .\nca\out\program\ --type nca --ncatype program --titleid %td% --exefsdir .\nca\exefs\ --romfsdir .\nca\romfs\ >nul 2>&1
.\Tools\hacpack.exe -k "%keys_path%" -o .\nca\out\control\ --type nca --ncatype control --titleid %td% --romfsdir .\nca\control\ >nul.txt 2>&1
if exist .\nca\out\program\*.nca (
	.\Tools\hacpack.exe -k "%keys_path%" -o .\nca\out\ --titletype application --type nca --ncatype meta --titleid %td% --programnca .\nca\out\program\*.nca --controlnca .\nca\out\control\*.nca >nul 2>&1
)
if exist .\nca\out\control\*.nca (
	.\Tools\hacpack.exe -k "%keys_path%" -o .\nca\out\ --titletype application --type nca --ncatype meta --titleid %td% --programnca .\nca\out\program\*.nca --controlnca .\nca\out\control\*.nca >nul 2>&1
)

mkdir .\nca\out\ncas
if exist .\nca\out\program\*.nca (
	move .\nca\out\program\*.nca .\nca\out\ncas\ >nul
)
if exist .\nca\out\control\*.nca (
	move .\nca\out\control\*.nca .\nca\out\ncas\ >nul
)
if exist .\nca\out\*.nca (
	move .\nca\out\*.nca .\nca\out\ncas\ >nul
)

.\Tools\hacpack.exe -k "%keys_path%" -o "%nsp_path:\=\\%" --type nsp --ncadir .\nca\out\ncas\ --titleid %td% >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
call :del_temp_files
rename "%nsp_path%%id%.nsp" "%name%_%id%.nsp" >nul
echo.
call "%associed_language_script%" "end_process"
pause
goto:menu

:Howtouse
call "%associed_language_script%" "howtouse_text"
pause
exit /b

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

:del_temp_files
rem del "ID.txt" >nul 2>&1
rmdir /s /q "nca\" >nul 2>&1
rmdir /s /q "nsp\" >nul 2>&1
rmdir /s /q "hacpack_backup\" >nul 2>&1
rmdir /s /q "hacpack_temp\" >nul 2>&1
rmdir /s /q Game_inject >nul 2>&1
rmdir /s /q icon >nul 2>&1
del /q main.npdm >nul 2>&1
del /q control.nacp >nul 2>&1
cd ..\..
exit /b

:manage_ini_profiles
echo Function not usable for now
pause
exit /b

:create_ini_profile

exit /b

modify_ini_profile

exit /b

:delete_ini_profile

goto:eof

:select_ini_profile

goto:eof

:infos_ini_profile

goto:eof

:end_script
pause
:end_script2
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal