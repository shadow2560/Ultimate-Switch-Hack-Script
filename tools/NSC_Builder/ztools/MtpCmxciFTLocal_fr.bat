@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"
set "bat_name=%~n0"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad

::///////////////////////////////////////////////////
::///////////////////////////////////////////////////
:: MTP MULTI-MODE
::///////////////////////////////////////////////////
::///////////////////////////////////////////////////

:multimode
if exist %w_folder% RD /S /Q "%w_folder%" >NUL 2>&1
if exist "%list_folder%\a_multi" RD /S /Q "%list_folder%\a_multi" >NUL 2>&1
cls
call :program_logo
echo -----------------------------------------------
echo CRÉER MULTI-XCI ET TRANSFÉRER PAR MTP
echo -----------------------------------------------
if exist "mlistMTP.txt" del "mlistMTP.txt"
:multi_manual_INIT
endlocal
set skip_list_split="false"
set "mlistfol=%list_folder%\m_multiMTP"
echo Faites glisser des fichiers ou des dossiers pour créer une liste
echo Note: N'oubliez pas d'appuyer sur Entrée après avoir fait glisser chaque fichier \ dossier
echo.
ECHO ****************************************************************************
echo Tapez "1" pour traiter les fichiers précédemment enregistrés
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "4" pour sélectionner des fichiers dans les bibliothèques locales
echo Tapez "5" pour ajouter des fichiers à la liste via le navigateur de dossiers
echo Tapez "0" pour revenir au MENU DE SELECTION
ECHO ****************************************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%mlistMTP.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" set skip_list_split="true"
if /i "%eval%"=="1" goto m_patch_keygen
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlistMTP.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlistMTP.txt" mode=file ext="nsp xci nsz xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%mlistMTP.txt" "mode=installer" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mlistMTP.txt" "extlist=nsp xci nsz xcz" )

goto multi_checkagain

:multi_checkagain
echo.
set "mlistfol=%list_folder%\a_multiMTP"
echo Que voulez-vous faire?
echo .......................................................................................................
echo "Faites glisser un autre fichier ou dossier et appuyez sur Entrée pour ajouter des éléments à la liste"
echo.
echo Tapez "1" pour commencer le traitement de la liste actuelle
echo Tapez "2" pour ajouter aux listes enregistrées et à les traiter
echo Tapez "3" pour enregistrer la liste pour plus tard
echo Tapez "4" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "5" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "6" pour sélectionner des fichiers dans les bibliothèques locales
echo Tapez "7" pour ajouter un autre fichier à la liste via le navigateur de dossiers
echo.
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer certains fichiers (en partant du bas)
echo Tapez "z" pour supprimer toute la liste
echo ......................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir au MENU DE SÉLECTION
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%mlistMTP.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" set "mlistfol=%list_folder%\a_multiMTP"
if /i "%eval%"=="1" goto m_patch_keygen
if /i "%eval%"=="2" set "mlistfol=%list_folder%\m_multiMTP"
if /i "%eval%"=="2" goto m_patch_keygen
if /i "%eval%"=="3" set "mlistfol=%list_folder%\m_multiMTP"
if /i "%eval%"=="3" goto multi_saved_for_later
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlistMTP.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mlistMTP.txt" mode=file ext="nsp xci nsz xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="6" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%mlistMTP.txt" "mode=installer" )
if /i "%eval%"=="7" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mlistMTP.txt" "extlist=nsp xci nsz xcz" )
REM if /i "%eval%"=="2" goto multi_set_clogo
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto multi_showlist
if /i "%eval%"=="r" goto multi_r_files
if /i "%eval%"=="z" del mlistMTP.txt

goto multi_checkagain

:multi_saved_for_later
if not exist "%list_folder%" MD "%list_folder%" >NUL 2>&1
if not exist "%mlistfol%" MD "%mlistfol%" >NUL 2>&1
echo ENREGISTRER LE TRAVAIL POUR UNE AUTRE FOIS
echo .........................................................................................
echo Tapez "1" pour ENREGISTRER la liste en tant que tâche unifier (liste multifichier unique)
echo Tapez "2" pour ENREGISTRER la liste en tant que travaux MULTIPLES par baseid de fichiers
echo.
ECHO ***********************************************
echo Tapez "b" pour continuer à construire la liste
echo Tapez "0" pour revenir au menu de sélection
ECHO ***********************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto multi_saved_for_later1
if /i "%bs%"=="2" ( %pycommand% "%squirrel%" -splid "%mlistfol%" -tfile "%prog_dir%mlistMTP.txt" )
if /i "%bs%"=="2" del "%prog_dir%mlistMTP.txt"
if /i "%bs%"=="2" goto multi_saved_for_later2
echo Mauvais choix!!
goto multi_saved_for_later
:multi_saved_for_later1
echo.
echo CHOISISSEZ UN NOM 
echo ......................................................................
echo La liste sera enregistrée sous le nom de votre choix dans la liste
echo dossier (Route est "dossier du programme \ list \ m_multi")
echo.
set /p lname="Tapez le nom pour la liste de travail: "
set lname=%lname:"=%
move /y "%prog_dir%mlistMTP.txt" "%mlistfol%\%lname%.txt" >nul
echo.
echo Sauvegardé!!!
:multi_saved_for_later2
echo.
echo Tapez "0" pour revenir au menu de sélection
echo Tapez "1" pour créer un autre travail
echo Tapez "2" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" echo.
if /i "%bs%"=="1" echo CREATE ANOTHER JOB
if /i "%bs%"=="1" goto multi_manual_INIT
if /i "%bs%"=="1" goto salida
goto multi_saved_for_later2

:multi_r_files
set /p bs="Saisissez le nombre de fichiers que vous souhaitez supprimer (par le bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mlistMTP.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<mlistMTP.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>mlistMTP.txt.new
endlocal
move /y "mlistMTP.txt.new" "mlistMTP.txt" >nul
endlocal

:multi_showlist
cls
call :program_logo
echo -------------------------------------------------
echo MODE MULTI-REPACK ACTIVÉ
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                FICHIERS À TRAITER 
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (mlistMTP.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mlistMTP.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo VOUS AVEZ AJOUTÉ !conta! FICHIERS À TRAITER
echo .................................................
endlocal

goto multi_checkagain

:m_KeyChange_wrongchoice
echo Mauvais choix
echo .............
:m_patch_keygen
echo *************************************************************
echo VÉRIFIEZ LE FIRMWARE DE LA CONSOLE ET LES EXIGENCES DE PATCH?
echo *************************************************************
echo.
echo 1. OUI
echo 2. NON
echo. 
ECHO *************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set dopatchkg=none
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" set "dopatchkg=True"
if /i "%bs%"=="2" set "dopatchkg=False"

if %dopatchkg%=="none" goto m_KeyChange_wrongchoice

:m_KeyChange_skip
if not exist "%list_folder%" MD "%list_folder%" >NUL 2>&1
if not exist "%mlistfol%" MD "%mlistfol%" >NUL 2>&1
if %skip_list_split% EQU "true" goto m_process_jobs
echo *******************************************************
echo COMMENT VOULEZ-VOUS TRAITER LES FICHIERS?
echo *******************************************************
echo Le mode séparé par ID de base est capable d'identifier le
echo contenu qui correspond à chaque jeu et crée plusieurs
echo multi-xci ou multi-nsp à partir du même fichier de liste
echo.
echo Tapez "1" pour fusionner tous les fichiers en un seul fichier
echo Tapez "2" pour SEPARER en multifichiers par 'baseid'
echo.
ECHO ************************************************
echo Ou tapez "b" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="b" goto multi_checkagain
if /i "%bs%"=="1" move /y "%prog_dir%mlistMTP.txt" "%mlistfol%\mlistMTP.txt" >nul
if /i "%bs%"=="1" goto m_process_jobs
if /i "%bs%"=="2" goto m_split_merge
goto m_KeyChange_skip

:m_split_merge
cls
call :program_logo
%pycommand% "%squirrel%" -splid "%mlistfol%" -tfile "%prog_dir%mlistMTP.txt"

:m_process_jobs
dir "%mlistfol%\*.txt" /b  > "%prog_dir%mlistMTP.txt"
for /f "tokens=*" %%f in (mlistMTP.txt) do (
set "listname=%%f"
call :program_logo
call :m_split_merge_list_name

%pycommand% "%squirrel_lb%" -lib_call mtp.mtpxci generate_multixci_and_transfer -xarg "%mlistfol%\%%f" "%w_folder%" "destiny=False" "kgpatch=%dopatchkg%" "verification=%MTP_verification%"
echo.
%pycommand% "%squirrel%" --strip_lines "%prog_dir%mlistMTP.txt" "1" "true"
if exist "%mlistfol%\%%f" del "%mlistfol%\%%f"
)

if exist mlistMTP.txt del mlistMTP.txt
goto m_exit_choice

:m_split_merge_list_name
echo *******************************************************
echo Liste de traitement %listname%
echo *******************************************************
exit /B


:m_exit_choice
ECHO ---------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ---------------------------------------------------
if exist mlistMTP.txt del mlistMTP.txt
if /i "%va_exit%"=="true" echo LE PROGRAMME FERMERA MAINTENANT
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir au menu de sélection
echo Tapez "1" quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto salida
goto m_exit_choice

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
ECHO "                         A MTP MANAGER FOR DBI INSTALLER                           "
ECHO                                  VERSION %program_version% (MTP)
ECHO -------------------------------------------------------------------------------------
ECHO DBI by DUCKBILL: https://github.com/rashevskyv/switch/releases
ECHO Latest DBI: https://github.com/rashevskyv/switch/releases
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
echo Amusez-vous bien...
exit /B
:MAIN
call "%prog_dir%\MtpMode_fr.bat"
exit /B

:salida
::pause
exit
