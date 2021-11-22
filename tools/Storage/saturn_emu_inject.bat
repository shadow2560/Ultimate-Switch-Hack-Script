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
IF NOT EXIST "Saturn_emu_inject_datas\credits\*.*" mkdir "Saturn_emu_inject_datas\Credit"
IF NOT EXIST "Saturn_emu_inject_datas\games\*.*" mkdir "Saturn_emu_inject_datas\games"
IF NOT EXIST "Saturn_emu_inject_datas\ini\*.*" mkdir "Saturn_emu_inject_datas\ini"
IF NOT EXIST "Saturn_emu_inject_datas\no_data\*.*" mkdir "Saturn_emu_inject_datas\no_data"
IF NOT EXIST "Saturn_emu_inject_datas\playingguides\*.*" mkdir "Saturn_emu_inject_datas\PlayingGuide"
IF NOT EXIST "Saturn_emu_inject_datas\profiles\*.*" mkdir "Saturn_emu_inject_datas\profiles"
IF NOT EXIST "Saturn_emu_inject_datas\textures\*.*" mkdir "Saturn_emu_inject_datas\textures"
IF NOT EXIST "Saturn_emu_inject_datas\wallpapers\*.*" mkdir "Saturn_emu_inject_datas\wallpapers"

set filename0=Cotton2
set filename1=GuardianForce
set filename2=CottonBoomerang

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
		start "" /d "Tools\Saturn_emu_inject\Tools\CDmage" "Tools\Saturn_emu_inject\Tools\CDmage\CDmage.exe"
		goto:Menu
) else if "%begin%"=="4" (
	cls
	call :save_prod.keys_file
	goto:Menu
) else if "%begin%"=="5" (
	cls
	call :convert_png_to_tex_folder
	goto:Menu
) else (
	goto:end_script2
)

:Start
set display_good_saved_games=n
for /l %%i in (0,1,2) do (
	IF EXIST "Saturn_emu_inject_datas\games\!filename%%i!\*.*" (
		set filename%%i_path=%ushs_base_path%Saturn_emu_inject_datas\games\!filename%%i!
		set display_good_saved_games=Y
	) else (
		set filename%%i_path=
	)
)
set br=
set br_choice=
call "%associed_language_script%" "nsp_source_choice"
IF /i "%display_good_saved_games%"=="Y" (
	IF "%br%"=="1" (
	set br_choice=0
	set game_files=%filename0%
	) else IF "%br%"=="2" (
	set br_choice=1
	set game_files=%filename1%
	) else IF "%br%"=="3" (
	set br_choice=2
	set game_files=%filename2%
	) else IF "%br%"=="0" (
	set /p br=<"%ushs_base_path%templogs\tempvar.txt"
	) else (
	goto:menu
	)
) else (
	set /p br=<"%ushs_base_path%templogs\tempvar.txt"
)
IF "%br%"=="0" set br=
IF "%br%"=="" (
	goto:menu
)

:saturn_game_set
echo.
set saturn_game_source=
call "%associed_language_script%" "set_saturn_game_source"
set /p saturn_game_source=<"%ushs_base_path%templogs\tempvar.txt"
IF "%saturn_game_source%"=="" (
	goto:menu
)
set saturn_game_source_folder=
call :get_saturn_game_source_folder "%saturn_game_source%"
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -i -e "^FILE " "%saturn_game_source%" | "%ushs_base_path%tools\gnuwin32\bin\cut.exe" -d\^" -f 2 > "%ushs_base_path%templogs\bin_list.txt"
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c "" "%ushs_base_path%templogs\bin_list.txt" > "%ushs_base_path%templogs\tempvar.txt"
set /p count_saturn_game_files=<"%ushs_base_path%templogs\tempvar.txt"
set /a count_saturn_game_files=%count_saturn_game_files%
IF %count_saturn_game_files% EQU 0 (
	call "%associed_language_script%" "cue_file_error"
	pause
	goto:menu
)
set /a templine=1
copy nul "%ushs_base_path%templogs\bin_list2.txt" >nul
:start_cue_analyse
IF %templine% GTR %count_saturn_game_files% goto:pass_start_cue_analyse
"%ushs_base_path%tools\gnuwin32\bin\sed.exe" -n !templine!p "%ushs_base_path%templogs\bin_list.txt" > "%ushs_base_path%templogs\tempvar.txt"
set /p tempinfo=<"%ushs_base_path%templogs\tempvar.txt"
set tempinfo=%saturn_game_source_folder%\%tempinfo%
IF NOT EXIST "%tempinfo%" (
	call "%associed_language_script%" "cue_file_error"
	pause
	goto:menu
)
echo !tempinfo! >> "%ushs_base_path%templogs\bin_list2.txt"
set /a templine=%templine%+1
goto:start_cue_analyse
:pass_start_cue_analyse

:keys_path_set
echo.
IF EXIST "Saturn_emu_inject_datas\prod.keys" set "keys_path=%ushs_base_path%Saturn_emu_inject_datas\prod.keys
IF EXIST "Saturn_emu_inject_datas\prod.keys" goto:icon_change_choice
set keys_path=
call "%associed_language_script%" "set_keys_path"
set /p keys_path=<"%ushs_base_path%templogs\tempvar.txt"
IF "%keys_path%"=="" (
	goto:menu
)

:title_keys_path_set
rem IF "%br_choice%"=="" (
	rem echo.
	rem set title_keys_path=
	rem call "%associed_language_script%" "set_title_keys_path"
	rem set /p title_keys_path=<"%ushs_base_path%templogs\tempvar.txt"
	rem IF "!title_keys_path!"=="" (
		rem goto:menu
	rem )
rem )

:icon_change_choice
set bs=
set bz=
echo.
call "%associed_language_script%" "set_icon_type_choice"
IF NOT "%bs%"=="" set bs=%bs:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "bs" "o/n_choice"
IF /i "%bs%"=="o" (
	call "%associed_language_script%" "set_icon_path"
	set /p bz=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!bz!"=="" (
		goto:icon_change_choice
	)
)

:custom_ini_change_choice
set custom_ini_choice=
set custom_ini_path=
set default_ini_choice=
echo.
call "%associed_language_script%" "set_default_ini_choice"
IF NOT "%default_ini_choice%"=="" set default_ini_choice=%default_ini_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "default_ini_choice" "o/n_choice"
IF "%default_ini_choice%"=="o" (
	set custom_ini_choice=o
	call :generic_ini_select
	goto:custom_wallpaper_change_choice
)
echo.
call "%associed_language_script%" "set_custom_ini_choice"
IF NOT "%custom_ini_choice%"=="" set custom_ini_choice=%custom_ini_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_ini_choice" "o/n_choice"
IF /i "%custom_ini_choice%"=="o" (
	call "%associed_language_script%" "set_custom_ini_path"
	set /p custom_ini_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_ini_path!"=="" (
		goto:custom_ini_change_choice
	)
)

:custom_wallpaper_change_choice
set custom_wallpaper_choice=
set custom_wallpaper_folder_path=
set default_wallpaper_choice=
echo.
call "%associed_language_script%" "set_default_wallpaper_choice"
IF NOT "%default_wallpaper_choice%"=="" set default_wallpaper_choice=%default_wallpaper_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "default_wallpaper_choice" "o/n_choice"
IF "%default_wallpaper_choice%"=="o" (
	set custom_wallpaper_choice=o
	set custom_wallpaper_folder_path=%ushs_base_path%tools\Saturn_emu_inject\Tools\Wallpaper
	goto:custom_credit_change_choice
)
echo.
call "%associed_language_script%" "set_custom_wallpaper_choice"
IF NOT "%custom_wallpaper_choice%"=="" set custom_wallpaper_choice=%custom_wallpaper_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_wallpaper_choice" "o/n_choice"
IF /i "%custom_wallpaper_choice%"=="o" (
	call "%associed_language_script%" "set_custom_wallpaper_folder_path"
	set /p custom_wallpaper_folder_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_wallpaper_folder_path!"=="" (
		goto:custom_wallpaper_change_choice
	)
)

:custom_credit_change_choice
set custom_credit_choice=
set custom_credit_folder_path=
set default_credit_choice=
echo.
call "%associed_language_script%" "set_default_credit_choice"
IF NOT "%default_credit_choice%"=="" set default_credit_choice=%default_credit_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "default_credit_choice" "o/n_choice"
IF "%default_credit_choice%"=="o" (
	set custom_credit_choice=o
	set custom_credit_folder_path=%ushs_base_path%tools\Saturn_emu_inject\Tools\Credit
	goto:custom_playingguide_change_choice
)
echo.
call "%associed_language_script%" "set_custom_credit_choice"
IF NOT "%custom_credit_choice%"=="" set custom_credit_choice=%custom_credit_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_credit_choice" "o/n_choice"
IF /i "%custom_credit_choice%"=="o" (
	call "%associed_language_script%" "set_custom_credit_folder_path"
	set /p custom_credit_folder_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_credit_folder_path!"=="" (
		goto:custom_credit_change_choice
	)
)

:custom_playingguide_change_choice
set custom_playingguide_choice=
set custom_playingguide_folder_path=
set default_playingguide_choice=
echo.
call "%associed_language_script%" "set_default_playingguide_choice"
IF NOT "%default_playingguide_choice%"=="" set default_playingguide_choice=%default_playingguide_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "default_playingguide_choice" "o/n_choice"
IF "%default_playingguide_choice%"=="o" (
	set custom_playingguide_choice=o
	set custom_playingguide_folder_path=%ushs_base_path%tools\Saturn_emu_inject\Tools\PlayingGuide
	goto:custom_texture_change_choice
)
echo.
call "%associed_language_script%" "set_custom_playingguide_choice"
IF NOT "%custom_playingguide_choice%"=="" set custom_playingguide_choice=%custom_playingguide_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_playingguide_choice" "o/n_choice"
IF /i "%custom_playingguide_choice%"=="o" (
	call "%associed_language_script%" "set_custom_playingguide_folder_path"
	set /p custom_playingguide_folder_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_playingguide_folder_path!"=="" (
		goto:custom_playingguide_change_choice
	)
)

:custom_texture_change_choice
set custom_texture_choice=
set custom_texture_path=
set default_texture_choice=
echo.
call "%associed_language_script%" "set_default_texture_choice"
IF NOT "%default_texture_choice%"=="" set default_texture_choice=%default_texture_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "default_texture_choice" "o/n_choice"
IF "%default_texture_choice%"=="o" (
	set custom_texture_choice=o
	set custom_texture_path=%ushs_base_path%tools\Saturn_emu_inject\Tools\Texture.tex
	goto:custom_nodata_change_choice
)
echo.
call "%associed_language_script%" "set_custom_texture_choice"
IF NOT "%custom_texture_choice%"=="" set custom_texture_choice=%custom_texture_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_texture_choice" "o/n_choice"
IF /i "%custom_texture_choice%"=="o" (
	call "%associed_language_script%" "set_custom_texture_path"
	set /p custom_texture_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_texture_path!"=="" (
		goto:custom_texture_change_choice
	)
)

:custom_nodata_change_choice
set custom_nodata_choice=
set custom_nodata_path=
echo.
call "%associed_language_script%" "set_custom_nodata_choice"
IF NOT "%custom_nodata_choice%"=="" set custom_nodata_choice=%custom_nodata_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "custom_nodata_choice" "o/n_choice"
IF /i "%custom_nodata_choice%"=="o" (
	call "%associed_language_script%" "set_custom_nodata_path"
	set /p custom_nodata_path=<"%ushs_base_path%templogs\tempvar.txt"
	IF "!custom_nodata_path!"=="" (
		goto:custom_nodata_change_choice
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
set i=0
:check_chars_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "name_char_error"
			goto:name_set
		)
	)
	set /a i+=1
	goto:check_chars_name
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
:save_size_set
echo.
set /a save_size=-1
call "%associed_language_script%" "set_save_size"
call "%ushs_base_path%tools\storage\functions\strlen.bat" nb "%save_size%"
set i=0
:check_chars_save_size_value
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 -) do (
		IF "!save_size:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_save_size_value
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "bad_char_error"
		goto:save_size_set
	)
)
:nsp_path_set
echo.
set nsp_path=
call "%associed_language_script%" "set_nsp_path"
set /p nsp_path=<"%ushs_base_path%templogs\tempvar.txt"
IF "%nsp_path%"=="" (
	goto:menu
)
set nsp_path=%nsp_path%\
set nsp_path=!nsp_path:\\=\!
IF EXIST "%nsp_path%%name%_%id%.nsp" (
	echo.
	call "%associed_language_script%" "set_confirm_nsp_duplicated_deletion"
	IF !errorlevel! NEQ 1 (
		goto:end_script2
	) else (
		del /q "%nsp_path:)=^)%%name%_%id%.nsp" >nul
	)
)
:confirm_nsp_creation
echo.
call "%associed_language_script%" "set_confirm_nsp_creation"
IF %errorlevel% NEQ 1 goto:menu

cd tools\Saturn_emu_inject
if exist "%CD%\nca" rmdir /s /q "%CD%\nca"
if exist "%CD%\nsp" rmdir /s /q "%CD%\nsp"
mkdir "%CD%\nca"
mkdir "%CD%\nca\control"
mkdir "%CD%\nca\exefs"
mkdir "%CD%\nca\logo"
mkdir "%CD%\nca\romfs"
mkdir "%CD%\nsp"

IF NOT "%br_choice%"=="" (
	%windir%\System32\Robocopy.exe "!filename%br_choice%_path! " "%CD%\nca" /e >nul
	goto:decrypted_folder_work
)
echo.
call "%associed_language_script%" "extract_nsp_step"
if not exist "%CD%\nsp" (
	mkdir "%CD%\nsp"
)
Tools\squirrel\bin\squirrel.exe -k "%keys_path:)=^)%" --Read_cnmt "%br%" > "%ushs_base_path%templogs\cnmt_infos.txt"
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" "Number of content =" "%ushs_base_path%templogs\cnmt_infos.txt" | "%ushs_base_path%tools\gnuwin32\bin\cut.exe" -d = -f 2 > "%ushs_base_path%templogs\tempvar.txt"
set /p tempcount=<"%ushs_base_path%templogs\tempvar.txt"
IF "%tempcount%"=="" (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
) else (
	set tempcount=%tempcount: =%
	set /a tempcount=%tempcount%
)
set /a nca_count=0
for /l %%i in (1,1,%tempcount%) do (
	"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -n -m 1 "Content number %%i" "%ushs_base_path%templogs\cnmt_infos.txt" | "%ushs_base_path%tools\gnuwin32\bin\cut.exe" -d : -f 1 > "%ushs_base_path%templogs\tempvar.txt"
	set /p templine=<"%ushs_base_path%templogs\tempvar.txt"
	set /a templine=!templine!
	set /a templine=!templine!+6
	"%ushs_base_path%tools\gnuwin32\bin\sed.exe" -n !templine!p "%ushs_base_path%templogs\cnmt_infos.txt" | "%ushs_base_path%tools\gnuwin32\bin\cut.exe" -d = -f 2 > "%ushs_base_path%templogs\tempvar.txt"
	set /p tempinfo=<"%ushs_base_path%templogs\tempvar.txt"
	set tempinfo=!tempinfo: =!
	IF "!tempinfo!"=="2" (
		set /a templine=!templine!-3
		"%ushs_base_path%tools\gnuwin32\bin\sed.exe" -n !templine!p "%ushs_base_path%templogs\cnmt_infos.txt" | "%ushs_base_path%tools\gnuwin32\bin\cut.exe" -d ' -f 2 > "%ushs_base_path%templogs\tempvar.txt"
		set /a nca_count=!nca_count!+1
		set /p nca!nca_count!=<"%ushs_base_path%templogs\tempvar.txt"
	)
)
IF %nca_count% EQU 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
call :get_nsp_source_file_name "%br%"
IF /i "%ushs_debug_mode%"=="on" (
	Tools\squirrel\bin\squirrel.exe -k "%keys_path:)=^)%" -o "%CD%\nsp" -nfx "%br%"
) else (
	Tools\squirrel\bin\squirrel.exe -k "%keys_path:)=^)%" -o "%CD%\nsp" -nfx "%br%" >nul 2>&1
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
"%windir%\System32\robocopy.exe" /move /e "%CD%\nsp\%nsp_source_file_name% " "%CD%\nsp" >nul
rem rmdir "%CD%\nsp\%nsp_source_file_name%"

:START_NCA
echo.
call "%associed_language_script%" "nca_step"
for /l %%i in (1,1,%nca_count%) do (
	for /D %%g in ("nsp\*") do (
		IF /i "%%g"=="nsp\!nca%%i!_nca" (
			for /D %%h in ("%%g\*") do (
				set tempvar=%%h
				IF /i "!tempvar:~-7!"=="[romfs]" (
					"%windir%\System32\robocopy.exe" /move /e "%%h " "nca\romfs" >nul
				) else IF /i "!tempvar:~-6!"=="[pfs0]" (
					"%windir%\System32\robocopy.exe" /move /e "%%h " "nca\exefs" >nul
				)
			)
		)
	)
)
move "%CD%\nca\romfs\control.nacp" "%CD%\nca\control" >nul
move "%CD%\nca\romfs\*.dat" "%CD%\nca\control" >nul
move "%CD%\nca\exefs\*.png" "%CD%\nca\logo" >nul
move "%CD%\nca\exefs\*.gif" "%CD%\nca\logo" >nul
rmdir /s /q "nsp"

:replace_game_files
set /a tempcount=0
for /l %%i in (0,1,2) do (
	IF EXIST "%CD:)=^)%\nca\romfs\!filename%%i!.bin" (
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
%windir%\System32\Robocopy.exe "%CD%\nca\ " "%ushs_base_path%Saturn_emu_inject_datas\games\%game_files%" /e /purge >nul

:decrypted_folder_work
rem rmdir /s /q "nca\romfs\Data" >nul 2>&1
rem rmdir /s /q "nca\romfs\important.htdocs" >nul 2>&1
rem rmdir /s /q "nca\romfs\ipnotices.htdocs" >nul 2>&1
rem rmdir /s /q "nca\romfs\support.htdocs" >nul 2>&1
rem del /q "nca\romfs\legalinfo.xml" >nul 2>&1
rem rmdir /s /q nca\romfs\Cheat_Switch
rem mkdir nca\romfs\Cheat_Switch

set /a templine=1
for /l %%i in (1,1,%count_saturn_game_files%) do (
	"%ushs_base_path%tools\gnuwin32\bin\sed.exe" -n !templine!p "%ushs_base_path%templogs\bin_list2.txt" > "%ushs_base_path%templogs\tempvar.txt"
	set /p tempinfo=<"%ushs_base_path%templogs\tempvar.txt"
	copy "!tempinfo!" "%CD%\nca\romfs">nul
	set /a templine=!templine!+1
)
set /a templine=1
for %%f in ("nca\romfs\*.bin") do (
	set tempvar=%%f
	"%ushs_base_path%tools\gnuwin32\bin\sed.exe" -n !templine!p "%ushs_base_path%templogs\bin_list.txt" > "%ushs_base_path%templogs\tempvar.txt"
	set /p tempinfo=<"%ushs_base_path%templogs\tempvar.txt"
	IF NOT "!tempvar!"=="nca\romfs\!tempinfo!" ren "!tempvar!" "!tempinfo!" >nul
	set /a templine=!templine!+1
)
copy "%saturn_game_source%" "%CD%\nca\romfs">nul
rename "%CD%\nca\romfs\*.cue" "%game_files%.cue"

:rewrite_ini_file
IF /i "%custom_ini_choice%"=="o" copy "%custom_ini_path%" "%CD%\nca\romfs\%game_files%_Switch.ini" >nul

:wallpaper_replace
IF /i NOT "%custom_wallpaper_choice%"=="o" goto:pass_wallpaper_replace
IF "%custom_wallpaper_folder_path%"=="" goto:pass_wallpaper_replace
set wallpaper_name_change=
IF "%game_files%"=="GuardianForce" set wallpaper_name_change=GF
IF "%game_files%"=="CottonBoomerang" set wallpaper_name_change=CB
IF "%game_files%"=="Cotton2" set wallpaper_name_change=C2
del /q "%CD%\nca\romfs\Wallpaper\*.*" >nul
copy "%custom_wallpaper_folder_path%\WP_001.tex" "%CD%\nca\romfs\Wallpaper\WP_%wallpaper_name_change%_001.tex" >nul 2>&1
copy "%custom_wallpaper_folder_path%\WP_002.tex" "%CD%\nca\romfs\Wallpaper\WP_%wallpaper_name_change%_002.tex" >nul 2>&1
copy "%custom_wallpaper_folder_path%\WP_003.tex" "%CD%\nca\romfs\Wallpaper\WP_%wallpaper_name_change%_003.tex" >nul 2>&1
copy "%custom_wallpaper_folder_path%\WP_004.tex" "%CD%\nca\romfs\Wallpaper\WP_%wallpaper_name_change%_004.tex" >nul 2>&1
:pass_wallpaper_replace

:credit_replace
IF /i NOT "%custom_credit_choice%"=="o" goto:pass_credit_replace
IF "%custom_credit_folder_path%"=="" goto:pass_credit_replace
set credit_name_change=
IF "%game_files%"=="GuardianForce" set credit_name_change=GF
IF "%game_files%"=="CottonBoomerang" set credit_name_change=CtnB
IF "%game_files%"=="Cotton2" set credit_name_change=Ctn2
del /q "%CD%\nca\romfs\Credit\*.*" >nul
copy "%custom_credit_folder_path%\00.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_00.tex" >nul 2>&1
copy "%custom_credit_folder_path%\01.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_01.tex" >nul 2>&1
copy "%custom_credit_folder_path%\02.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_02.tex" >nul 2>&1
copy "%custom_credit_folder_path%\03.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_03.tex" >nul 2>&1
copy "%custom_credit_folder_path%\04.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_04.tex" >nul 2>&1
copy "%custom_credit_folder_path%\05.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_05.tex" >nul 2>&1
copy "%custom_credit_folder_path%\06.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_06.tex" >nul 2>&1
copy "%custom_credit_folder_path%\07.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_07.tex" >nul 2>&1
copy "%custom_credit_folder_path%\08.tex" "%CD%\nca\romfs\Credit\%credit_name_change%_08.tex" >nul 2>&1
:pass_credit_replace

:playingguide_replace
IF /i NOT "%custom_playingguide_choice%"=="o" goto:pass_playingguide_replace
IF "%custom_playingguide_folder_path%"=="" goto:pass_playingguide_replace
set playingguide_name_change=
IF "%game_files%"=="GuardianForce" set playingguide_name_change=GF
IF "%game_files%"=="CottonBoomerang" set playingguide_name_change=CtnB
IF "%game_files%"=="Cotton2" set playingguide_name_change=Ctn2
del /q "%CD%\nca\romfs\PlayingGuide\English\*.*" >nul
del /q "%CD%\nca\romfs\PlayingGuide\Japanese\*.*" >nul
copy "%custom_playingguide_folder_path%\English\00.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_00.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\01.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_01.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\02.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_02.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\03.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_03.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\04.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_04.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\05.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_05.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\06.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_06.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\07.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_07.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\English\08.tex" "%CD%\nca\romfs\PlayingGuide\English\%playingguide_name_change%_08.tex" >nul 2>&1

copy "%custom_playingguide_folder_path%\Japanese\00.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_00.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\01.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_01.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\02.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_02.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\03.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_03.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\04.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_04.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\05.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_05.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\06.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_06.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\07.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_07.tex" >nul 2>&1
copy "%custom_playingguide_folder_path%\Japanese\08.tex" "%CD%\nca\romfs\PlayingGuide\Japanese\%playingguide_name_change%_08.tex" >nul 2>&1
:pass_playingguide_replace

:texture_replace
IF /i NOT "%custom_texture_choice%"=="o" goto:pass_texture_replace
IF "%custom_texture_path%"=="" goto:pass_texture_replace
copy "%custom_texture_path%" "%CD%\nca\romfs\Texture.tex" >nul
:pass_texture_replace

:nodata_replace
IF /i NOT "%custom_nodata_choice%"=="o" goto:pass_nodata_replace
IF "%custom_nodata_path%"=="" goto:pass_nodata_replace
copy "%custom_nodata_path%" "%CD%\nca\romfs\no_data.tex" >nul
:pass_nodata_replace

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
	copy /b "%bz:)=^)%" .\icon\icon.jpg >nul
) else IF /i "%bz:~-3,3%"=="png" (
	copy /b "%bz:)=^)%" .\icon\icon.png >nul
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
copy .\icon\icon.jpg .\nca\control\icon_AmericanEnglish.dat >nul
copy .\icon\icon.jpg .\nca\control\icon_Japanese.dat >nul
del /q .\icon\icon.jpg
GOTO Next

:Generic
copy .\Tools\control\icon_AmericanEnglish.dat .\nca\control\icon_AmericanEnglish.dat >nul
copy .\Tools\control\icon_AmericanEnglish.dat .\nca\control\icon_Japanese.dat >nul
:Next

echo.
call "%associed_language_script%" "create_game_step"
if exist .\nca\exefs\main.npdm (
	move .\nca\exefs\main.npdm .\ >nul
) else (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
if exist .\nca\control\control.nacp (
	move .\nca\control\control.nacp .\control.nacp >nul
) else (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)

IF /i "%ushs_debug_mode%"=="on" (
	"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t npdm -d %id% -i main.npdm
) else (
	"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t npdm -d %id% -i main.npdm >nul
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "conversion_error"
	pause
	call :del_temp_files
	goto:menu
)
IF /i "%ushs_debug_mode%"=="on" (
	"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t nacp -d %id% -n "%name%" -a "%author%" -v "%version%" -p 0 -s %save_size% -i control.nacp
) else (
	"%ushs_base_path%tools\python3_scripts\npdm_and_nacp_rewrite\npdm_and_nacp_rewrite.exe" -t nacp -d %id% -n "%name%" -a "%author%" -v "%version%" -p 0 -s %save_size% -i control.nacp >nul
)
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
IF /i "%ushs_debug_mode%"=="on" (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\program\ --type nca --ncatype program --titleid %td% --exefsdir .\nca\exefs\ --romfsdir .\nca\romfs\ --logodir .\nca\logo\
) else (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\program\ --type nca --ncatype program --titleid %td% --exefsdir .\nca\exefs\ --romfsdir .\nca\romfs\ --logodir .\nca\logo\ >nul 2>&1
)
IF /i "%ushs_debug_mode%"=="on" (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\control\ --type nca --ncatype control --titleid %td% --romfsdir .\nca\control\
) else (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\control\ --type nca --ncatype control --titleid %td% --romfsdir .\nca\control\ >nul 2>&1
)
if exist .\nca\out\program\*.nca (
	if exist .\nca\out\control\*.nca (
		IF /i "%ushs_debug_mode%"=="on" (
			.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\ --titletype application --type nca --ncatype meta --titleid %td% --programnca .\nca\out\program\*.nca --controlnca .\nca\out\control\*.nca
		) else (
			.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o .\nca\out\ --titletype application --type nca --ncatype meta --titleid %td% --programnca .\nca\out\program\*.nca --controlnca .\nca\out\control\*.nca >nul 2>&1
		)
	)
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

set temp_nsp_path=%nsp_path:\=\\%
IF /i "%ushs_debug_mode%"=="on" (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o "%temp_nsp_path:)=^)%" --type nsp --ncadir .\nca\out\ncas\ --titleid %td%
) else (
	.\Tools\hacpack.exe -k "%keys_path:)=^)%" -o "%temp_nsp_path:)=^)%" --type nsp --ncadir .\nca\out\ncas\ --titleid %td% >nul 2>&1
)
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

:get_nsp_source_file_name
set nsp_source_file_name=%~n1
exit /b

:get_saturn_game_source_folder
set saturn_game_source_folder=%~dp1
exit /b

:save_prod.keys_file
call "%associed_language_script%" "set_keys_path"
set /p temp_keys_file_path=<templogs\tempvar.txt
IF "%temp_keys_file_path%"=="" (
	exit /b
)
IF NOT EXIST "Saturn_emu_inject_datas\*.*" mkdir "Saturn_emu_inject_datas" >nul
copy "%temp_keys_file_path%" "Saturn_emu_inject_datas\prod.keys" >nul
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "keys_file_save_successful"
	pause
) else (
	call "%associed_language_script%" "keys_file_save_error"
	pause
)
exit /b

:convert_png_to_tex_folder
set png2tex_src_folder_path=
call "%associed_language_script%" "png2tex_src_folder_choice"
set /p png2tex_src_folder_path=<templogs\tempvar.txt
IF "%png2tex_src_folder_path%"=="" exit /b
set png2tex_dest_folder_path=
call "%associed_language_script%" "png2tex_dest_folder_choice"
set /p png2tex_dest_folder_path=<templogs\tempvar.txt
IF "%png2tex_dest_folder_path%"=="" exit /b
"tools\Saturn_emu_inject\Tools\png2tex\png2tex.exe" "%png2tex_src_folder_path%" "%png2tex_dest_folder_path%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "png2tex_conversion_error"
	pause
) else (
	call "%associed_language_script%" "png2tex_conversion_success"
	pause
)
exit /b

:generic_ini_select
set custom_ini_path=%ushs_base_path%tools\Saturn_emu_inject\Tools\config
set cartridge_4mb_ram_choice=
set widescreen_choice=
call "%associed_language_script%" "set_cartridge_4mb_ram_choice"
IF NOT "%cartridge_4mb_ram_choice%"=="" set cartridge_4mb_ram_choice=%cartridge_4mb_ram_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "cartridge_4mb_ram_choice" "o/n_choice"
call "%associed_language_script%" "set_widescreen_choice"
IF NOT "%widescreen_choice%"=="" set widescreen_choice=%widescreen_choice:~0,1%
call "%ushs_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "widescreen_choice" "o/n_choice"
IF /i "%cartridge_4mb_ram_choice%"=="o" set custom_ini_path=%custom_ini_path%_4mb
IF /i "%widescreen_choice%"=="o" set custom_ini_path=%custom_ini_path%_widescreen
set custom_ini_path=%custom_ini_path%.ini
exit /b

:manage_profiles
echo Function not usable for now
pause
exit /b

:create_profile

exit /b

modify_profile

exit /b

:delete_profile

goto:eof

:select_profile

goto:eof

:infos_profile

goto:eof

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