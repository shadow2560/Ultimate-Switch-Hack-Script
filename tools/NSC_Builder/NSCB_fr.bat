@ECHO OFF
chcp 65001 >nul
set "program_version=1.01"

:TOP_INIT
set "prog_dir=%~dp0"
set "bat_name=%~n0"
set "ofile_name=%bat_name%_options.cmd"
set "opt_interface=Interface_options.cmd"
set "opt_server=Server_options.cmd"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad
set "list_folder=%prog_dir%lists"
::-----------------------------------------------------
::EDIT THIS VARIABLE TO LINK OTHER OPTION FILE
::-----------------------------------------------------
set "op_file=%~dp0zconfig\%ofile_name%"
set "opt_interface=%~dp0zconfig\%opt_interface%"
set "opt_server=%~dp0zconfig\%opt_server%"
::-----------------------------------------------------
::COPY OPTIONS FROM OPTION FILE
::-----------------------------------------------------
setlocal
if exist "%op_file%" call "%op_file%"
endlocal & (
REM VARIABLES
set "safe_var=%safe_var%"
set "vrepack=%vrepack%"
set "vrename=%vrename%"
set "fi_rep=%fi_rep%"
set "zip_restore=%zip_restore%"
set "manual_intro=%manual_intro%"
set "va_exit=%va_exit%"
set "skipRSVprompt=%skipRSVprompt%"
set "oforg=%oforg%"
set "NSBMODE=%NSBMODE%"
set "romaji=%romaji%"
set "transnutdb=%transnutdb%"
set "workers=%workers%"
set "compression_lv=%compression_lv%"
set "compression_threads=%compression_threads%"
set "xci_export=%xci_export%"
set "MTP_verification=%MTP_verification%"
set "MTP_prioritize_NSZ=%MTP_prioritize_NSZ%"
set "MTP_exclude_xci_autinst=%MTP_exclude_xci_autinst%"
set "MTP_aut_ch_medium=%MTP_aut_ch_medium%"
set "MTP_chk_fw=%MTP_chk_fw%"
set "MTP_prepatch_kg=%MTP_prepatch_kg%"
set "MTP_prechk_Base=%MTP_prechk_Base%"
set "MTP_prechk_Upd=%MTP_prechk_Upd%"
set "MTP_saves_Inline=%MTP_saves_Inline%"
set "MTP_saves_AddTIDandVer=%MTP_saves_AddTIDandVer%"
set "MTP_pdrive_truecopy=%MTP_pdrive_truecopy%"
set "MTP_stc_installs=%MTP_stc_installs%"
set "MTP_ptch_inst_spec=%MTP_ptch_inst_spec%"

REM Copy function
set "pycommand=%pycommand%"
set "buffer=%buffer%"
set "nf_cleaner=%nf_cleaner%"
set "patchRSV=%patchRSV%"
set "vkey=%vkey%"
set "capRSV=%capRSV%"
set "fatype=%fatype%"
set "fexport=%fexport%"
set "skdelta=%skdelta%"
REM PROGRAMS
set "squirrel=%nut%"
set "squirrel_lb=%squirrel_lb%"
set "MTP=%MTP%"
set "xci_lib=%xci_lib%"
set "nsp_lib=%nsp_lib%"
set "zip=%zip%"
set "hacbuild=%hacbuild%"
set "listmanager=%listmanager%"
set "batconfig=%batconfig%"
set "batdepend=%batdepend%"
set "infobat=%infobat%"
REM FILES
set "uinput=%uinput%"
set "dec_keys=%dec_keys%"
REM FOLDERS
set "w_folder=%~dp0%w_folder%"
set "fold_output=%fold_output%"
set "zip_fold=%~dp0%zip_fold%"
)
::-----------------------------------------------------
::SET ABSOLUTE ROUTES
::-----------------------------------------------------
::Program full route
if exist "%~dp0%squirrel%" set "squirrel=%~dp0%squirrel%"
if exist "%~dp0%squirrel_lb%" set "squirrel_lb=%~dp0%squirrel_lb%"
if exist "%~dp0%xci_lib%"  set "xci_lib=%~dp0%xci_lib%"
if exist "%~dp0%nsp_lib%"  set "nsp_lib=%~dp0%nsp_lib%"
if exist "%~dp0%zip%"  set "zip=%~dp0%zip%"

if exist "%~dp0%hacbuild%"  set "hacbuild=%~dp0%hacbuild%"
if exist "%~dp0%listmanager%"  set "listmanager=%~dp0%listmanager%"
if exist "%~dp0%batconfig%"  set "batconfig=%~dp0%batconfig%"
if exist "%~dp0%batdepend%"  set "batdepend=%~dp0%batdepend%"
if exist "%~dp0%infobat%"  set "infobat=%~dp0%infobat%"
::Important files full route
if exist "%~dp0%uinput%"  set "uinput=%~dp0%uinput%"
if exist "%~dp0%dec_keys%"  set "dec_keys=%~dp0%dec_keys%"
::Folder output
CD /d "%~dp0"
if not exist "%fold_output%" MD "%fold_output%"
if not exist "%fold_output%" MD "%~dp0%fold_output%"
if exist "%~dp0%fold_output%"  set "fold_output=%~dp0%fold_output%"
::-----------------------------------------------------
::A LOT OF CHECKS
::-----------------------------------------------------
::Option file check
if not exist "%op_file%" ( goto missing_things )
::Program checks
if not exist "%squirrel%" ( goto missing_things )
if not exist "%xci_lib%" ( goto missing_things )
if not exist "%nsp_lib%" ( goto missing_things )
if not exist "%zip%" ( goto missing_things )

if not exist "%hacbuild%" ( goto missing_things )
if not exist "%listmanager%" ( goto missing_things )
if not exist "%batconfig%" ( goto missing_things )
if not exist "%infobat%" ( goto missing_things )
::Important files check
if not exist "%dec_keys%" ( goto missing_things )
::-----------------------------------------------------
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1

::Check if user is dragging a folder or a file
if "%~1"=="" goto manual
if "%vrepack%" EQU "nodelta" goto aut_rebuild_nodeltas
if "%vrepack%" EQU "rebuild" goto aut_rebuild_nsp
dir "%~1\" >nul 2>nul
if not errorlevel 1 goto folder
if exist "%~1\" goto folder
goto file

:folder
if "%fi_rep%" EQU "multi" goto folder_mult_mode
if "%fi_rep%" EQU "baseid" goto folder_packbyid
goto folder_ind_mode

::AUTO MODE. INDIVIDUAL REPACK PROCESSING OPTION.
:folder_ind_mode
rem if "%fatype%" EQU "-fat fat32" goto folder_ind_mode_fat32
call :program_logo
echo ---------------------------------------------------------
echo Mode automatique. Le ré-empaquetage individuel est défini
echo ---------------------------------------------------------
echo.
::****************
::pour fichier nsp
::****************
for /r "%~1" %%f in (*.nsp) do (
set "target=%%f"
if exist "%w_folder%" RD /s /q "%w_folder%" >NUL 2>&1

set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"

MD "%w_folder%"
REM echo %safe_var%>safe.txt
call :squirrell

if "%zip_restore%" EQU "true" ( set "ziptarget=%%f" )
if "%zip_restore%" EQU "true" ( call :makezip )
call :getname
REM setlocal enabledelayedexpansion
REM set vpack=!vrepack!
REM endlocal & ( set "vpack=!vrepack!" )

REM if "%trn_skip%" EQU "true" ( call :check_titlerights )
if "%vrename%" EQU "true" ( call :addtags_from_nsp )

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%%f" )
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%%f" )
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%%f" )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
)

::*************
::FOR NSZ FILES
::*************
for /r "%~1" %%f in (*.nsz) do (
set "target=%%f"
if exist "%w_folder%" RD /s /q "%w_folder%" >NUL 2>&1

set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"

MD "%w_folder%"
REM echo %safe_var%>safe.txt
call :squirrell

if "%zip_restore%" EQU "true" ( set "ziptarget=%%f" )
if "%zip_restore%" EQU "true" ( call :makezip )
call :getname
REM setlocal enabledelayedexpansion
REM set vpack=!vrepack!
REM endlocal & ( set "vpack=!vrepack!" )

REM if "%trn_skip%" EQU "true" ( call :check_titlerights )
if "%vrename%" EQU "true" ( call :addtags_from_nsp )

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%%f" )
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%%f" )
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%%f" )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
)

::FOR XCI FILES
for /r "%~1" %%f in (*.xci) do (
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"

MD "%w_folder%"
call :getname
if "%vrename%" EQU "true" ( call :addtags_from_xci )

if "%vrepack%" EQU "nsp" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%%f" )
if "%vrepack%" EQU "xci" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%%f" )
if "%vrepack%" EQU "both" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%%f" )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! ************* 
ECHO ------------------------------------------------------------
goto aut_exit_choice

::FOR XCZ FILES
for /r "%~1" %%f in (*.xcz) do (
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"

MD "%w_folder%"
call :getname
if "%vrename%" EQU "true" ( call :addtags_from_xci )

if "%vrepack%" EQU "nsp" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%%f" )
if "%vrepack%" EQU "xci" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%%f" )
if "%vrepack%" EQU "both" (  %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%%f" )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! ************* 
ECHO ------------------------------------------------------------
goto aut_exit_choice

:folder_ind_mode_fat32
CD /d "%prog_dir%"
call :program_logo
echo ---------------------------------------------------------
echo Mode automatique. Le ré-empaquetage individuel est défini
echo ---------------------------------------------------------
echo.
::*************
::FOR NSP FILES
::*************
for /r "%~1" %%f in (*.nsp) do (
set "target=%%f"
if exist "%w_folder%" RD /s /q "%w_folder%" >NUL 2>&1

MD "%w_folder%"
MD "%w_folder%\secure"

set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"
call :processing_message
REM echo %safe_var%>safe.txt
call :squirrell
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%%f"
if "%zip_restore%" EQU "true" ( set "ziptarget=%%f" )
if "%zip_restore%" EQU "true" ( call :makezip )
call :getname
REM setlocal enabledelayedexpansion
REM set vpack=!vrepack!
REM endlocal & ( set "vpack=!vrepack!" )

REM if "%trn_skip%" EQU "true" ( call :check_titlerights )
if "%vrename%" EQU "true" ( call :addtags_from_nsp )

if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%gefolder%\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
)

::FOR XCI FILES
for /r "%~1" %%f in (*.xci) do (
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
set "filename=%%~nf"
set "orinput=%%f"
set "showname=%orinput%"
call :processing_message
MD "%w_folder%"
MD "%w_folder%\secure"
call :getname
echo -------------------------------------
echo Extraction de la partition secure du xci...
echo -------------------------------------
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%%f"
echo Terminé.
if "%vrename%" EQU "true" ( call :addtags_from_xci )
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
MD "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.xci" "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.xc*"  "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%\!end_folder!" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\!end_folder!\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! ************* 
ECHO ------------------------------------------------------------
goto aut_exit_choice

::AUTO MODE. MULTIREPACK PROCESSING OPTION.
:folder_mult_mode
rem if "%fatype%" EQU "-fat fat32" goto folder_mult_mode_fat32
call :program_logo
echo -------------------------------------------
echo Auto-Mode. Le Multi-réempactage est activé.
echo -------------------------------------------
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
if exist "%prog_dir%mlist.txt" del "%prog_dir%mlist.txt" >NUL 2>&1

echo - Generating filelist
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%mlist.txt" -ff "%~1"
echo   Terminé.

if "%vrepack%" EQU "nsp" echo ........................................
if "%vrepack%" EQU "nsp" echo REPACKAGE DE CONTENU DE DOSSIERS SUR NSP
if "%vrepack%" EQU "nsp" echo ........................................
if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "nsp" echo.

if "%vrepack%" EQU "xci" echo ........................................
if "%vrepack%" EQU "xci" echo REPACKAGE DE CONTENU DE DOSSIERS SUR XCI
if "%vrepack%" EQU "xci" echo ........................................
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "xci" echo.

if "%vrepack%" EQU "both" echo ........................................
if "%vrepack%" EQU "both" echo REPACKAGE DE CONTENU DE DOSSIERS SUR NSP
if "%vrepack%" EQU "both" echo ........................................
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "both" echo.

if "%vrepack%" EQU "both" echo ........................................
if "%vrepack%" EQU "both" echo REPACKAGE DE CONTENU DE DOSSIERS SUR XCI
if "%vrepack%" EQU "both" echo ........................................
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "both" echo.

setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -tfile "%w_folder%\filename.txt" -ifo "%w_folder%\archfolder" -archive "%gefolder%" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! ************* 
ECHO ------------------------------------------------------------
call :thumbup
goto aut_exit_choice

:folder_mult_mode_fat32
CD /d "%prog_dir%"
call :program_logo
echo -------------------------------------------------------
echo Mode automatique. Le ré-empaquetage multiple est défini
echo -------------------------------------------------------
echo.
set "filename=%~n1"
set "orinput=%~f1"
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
MD "%w_folder%\secure"
set "end_folder=%filename%"
set "filename=%filename%[multi]"
::FOR NSP FILES
for /r "%~1" %%f in (*.nsp) do (
set "showname=%orinput%"
call :processing_message
::echo %safe_var%>safe.txt
call :squirrell
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%%f"
if "%zip_restore%" EQU "true" ( set "ziptarget=%%f" )
if "%zip_restore%" EQU "true" ( call :makezip )
)

::FOR XCI FILES
for /r "%~1" %%f in (*.xci) do (
echo -------------------------------------------
echo Extraction de la partition secure du xci...
echo -------------------------------------------
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%%f"
echo Terminé.
)
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%gefolder%\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! ************* 
ECHO ------------------------------------------------------------
goto aut_exit_choice

:folder_packbyid
rem if "%fatype%" EQU "-fat fat32" goto folder_mult_mode_fat32
call :program_logo
echo --------------------------------------------------------------
echo Mode automatique. le ré-empaquetage par identifiant est défini
echo --------------------------------------------------------------
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
if exist "%prog_dir%mlist.txt" del "%prog_dir%mlist.txt" >NUL 2>&1
set "mlistfol=%list_folder%\a_multi"
if not exist "%list_folder%" MD "%list_folder%" >NUL 2>&1
if not exist "%mlistfol%" MD "%mlistfol%" >NUL 2>&1

echo - Générer une liste de fichiers
%pycommand% "%squirrel%" -t nsp xci -tfile "%prog_dir%mlist.txt" -ff "%~1"
echo   Terminé.
echo - Fractionner la liste de fichiers
%pycommand% "%squirrel%" -splid "%mlistfol%" -tfile "%prog_dir%mlist.txt"
if "%vrepack%" EQU "nsp" set "vrepack=cnsp"
if "%vrepack%" EQU "both" set "vrepack=cboth"
goto m_process_jobs2

:aut_rebuild_nodeltas
call :program_logo
echo ------------------------------------------
echo Mode automatique. Reconstruire sans deltas
echo ------------------------------------------
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
if exist "%prog_dir%list.txt" del "%prog_dir%list.txt" >NUL 2>&1
%pycommand% "%squirrel%" -t nsp xci -tfile "%prog_dir%list.txt" -ff "%~1"
echo   Termminé
goto s_KeyChange_skip

:aut_rebuild_nsp
call :program_logo
echo ----------------------------------------------------
echo Mode automatique. Reconstruire nsp par ordre de cnmt
echo ----------------------------------------------------
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
if exist "%prog_dir%list.txt" del "%prog_dir%list.txt" >NUL 2>&1
%pycommand% "%squirrel%" -t nsp xci -tfile "%prog_dir%list.txt" -ff "%~1"
echo   Terminé
goto s_KeyChange_skip

:file
call :program_logo
if "%~x1"==".nsp" ( goto nsp )
if "%~x1"==".xci" ( goto xci )
if "%~x1"==".nsz" ( goto nsp )
if "%~x1"==".xcz" ( goto xci )
if "%~x1"==".*" ( goto other )
:other
echo Aucun fichier valide n'a été entré. Le programme accepte seulement les fichiers xci ou nsp.
echo Vous allez être redirigé vers le mode manuel.
pause
goto manual

:nsp
rem if "%fatype%" EQU "-fat fat32" goto file_nsp_fat32
set "orinput=%~f1"
set "filename=%~n1"
set "target=%~1"
set "showname=%orinput%"

if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
call :squirrell

if "%zip_restore%" EQU "true" ( set "ziptarget=%~1" )
if "%zip_restore%" EQU "true" ( call :makezip )
MD "%w_folder%"
call :getname
if "%vrename%" EQU "true" call :addtags_from_nsp

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%~1" )
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%~1" )
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%~1"  )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
goto aut_exit_choice

:file_nsp_fat32
CD /d "%prog_dir%"
set "orinput=%~f1"
set "filename=%~n1"
set "target=%~1"
set "showname=%orinput%"
call :processing_message
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
call :squirrell
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%~1"
if "%zip_restore%" EQU "true" ( set "ziptarget=%~1" )
if "%zip_restore%" EQU "true" ( call :makezip )
call :getname
if "%vrename%" EQU "true" call :addtags_from_nsp
::echo "%vrepack%"
::echo "%nsp_lib%"
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%gefolder%\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
goto aut_exit_choice

:xci
rem if "%fatype%" EQU "-fat fat32" goto file_xci_fat32
set "filename=%~n1"
set "orinput=%~f1"
set "showname=%orinput%"

if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
MD "%w_folder%\secure"
call :getname

if "%vrename%" EQU "true" call :addtags_from_xci

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%~1" )
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%~1" )
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%~1"  )

MD "%fold_output%\" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
goto aut_exit_choice

:file_xci_fat32
CD /d "%prog_dir%"
set "filename=%~n1"
set "orinput=%~f1"
set "showname=%orinput%"
call :processing_message
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
MD "%w_folder%\secure"
call :getname
echo -------------------------------------------
echo Extraction de la partition secure du xci...
echo -------------------------------------------
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%~1"
echo Terminé.
if "%vrename%" EQU "true" call :addtags_from_xci
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
if exist "%fold_output%\!end_folder!" RD /S /Q "%fold_output%\!end_folder!" >NUL 2>&1
MD "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.xci"  "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.xc*"  "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.nsp"  "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%\!end_folder!" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\!end_folder!\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
goto aut_exit_choice

:aut_exit_choice
if /i "%va_exit%"=="true" echo Le programme va fermé maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour quitter le script
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto aut_exit_choice
exit
:manual
endlocal
cls
call :program_logo
echo ********************************
echo Vous êtes entré en mode manuel.
echo ********************************
if "%manual_intro%" EQU "indiv" ( goto normalmode )
if "%manual_intro%" EQU "multi" ( goto multimode )
if "%manual_intro%" EQU "split" ( goto SPLMODE )
::if "%manual_intro%" EQU "update" ( goto UPDMODE )
goto manual_Reentry

:manual_Reentry
cls
if "%NSBMODE%" EQU "legacy" call "%prog_dir%ztools\LEGACY_fr.bat"
call :program_logo
ECHO .............................................................................................................
echo Tapez "1" pour traiter les fichiers individuellement (un fichier en entré donnera un fichier en sortie).
echo Tapez "2" pour entrer en mode multi-réempactage (plusieurs fichiers empactés dans un seul fichier en sortie).
echo Tapez "3" pour spliter le contenu d'un fichier aux multiples contenus.
echo Tapez "4" pour avoir des informations sur le fichier XCI ou NSP.
echo Tapez "5" pour entrer en mode de construction de base de donnée
echo Tapez "6" pour entrer en mode avancé.
echo Tapez "7" pour entrer en mode réunification

echo Tapez "8" pour entrer en mode Compression/Décompression
echo Tapez "9" pour entrer en mode restauration
REM echo Tapez "10" pour dans le gestionnaire de fichiers
echo Tapez "0" pour configurer le script.
echo.
echo Tapez "D" pour entrer dans le mode GOOGLE DRIVE 
echo Tapez "M" pour entrer dans le mode MTP 
echo Tapez "L" pour entrer dans l'ancien mode
echo Tapez "I" pour ouvrir l'INTERFACE
echo Tapez "S" pour ouvrir le serveur
echo .............................................................................................................
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="1" goto normalmode
if /i "%bs%"=="2" goto multimode
if /i "%bs%"=="3" goto SPLMODE
if /i "%bs%"=="4" goto INFMODE
if /i "%bs%"=="5" goto DBMODE
if /i "%bs%"=="6" goto ADVmode
if /i "%bs%"=="7" goto JOINmode
if /i "%bs%"=="8" goto ZSTDmode
if /i "%bs%"=="9" goto RSTmode
REM if /i "%bs%"=="10" goto MNGmode
if /i "%bs%"=="M" goto MTPMode
if /i "%bs%"=="D" goto DriveMode
if /i "%bs%"=="L" goto LegacyMode
if /i "%bs%"=="I" goto InterfaceTrigger
if /i "%bs%"=="S" goto ServerTrigger
if /i "%bs%"=="0" goto OPT_CONFIG
goto manual_Reentry

:ADVmode
call "%prog_dir%ztools\ADV_fr.bat"
goto manual_Reentry
:JOINmode
call "%prog_dir%ztools\JOINER_fr.bat"
goto manual_Reentry
:ZSTDmode
call "%prog_dir%ztools\ZSTD_fr.bat"
goto manual_Reentry
:RSTmode
call "%prog_dir%ztools\RST_fr.bat"
goto manual_Reentry
:MNGmode
call "%prog_dir%ztools\MNG_fr.bat"
goto manual_Reentry
:LegacyMode
call "%prog_dir%ztools\LEGACY_fr.bat"
goto manual_Reentry
:MTPMode
call "%prog_dir%ztools\MtpMode_fr.bat"
goto manual_Reentry
:DriveMode
call "%prog_dir%ztools\DriveMode_fr.bat"
goto manual_Reentry
:InterfaceTrigger
call Interface_fr.bat
goto manual_Reentry
:ServerTrigger
call Server_fr.bat
goto manual_Reentry
REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM START OF MANUAL MODE. INDIVIDUAL PROCESSING
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -----------------------------------------------
echo Traitement individuel activé.
echo -----------------------------------------------
if exist "list.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (list.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (list.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del list.txt )
endlocal
if not exist "list.txt" goto manual_INIT
ECHO .............................................................
ECHO Une précédente liste a été trouvée. Que souhaitez-vous faire?
:prevlist0
ECHO .............................................................
echo Tapez "1" pour lancer le traitement à partir de la liste.
echo Tapez "2" pour supprimer la liste et en faire une nouvelle.
echo Tapez "3" pour continuer à constuire la liste.
echo .............................................................
echo NOTE: En tapant 3 vous verrez la liste précédente que
echo       vous pourrez modifier avant de lancer son traitement.
echo.
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto showlist
if /i "%bs%"=="2" goto delist
if /i "%bs%"=="1" goto start_cleaning
if /i "%bs%"=="0" goto manual_Reentry
echo.
echo Choix inexistant.
goto prevlist0
:delist
del list.txt
cls
call :program_logo
echo -----------------------------------------------
echo Traitement individuel activé.
echo -----------------------------------------------
echo .................................................
echo Vous avez décidé de commencer une nouvelle liste.
echo .................................................
:manual_INIT
endlocal
ECHO ****************************************************************************
echo Tapez "1" pour ajouter un dossier à la liste.
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "4" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "0" pour revenir à la sélection du mode.
ECHO ****************************************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz nsx xcz -tfile "%prog_dir%list.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%list.txt" mode=folder ext="nsp xci nsz nsx xcz" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%list.txt" mode=file ext="nsp xci nsz nsx xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%list.txt" "extlist=nsp xci nsz nsx xcz" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%list.txt" "extlist=nsp xci nsz nsx xcz" )
goto checkagain
echo.
:checkagain
echo Que souhaitez-vous faire?
echo ...........................................................................
echo "Glissez un autre fichier et appuyer sur entrer pour l'ajouter à la liste."
echo.
echo Tapez "1" pour commencer le traitement.
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "4" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "5" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "e" pour quitter.
echo Tapez "i" pour voir la liste des fichiers à traiter.
echo Tapez "r" pour supprimer certains fichiers de la liste (en partant du bas).
echo Tapez "z" pour supprimer toute la liste.
echo .............................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz nsx xcz -tfile "%prog_dir%list.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" goto start_cleaning
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg  "%prog_dir%list.txt" mode=folder ext="nsp xci nsz nsx xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg  "%prog_dir%list.txt" mode=file ext="nsp xci nsz nsx xcz" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%list.txt" "extlist=nsp xci nsz nsx xcz" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%list.txt" "extlist=nsp xci nsz nsx xcz" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del list.txt

goto checkagain

:r_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (list.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:update_list1
if !pos1! GTR !pos2! ( goto :update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :update_list1
:update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<list.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>list.txt.new
endlocal
move /y "list.txt.new" "list.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo Traitement individuel activé.
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter:
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (list.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (list.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichiers à traiter.
echo .................................................
endlocal

goto checkagain

:s_cl_wrongchoice
echo Choix inexistant.
echo .................
:start_cleaning
echo *******************************************************
echo Choisir quoi faire après le traitement des fichiers:
echo *******************************************************
echo Tapez "1" pour réempacter les fichiers de la liste en nsp.
echo Tapez "2" pour réempacter les fichiers de la liste en xci.
echo Tapez "3" pour réempacter les fichiers de la liste dans les deux formats.
echo.
echo Options spéciales:
echo Tapez "4" pour éffacer les deltas des fichiers nsp
echo Tapez "5" pour renommer des fichiers xci ou nsp
echo Tapez "6" pour réduire le fichier XCI
echo Tapez "7" pour reconstruire le nsp par ordre de cnmt
echo Tapez "8" pour vérifier les fichiers
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" set "vrepack=nsp"
if /i "%bs%"=="2" set "vrepack=xci"
if /i "%bs%"=="3" set "vrepack=both"
if /i "%bs%"=="4" set "vrepack=nodelta"
if /i "%bs%"=="4" goto s_KeyChange_skip
if /i "%bs%"=="5" set "vrepack=renamef"
if /i "%bs%"=="5" goto rename
if /i "%bs%"=="6" goto s_trimmer_selection
if /i "%bs%"=="7" set "vrepack=rebuild"
if /i "%bs%"=="7" goto s_KeyChange_skip
if /i "%bs%"=="8" set "vrepack=verify"
if /i "%bs%"=="8" goto s_vertype
if %vrepack%=="none" goto s_cl_wrongchoice
:s_RSV_wrongchoice
if /i "%skipRSVprompt%"=="true" set "patchRSV=-pv false"
if /i "%skipRSVprompt%"=="true" goto s_KeyChange_skip
echo *******************************************************
echo Souhaitez-vous patcher la version requise du système?
echo *******************************************************
echo Si vous choisissez de la patcher la version nécessaire 
echo sera allignée sur la version de la cryptographie des NCA 
echo donc une demande de mise à jour ne sera effectué que si nécessaire.
echo.
echo Tapez "0" pour ne pas "patcher" la version requise du système.
echo Tapez "1" pour "patcher" la version requise du système.
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "patchRSV=none"
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="0" set "patchRSV=-pv false"
if /i "%bs%"=="1" set "patchRSV=-pv true"
if /i "%patchRSV%"=="none" echo Choix inexistant.
if /i "%patchRSV%"=="none" goto s_RSV_wrongchoice
if /i "%bs%"=="0" goto s_KeyChange_skip

:s_KeyChange_wrongchoice
echo *******************************************************
echo Régler la KEYGENERATION\RSV maximale autorisée.
echo *******************************************************
echo La keygeneration et le RSV seront utilisés selon ce paramètre 
echo de la keygeneration si la clé trouvé est supérieur à celle définie ici.
echo Cela ne fonctionne pas toujours sous les firmwares 
echo inférieurs que celui requis par le fichier.
echo.
echo Tapez "f" pour ne pas changer la keygeneration
echo Tapez "0" pour changer la keygeneration à 0 (FW 1.0)
echo Tapez "1" pour changer la keygeneration à 1 (FW 2.0-2.3)
echo Tapez "2" pour changer la keygeneration à 2 (FW 3.0)
echo Tapez "3" pour changer la keygeneration à 3 (FW 3.0.1-3.02)
echo Tapez "4" pour changer la keygeneration à 4 (FW 4.0.0-4.1.0)
echo Tapez "5" pour changer la keygeneration à 5 (FW 5.0.0-5.1.0)
echo Tapez "6" pour changer la keygeneration à 6 (FW 6.0.0-6.1.0)
echo Tapez "7" pour changer la keygeneration à 7 (FW 6.2.0)
echo Tapez "8" pour changer la keygeneration à 8 (FW 7.0.0-8.0.1)
echo Tapez "9" pour changer la keygeneration à 9 (FW 8.1.0)
echo Tapez "10" pour changer la keygeneration à 10 (FW 9.0.0-9.01)
echo Tapez "11" pour changer la keygeneration à 11 (FW 9.1.0-10.2.0)
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "vkey=none"
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="f" set "vkey=-kp false"
if /i "%bs%"=="0" set "vkey=-kp 0"
if /i "%bs%"=="0" set "capRSV=--RSVcap 0"
if /i "%bs%"=="1" set "vkey=-kp 1"
if /i "%bs%"=="1" set "capRSV=--RSVcap 65796"
if /i "%bs%"=="2" set "vkey=-kp 2"
if /i "%bs%"=="2" set "capRSV=--RSVcap 201327002"
if /i "%bs%"=="3" set "vkey=-kp 3"
if /i "%bs%"=="3" set "capRSV=--RSVcap 201392178"
if /i "%bs%"=="4" set "vkey=-kp 4"
if /i "%bs%"=="4" set "capRSV=--RSVcap 268435656"
if /i "%bs%"=="5" set "vkey=-kp 5"
if /i "%bs%"=="5" set "capRSV=--RSVcap 335544750"
if /i "%bs%"=="6" set "vkey=-kp 6"
if /i "%bs%"=="6" set "capRSV=--RSVcap 402653494"
if /i "%bs%"=="7" set "vkey=-kp 7"
if /i "%bs%"=="7" set "capRSV=--RSVcap 404750336"
if /i "%bs%"=="8" set "vkey=-kp 8"
if /i "%bs%"=="8" set "capRSV=--RSVcap 469762048"
if /i "%bs%"=="9" set "vkey=-kp 9"
if /i "%bs%"=="9" set "capRSV=--RSVcap 537919488"
if /i "%bs%"=="10" set "vkey=-kp 10"
if /i "%bs%"=="10" set "capRSV=--RSVcap 603979776"
if /i "%bs%"=="11" set "vkey=-kp 11"
if /i "%bs%"=="11" set "capRSV=--RSVcap 605028352"
if /i "%vkey%"=="none" echo Choix inexistant.
if /i "%vkey%"=="none" goto s_KeyChange_wrongchoice
goto s_KeyChange_skip

:s_trimmer_selection
echo *******************************************************
echo SUPERTRIMMING\TRIMMING\UNTRIMMING
echo *******************************************************
echo Description:
echo - Supertrimming
echo   Supprime la mise à jour du micrologiciel du système, vide la partition de mise à jour, 
echo   supprime le rembourrage final et moyen, supprime la partition du logo
echo   supprime la mise à jour du jeu, conserve le certificat de jeu s'il existe
echo   (Parfait pour l'installation avec tinfoil)
echo - Supertrimming et garder les mises à jour du jeu
echo   Comme auparavant, mais conserve les mises à jour du jeu.
echo - Trimming
echo   Supprime le remplissage final (données vides)
echo - UnTrimming
echo   Annule le Triming.
echo.
echo Tapez "1" pour utiliser Supertrimming
echo Tapez "2" pour utiliser Supertrimming et garder les mises à jour du jeu
echo Tapez "3" pour utiliser Trimmming
echo Tapez "4" pour utiliser UnTrimming
echo.
ECHO *************************************************
echo Ou tapez "b" pour revenir aux options de la liste
ECHO *************************************************
echo.
set /p bs="Entrez votre choix: "
set bs=%bs:"=%
set "vrepack=none"
if /i "%bs%"=="1" set "vrepack=xci_supertrimmer"
if /i "%bs%"=="2" set "vrepack=xci_supertrimmer_keep_upd"
if /i "%bs%"=="3" set "vrepack=xci_trimmer"
if /i "%bs%"=="4" set "vrepack=xci_untrimmer"
if /i "%vrepack%"=="none" echo MAUVAIS CHOIX
if /i "%vrepack%"=="none" goto s_trimmer_selection
goto s_KeyChange_skip

:s_vertype
echo *******************************************************
echo Type de vérification
echo *******************************************************
echo Ceci choisit le niveau de vérification.
echo DECRYPTION - Les fichiers sont lisibles, le ticket est correct
echo              Aucun fichier n'est manquant
echo SIGNATURE  - Vérifier l'en-tête contre Nintendo Sig1
echo              Calcule l'en-tête d'origine pour les modifications NSCB
echo HASH       - Vérifier le hachage actuel et original des fichiers et 
echo              les fait correspondre au nom du fichier
echo.
echo REMARQUE: Si vous lisez des fichiers sur un service distant via un flux
echo la méthode decryption ou signature sont les méthodes recommandées
echo.
echo Tapez "1" pour utiliser DECRYPTION verification (rapide)
echo Tapez "2" pour utiliser DECRYPTION + SIGNATURE verification (rapide)
echo Tapez "3" pour utiliser DECRYPTION + signature + HASH verification (lent)
echo.
ECHO *************************************************
echo Ou tapez "b" pour revenir aux options de la liste
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "verif=none"
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" set "verif=lv1"
if /i "%bs%"=="2" set "verif=lv2"
if /i "%bs%"=="3" set "verif=lv3"
if /i "%verif%"=="none" echo Choix inexistant
if /i "%verif%"=="none" echo.
if /i "%verif%"=="none" goto s_vertype

:s_KeyChange_skip
echo Filtering extensions from list according to options chosen
if "%vrepack%" EQU "xci_supertrimmer" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=xci","token=False",Print="False" )
if "%vrepack%" EQU "xci_supertrimmer_keep_upd" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=xci","token=False",Print="False" )
if "%vrepack%" EQU "xci_trimmer" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=xci","token=False",Print="False" )
if "%vrepack%" EQU "xci_untrimmer" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=xci","token=False",Print="False" )
if "%vrepack%" EQU "rebuild" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=nsp nsz","token=False",Print="False" )
if "%vrepack%" EQU "nodelta" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=nsp nsz","token=False",Print="False" )
if "%fatype%" EQU "-fat fat32" echo Fat32 selected, removing nsz and xcz from input list
if "%fatype%" EQU "-fat fat32" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%list.txt","ext=nsp nsx xci","token=False",Print="False" )
cls
call :program_logo

for /f "tokens=*" %%f in (list.txt) do (
set "name=%%~nf"
set "filename=%%~nxf"
set "orinput=%%f"
set "ziptarget=%%f"

if "%%~nxf"=="%%~nf.nsp" call :nsp_manual
if "%%~nxf"=="%%~nf.nsz" call :nsp_manual
if "%%~nxf"=="%%~nf.xci" call :xci_manual
if "%%~nxf"=="%%~nf.xcz" call :xci_manual
%pycommand% "%squirrel%" --strip_lines "%prog_dir%list.txt" "1" "true"
rem call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:rename
:s_rename_wrongchoice1
echo.
echo *******************************************************
echo Type de renommage
echo *******************************************************
echo Modes normaux:
echo Tapez "1" pour toujours renommer
echo Tapez "2" pour ne pas renommer si [TITLEID] est présent
echo Tapez "3" pour ne pas renommer si [TITLEID] est égal à celui calculé
echo Tapez "4" pour ajouter seulement ID
echo Tapez "5" pour conserver le nom d'origine et ajouter l'ID + le tags sélectionnés
echo.
echo Expurger:
echo Tapez "6" pour supprimer les mauvais caractères du nom de fichier
echo Tapez "7" pour convertir le japonais/chinois en ROMAJI
echo.
echo Étiquettes propres:
echo Tapez "8" pour supprimer des balises [] du nom de fichier
echo Tapez "9" pour supprimer des balises () du nom de fichier
echo Tapez "10" pour RETIRER les balises [] et () du nom du fichier
echo Tapez "11" pour supprimer le titre du premier [
echo Tapez "12" pour supprimer le titre du premier (
echo.
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="faites votre choix: "
set bs=%bs:"=%
set "renmode=none"
if /i "%bs%"=="0" goto checkagain
if /i "%bs%"=="1" set "renmode=force"
if /i "%bs%"=="1" set "oaid=false"
if /i "%bs%"=="2" set "renmode=skip_corr_tid"
if /i "%bs%"=="2" set "oaid=false"
if /i "%bs%"=="3" set "renmode=skip_if_tid"
if /i "%bs%"=="3" set "oaid=false"
if /i "%bs%"=="4" set "renmode=skip_corr_tid"
if /i "%bs%"=="4" set "oaid=true"
if /i "%bs%"=="5" set "renmode=force"
if /i "%bs%"=="5" set "oaid=idtag"
if /i "%bs%"=="6" goto sanitize
if /i "%bs%"=="7" goto romaji

if /i "%bs%"=="8" set "tagtype=[]"
if /i "%bs%"=="8" goto filecleantags
if /i "%bs%"=="9" set "tagtype=()"
if /i "%bs%"=="9" goto filecleantags
if /i "%bs%"=="10" set "tagtype=false"
if /i "%bs%"=="10" goto filecleantags
if /i "%bs%"=="11" set "tagtype=["
if /i "%bs%"=="11" goto filecleantags
if /i "%bs%"=="12" set "tagtype=("
if /i "%bs%"=="12" goto filecleantags

if /i "%renmode%"=="none" echo Choix inexistant.
if /i "%renmode%"=="none" goto s_rename_wrongchoice1
echo.
:s_rename_wrongchoice2
echo *******************************************************
echo Ajouter un numéro de version
echo *******************************************************
echo Ajouter le numéro de version du contenu au nom du fichier
echo.
echo Tapez "1" pour ajouter le numéro de version
echo Tapez "2" pour ne pas ajouter le numéro de version
echo Tapez "3" pour ne pas ajouter la version dans xci si VERSION=0
echo.
ECHO ************************************************
echo Ou tapez "b" pour revenir à TYPE DE RENOMMAGE
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "nover=none"
if /i "%bs%"=="0" goto checkagain
if /i "%bs%"=="b" goto s_rename_wrongchoice1
if /i "%bs%"=="1" set "nover=false"
if /i "%bs%"=="2" set "nover=true"
if /i "%bs%"=="3" set "nover=xci_no_v0"
if /i "%nover%"=="none" echo Choix inexistant.
if /i "%nover%"=="none" goto s_rename_wrongchoice2
echo.
:s_rename_wrongchoice3
echo *******************************************************
echo AJOUTER UNE LIGNE DE LANGUE
echo *******************************************************
echo Ajoute des balises de langue pour les jeux et les mises à jour
echo.
echo Tapez "1" pour ne pas ajouter la langue
echo Tapez "2" pour ajouter la langue
echo.
echo Remarque: la langue ne pouvant pas être lue à partir de dlcs, cette option
echo ne les affectera pas
echo.
ECHO *****************************************************
echo Ou tapez "b" pour revenir à ajouter numéro de version
echo Ou tapez "0" pour revenir à la liste des options
ECHO *****************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "addlangue=none"
if /i "%bs%"=="0" goto checkagain
if /i "%bs%"=="b" goto s_rename_wrongchoice2
if /i "%bs%"=="1" set "addlangue=false"
if /i "%bs%"=="2" set "addlangue=true"
if /i "%addlangue%"=="none" echo Choix inexistant.
if /i "%addlangue%"=="none" goto s_rename_wrongchoice3
echo.
:s_rename_wrongchoice4
echo *******************************************************
echo GARDER LES NOMS DE DLC
echo *******************************************************
echo Soit conserver le nom sans balises, soit utiliser un numéro de DLC comme nom
echo NOTE: Ceci est fait de cette façon puisque les noms de dlc ne peuvent pas être lus
echo à partir du fichier, seuls les numéros de DLC
echo.
echo Format de base normal [nom du contenu]
echo Option 3 format de base [contenu] [numéro de DLC]
echo.
echo Tapez "1" pour GARDER le nom de base
echo Tapez "2" pour RENOMMER comme numéro de DLC (1,2,3...)
echo Tapez "3" pour conserver le nom de base et AJOUTER un numéro de DLC comme étiquette
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir à GARDER LES NOMS DE DLC
echo Ou tapez "0" pour revenir à la liste des options
ECHO **************************************************
echo.
set /p bs="faites votre choix: "
set bs=%bs:"=%
set "dlcrname=none"
if /i "%bs%"=="0" goto checkagain
if /i "%bs%"=="b" goto s_rename_wrongchoice3
if /i "%bs%"=="1" set "dlcrname=false"
if /i "%bs%"=="2" set "dlcrname=true"
if /i "%bs%"=="3" set "dlcrname=tag"
if /i "%dlcrname%"=="none" echo Choix inexistant.
if /i "%dlcrname%"=="none" goto s_rename_wrongchoice4
echo.
cls
call :program_logo
set "workers=-threads 1"
for /f "tokens=*" %%f in (list.txt) do (
%pycommand% "%squirrel%" -renf "single" -tfile "%prog_dir%list.txt" -t nsp xci nsx nsz xcz -renm %renmode% -nover %nover% -oaid %oaid% -addl %addlangue% -roma %romaji% -dlcrn %dlcrname% %workers%
if "%workers%" EQU "-threads 1" ( %pycommand% "%squirrel%" --strip_lines "%prog_dir%list.txt" "1" "true" )
if "%workers%" NEQ "-threads 1" ( call :renamecheck )
rem call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:renamecheck
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (list.txt) do (
set /a conta=!conta! + 1
)
if !conta! LEQ 0 ( del list.txt )
endlocal
if not exist "list.txt" goto s_exit_choice
exit /B

:sanitize
cls
call :program_logo
for /f "tokens=*" %%f in (list.txt) do (
%pycommand% "%squirrel%" -snz "single" -tfile "%prog_dir%list.txt" -t nsp xci nsx nsz xcz
%pycommand% "%squirrel%" --strip_lines "%prog_dir%list.txt" "1" "true"
rem call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:romaji
cls
call :program_logo
for /f "tokens=*" %%f in (list.txt) do (
%pycommand% "%squirrel%" -roma "single" -tfile "%prog_dir%list.txt" -t nsp xci nsx nsz xcz
%pycommand% "%squirrel%" --strip_lines "%prog_dir%list.txt" "1" "true"
rem call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
goto s_exit_choice


:filecleantags
cls
call :program_logo
for /f "tokens=*" %%f in (list.txt) do (
%pycommand% "%squirrel%" -cltg "single" -tfile "%prog_dir%list.txt" -t nsp xci nsx nsz xcz -tgtype "%tagtype%"
%pycommand% "%squirrel%" --strip_lines "%prog_dir%list.txt" "1" "true"
rem call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:s_exit_choice
if exist list.txt del list.txt
if /i "%va_exit%"=="true" echo Le programme peu être fermé maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour quitter le script
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:nsp_manual
rem if "%fatype%" EQU "-fat fat32" goto nsp_manual_fat32
rem set "filename=%name%"
rem set "showname=%orinput%"
if "%zip_restore%" EQU "true" ( call :makezip )
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%" >NUL 2>&1
call :squirrell

if "%vrename%" EQU "true" call :addtags_from_nsp

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "nodelta" ( %pycommand% "%squirrel%" %buffer% --xml_gen "true" -o "%w_folder%" -tfile "%prog_dir%list.txt" --erase_deltas "")
if "%vrepack%" EQU "rebuild" ( %pycommand% "%squirrel%" %buffer% %skdelta% --xml_gen "true" -o "%w_folder%" -tfile "%prog_dir%list.txt" --rebuild_nsp "")
if "%vrepack%" EQU "verify" ( %pycommand% "%squirrel%" %buffer% -vt "%verif%" -tfile "%prog_dir%list.txt" -v "")
if "%vrepack%" EQU "verify" ( goto end_nsp_manual )

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
call :delay
goto end_nsp_manual

:nsp_manual_fat32
CD /d "%prog_dir%"
set "filename=%name%"
set "showname=%orinput%"
call :processing_message

if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
call :squirrell

if "%vrepack%" EQU "zip" ( goto nsp_just_zip )

%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%orinput%"

:nsp_just_zip
if "%zip_restore%" EQU "true" ( call :makezip )
call :getname
if "%vrename%" EQU "true" call :addtags_from_nsp
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "repack" "%w_folder%" "%%f")
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" "%%f")
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "repack" "%w_folder%" "%%f")
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" "%%f")
setlocal enabledelayedexpansion
if "%zip_restore%" EQU "true" ( goto :nsp_just_zip2 )
if exist "%fold_output%\!end_folder!" RD /S /Q "%fold_output%\!end_folder!" >NUL 2>&1
:nsp_just_zip2
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%gefolder%\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
call :delay
goto end_nsp_manual

:end_nsp_manual
exit /B

:xci_manual
rem if "%fatype%" EQU "-fat fat32" goto xci_manual_fat32
::FOR XCI FILES
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"

set "filename=%name%"
set "showname=%orinput%"

if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "nsp" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "xci" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -o "%w_folder%" -t "both" -dc "%orinput%" -tfile "%prog_dir%list.txt")
if "%vrepack%" EQU "xci_supertrimmer" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" -tfile "%prog_dir%list.txt" -xci_st "%orinput%")
if "%vrepack%" EQU "xci_supertrimmer_keep_upd" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" -t "xci" -dc "%orinput%" -tfile "%prog_dir%list.txt" )
if "%vrepack%" EQU "xci_trimmer" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" -tfile "%prog_dir%list.txt" -xci_tr "%orinput%")
if "%vrepack%" EQU "xci_untrimmer" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" -tfile "%prog_dir%list.txt" -xci_untr "%orinput%" )
if "%vrepack%" EQU "verify" ( %pycommand% "%squirrel%" %buffer% -vt "%verif%" -tfile "%prog_dir%list.txt" -v "")
if "%vrepack%" EQU "verify" ( goto end_xci_manual )

if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\%filename%.nsp" )

RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé
call :thumbup
call :delay
goto end_xci_manual

:xci_manual_fat32
CD /d "%prog_dir%"
::FOR XCI FILES
cls
if "%vrepack%" EQU "zip" ( goto end_xci_manual )
set "filename=%name%"
call :program_logo
set "showname=%orinput%"
call :processing_message
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
MD "%w_folder%\secure"
call :getname
echo -------------------------------------------
echo Extraction de la partition secure du xci...
echo -------------------------------------------
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%orinput%"
echo Terminé.
if "%vrename%" EQU "true" call :addtags_from_xci
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
setlocal enabledelayedexpansion
if exist "%fold_output%\!end_folder!" RD /S /Q "%fold_output%\!end_folder!" >NUL 2>&1
MD "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.xci"  "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.xc*"  "%fold_output%\!end_folder!" >NUL 2>&1
move  "%w_folder%\*.nsp"  "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%\!end_folder!" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\!end_folder!\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
echo Terminé.
call :thumbup
call :delay
goto end_xci_manual

:end_xci_manual
exit /B

:contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (list.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter.
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B

::///////////////////////////////////////////////////
::///////////////////////////////////////////////////
:: MULTI-MODE
::///////////////////////////////////////////////////
::///////////////////////////////////////////////////

:multimode
if exist %w_folder% RD /S /Q "%w_folder%" >NUL 2>&1
if exist "%list_folder%\a_multi" RD /S /Q "%list_folder%\a_multi" >NUL 2>&1
cls
call :program_logo
echo -----------------------------------------------
echo Mode MULTI-réempactage activé.
echo -----------------------------------------------
if exist "mlist.txt" del "mlist.txt"
:multi_manual_INIT
endlocal
set skip_list_split="false"
set "mlistfol=%list_folder%\m_multi"
echo Faites glisser des fichiers ou des dossiers pour créer une liste
echo Remarque: n'oubliez pas d'appuyer sur Entrée après chaque dossier déplacé
echo.
ECHO ***********************************************************
echo Tapez "1" pour traiter les tâches précédemment sauvegardées
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "4" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "5" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "0" pour revenir au MENU DE SELECTION
ECHO ***********************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%mlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" set skip_list_split="true"
if /i "%eval%"=="1" goto multi_start_cleaning
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlist.txt" mode=file ext="nsp xci nsz xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%mlist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mlist.txt" "extlist=nsp xci nsz xcz" )

goto multi_checkagain
echo.
:multi_checkagain
set "mlistfol=%list_folder%\a_multi"
echo QUE SOUHAITEZ-VOUS FAIRE?
echo ...............................................................................................
echo "Déposer un autre fichier ou dossier et appuyez sur ENTER pour ajouter des articles à la liste."
echo.
echo Tapez "1" pour lancer le traitement à partir de la liste.
echo Tapez "2" pour ajouter aux listes sauvegardées et les traiter
echo Tapez "3" pour enregistrer la liste pour plus tard
echo Tapez "4" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "5" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "6" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "7" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo.
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer des fichiers (en partant du bas)
echo Tapez "z" pour enlever toute la liste
echo ...............................................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%mlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" set "mlistfol=%list_folder%\a_multi"
if /i "%eval%"=="1" goto multi_start_cleaning
if /i "%eval%"=="2" set "mlistfol=%list_folder%\m_multi"
if /i "%eval%"=="2" goto multi_start_cleaning
if /i "%eval%"=="3" set "mlistfol=%list_folder%\m_multi"
if /i "%eval%"=="3" goto multi_saved_for_later
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlist.txt" mode=file ext="nsp xci nsz xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="6" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%mlist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="7" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mlist.txt" "extlist=nsp xci nsz xcz" )
REM if /i "%eval%"=="2" goto multi_set_clogo
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto multi_showlist
if /i "%eval%"=="r" goto multi_r_files
if /i "%eval%"=="z" del mlist.txt

goto multi_checkagain

:multi_saved_for_later
if not exist "%list_folder%" MD "%list_folder%" >NUL 2>&1
if not exist "%mlistfol%" MD "%mlistfol%" >NUL 2>&1
echo SAUVEGARDER LA LISTE DE TRAVAIL POUR PLUS TARD
echo ................................................................................................................
echo Tapez "1" pour SAUVEGARDER la liste en tant que tâche de travail en une seule fois (liste unique multi-fichiers)
echo Tapez "2" pour SAUVEGARDER la liste sous forme de plusieurs travaux en fonction de la base de fichiers.
echo.
ECHO **********************************************
echo Tapez "b" pour continuer à construire la liste
echo Tapez "0" pour revenir au menu de sélection
ECHO **********************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto multi_saved_for_later1
if /i "%bs%"=="2" ( %pycommand% "%squirrel%" -splid "%mlistfol%" -tfile "%prog_dir%mlist.txt" )
if /i "%bs%"=="2" del "%prog_dir%mlist.txt"
if /i "%bs%"=="2" goto multi_saved_for_later2
echo Choix inexistant!!
goto multi_saved_for_later
:multi_saved_for_later1
echo.
echo CHOISISSEZ LE NOM DU FICHIER DE TRAVAIL
echo ......................................................................
echo La liste sera sauvegardée sous le nom de votre choix.
echo (le chemin est "dossier du programme \ list \ m_multi")
echo.
set /p lname="Entrée le nom du fichier: "
set lname=%lname:"=%
move /y "%prog_dir%mlist.txt" "%mlistfol%\%lname%.txt" >nul
echo.
echo Sauvegardé!!!
:multi_saved_for_later2
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour créer un autre travail
echo Tapez "2" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" echo.
if /i "%bs%"=="1" echo CRÉER UN AUTRE TRAVAIL
if /i "%bs%"=="1" goto multi_manual_INIT
if /i "%bs%"=="1" goto salida
goto multi_saved_for_later2

:multi_r_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mlist.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:multi_update_list1
if !pos1! GTR !pos2! ( goto :multi_update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :multi_update_list1
:multi_update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<mlist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>mlist.txt.new
endlocal
move /y "mlist.txt.new" "mlist.txt" >nul
endlocal

:multi_showlist
cls
call :program_logo
echo -------------------------------------------------
echo Mode MULTI-réempactage activé.
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter:
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (mlist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mlist.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichiers à traiter.
echo .................................................
endlocal

goto multi_checkagain

:m_cl_wrongchoice
echo Choix inexistant.
echo .................
:multi_start_cleaning
echo *******************************************************
echo Choisir quoi faire après le traitement des fichiers:
echo *******************************************************
echo Option de cryptage standard:
echo Tapez "1" pour réempacter les fichiers de la liste en nsp
echo Tapez "2" pour réempacter les fichiers de la liste en xci.
echo Tapez "3" pour réempacter les fichiers de la liste dans les deux format T-NSP et XCI
echo.
echo Options spéciales:
echo Tapez "4" pour créer un  NSP avec uniquement des fichiers eshop nca non modifiés
echo Tapez "5" pour réempacter les fichiers de la liste dans les deux format T-NSP-U et XCI
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="1" set "vrepack=cnsp"
if /i "%bs%"=="2" set "vrepack=xci"
if /i "%bs%"=="3" set "vrepack=cboth"

if /i "%bs%"=="4" set "vrepack=nsp"
if /i "%bs%"=="4" set "skipRSVprompt=true"
if /i "%bs%"=="5" set "vrepack=both"

if %vrepack%=="none" goto m_cl_wrongchoice
:m_RSV_wrongchoice
if /i "%skipRSVprompt%"=="true" set "patchRSV=-pv false"
if /i "%skipRSVprompt%"=="true" set "vkey=-kp false"
if /i "%skipRSVprompt%"=="true" goto m_KeyChange_skip
echo *******************************************************
echo Souhaitez-vous patcher la version requise du système?
echo *******************************************************
echo Si vous choisissez de la patcher la version nécessaire sera allignée sur 
echo la version de la cryptographie des NCA donc une demande de mise 
echo à jour ne sera effectué que si nécessaire.
echo.
echo Tapez "0" pour ne pas "patcher" la version requise du système.
echo Tapez "1" pour "patcher" la version requise du système.
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set patchRSV=none
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="0" set "patchRSV=-pv false"
if /i "%bs%"=="0" set "vkey=-kp false"
if /i "%bs%"=="1" set "patchRSV=-pv true"
if /i "%patchRSV%"=="none" echo Choix inexistant.
if /i "%patchRSV%"=="none" goto m_RSV_wrongchoice
if /i "%bs%"=="0" goto m_KeyChange_skip

:m_KeyChange_wrongchoice
echo *******************************************************
echo Régler la KEYGENERATION\RSV maximale autorisée.
echo *******************************************************
echo La keygeneration et le RSV seront utilisés selon ce 
echo paramètre de la keygeneration si la clé trouvé est supérieur à celle définie ici.
echo Cela ne fonctionne pas toujours sous les firmwares inférieurs que celui requis par le fichier.
echo.
echo Tapez "f" pour ne pas changer la keygeneration
echo Tapez "0" pour changer la keygeneration à 0 (FW 1.0)
echo Tapez "1" pour changer la keygeneration à 1 (FW 2.0-2.3)
echo Tapez "2" pour changer la keygeneration à 2 (FW 3.0)
echo Tapez "3" pour changer la keygeneration à 3 (FW 3.0.1-3.02)
echo Tapez "4" pour changer la keygeneration à 4 (FW 4.0.0-4.1.0)
echo Tapez "5" pour changer la keygeneration à 5 (FW 5.0.0-5.1.0)
echo Tapez "6" pour changer la keygeneration à 6 (FW 6.0.0-6.1.0)
echo Tapez "7" pour changer la keygeneration à 7 (FW 6.2.0)
echo Tapez "8" pour changer la keygeneration à 8 (FW 7.0.0-8.0.1)
echo Tapez "9" pour changer la keygeneration à 9 (FW 8.1.0)
echo Tapez "10" pour changer la keygeneration à 10 (FW 9.0.0-9.01)
echo Tapez "11" pour changer la keygeneration à 11 (FW 9.1.0-10.2.0)
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set "vkey=none"
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="f" set "vkey=-kp false"
if /i "%bs%"=="0" set "vkey=-kp 0"
if /i "%bs%"=="0" set "capRSV=--RSVcap 0"
if /i "%bs%"=="1" set "vkey=-kp 1"
if /i "%bs%"=="1" set "capRSV=--RSVcap 65796"
if /i "%bs%"=="2" set "vkey=-kp 2"
if /i "%bs%"=="2" set "capRSV=--RSVcap 201327002"
if /i "%bs%"=="3" set "vkey=-kp 3"
if /i "%bs%"=="3" set "capRSV=--RSVcap 201392178"
if /i "%bs%"=="4" set "vkey=-kp 4"
if /i "%bs%"=="4" set "capRSV=--RSVcap 268435656"
if /i "%bs%"=="5" set "vkey=-kp 5"
if /i "%bs%"=="5" set "capRSV=--RSVcap 335544750"
if /i "%bs%"=="6" set "vkey=-kp 6"
if /i "%bs%"=="6" set "capRSV=--RSVcap 402653494"
if /i "%bs%"=="7" set "vkey=-kp 7"
if /i "%bs%"=="7" set "capRSV=--RSVcap 404750336"
if /i "%bs%"=="8" set "vkey=-kp 8"
if /i "%bs%"=="8" set "capRSV=--RSVcap 469762048"
if /i "%bs%"=="9" set "vkey=-kp 9"
if /i "%bs%"=="9" set "capRSV=--RSVcap 537919488"
if /i "%bs%"=="10" set "vkey=-kp 10"
if /i "%bs%"=="10" set "capRSV=--RSVcap 603979776"
if /i "%bs%"=="11" set "vkey=-kp 11"
if /i "%bs%"=="11" set "capRSV=--RSVcap 605028352"
if /i "%vkey%"=="none" echo Choix inexistant.
if /i "%vkey%"=="none" goto m_KeyChange_wrongchoice

:m_KeyChange_skip
if not exist "%list_folder%" MD "%list_folder%" >NUL 2>&1
if not exist "%mlistfol%" MD "%mlistfol%" >NUL 2>&1
if %skip_list_split% EQU "true" goto m_process_jobs
echo *******************************************************
echo Entrez le nom du fichier final qui sera créé.
echo *******************************************************
echo Le mode séparé par base id est capable d’identifier le
echo contenu qui correspond à chaque jeu et créer plusieurs
echo multi-xci ou multi-nsp 
echo.
echo Tapez "1" pour fusionner tous les fichiers en un seul fichier
echo Tapez "2" pour séparer en multifichiers par baseid
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="1" move /y "%prog_dir%mlist.txt" "%mlistfol%\mlist.txt" >nul
if /i "%bs%"=="1" goto m_process_jobs
if /i "%bs%"=="2" goto m_split_merge
goto m_KeyChange_skip

:m_split_merge
if "%fatype%" EQU "-fat fat32" echo Fat32 selected, removing nsz and xcz from input list
if "%fatype%" EQU "-fat fat32" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%mlist.txt","ext=nsp nsx xci","token=False",Print="False" )
cls
call :program_logo
%pycommand% "%squirrel%" -splid "%mlistfol%" -tfile "%prog_dir%mlist.txt"
goto m_process_jobs2
:m_process_jobs
if "%fatype%" EQU "-fat fat32" echo Fat32 selected, removing nsz and xcz from input list
if "%fatype%" EQU "-fat fat32" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%mlist.txt","ext=nsp nsx xci","token=False",Print="False" )
cls
:m_process_jobs2
dir "%mlistfol%\*.txt" /b  > "%prog_dir%mlist.txt"
rem if "%fatype%" EQU "-fat fat32" goto m_process_jobs_fat32
for /f "tokens=*" %%f in (mlist.txt) do (
set "listname=%%f"
if "%vrepack%" EQU "cnsp" call :program_logo
if "%vrepack%" EQU "cnsp" call :m_split_merge_list_name
if "%vrepack%" EQU "cnsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "xci" call :program_logo
if "%vrepack%" EQU "xci" call :m_split_merge_list_name
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "nsp" call :program_logo
if "%vrepack%" EQU "nsp" call :m_split_merge_list_name
if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t nsp -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "cboth" call :program_logo
if "%vrepack%" EQU "cboth" call :m_split_merge_list_name
if "%vrepack%" EQU "cboth" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "cboth" call :program_logo
if "%vrepack%" EQU "cboth" call :m_split_merge_list_name
if "%vrepack%" EQU "cboth" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "both" call :program_logo
if "%vrepack%" EQU "both" call :m_split_merge_list_name
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t nsp -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "both" call :program_logo
if "%vrepack%" EQU "both" call :m_split_merge_list_name
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%mlistfol%\%%f" -roma %romaji% -dmul "calculate" )
%pycommand% "%squirrel%" --strip_lines "%prog_dir%mlist.txt" "1" "true"
if exist "%mlistfol%\%%f" del "%mlistfol%\%%f"
rem call :multi_contador_NF
)

setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%"
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -tfile "%w_folder%\filename.txt" -ifo "%w_folder%\archfolder" -archive "%gefolder%" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
if exist "%mlistfol%" RD /S /Q "%mlistfol%" >NUL 2>&1
if exist mlist.txt del mlist.txt
goto m_exit_choice

:m_process_jobs_fat32
CD /d "%prog_dir%"
set "finalname=tempname"
cls
call :program_logo
for /f "tokens=*" %%f in (mlist.txt) do (
set "listname=%%f"
set "list=%mlistfol%\%%f"
call :m_split_merge_list_name
call :m_process_jobs_fat32_2
%pycommand% "%squirrel%" --strip_lines "%prog_dir%mlist.txt" "1" "true"
if exist "%mlistfol%\%%f" del "%mlistfol%\%%f"
rem call :multi_contador_NF
)
goto m_exit_choice
:m_process_jobs_fat32_2
if not exist "%w_folder%" MD "%w_folder%" >NUL 2>&1
copy "%list%" "%w_folder%\list.txt" >NUL 2>&1
for /f "usebackq tokens=*" %%f in ("%w_folder%\list.txt") do (
echo %%f
set "name=%%~nf"
set "filename=tempname"
set "orinput=%%f"
if "%%~nxf"=="%%~nf.nsp" call :multi_nsp_manual
if "%%~nxf"=="%%~nf.xci" call :multi_xci_manual
)
if exist "%w_folder%\list.txt" del "%w_folder%\list.txt"
if "%vrepack%" EQU "cnsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "cboth" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "cboth" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )
RD /S /Q "%w_folder%\secure" >NUL 2>&1
RD /S /Q "%w_folder%\normal" >NUL 2>&1
if exist "%w_folder%\archfolder" goto m_process_jobs_fat32_3
if exist "%w_folder%\*.xc*" goto m_process_jobs_fat32_4
if exist "%w_folder%\*.ns*" goto m_process_jobs_fat32_4
if exist "%w_folder%\tempname.*" goto m_process_jobs_fat32_4
:m_process_jobs_fat32_3
setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\tempname.nsp" )
endlocal
dir "%fold_output%\tempname.*" /b  > "%w_folder%\templist.txt"
for /f "usebackq tokens=*" %%f in ("%w_folder%\templist.txt") do (
%pycommand% "%squirrel%" -roma %romaji% --renameftxt "%fold_output%\%%f" -tfile "%list%"
if exist "%w_folder%\templist.txt" del "%w_folder%\templist.txt"
)

if exist "%w_folder%\*.xc*" goto m_process_jobs_fat32_4
if exist "%w_folder%\*.ns*" goto m_process_jobs_fat32_4
RD /S /Q "%w_folder%" >NUL 2>&1
exit /B

:m_process_jobs_fat32_4
dir "%w_folder%\tempname.*" /b  > "%w_folder%\templist.txt"
for /f "usebackq tokens=*" %%f in ("%w_folder%\templist.txt") do (
%pycommand% "%squirrel%" -roma %romaji% --renameftxt "%w_folder%\%%f" -tfile "%list%"
)
setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
exit /B

:m_split_merge_list_name
echo *******************************************************
echo Liste de traitement %listname%
echo *******************************************************
exit /B

:m_normal_merge
rem if "%fatype%" EQU "-fat fat32" goto m_KeyChange_skip_fat32
REM Pour la version bêta actuelle, les noms de fichiers sont calculés. Ce code reste commenté pour une réintégration future
rem echo ********************************************************
rem echo ENTRER LE NOM DU FICHIER FINAL POUR LE FICHIER DE SORTIE
rem echo ********************************************************
rem echo.
rem echo Ou Tapez "b" pour revenir à la liste des options
rem echo.
rem set /p bs="Veuillez taper le nom sans extension: "
rem set finalname=%bs:"=%
rem if /i "%finalname%"=="b" goto multi_checkagain

cls
if "%vrepack%" EQU "cnsp" call :program_logo
if "%vrepack%" EQU "cnsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "xci" call :program_logo
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "nsp" call :program_logo
if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t nsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "cboth" call :program_logo
if "%vrepack%" EQU "cboth" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "cboth" call :program_logo
if "%vrepack%" EQU "cboth" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t cnsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )

if "%vrepack%" EQU "both" call :program_logo
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t nsp -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )
if "%vrepack%" EQU "both" call :program_logo
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% %fatype% %fexport% %skdelta% -t xci -o "%w_folder%" -tfile "%prog_dir%mlist.txt" -roma %romaji% -dmul "calculate" )

setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -tfile "%w_folder%\filename.txt" -ifo "%w_folder%\archfolder" -archive "%gefolder%" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
goto m_exit_choice

:m_KeyChange_skip_fat32
CD /d "%prog_dir%"
echo ********************************************************
echo ENTRER LE NOM DU FICHIER FINAL POUR LE FICHIER DE SORTIE
echo ********************************************************
echo.
echo Ou Tapez "b" pour revenir à la liste des options
echo.
set /p bs="Tapez le nom du fichier sans l'extention ou choisissez une option: "
set finalname=%bs:"=%
if /i "%finalname%"=="b" goto multi_checkagain

cls
call :program_logo
for /f "tokens=*" %%f in (mlist.txt) do (
set "name=%%~nf"
set "filename=%%~nxf"
set "orinput=%%f"
if "%%~nxf"=="%%~nf.nsp" call :multi_nsp_manual
if "%%~nxf"=="%%~nf.xci" call :multi_xci_manual
%pycommand% "%squirrel%" --strip_lines "%prog_dir%mlist.txt" "1" "true"
rem call :multi_contador_NF
)
set "filename=%finalname%"
set "end_folder=%finalname%"
set "filename=%finalname%[multi]"
::pause
if "%vrepack%" EQU "nsp" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "xci" ( call "%xci_lib%" "repack" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%nsp_lib%" "convert" "%w_folder%" )
if "%vrepack%" EQU "both" ( call "%xci_lib%" "repack" "%w_folder%" )

setlocal enabledelayedexpansion
if not exist "%fold_output%" MD "%fold_output%" >NUL 2>&1
set "gefolder=%fold_output%\!end_folder!"
if "%oforg%" EQU "inline" ( set "gefolder=%fold_output%" )
MD "%gefolder%" >NUL 2>&1
move "%w_folder%\*.xci" "%gefolder%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.nsp" "%gefolder%" >NUL 2>&1
move "%w_folder%\*.ns*" "%gefolder%" >NUL 2>&1
if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%gefolder%\%filename%.nsp" )
endlocal
RD /S /Q "%w_folder%" >NUL 2>&1
goto m_exit_choice

:m_exit_choice
ECHO ------------------------------------------------------------
ECHO *********** Tout les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
if exist mlist.txt del mlist.txt
if /i "%va_exit%"=="true" echo PROGRAM WILL CLOSE NOW
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour quitter le script.
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto m_exit_choice


:multi_nsp_manual
set "showname=%orinput%"
call :processing_message
call :squirrell
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%orinput%"
echo Terminé.
call :thumbup
call :delay
exit /B

:multi_xci_manual
::FOR XCI FILES
set "showname=%orinput%"
call :processing_message
MD "%w_folder%" >NUL 2>&1
MD "%w_folder%\secure" >NUL 2>&1
MD "%w_folder%\normal" >NUL 2>&1
MD "%w_folder%\update" >NUL 2>&1
call :getname
echo -------------------------------------------
echo Extraction de la partition secure du xci...
echo -------------------------------------------
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\secure" %nf_cleaner% "%orinput%"
echo Terminé.
call :thumbup
call :delay
exit /B

:multi_contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (mlist.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter.
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B

REM the logo function has been disabled temporarly for the current beta, the code remains here
REM unaccessed for future modification and reintegration
:multi_set_clogo
cls
call :program_logo
echo ------------------------------------------------------
echo Définissez un logo personnalisé ou un jeu prédominant.
echo ------------------------------------------------------
echo Plus approprié pour les fichiers XCI. 
echo Actuellement, les logos personnalisé et les noms sont définis en glissant un nsp ou un control nca.
echo En faisant ainsi, le script va copier le control nca dans la partition Normal.
echo Si vous n'ajoutez pas un logo personnalisé, celui-ci sera ajouté via un des fichiers ajoutés pour le réempactage.
echo .....................................................
echo Tapez "b" pour revenir à la construction de la liste.
echo .....................................................
set /p bs="Ou glissez un fichier NSP ou NCA sur la fenêtre et appuyez sur entrer: "
set bs=%bs:"=%
if /i "%bs%"=="b" ( goto multi_checkagain )
if exist "%bs%" ( goto multi_checklogo )
goto multi_set_clogo

:multi_checklogo
if exist "%~dp0logo.txt" del "%~dp0logo.txt" >NUL 2>&1
echo %bs%>"%~dp0hlogo.txt"
FINDSTR /L ".nsp" "%~dp0hlogo.txt" >"%~dp0logo.txt"
FINDSTR /L ".nca" "%~dp0hlogo.txt" >>"%~dp0logo.txt"
set /p custlogo=<"%~dp0logo.txt"
del "%~dp0hlogo.txt"
::echo %custlogo%
for /f "usebackq tokens=*" %%f in ( "%~dp0logo.txt" ) do (
set "logoname=%%~nxf"
if "%%~nxf"=="%%~nf.nsp" goto ext_log
if "%%~nxf"=="%%~nf.nca" goto check_log
)

:ext_log
del "%~dp0logo.txt"
if not exist "%w_folder%" MD "%w_folder%" >NUL 2>&1
if exist "%w_folder%\normal" RD /S /Q "%w_folder%\normal" >NUL 2>&1

%pycommand% "%squirrel%" --nsptype "%custlogo%">"%w_folder%\nsptype.txt"
set /p nsptype=<"%w_folder%\nsptype.txt"
del "%w_folder%\nsptype.txt"
if "%nsptype%" EQU "DLC" echo.
if "%nsptype%" EQU "DLC" echo ---Le NSP n'a pas de CONTROL NCA---
if "%nsptype%" EQU "DLC" echo.
if "%nsptype%" EQU "DLC" ( goto multi_set_clogo )
MD "%w_folder%\normal" >NUL 2>&1
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\normal" --NSP_copy_nca_control "%custlogo%"
echo ................
echo "Logo extrait."
echo ................
echo.
goto multi_checkagain

:check_log
del "%~dp0logo.txt"
if not exist "%w_folder%" MD "%w_folder%" >NUL 2>&1
if exist "%w_folder%\normal" RD /S /Q "%w_folder%\normal" >NUL 2>&1
%pycommand% "%squirrel%" --ncatype "%custlogo%">"%w_folder%\ncatype.txt"
set /p ncatype=<"%w_folder%\ncatype.txt"
del "%w_folder%\ncatype.txt"
if "%ncatype%" NEQ "Content.CONTROL" echo.
if "%ncatype%" NEQ "Content.CONTROL" echo ---Le NCA n'est pas un type CONTROL ---
if "%ncatype%" NEQ "Content.CONTROL" echo.
if "%ncatype%" NEQ "Content.CONTROL" ( goto multi_set_clogo )
MD "%w_folder%\normal" >NUL 2>&1
copy "%custlogo%" "%w_folder%\normal\%logoname%"
echo.
goto multi_checkagain
exit


::///////////////////////////////////////////////////
::///////////////////////////////////////////////////
::SPLITTER MODE
::///////////////////////////////////////////////////
::///////////////////////////////////////////////////

:SPLMODE
cls
call :program_logo
if exist %w_folder% RD /S /Q "%w_folder%" >NUL 2>&1
echo -----------------------------------------------
echo Mode split activé.
echo -----------------------------------------------
if exist "splist.txt" goto sp_prevlist
goto sp_manual_INIT
:sp_prevlist
set conta=0
for /f "tokens=*" %%f in (splist.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (splist.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del splist.txt )
endlocal
if not exist "splist.txt" goto sp_manual_INIT
ECHO .............................................................
ECHO Une précédente liste a été trouvée. Que souhaitez-vous faire?
:sp_prevlist0
ECHO .............................................................
echo Tapez "1" pour lancer le traitement à partir de la liste.
echo Tapez "2" pour supprimer la liste et en faire une nouvelle.
echo Tapez "3" pour continuer à constuire la liste.
echo .............................................................
echo NOTE: En tapant 3 vous verrez la liste précédente que vous 
echo pourrez modifier avant de lancer son traitement.
echo.
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto sp_showlist
if /i "%bs%"=="2" goto sp_delist
if /i "%bs%"=="1" goto sp_start_cleaning
if /i "%bs%"=="0" goto manual_Reentry
echo.
echo Choix inexistant.
goto sp_prevlist0
:sp_delist
del splist.txt
cls
call :program_logo
echo -----------------------------------------------
echo Mode split activé.
echo -----------------------------------------------
echo .................................................
echo Vous avez décidé de commencer une nouvelle liste.
echo .................................................
:sp_manual_INIT
endlocal
ECHO ****************************************************************************
echo Tapez "1" pour ajouter un dossier à la liste via le sélecteur
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "4" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "0" pour revenir au menu de sélection 
ECHO ****************************************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%splist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%splist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%splist.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%splist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%splist.txt" "extlist=nsp xci nsz xcz" )

echo.
:sp_checkagain
echo Que souhaitez-vous faire?
echo ...........................................................................
echo "Glissez un autre fichier et appuyer sur entrer pour l'ajouter à la liste."
echo.
echo Tapez "1" pour commencer le traitement.
echo Tapez "2" pour ajouter un autre dossier à la liste
echo Tapez "3" pour ajouter un autre fichier à la liste
echo Tapez "4" pour ajouter des fichiers à la liste via les bibliothèques locales
echo Tapez "5" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "e" pour quitter.
echo Tapez "i" pour voir la liste des fichiers à traiter.
echo Tapez "r" pour supprimer certains fichiers de la liste (en partant du bas).
echo Tapez "z" pour supprimer toute la liste.
echo ...........................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%splist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto manual_Reentry
if /i "%eval%"=="1" goto sp_start_cleaning
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%splist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%splist.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%splist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%splist.txt" "extlist=nsp xci nsz xcz" )

if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto sp_showlist
if /i "%eval%"=="r" goto sp_r_files
if /i "%eval%"=="z" del splist.txt

goto sp_checkagain

:sp_r_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (splist.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:sp_update_list1
if !pos1! GTR !pos2! ( goto :sp_update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :sp_update_list1
:sp_update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<splist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>splist.txt.new
endlocal
move /y "splist.txt.new" "splist.txt" >nul
endlocal

:sp_showlist
cls
call :program_logo
echo -------------------------------------------------
echo Mode split activé.
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter:
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (splist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (splist.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichiers à traiter.
echo .................................................
endlocal

goto sp_checkagain

:sp_cl_wrongchoice
echo Choix inexistant.
echo .................
:sp_start_cleaning
echo *******************************************************
echo Choisir quoi faire après le traitement des fichiers:
echo *******************************************************
echo Tapez "1" pour réempacter les fichiers de la liste en nsp.
echo Tapez "2" pour réempacter les fichiers de la liste en xci.
echo Tapez "3" pour réempacter les fichiers de la liste dans les deux formats.
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto sp_checkagain
if /i "%bs%"=="1" set "vrepack=nsp"
if /i "%bs%"=="2" set "vrepack=xci"
if /i "%bs%"=="3" set "vrepack=both"
if %vrepack%=="none" goto sp_cl_wrongchoice
if "%fatype%" EQU "-fat fat32" echo Fat32 selected, removing nsz and xcz from input list
if "%fatype%" EQU "-fat fat32" ( %pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%splist.txt","ext=nsp nsx xci","token=False",Print="False" )
cls
call :program_logo
for /f "tokens=*" %%f in (splist.txt) do (
set "name=%%~nf"
set "filename=%%~nxf"
set "end_folder=%%~nf"
set "orinput=%%f"
if "%%~nxf"=="%%~nf.nsp" call :split_content
if "%%~nxf"=="%%~nf.NSP" call :split_content
if "%%~nxf"=="%%~nf.nsz" call :split_content
if "%%~nxf"=="%%~nf.NSZ" call :split_content
if "%%~nxf"=="%%~nf.xci" call :split_content
if "%%~nxf"=="%%~nf.XCI" call :split_content
if "%%~nxf"=="%%~nf.xcz" call :split_content
if "%%~nxf"=="%%~nf.XCZ" call :split_content
%pycommand% "%squirrel%" --strip_lines "%prog_dir%splist.txt" "1" "true"
setlocal enabledelayedexpansion
if exist "%fold_output%\!end_folder!" RD /S /Q "%fold_output%\!end_folder!" >NUL 2>&1
MD "%fold_output%\!end_folder!" >NUL 2>&1
move "%w_folder%\*.xci" "%fold_output%\!end_folder!\" >NUL 2>&1
move "%w_folder%\*.xc*" "%fold_output%\!end_folder!\" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%\!end_folder!\" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%\!end_folder!\" >NUL 2>&1
if exist "%w_folder%\archfolder" ( %pycommand% "%squirrel%" -ifo "%w_folder%\archfolder" -archive "%fold_output%\!end_folder!\%filename%.nsp" )
if exist "%w_folder%" RD /S /Q  "%w_folder%" >NUL 2>&1
endlocal
rem call :sp_contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tout les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
:SPLIT_exit_choice
if exist splist.txt del splist.txt
if /i "%va_exit%"=="true" echo PROGRAM WILL CLOSE NOW
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour quitter le script.
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto SPLIT_exit_choice

:split_content
rem if "%fatype%" EQU "-fat fat32" goto split_content_fat32
set "showname=%orinput%"
set "sp_repack=%vrepack%"
if exist "%w_folder%" RD /S /Q  "%w_folder%" >NUL 2>&1
MD "%w_folder%" >NUL 2>&1
call :processing_message
call :squirrell
if "%vrepack%" EQU "nsp" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" %fatype% %fexport% -t "nsp" -dspl "%orinput%" -tfile "%prog_dir%splist.txt")
if "%vrepack%" EQU "xci" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" %fatype% %fexport% -t "xci" -dspl "%orinput%" -tfile "%prog_dir%splist.txt")
if "%vrepack%" EQU "both" ( %pycommand% "%squirrel%" %buffer% -o "%w_folder%" %fatype% %fexport% -t "both" -dspl "%orinput%" -tfile "%prog_dir%splist.txt")

call :thumbup
call :delay
exit /B

:split_content_fat32
CD /d "%prog_dir%"
set "showname=%orinput%"
set "sp_repack=%vrepack%"
if exist "%w_folder%" RD /S /Q  "%w_folder%" >NUL 2>&1
MD "%w_folder%" >NUL 2>&1
call :processing_message
call :squirrell
%pycommand% "%squirrel%" %buffer% -o "%w_folder%" --splitter "%orinput%" -pe "secure"
for /f "usebackq tokens=*" %%f in ("%w_folder%\dirlist.txt") do (
setlocal enabledelayedexpansion
rem echo "!sp_repack!"
set "tfolder=%%f"
set "fname=%%~nf"
set "test=%%~nf"
set test=!test:[DLC]=!
rem echo !test!
rem echo "!test!"
rem echo "!fname!"
if "!test!" NEQ "!fname!" ( set "sp_repack=nsp" )
rem echo "!sp_repack!"
set "test=%%~nf"
set test=!test:[UPD]=!
rem echo !test!
rem echo "!test!"
rem echo "!fname!"
if "!test!" NEQ "!fname!" ( set "sp_repack=nsp" )
rem echo "!sp_repack!"
if "!sp_repack!" EQU "nsp" ( call "%nsp_lib%" "sp_convert" "%w_folder%" "!tfolder!" "!fname!" )
if "!sp_repack!" EQU "xci" ( call "%xci_lib%" "sp_repack" "%w_folder%" "!tfolder!" "!fname!" )
if "!sp_repack!" EQU "both" ( call "%nsp_lib%" "sp_convert" "%w_folder%" "!tfolder!" "!fname!" )
if "!sp_repack!" EQU "both" ( call "%xci_lib%" "sp_repack" "%w_folder%" "!tfolder!" "!fname!" )
endlocal
%pycommand% "%squirrel%" --strip_lines "%prog_dir%dirlist.txt" "1" "true"
)
del "%w_folder%\dirlist.txt" >NUL 2>&1

call :thumbup
call :delay
exit /B

:sp_contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (splist.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter.
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B

::///////////////////////////////////////////////////
::///////////////////////////////////////////////////
:: DB-MODE
::///////////////////////////////////////////////////
::///////////////////////////////////////////////////
:DBMODE
cls
call :program_logo
echo -----------------------------------------------
echo      Génération de base de données activé.
echo -----------------------------------------------
if exist "DBL.txt" goto DBprevlist
goto DBmanual_INIT
:DBprevlist
set conta=0
for /f "tokens=*" %%f in (DBL.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (DBL.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del DBL.txt )
endlocal
if not exist "DBL.txt" goto DBmanual_INIT
ECHO .........................................................................................
ECHO Une précédente liste de fichiers à mettre à jour a été trouvée. Que souhaitez-vous faire?
:DBprevlist0
ECHO ............................................................
echo Tapez "1" pour commencer à mettre à jour le contenu de base.
echo Tapez "2" pour supprimer la liste et en faire une nouvelle.
echo Tapez "3" pour continuer à constuire la liste.
echo ............................................................
echo NOTE: En appuyant sur 3 vous verrez la liste précédente que 
echo       vous pourrez modifier avant de lancer son traitement.
echo.
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto DBshowlist
if /i "%bs%"=="2" goto DBdelist
if /i "%bs%"=="1" goto DBstart_cleaning
if /i "%bs%"=="0" goto manual_Reentry
echo.
echo Choix inexistant.
goto DBprevlist0
:DBdelist
del DBL.txt
cls
call :program_logo
echo -----------------------------------------------
echo TRAITEMENT INDIVIDUEL ACTIVÉ
echo -----------------------------------------------
echo .................................................
echo Vous avez décidé de commencer une nouvelle liste.
echo .................................................
:DBmanual_INIT
endlocal
ECHO ***********************************************
echo Tapez "0" pour revenir au MENU de SELECTION
ECHO ***********************************************
echo.
set /p bs="Veuillez déposer UN FICHIER OU UN DOSSIER SUR LA FENETRE ET APPUYER SUR ENTREE: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
set "targt=%bs%"
dir "%bs%\" >nul 2>nul
if not errorlevel 1 goto DBcheckfolder
if exist "%bs%\" goto DBcheckfolder
goto DBcheckfile
:DBcheckfolder
%pycommand% "%squirrel%" -t nsp xci nsx nsz xcz -tfile "%prog_dir%DBL.txt" -ff "%targt%"
goto DBcheckagain
:DBcheckfile
%pycommand% "%squirrel%" -t nsp xci nsx nsz xcz -tfile "%prog_dir%DBL.txt" -ff "%targt%"
goto DBcheckagain
echo.
:DBcheckagain
echo QUE SOUHAITEZ-VOUS FAIRE?
echo ...........................................................................
echo "Glissez un autre fichier et appuyer sur entrer pour l'ajouter à la liste."
echo.
echo Tapez "1" pour commencer le traitement.
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer certains fichiers de la liste (en partant du bas).
echo Tapez "z" pour supprimer toute la liste.
echo ...........................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode.
ECHO *************************************************
echo.
set /p bs="Glissez un fichier ou choisissez une option: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto DBstart_cleaning
if /i "%bs%"=="e" goto DBsalida
if /i "%bs%"=="i" goto DBshowlist
if /i "%bs%"=="r" goto DBr_files
if /i "%bs%"=="z" del DBL.txt
set "targt=%bs%"
dir "%bs%\" >nul 2>nul
if not errorlevel 1 goto DBcheckfolder
if exist "%bs%\" goto DBcheckfolder
goto DBcheckfile
goto DBsalida

:DBr_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (DBL.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:DBupdate_list1
if !pos1! GTR !pos2! ( goto :DBupdate_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :DBupdate_list1
:DBupdate_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<DBL.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>DBL.txt.new
endlocal
move /y "DBL.txt.new" "DBL.txt" >nul
endlocal

:DBshowlist
cls
call :program_logo
echo -------------------------------------------------
echo TRAITEMENT INDIVIDUEL activé
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter:
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (DBL.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (DBL.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichiers à traiter.
echo .................................................
endlocal

goto DBcheckagain

:DBs_cl_wrongchoice
echo Choix inexistant.
echo .................
:DBstart_cleaning
echo ****************************************************************
echo CHOISIR QUOI FAIRE APRES LE TRAITEMENT DES FICHIERS SELECTIONNES
echo ****************************************************************
echo Tapez "1" pour générer la base de données NUTDB
echo Tapez "2" pour générer une base de données étendue
echo Tapez "3" pour générer une base de données sans clé (ÉTENDUE)
echo Tapez "4" pour générer une base de données simple
echo Tapez "5" pour générer les 4 bases de données ci-dessus
echo Tapez "Z" pour créer des fichiers ZIP
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="0" goto DBcheckagain
if /i "%bs%"=="Z" set "vrepack=zip"
if /i "%bs%"=="Z" goto DBs_start
if /i "%bs%"=="1" set "dbformat=nutdb"
if /i "%bs%"=="1" goto DBs_GENDB
if /i "%bs%"=="2" set "dbformat=extended"
if /i "%bs%"=="2" goto DBs_GENDB
if /i "%bs%"=="3" set "dbformat=keyless"
if /i "%bs%"=="3" goto DBs_GENDB
if /i "%bs%"=="4" set "dbformat=simple"
if /i "%bs%"=="4" goto DBs_GENDB
if /i "%bs%"=="5" set "dbformat=all"
if /i "%bs%"=="5" goto DBs_GENDB
if %vrepack%=="none" goto DBs_cl_wrongchoice

:DBs_start
cls
call :program_logo
for /f "tokens=*" %%f in (DBL.txt) do (
set "name=%%~nf"
set "filename=%%~nxf"
set "orinput=%%f"
set "ziptarget=%%f"
if "%vrepack%" EQU "zip" ( set "zip_restore=true" )
if "%%~nxf"=="%%~nf.nsp" call :DBnsp_manual
if "%%~nxf"=="%%~nf.nsx" call :DBnsp_manual
if "%%~nxf"=="%%~nf.nsz" call :DBnsp_manual
if "%%~nxf"=="%%~nf.NSP" call :DBnsp_manual
if "%%~nxf"=="%%~nf.NSX" call :DBnsp_manual
if "%%~nxf"=="%%~nf.NSZ" call :DBnsp_manual
if "%%~nxf"=="%%~nf.xci" call :DBnsp_manual
if "%%~nxf"=="%%~nf.XCI" call :DBnsp_manual
if "%%~nxf"=="%%~nf.xcz" call :DBnsp_manual
if "%%~nxf"=="%%~nf.XCZ" call :DBnsp_manual
%pycommand% "%squirrel%" --strip_lines "%prog_dir%DBL.txt" "1" "true"
rem call :DBcontador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** Tout les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
:DBs_exit_choice
if exist DBL.txt del DBL.txt
if /i "%va_exit%"=="true" echo LE PROGRAMME SE FERME MAINTENANT
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode.
echo Tapez "1" pour quitter le script.
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:DBnsp_manual
set "filename=%name%"
set "showname=%orinput%"
if exist "%w_folder%" rmdir /s /q "%w_folder%" >NUL 2>&1
MD "%w_folder%"
call :squirrell

if "%vrepack%" EQU "zip" ( goto nsp_just_zip )

:DBnsp_just_zip
if "%zip_restore%" EQU "true" ( call :makezip )
rem call :getname
if "%vrename%" EQU "true" call :addtags_from_nsp
if "%zip_restore%" EQU "true" ( goto :nsp_just_zip2 )

:DBnsp_just_zip2

if exist "%w_folder%\*.zip" ( MD "%zip_fold%" ) >NUL 2>&1
move "%w_folder%\*.zip" "%zip_fold%" >NUL 2>&1
RD /S /Q "%w_folder%" >NUL 2>&1

echo Terminé
call :thumbup
call :delay

:DBend_nsp_manual
exit /B

:DBs_GENDB
set "db_file=%prog_dir%INFO\%dbformat%_DB.txt"
set "dbdir=%prog_dir%INFO\"
if exist "%dbdir%temp" ( RD /S /Q "%dbdir%temp" ) >NUL 2>&1
rem echo %dbdir%temp

for /f "tokens=*" %%f in (DBL.txt) do (
set "orinput=%%f"
if exist "%dbdir%temp" ( RD /S /Q "%dbdir%temp" ) >NUL 2>&1
call :DBGeneration
if "%workers%" EQU "-threads 1" ( %pycommand% "%squirrel%" --strip_lines "%prog_dir%DBL.txt" "1" "true")
if "%workers%" NEQ "-threads 1" ( call :DBcheck )
rem if "%workers%" NEQ "-threads 1" ( call :DBcontador_NF )
)
:DBs_fin
ECHO ------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ------------------------------------------------------------
if exist "%dbdir%temp" ( RD /S /Q "%dbdir%temp" ) >NUL 2>&1
goto DBs_exit_choice

:DBGeneration
if not exist "%dbdir%" MD "%dbdir%">NUL 2>&1
%pycommand% "%squirrel%" --dbformat "%dbformat%" -dbfile "%db_file%" -tfile "%prog_dir%DBL.txt" -nscdb "%orinput%" %workers%
exit /B

:DBcheck
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (DBL.txt) do (
set /a conta=!conta! + 1
)
if !conta! LEQ 0 ( del DBL.txt )
endlocal
if not exist "DBL.txt" goto DBs_fin
exit /B

:DBcontador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (DBL.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter.
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B


::///////////////////////////////////////////////////
::NSCB FILE INFO MODE
::///////////////////////////////////////////////////
:INFMODE
call "%infobat%" "%prog_dir%"
cls
goto TOP_INIT

::///////////////////////////////////////////////////
::NSCB_options.cmd configuration script
::///////////////////////////////////////////////////
:OPT_CONFIG
call "%batconfig%" "%op_file%" "%listmanager%" "%batdepend%"
cls
goto TOP_INIT


::///////////////////////////////////////////////////
::SUBROUTINES
::///////////////////////////////////////////////////

:squirrell
echo                    ,;:;;,
echo                   ;;;;;
echo           .=',    ;:;;:,
echo          /_', "=. ';:;:;
echo          @=:__,  \,;:;:'
echo            _(\.=  ;:;;'
echo           `"_(  _/="`
echo            `"'
exit /B

:program_logo

ECHO                                        __          _ __    __
ECHO                  ____  _____ ____     / /_  __  __(_) /___/ /__  _____
ECHO                 / __ \/ ___/ ___/    / __ \/ / / / / / __  / _ \/ ___/
ECHO                / / / (__  ) /__     / /_/ / /_/ / / / /_/ /  __/ /
ECHO               /_/ /_/____/\___/____/_.___/\__,_/_/_/\__,_/\___/_/
ECHO                              /_____/
ECHO -------------------------------------------------------------------------------------
ECHO                         NINTENDO SWITCH CLEANER AND BUILDER
ECHO                      (THE XCI MULTI CONTENT BUILDER AND MORE)
ECHO -------------------------------------------------------------------------------------
ECHO =============================     BY JULESONTHEROAD     =============================
ECHO -------------------------------------------------------------------------------------
ECHO "                                POWERED BY SQUIRREL                                "
ECHO "                    BASED IN THE WORK OF BLAWAR AND LUCA FRAGA                     "
ECHO                                   VERSION %program_version% (NEW)
ECHO -------------------------------------------------------------------------------------                   
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Blawar's github:  https://github.com/blawar
ECHO Luca Fraga's github: https://github.com/LucaFraga
ECHO -------------------------------------------------------------------------------------
exit /B

:delay
PING -n 2 127.0.0.1 >NUL 2>&1
exit /B

:thumbup
echo.
echo    /@
echo    \ \
echo  ___\ \
echo (__O)  \
echo (____@) \
echo (____@)  \
echo (__o)_    \
echo       \    \
echo.
echo Amusez-vous bien.
exit /B

:getname

if not exist %w_folder% MD %w_folder% >NUL 2>&1

set filename=%filename:[nap]=%
set filename=%filename:[xc]=%
set filename=%filename:[nc]=%
set filename=%filename:[rr]=%
set filename=%filename:[xcib]=%
set filename=%filename:[nxt]=%
set filename=%filename:[Trimmed]=%
echo %filename% >"%w_folder%\fname.txt"

::deletebrackets
for /f "usebackq tokens=1* delims=[" %%a in ("%w_folder%\fname.txt") do (
    set end_folder=%%a)
echo %end_folder%>"%w_folder%\fname.txt"
::deleteparenthesis
for /f "usebackq tokens=1* delims=(" %%a in ("%w_folder%\fname.txt") do (
    set end_folder=%%a)
echo %end_folder%>"%w_folder%\fname.txt"
::I also wanted to remove_(
set end_folder=%end_folder:_= %
set end_folder=%end_folder:~0,-1%
del "%w_folder%\fname.txt" >NUL 2>&1
if "%vrename%" EQU "true" ( set "filename=%end_folder%" )
exit /B

:makezip
echo.
echo Création d'un fichier  zip pour %ziptarget%...
echo.
%pycommand% "%squirrel%" %buffer% %patchRSV% %vkey% %capRSV% -o "%w_folder%\zip" --zip_combo "%ziptarget%"
%pycommand% "%squirrel%" -o "%w_folder%\zip" --NSP_c_KeyBlock "%ziptarget%"
%pycommand% "%squirrel%" --nsptitleid "%ziptarget%" >"%w_folder%\nsptitleid.txt"
if exist "%w_folder%\secure\*.dat" ( move "%w_folder%\secure\*.dat" "%w_folder%\zip" ) >NUL 2>&1

set /p titleid=<"%w_folder%\nsptitleid.txt"
del "%w_folder%\nsptitleid.txt" >NUL 2>&1
%pycommand% "%squirrel%" --nsptype "%ziptarget%" >"%w_folder%\nsptype.txt"
set /p type=<"%w_folder%\nsptype.txt"
del "%w_folder%\nsptype.txt" >NUL 2>&1
%pycommand% "%squirrel%" --ReadversionID "%ziptarget%">"%w_folder%\nspversion.txt"
set /p verID=<"%w_folder%\nspversion.txt"
set "verID=V%verID%"
del "%w_folder%\nspversion.txt" >NUL 2>&1
if "%type%" EQU "BASE" ( set "ctag=" )
if "%type%" EQU "UPDATE" ( set ctag=[UPD] )
if "%type%" EQU "DLC" ( set ctag=[DLC] )
%pycommand% "%squirrel%" -i "%ziptarget%">"%w_folder%\zip\fileinfo[%titleid%][%verID%]%ctag%.txt"
%pycommand% "%squirrel%" --filelist "%ziptarget%">"%w_folder%\zip\ORIGINAL_filelist[%titleid%][%verID%]%ctag%.txt"
"%zip%" -ifo "%w_folder%\zip" -zippy "%w_folder%\%titleid%[%verID%]%ctag%.zip"
RD /S /Q "%w_folder%\zip" >NUL 2>&1
exit /B

:processing_message
echo Traitement de  %showname%...
echo.
exit /B

:check_titlerights
%pycommand% "%squirrel%" --nsp_htrights "%target%">"%w_folder%\trights.txt"
set /p trights=<"%w_folder%\trights.txt"
del "%w_folder%\trights.txt" >NUL 2>&1
if "%trights%" EQU "TRUE" ( goto ct_true )
if "%vrepack%" EQU "nsp" ( set "vpack=none" )
if "%vrepack%" EQU "both" ( set "vpack=xci" )
:ct_true
exit /B


:addtags_from_nsp
%pycommand% "%squirrel%" --nsptitleid "%orinput%" >"%w_folder%\nsptitleid.txt"
set /p titleid=<"%w_folder%\nsptitleid.txt"
del "%w_folder%\nsptitleid.txt" >NUL 2>&1
%pycommand% "%squirrel%" --nsptype "%orinput%" >"%w_folder%\nsptype.txt"
set /p type=<"%w_folder%\nsptype.txt"
del "%w_folder%\nsptype.txt" >NUL 2>&1
if "%type%" EQU "BASE" ( set filename=%filename%[%titleid%][v0] )
if "%type%" EQU "UPDATE" ( set filename=%filename%[%titleid%][UPD] )
if "%type%" EQU "DLC" ( set filename=%filename%[%titleid%][DLC] )

exit /B
:addtags_from_xci
dir "%w_folder%\secure\*.cnmt.nca" /b  >"%w_folder%\ncameta.txt"
set /p ncameta=<"%w_folder%\ncameta.txt"
del "%w_folder%\ncameta.txt" >NUL 2>&1
set "ncameta=%w_folder%\secure\%ncameta%"
%pycommand% "%squirrel%" --ncatitleid "%ncameta%" >"%w_folder%\ncaid.txt"
set /p titleid=<"%w_folder%\ncaid.txt"
del "%w_folder%\ncaid.txt"
echo [%titleid%]>"%w_folder%\titleid.txt"

FINDSTR /L 000] "%w_folder%\titleid.txt">"%w_folder%\isbase.txt"
set /p c_base=<"%w_folder%\isbase.txt"
del "%w_folder%\isbase.txt"
FINDSTR /L 800] "%w_folder%\titleid.txt">"%w_folder%\isupdate.txt"
set /p c_update=<"%w_folder%\isupdate.txt"
del "%w_folder%\isupdate.txt"

set ttag=[DLC]

if [%titleid%] EQU %c_base% set ttag=[v0]
if [%titleid%] EQU %c_update% set ttag=[UPD]

set filename=%filename%[%titleid%][%ttag%]
del "%w_folder%\titleid.txt"
exit /B

:missing_things
call :program_logo
echo ....................................
echo Il manque les choses suivantes:
echo ....................................
echo.
if not exist "%op_file%" echo - Le fichier de configuration n'est pas correctement défini ou est manquant.
if not exist "%squirrel%" echo - "squirrel.py" n'est pas correctement défini ou est manquant.
if not exist "%xci_lib%" echo - "XCI.bat" n'est pas correctement défini ou est manquant.
if not exist "%nsp_lib%" echo - "NSP.bat" n'est pas correctement défini ou est manquant.
if not exist "%zip%" echo - "7za.exe" n'est pas correctement défini ou est manquant.
if not exist "%hacbuild%" echo - "hacbuild.exe" n'est pas correctement défini ou est manquant.
if not exist "%listmanager%" echo - "listmanager.exe" n'est pas correctement défini ou est manquant.
if not exist "%batconfig%" echo - "NSCB_config.bat" n'est pas correctement défini ou est manquant.
if not exist "%infobat%" echo - "info.bat" n'est pas correctement défini ou est manquant.
::File full route
if not exist "%dec_keys%" echo - "keys.txt" n'est pas correctement défini ou est manquant.
echo.
pause
echo Le script va s'arrêter.
PING -n 2 127.0.0.1 >NUL 2>&1
goto salida
:salida
::pause
exit
