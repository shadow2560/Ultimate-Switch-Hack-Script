@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"

REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM GESTION DE FICHIERS
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -------------------------------------------------
echo GESTION DE FICHIERS ACTIVÉE
echo -------------------------------------------------
if exist "mnglist.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (mnglist.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (mnglist.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del mnglist.txt )
endlocal
if not exist "mnglist.txt" goto manual_INIT
ECHO ..........................................................
ECHO Une liste précédente à été trouvée. Que voulez vous faire?
:prevlist0
ECHO ............................................................................
echo Tapez "1" pour démarrer automatiquement le traitement de la liste précédente
echo Tapez "2" pour effacer la liste et en créer une nouvelle.
echo Tapez "3" pour continuer à construire la liste précédente
echo ............................................................................
echo NOTE: En appuyant sur 3, vous verrez la liste précédente 
echo avant de commencer le traitement des fichiers et vous 
echo pouvez ajouter et supprimer des éléments de la liste
echo.
ECHO ******************************************************
echo Ou tapez "0" pour revenir au menu de sélection de mode
ECHO ******************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto showlist
if /i "%bs%"=="2" goto delist
if /i "%bs%"=="1" goto start_cleaning
if /i "%bs%"=="0" exit /B
echo.
echo Mauvais choix
goto prevlist0
:delist
del mnglist.txt
cls
call :program_logo
echo -------------------------------------------------
echo GESTION DE FICHIERS ACTIVÉE
echo -------------------------------------------------
echo ................................................
echo VOUS AVEZ DÉCIDÉ DE COMMENCER UNE NOUVELLE LISTE
echo ................................................

:manual_INIT
endlocal
ECHO **********************************************************************
echo Tapez "1" pour ajouter un dossier à la liste via le sélecteur
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour sélectionner des fichiers via les bibliothèques locales 
echo Tapez "4" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "0" pour revenir au menu du mode de sélection
ECHO **********************************************************************
echo.
%pycommand% "%squirrel%" -t nsp nsx -tfile "%prog_dir%mnglist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mnglist.txt" mode=folder ext="nsp nsx" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mnglist.txt" mode=file ext="nsp nsx" False False True )  2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%mnglist.txt" "extlist=nsp nsx" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mnglist.txt" "extlist=nsp nsx" )
goto checkagain
echo.
:checkagain
echo Que voulez vous faire?
echo ..........................................................................
echo "Glissez un autre fichier et appuyer sur entrer pour l'ajouter à la liste."
echo.
echo Tapez "1" pour commencer le traitement.
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "4" pour sélectionner des fichiers via les bibliothèques locales
echo Tapez "5" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "e" pour quitter.
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer certains fichiers de la liste (en partant du bas).
echo Tapez "z" pour supprimer toute la liste.
echo ...........................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir à la sélection du mode
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp nsx -tfile "%prog_dir%mnglist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" goto start_cleaning
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mnglist.txt" mode=folder ext="nsp nsx" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%mnglist.txt" mode=file ext="nsp nsx" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%mnglist.txt" "extlist=nsp nsx" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%mnglist.txt" "extlist=nsp nsx" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del mnglist.txt

goto checkagain

:r_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mnglist.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<mnglist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>mnglist.txt.new
endlocal
move /y "mnglist.txt.new" "mnglist.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo GESTION DE FICHIERS ACTIVÉE
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter: 
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (mnglist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (mnglist.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichier(s) à traiter.
echo .................................................
endlocal

goto checkagain

:s_cl_wrongchoice
echo Mauvais choix
echo .............
:start_cleaning
echo *******************************************************
echo CHOISISSEZ COMMENT TRAITER LES FICHIERS
echo *******************************************************
echo.
echo Tapez "1" pour vérifier l'extension nsp\nsx en fonction du tk
echo.
ECHO **************************************************
echo Ou tapez "b" pour revenir aux options de la liste.
ECHO **************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" goto renamensx
if %vrepack%=="none" goto s_cl_wrongchoice

:renamensx
cls
call :program_logo
CD /d "%prog_dir%"
%pycommand% "%squirrel_lb%" -lib_call management rename_nsx "%prog_dir%mnglist.txt"

ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:s_exit_choice
if exist mnglist.txt del mnglist.txt
if /i "%va_exit%"=="true" echo Le programme peu être fermé maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode
echo Tapez "1" pour quitter le script
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (mnglist.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B


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
ECHO "                    BASED ON THE WORK OF BLAWAR AND LUCA FRAGA                     "
ECHO                                    VERSION %program_version%
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


:salida
exit /B
