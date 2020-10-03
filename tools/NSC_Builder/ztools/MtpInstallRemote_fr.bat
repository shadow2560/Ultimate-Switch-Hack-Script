@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"
set "bat_name=%~n0"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad

:MAIN
if exist "MTP1GD.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (MTP1GD.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (MTP1GD.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del MTP1GD.txt )
endlocal
if not exist "MTP1GD.txt" goto manual_INIT
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
if /i "%bs%"=="1" goto select_medium
if /i "%bs%"=="0" call "%prog_dir%ztools\MtpMode_fr.bat"
echo.
echo Mauvais choix
goto prevlist0
:delist
del MTP1GD.txt
cls
call :program_logo
echo -------------------------------------------------
echo MTP - INSTALLER À PARTIR DE GOOGLE DRIVE
echo -------------------------------------------------
echo ................................................
echo VOUS AVEZ DÉCIDÉ DE COMMENCER UNE NOUVELLE LISTE
echo ................................................

:manual_INIT
endlocal
cls
call :program_logo
echo *******************************************************
echo SÉLECTIONNEZ LA FONCTION
echo *******************************************************
echo.
echo Tapez "1" pour sélectionner des fichiers à partir des fichiers CACHE
echo Tapez "2" pour sélectionner les fichiers des bibliothèques
echo Tapez "3" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "c" pour régénérer le cache des bibliothèques distantes
ECHO.
echo --- Ou tapez GDRIVE LIEN PUBLIC ou LIEN 1FICHIER ---	
echo. 
ECHO *************************************************
echo Tapez "0" pour revenir au MENU DE SELECTION
ECHO *************************************************
echo.
%pycommand% "%squirrel%" --mtp_eval_link "%prog_dir%MTP1GD.txt" "%uinput%"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_cache -xarg "%prog_dir%MTP1GD.txt" )
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_libraries -xarg "%prog_dir%MTP1GD.txt" )
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_walker -xarg "%prog_dir%MTP1GD.txt" "nsp nsz xci xcz" )
if /i "%eval%"=="c" ( %pycommand% "%squirrel_lb%" -lib_call workers concurrent_cache )
echo.
goto checkagain

:checkagain
echo Que voulez-vous faire?
echo ......................................................................................................
echo "Faites glisser un autre fichier ou dossier et appuyez sur Entrée pour ajouter des éléments à la liste"
echo.
echo Tapez "1" pour commencer l'installation
echo Tapez "2" pour sélectionner des fichiers à partir des fichiers CACHE
echo Tapez "3" pour sélectionner les fichiers des bibliothèques
echo Tapez "4" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "c" pour régénérer le cache des bibliothèques distantes
echo Tapez "e" pour quitter
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer certains fichiers (en partant du bas)
echo Tapez "z" pour supprimer toute la liste
ECHO.
echo --- Ou tapez GDRIVE LIEN PUBLIC ou LIEN 1FICHIER ---	
echo. 
ECHO *************************************************
echo Ou tapez "0" pour revenir au MENU DE SELECTION
ECHO *************************************************
echo.
%pycommand% "%squirrel%" --mtp_eval_link "%prog_dir%MTP1GD.txt" "%uinput%"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" goto select_medium
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_cache -xarg "%prog_dir%MTP1GD.txt" )
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_libraries -xarg "%prog_dir%MTP1GD.txt" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker remote_select_from_walker -xarg "%prog_dir%MTP1GD.txt" "nsp nsz xci xcz" )
if /i "%eval%"=="c" ( %pycommand% "%squirrel_lb%" -lib_call workers concurrent_cache )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del "%prog_dir%MTP1GD.txt"
echo.
goto checkagain

:r_files
set /p bs="Saisissez le nombre de fichiers que vous souhaitez supprimer (par le bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (MTP1GD.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<MTP1GD.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>MTP1GD.txt.new
endlocal
move /y "MTP1GD.txt.new" "MTP1GD.txt" >nul
endlocal
:showlist
cls
call :program_logo
echo -------------------------------------------------
echo MTP - INSTALLER À PARTIR DE GOOGLE DRIVE
echo -------------------------------------------------
ECHO FICHIERS À TRAITER: 
for /f "tokens=*" %%f in (MTP1GD.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (MTP1GD.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo VOUS AVEZ AJOUTÉ !conta! FICHIERS À TRAITER
echo .................................................
endlocal
goto checkagain

:select_medium_wrongchoice
echo Mauvais choix
echo .............
:select_medium
echo *******************************************************
echo SUPPORT D'INSTALLATION
echo *******************************************************
echo.
echo 1. SD
echo 2. EMMC
echo. 
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set medium=none
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" set "medium=SD"
if /i "%bs%"=="2" set "medium=EMMC"

if %medium%=="none" goto select_medium_wrongchoice

:START_INSTALLATION
cls
call :program_logo
CD /d "%prog_dir%"
%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_gdrive loop_install -xarg "%prog_dir%MTP1GD.txt" "destiny=%medium%" "%w_folder%" "ch_medium=%MTP_aut_ch_medium%" "check_fw=%MTP_chk_fw%" "patch_keygen=%MTP_prepatch_kg%" "ch_base=%MTP_prechk_Base%" "ch_other=%MTP_prechk_Upd%" "truecopy=%MTP_pdrive_truecopy%"
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:s_exit_choice
if exist MTP1GD.txt del MTP1GD.txt
if /i "%va_exit%"=="true" echo PROGRAM WILL CLOSE NOW
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir au menu de sélection
echo Tapez "1" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice


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
