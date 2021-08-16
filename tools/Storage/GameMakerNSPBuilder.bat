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
call "%associed_language_script%" "display_title"
cd tools\GameMakerNSPBuilder
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

:gamemaker_game_set
echo.
set gamemaker_source=
call "%associed_language_script%" "set_gamemaker_game_source"
set /p gamemaker_source=<%ushs_base_path%templogs\tempvar.txt
IF "%gamemaker_source%"=="" (
	goto:menu
) else (
	set gamemaker_source=%gamemaker_source%\
	set gamemaker_source=!gamemaker_source:\\=\!
	IF NOT EXIST "Game_inject" mkdir Game_inject
	%windir%\System32\Robocopy.exe "%gamemaker_source%"  "Game_inject" /e >nul
)

:keys_path_set
echo.
set keys_path=
call "%associed_language_script%" "set_keys_path"
set /p keys_path=<%ushs_base_path%templogs\tempvar.txt
IF "%keys_path%"=="" (
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
:author_set
echo.
set author=No specified
call "%associed_language_script%" "set_author"
:version_set
echo.
set version=1.0
call "%associed_language_script%" "set_version"
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

echo.
call "%associed_language_script%" "extract_nsp_step"
if not exist "%CD%\nsp" (
	mkdir "%CD%\nsp"
)
rem "%ushs_base_path%tools\Hactool_based_programs\tools\hactool.exe" "%br%" -k "%keys_path%" -x --intype=pfs0 --pfs0dir="%CD%\nsp"
"%ushs_base_path%tools\Hactool_based_programs\hactoolnet.exe" --k "%keys_path%" -t pfs0 --outdir "%CD%\nsp" "%br%" >nul 2>&1

:START_NCA
echo.
set bl=
call "%associed_language_script%" "nca_step"
if not exist "%CD%\nca" (
	mkdir "%CD%\nca"
	mkdir "%CD%\nca\control"
	mkdir "%CD%\nca\exefs"
	mkdir "%CD%\nca\romfs"
)

For /R "%CD%\nsp\" %%G in (*.nca) do (
	rem "%ushs_base_path%tools\Hactool_based_programs\tools\hactool.exe" "%%G" -k "%keys_path%" --romfsdir="%CD%\nca\romfs" --exefsdir="%CD%\nca\exefs"
	"%ushs_base_path%tools\Hactool_based_programs\hactoolnet.exe" -k "%keys_path%" --romfsdir "%CD%\nca\romfs" --exefsdir "%CD%\nca\exefs" "%%G" >nul 2>&1
)
move "%CD%\nca\romfs\control.nacp" "%CD%\nca\control\control.nacp" >nul
move "%CD%\nca\romfs\icon_AmericanEnglish.dat" "%CD%\nca\control\icon_AmericanEnglish.dat" >nul
del /f /s /q "%CD%\nca\romfs\*.*" >nul

ren "%CD%\Game_inject\data.win"  game.win >nul
for /d %%f in ("%CD%\Game_inject\*.*") do (
	move /y "%%f" "%CD%\nca\romfs\" >nul
)
move /y "%CD%\Game_inject\*.*" "%CD%\nca\romfs\" >nul
if exist .\nca\control\icon_AmericanEnglish.dat (
	del .\nca\control\icon_AmericanEnglish.dat >nul
)

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
move .\icon\icon.jpg .\nca\control\icon_AmericanEnglish.dat >nul
rmdir /s /q .\icon
GOTO Next

:Generic
copy .\Tools\icon_AmericanEnglish.dat .\nca\control\icon_AmericanEnglish.dat >nul

:Next
echo.
call "%associed_language_script%" "create_game_step"
if exist .\nca\exefs\main.npdm (
	move .\nca\exefs\main.npdm .\ >nul
)
if exist .\nca\control\control.nacp (
	move .\nca\control\control.nacp .\ >nul
) else (
	copy .\Tools\control2.nacp .\control.nacp >nul
)
rem set /p bs=<main.npdm

rem .\Tools\mnpdm.exe "%bs:"=%"
"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t npdm -d %id% -i main.npdm >nul
"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t nacp -n "%name%" -a "%author%" -v "%version%" -i control.nacp >nul

move .\control.nacp .\nca\control\ >nul
move .\main.npdm .\nca\exefs\ >nul
rem set /p td=<ID.txt
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
rmdir /s /q .\nca\out
rem del "ID.txt" >nul
rmdir /s /q "%CD%\nca\"
rmdir /s /q "%CD%\nsp\"
rmdir /s /q "%CD%\hacpack_backup\"
rmdir /s /q Game_inject
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

:end_script
pause
:end_script2
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal