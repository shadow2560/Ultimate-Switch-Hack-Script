@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"
set "bat_name=%~n0"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad
REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM START OF MANUAL MODE. INDIVIDUAL PROCESSING
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -----------------------------------------------
echo MTP - Creer XCI ET TRANSFERT ACTIVÉ
echo -----------------------------------------------
if exist "mtpxci.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (mtpxci.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (mtpxci.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del mtpxci.txt )
endlocal
if not exist "mtpxci.txt" goto manual_INIT
ECHO .....................................................................................
ECHO UNE LISTE PRÉCÉDENTE A ÉTÉ TROUVÉE. QU'EST-CE QUE TU VEUX FAIRE?
:prevlist0
ECHO .....................................................................................
echo Tapez "1" pour démarrer automatiquement le traitement à partir de la liste précédente
echo Tapez "2" pour effacer la liste et en créer une nouvelle.
echo Tapez "3" pour continuer à construire la liste précédente
echo .....................................................................................
echo NOTE: En appuyant sur 3, vous verrez la liste précédente
echo avant de commencer le traitement des fichiers et vous 
echo pouvez ajouter et supprimer des éléments de la liste
echo.
ECHO *************************************************
echo Ou tapez "0" pour revenir au MENU DE SELECTION 
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto showlist
if /i "%bs%"=="2" goto delist
if /i "%bs%"=="1" goto start_xci_process
if /i "%bs%"=="0" goto MAIN
echo.
echo Mauvais choix
goto prevlist0
:delist
del mtpxci.txt
cls
call :program_logo
echo -----------------------------------------------
echo MTP - Creer XCI ET TRANSFERT ACTIVÉ
echo -----------------------------------------------
echo ................................................
echo VOUS AVEZ DÉCIDÉ DE COMMENCER UNE NOUVELLE LISTE
echo ................................................
:manual_INIT
endlocal
ECHO ***********************************************************************
echo Tapez "1" pour ajouter un dossier à la liste via le sélecteur
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour sélectionner des fichiers dans les bibliothèques locales
echo Tapez "4" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "0" pour revenir au MENU DE SELECTION
ECHO ***********************************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz nsx xcz -tfile "%prog_dir%mtpxci.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mtpxci.txt" mode=folder ext="nsp xci nsz nsx xcz" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mtpxci.txt" mode=file ext="nsp xci nsz nsx xcz" False False True ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%mtpxci.txt" "mode=installer" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mtpxci.txt" "extlist=nsp xci nsz xcz" )
goto checkagain
echo.
:checkagain
echo Que voulez-vous faire?
echo ......................................................................................................
echo "Faites glisser un autre fichier ou dossier et appuyez sur Entrée pour ajouter des éléments à la liste"
echo.
echo Tapez "1" pour commencer le traitement
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "4" pour sélectionner des fichiers dans les bibliothèques locales
echo Tapez "5" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer certains fichiers (en partant du bas)
echo Tapez "z" pour supprimer toute la liste
echo ......................................................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir au MENU DE SELECTION
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz nsx xcz -tfile "%prog_dir%mtpxci.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" goto patch_keygen
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg  "%prog_dir%mtpxci.txt" mode=folder ext="nsp xci nsz nsx xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg  "%prog_dir%mtpxci.txt" mode=file ext="nsp xci nsz nsx xcz" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%mtpxci.txt" "mode=installer" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mtpxci.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del mtpxci.txt

goto checkagain

:r_files
set /p bs="Saisissez le nombre de fichiers que vous souhaitez supprimer (par le bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mtpxci.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<mtpxci.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>mtpxci.txt.new
endlocal
move /y "mtpxci.txt.new" "mtpxci.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo MTP - Creer XCI ET TRANSFERT ACTIVÉ
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 FICHIERS À TRAITER 
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (mtpxci.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mtpxci.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo VOUS AVEZ AJOUTÉ !conta! FICHIERS À TRAITER
echo .................................................
endlocal

goto checkagain

:patch_keygen_wrongchoice
echo Mauvais choix
echo .............
:patch_keygen
echo *************************************************************
echo VÉRIFIEZ LE FIRMWARE DE LA CONSOLE ET LES EXIGENCES DE PATCH?
echo *************************************************************
echo.
echo 1. OUI
echo 2. NON
echo. 
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set dopatchkg=none
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" set "dopatchkg=True"
if /i "%bs%"=="2" set "dopatchkg=False"

if %dopatchkg%=="none" goto patch_keygen_wrongchoice

:start_xci_process
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpxci loop_xci_transfer -xarg "%prog_dir%mtpxci.txt" "destiny=False" "verification=%MTP_verification%" "%w_folder%" "patch_keygen=%dopatchkg%" "mode=single"

ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice


:s_exit_choice
if exist mtpxci.txt del mtpxci.txt
if /i "%va_exit%"=="true" echo LE PROGRAMME FERMERA MAINTENANT
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir au menu de sélection
echo Tapez "1" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto salida
goto s_exit_choice


echo Le programme se termine maintenant
PING -n 2 127.0.0.1 >NUL 2>&1
goto salida


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
echo Bon amusement.
exit /B

:MAIN
call "%prog_dir%\MtpMode_fr.bat"
exit /B

:salida
::pause
exit
