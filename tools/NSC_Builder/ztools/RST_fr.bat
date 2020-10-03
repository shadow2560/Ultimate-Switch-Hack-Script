@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"

REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM RESTAURATION DE FICHIER
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -------------------------------------------------
echo RESTAURATION DE FICHIERS ACTIVÉE
echo -------------------------------------------------
if exist "rstlist.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (rstlist.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (rstlist.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del rstlist.txt )
endlocal
if not exist "rstlist.txt" goto manual_INIT
ECHO ............................................................................
ECHO Une liste précédente a été trouvée. Qu'est-ce que vous voulez faire?
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
echo Ou tapez "0" pour revenir au menu du mode de sélection
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
del rstlist.txt
cls
call :program_logo
echo -------------------------------------------------
echo RESTAURATION DE FICHIERS ACTIVÉE
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
%pycommand% "%squirrel%" -t nsp xci -tfile "%prog_dir%rstlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%rstlist.txt" mode=folder ext="nsp xci" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%rstlist.txt" mode=file ext="nsp xci" False False True ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%rstlist.txt" "extlist=nsp xci" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%rstlist.txt" "extlist=nsp xci" )
goto checkagain
echo.
:checkagain
echo QU'EST-CE QUE TU VEUX FAIRE?
echo .................................................................................
echo "Glissez un autre fichier ou dossier et appuyez sur enter pour ajouter à la liste"
echo.
echo Tapez "1" pour commencer le traitement
echo Tapez "2" pour ajouter un autre dossier à la liste via le sélecteur
echo Tapez "3" pour ajouter un autre fichier à la liste via le sélecteur
echo Tapez "4" pour sélectionner des fichiers via les bibliothèques locales
echo Tapez "5" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer des fichiers (en partant du bas)
echo Tapez "z" pour enlever toute la liste
echo .................................................................................
ECHO ******************************************************
echo Ou tapez "0" pour revenir au menu du mode de sélection
ECHO ******************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci -tfile "%prog_dir%rstlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" goto start_cleaning
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%rstlist.txt" mode=folder ext="nsp xci" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%rstlist.txt" mode=file ext="nsp xci" False False True ) 2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%rstlist.txt" "extlist=nsp xci" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%rstlist.txt" "extlist=nsp xci" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del rstlist.txt

goto checkagain

:r_files
set /p bs="Entrez le nombre de fichiers que vous souhaitez supprimer (à partir du bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (rstlist.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<rstlist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>rstlist.txt.new
endlocal
move /y "rstlist.txt.new" "rstlist.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo RESTAURATION DE FICHIERS ACTIVÉE
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 FICHIERS À TRAITER
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (rstlist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (rstlist.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichier(s) à traiter
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
echo Si les fichiers ont été modifiés avec NSCB à partir de sources légitimes
echo leurs fichiers nca sont restaurables, sinon vous n'avez pas de chance
echo.
echo Ce mode va restaurer:
echo   - Conversions entre xci \ nsp (effectuées par NSCB)
echo   - Opérations d'élimination de Titlerights
echo   - Changements de génération de clé et de RSV
echo.
echo + La restauration du lien avec un compte patché n'est pas encore supportée
echo + Les fichiers multi-contenus doivent être traités en premier lieu  avec
echo   l'extraction d'élément de fichiers multi-contenus dans cette première implémentation ^(extraire les différents contenus des supers XCI/NSP car ces derniers ne sont pour l'instant pas pris en charge^)
echo.
echo ------------------------------------------
echo Tapez "1" pour traiter les fichiers
echo.
ECHO *************************************************
echo Ou tapez "b" pour revenir aux options de la liste
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" goto restorefiles
if %vrepack%=="none" goto s_cl_wrongchoice

:restorefiles
cls
call :program_logo
CD /d "%prog_dir%"
MD "%fold_output%" >NUL 2>&1
for /f "tokens=*" %%f in (rstlist.txt) do (
MD "%w_folder%" >NUL 2>&1

%pycommand% "%squirrel%" %buffer% -o "%w_folder%" %buffer% -tfile "%prog_dir%rstlist.txt" --restore ""
%pycommand% "%squirrel%" --strip_lines "%prog_dir%rstlist.txt"

move "%w_folder%\*.xci" "%fold_output%" >NUL 2>&1
move  "%w_folder%\*.xc*" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.nsp" "%fold_output%" >NUL 2>&1
move "%w_folder%\*.ns*" "%fold_output%" >NUL 2>&1

RD /S /Q "%w_folder%" >NUL 2>&1
call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:s_exit_choice
if exist rstlist.txt del rstlist.txt
if /i "%va_exit%"=="true" echo Le programme ferme maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir au mode de sélection
echo Tapez "1" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (rstlist.txt) do (
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
echo amusez-vous bien
exit /B


:salida
exit /B
