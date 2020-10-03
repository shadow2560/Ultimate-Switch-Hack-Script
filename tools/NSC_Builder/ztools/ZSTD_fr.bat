@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"

REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM COMPRESSION
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -------------------------------------------------
echo Mode compression/décompression activé
echo -------------------------------------------------
if exist "zzlist.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (zzlist.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (zzlist.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del zzlist.txt )
endlocal
if not exist "zzlist.txt" goto manual_INIT
ECHO ................................................................
ECHO UNE LISTE PRÉCÉDENTE A ÉTÉ TROUVÉE. QUE SOUHAITEZ-VOUS FAIRE?
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
if /i "%bs%"=="1" goto start
if /i "%bs%"=="0" exit /B
echo.
echo Mauvais choix
goto prevlist0
:delist
del zzlist.txt
cls
call :program_logo
echo -------------------------------------------------
echo Compression / Décompression activé
echo -------------------------------------------------
echo ................................................
echo VOUS AVEZ DÉCIDÉ DE COMMENCER UNE NOUVELLE LISTE
echo ................................................

:manual_INIT
endlocal
echo "GLISSEZ UN AUTRE FICHIER OU DOSSIER ET APPUYEZ SUR ENTER POUR AJOUTER DES ARTICLES À LA LISTE"
echo.
ECHO **********************************************************************
echo Tapez "1" pour ajouter un dossier à la liste via le sélecteur
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour sélectionner des fichiers via les bibliothèques locales
echo Tapez "4" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "0" pour revenir au menu de sélection de mode
ECHO **********************************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%zzlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%zzlist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%zzlist.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%zzlist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%zzlist.txt" "extlist=nsp xci nsz xcz" )

goto checkagain
echo.
:checkagain
echo QUE SOUHAITEZ-VOUS FAIRE?
echo ..............................................................................................
echo "GLISSEZ UN AUTRE FICHIER OU DOSSIER ET APPUYEZ SUR ENTER POUR AJOUTER DES ARTICLES À LA LISTE"
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
echo ..............................................................................................
ECHO ******************************************************
echo Ou tapez "0" pour revenir au menu de sélection de mode
ECHO ******************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz -tfile "%prog_dir%zzlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" goto start
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%zzlist.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%zzlist.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker select_from_local_libraries -xarg "%prog_dir%zzlist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%zzlist.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del zzlist.txt

goto checkagain

:r_files
set /p bs="Entrez le nombre de fichiers que vous souhaitez supprimer (à partir du bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (zzlist.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<zzlist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>zzlist.txt.new
endlocal
move /y "zzlist.txt.new" "zzlist.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo mode Compression / Décompression activé
echo -------------------------------------------------
ECHO FICHIERS À TRAITER: 
for /f "tokens=*" %%f in (zzlist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (zzlist.txt) do (
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
:start
echo *******************************************************
echo CHOISISSEZ COMMENT TRAITER LES FICHIERS
echo *******************************************************
echo Tapez "1" pour compresser le NSP/XCI en NSZ/XCZ
echo Tapez "2" pour la compression pararell
echo Tapez "3" pour décompresser NSZ/XCZ
echo.
ECHO *************************************************
echo Ou tapez "b" pour revenir aux options de la liste
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set choice=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" goto compression_presets_menu
if /i "%bs%"=="2" goto pararell_compress
if /i "%bs%"=="3" goto decompress
if "%choice%"=="none" goto s_cl_wrongchoice


:compression_presets_wrongchoice
echo mauvais choix
echo .............
:compression_presets_menu
echo *******************************************************
echo réglage du niveau de compression
echo *******************************************************
echo Réglage de compression pour simplifier l'utilisation
echo.
echo 0. Réglage manuel
echo 1. Rapide (THREADED)           - Niveau 1  _ 4   threads
echo 2. Rapide (UNTHREADED)         - Niveau 1  _ no  threads
echo 3. Intermédiaire (THREADED)    - Niveau 10 _ 4   threads
echo 4. Intermédiaire (UNTHREADED)  - Niveau 10 _ no  threads
echo 5. Moyen   (THREADED)          - Niveau 17 _ 2   threads
echo 6. Moyen   (UNTHREADED)        - Niveau 17 _ no  threads
echo 7. Haute   (UNTHREADED)        - Niveau 22 _ no  threads
echo 8. Haute   (THREADED)          - Niveau 22 _ 1   threads
echo 9. Configuration de la valeur (Dans le fichier de configuration du script)
echo. 
ECHO *****************************************************************
echo Tapez "d" pour utiliser l'option par défaut (level 17_no threads)
echo Ou tapez "b" pour revenir à la liste des options
ECHO *****************************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set level=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="d" set "level=17"
if /i "%bs%"=="d" set "workers=0"

if /i "%bs%"=="0" goto levels
if /i "%bs%"=="1" set "level=1"
if /i "%bs%"=="1" set "workers=4"
if /i "%bs%"=="2" set "level=1"
if /i "%bs%"=="2" set "workers=0"
if /i "%bs%"=="3" set "level=10"
if /i "%bs%"=="3" set "workers=4"
if /i "%bs%"=="4" set "level=10"
if /i "%bs%"=="4" set "workers=0"
if /i "%bs%"=="5" set "level=17"
if /i "%bs%"=="5" set "workers=2"
if /i "%bs%"=="6" set "level=17"
if /i "%bs%"=="6" set "workers=0"
if /i "%bs%"=="7" set "level=22"
if /i "%bs%"=="7" set "workers=0"
if /i "%bs%"=="8" set "level=22"
if /i "%bs%"=="8" set "workers=1"
if /i "%bs%"=="9" set "level=%compression_lv%"
if /i "%bs%"=="9" set "workers=%compression_threads%"

if "%level%"=="none" goto compression_presets_wrongchoice
goto compress


:levels_wrongchoice
echo Mauvais choix
echo .............
:levels
echo *******************************************************
echo Entrer le niveau de compression
echo *******************************************************
echo Entrez un niveau de compression compris entre 1 et 22
echo Notes:
echo  + Niveau 1 - Taux de compression rapide et réduit
echo  + Niveau 22 - Taux de compression lent mais meilleur
echo  Les niveaux 10-17 sont recommandés
echo.
ECHO *************************************************
echo Tapez "d" pour le choix par défaut (niveau 17)
echo Ou tapez "b" pour revenir à l'option précédente
echo Ou tapez "x" pour revenir aux options de la liste
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set choice=none
if /i "%bs%"=="x" goto checkagain
if /i "%bs%"=="b" goto compression_presets_menu
if /i "%bs%"=="d" set "bs=17"
set "level=%bs%"
if "%choice%"=="none" goto levels_wrongchoice
goto threads
:threads_wrongchoice
echo Mauvais choix
echo .............
:threads
echo ********************************************************
echo Nombre de treads a utiliser
echo ********************************************************
echo Entrez un nombre de treads à utiliser compris entre 0 et 4
echo Notes:
echo  + En utilisant les tread, vous pouvez gagner un peu de vitesse. 
echo    mais vous perdrez le taux de compression
echo  + Le niveau 22 et 4 treads risque de vous faire manquer de mémoire
echo  + Le maximum de tread pour le niveau de compression 17 est conseillé
echo    mais vous perdrez le taux de compression
echo.
ECHO ************************************************
echo Tapez "d" pour l'option par defaut (0 tread)
echo Ou tapez "b" pour revenir à l'option précédente
echo Ou tapez "x" pour revenir aux options de la liste
ECHO ************************************************
echo.
set /p bs="Entrez le nombre de treads [-1;0-4]: "
set bs=%bs:"=%
set workers=none
if /i "%bs%"=="x" goto checkagain
if /i "%bs%"=="b" goto levels
if /i "%bs%"=="d" set "bs=0"
set "workers=%bs%"
if "%workers%"=="none" goto threads_wrongchoice

:compress
cls
call :program_logo
echo ***************************************
echo Compression d'un NSP /XCI
echo ***************************************
CD /d "%prog_dir%"
%pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%zzlist.txt","ext=nsp xci","token=False",Print="False"
for /f "tokens=*" %%f in (zzlist.txt) do (

%pycommand% "%squirrel%" %buffer% -o "%fold_output%" -tfile "%prog_dir%zzlist.txt" --compress "%level%" --threads "%workers%" --nodelta "%skdelta%" --fexport "%xci_export%"
REM %pycommand% "%squirrel%" %buffer% -o "%fold_output%" -tfile "%prog_dir%zzlist.txt" --compress "%level%" --threads "%workers%" --nodelta "%skdelta%" --pararell "true"

%pycommand% "%squirrel%" --strip_lines "%prog_dir%zzlist.txt"
call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:pararell_compress_wrongchoice
echo wrong choice
echo ............
:pararell_compress
echo *******************************************************
echo NOMBRE D'INSTANCES A UTILISER
echo *******************************************************
echo Entrez un nombre d'instances à utiliser supérieur à 0
echo Les valeurs erronées sont converties en 2. 0 est converti en 1
echo Notes:
echo  + Vous allez créer un nombre de fichier compressé égal au
echo    Nombre d'instances
echo  + Si vous avez assez d’espaces disque, plus 
echo    efficace que les threads et a une puissance de calcul plus faible
echo     
echo  + Si vous avez assez d'espace disque et de puissance de calcul 
echo    n'ayez pas peur d'essayer d'utiliser 10 à 20 instances
echo  + tqdm is a little wonky when printing pararell bars
echo    with threads some so the screen will refresh
echo    each 3s in pararell mode to clear bad prints.
echo.
ECHO ********************************************************
echo Tapez "d" pour défaut (4 instances)
echo Ou Tapez "b" pour revenir à l'option précédente
echo Ou Tapez "x" pour revenir aux options de la liste
ECHO ********************************************************
echo.
set /p bs="Tapez le nombre d'instances [>1]: "
set bs=%bs:"=%
set workers=none
if /i "%bs%"=="x" goto checkagain
if /i "%bs%"=="b" goto start
if /i "%bs%"=="d" set "bs=4"
set "workers=%bs%"
if "%workers%"=="none" goto pararell_compress_wrongchoice
goto pararell_levels

:pararell_levels_wrongchoice
echo mauvais choix
echo .............
:pararell_levels
echo *******************************************************
echo Entrez le niveau de compression
echo *******************************************************
echo Entrez un niveau de compression compris entre 1 et 22
echo Notes:
echo  + Niveau 1 - Taux de compression rapide et réduit
echo  + Niveau 22 - Taux de compression lent mais meilleur
echo  Niveau 10-17 sont recommandés dans les spécifications
echo.
ECHO *******************************************************
echo Tapez "d" pour défaut (Niveau 17)
echo Ou Tapez "b" pour revenir à l'option précédente
echo Ou Tapez "x" pour revenir aux options de la liste
ECHO *******************************************************
echo.
set /p bs="Entrez le niveau de compression [1-22]: "
set bs=%bs:"=%
set level=none
if /i "%bs%"=="x" goto checkagain
if /i "%bs%"=="b" goto pararell_compress
if /i "%bs%"=="d" set "bs=17"
set "level=%bs%"
if "%level%"=="none" goto pararell_levels_wrongchoice
goto pcompress
:pcompress
cls
call :program_logo
echo ********************************
echo Compression parallèle de NSP\XCI
echo ********************************
CD /d "%prog_dir%"
echo Filtrer les extensions de la liste
%pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%zzlist.txt","ext=nsp xci","token=False",Print="False"
echo Tri de la liste par taille des fichiers
%pycommand% "%squirrel_lb%" -lib_call listmanager size_sorted_from_tfile -xarg "%prog_dir%zzlist.txt"
echo Lancer la compression par lots de "%workers%"
%pycommand% "%squirrel%" %buffer% -o "%fold_output%" -tfile "%prog_dir%zzlist.txt" --compress "%level%" --threads "%workers%" --nodelta "%skdelta%" --fexport "%xci_export%" --pararell "true"

ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:decompress
cls
call :program_logo
echo **************************
echo Décompression d'un NSZ/XCZ
echo **************************
CD /d "%prog_dir%"
%pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%zzlist.txt","ext=nsz xcz","token=False",Print="False"
for /f "tokens=*" %%f in (zzlist.txt) do (

%pycommand% "%squirrel%" -o "%fold_output%" -tfile "%prog_dir%zzlist.txt" --decompress "auto"

%pycommand% "%squirrel%" --strip_lines "%prog_dir%zzlist.txt"
call :contador_NF
)
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:s_exit_choice
if exist zzlist.txt del zzlist.txt
if /i "%va_exit%"=="true" echo Le programme va fermé maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode
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
for /f "tokens=*" %%f in (zzlist.txt) do (
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
