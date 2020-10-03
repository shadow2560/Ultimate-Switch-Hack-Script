@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"
set "bat_name=%~n0"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad

:MAIN
cls
call :program_logo
ECHO .............................................................
echo Tapez "1" pour entrer dans le mode INSTALLATION de jeu
echo Tapez "2" pour entrer dans le mode de transfert de fichiers
echo Tapez "3" pour entrer dans le mode mise à jour atomatique de la console depuis la bibliothèque
echo Tapez "4" pour entrer dans le DUMP ou déinstaller un jeu 
echo Tapez "5" pour entrer dans le mode de copie des sauvegardes
echo Tapez "6" pour entrer dans le mode information de la console
echo Tapez "7" pour entrer dans le mode générer des fichiers autoloader SX
echo Tapez "0" pour entrer en mode CONFIGURATION
echo.
echo Tapez "N" pour aller aux MODES STANDARD
echo Tapez "D" pour entrer dans le mode GOOGLE DRIVE
echo Tapez "L" pour accéder à l'ancien mode
echo .............................................................
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="1" goto G_INST
if /i "%bs%"=="2" goto F_TR
if /i "%bs%"=="3" goto AUTOUPDATE
if /i "%bs%"=="4" goto INSTALLED
if /i "%bs%"=="5" goto SAVES
if /i "%bs%"=="6" goto DEV_INF
if /i "%bs%"=="7" goto SX_AUTOLOADER
if /i "%bs%"=="N" goto call_main
if /i "%bs%"=="L" goto LegacyMode
if /i "%bs%"=="D" goto GDMode
if /i "%bs%"=="0" goto OPT_CONFIG
goto MAIN

:LegacyMode
call "%prog_dir%ztools\LEGACY_fr.bat"
exit /B

:GDMode
call "%prog_dir%ztools\DriveMode_fr.bat"
exit /B

:G_INST
cls
call :program_logo
echo -------------------------------------------------
echo MTP - MODE DE TRANSFERT DE FICHIERS ACTIVÉ
echo -------------------------------------------------
echo *******************************************************
echo SÉLECTIONNEZ LA FONCTION
echo *******************************************************
echo.
echo 1. INSTALLATION DU JEU À PARTIR DE FICHIERS LOCAUX
echo 2. INSTALLATION DE JEU À PARTIR DE BIBLIOTHÈQUES À DISTANCE (GDRIVE)
echo. 
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto G_INST_LOCAL
if /i "%bs%"=="2" goto G_INST_GDRIVE
goto G_INST

:G_INST_GDRIVE
call "%prog_dir%ztools\MtpInstallRemote_fr.bat"
goto MAIN

:G_INST_LOCAL
cls
call :program_logo
echo -------------------------------------------------
echo MTP - MODE D'INSTALLATION ACTIVÉ
echo -------------------------------------------------
if exist "MTP1.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (MTP1.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (MTP1.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del MTP1.txt )
endlocal
if not exist "MTP1.txt" goto manual_INIT
ECHO ................................................................
ECHO UNE LISTE PRÉCÉDENTE A ÉTÉ TROUVÉE. QU'EST-CE QUE TU VEUX FAIRE?
:prevlist0
ECHO ................................................................
echo Tapez "1" pour démarrer automatiquement le traitement à partir de la liste précédente
echo Tapez "2" pour effacer la liste et en créer une nouvelle.
echo Tapez "3" pour continuer à construire la liste précédente
echo .......................................................
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
if /i "%bs%"=="1" goto start_1install
if /i "%bs%"=="0" goto MAIN
echo.
echo Mouvais choix
goto prevlist0
:delist
del MTP1.txt
cls
call :program_logo
echo -------------------------------------------------
echo MTP - MODE D'INSTALLATION ACTIVÉ
echo -------------------------------------------------
echo ................................................
echo VOUS AVEZ DÉCIDÉ DE COMMENCER UNE NOUVELLE LISTE
echo ................................................

:manual_INIT
endlocal
echo "Faites glisser un autre fichier ou dossier et appuyez sur Entrée pour ajouter des éléments à la liste"
echo.
ECHO ***********************************************************************
echo Tapez "1" pour ajouter un dossier à la liste via le sélecteur
echo Tapez "2" pour ajouter un fichier à la liste via le sélecteur
echo Tapez "3" pour sélectionner des fichiers dans les bibliothèques locales
echo Tapez "4" pour sélectionner des fichiers via le navigateur de dossiers
echo Tapez "0" pour revenir au MENU DE SELECTION
ECHO ***********************************************************************
echo.
%pycommand% "%squirrel%" -t nsp nsz xci xcz -tfile "%prog_dir%MTP1.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%MTP1.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%MTP1.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%MTP1.txt" )
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%MTP1.txt" "extlist=nsp xci nsz xcz" )

goto checkagain
echo.
:checkagain
echo Que voulez-vous faire?
echo .......................................................................................................
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
echo Tapez "z" supprimer toute la liste
echo .......................................................................................................
ECHO *************************************************
echo Ou tapez "0" pour revenir au menu de sélection
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp nsz xci xcz -tfile "%prog_dir%MTP1.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" goto MAIN
if /i "%eval%"=="1" goto start_1install
if /i "%eval%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%MTP1.txt" mode=folder ext="nsp xci nsz xcz" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call listmanager selector2list -xarg "%prog_dir%MTP1.txt" mode=file ext="nsp xci nsz xcz" False False True )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller select_from_local_libraries -xarg "%prog_dir%MTP1.txt" )
if /i "%eval%"=="5" ( %pycommand% "%squirrel_lb%" -lib_call picker_walker get_files_from_walk -xarg "%prog_dir%MTP1.txt" "extlist=nsp xci nsz xcz" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del MTP1.txt

goto checkagain

:r_files
set /p bs="Saisissez le nombre de fichiers que vous souhaitez supprimer (par le bas): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (MTP1.txt) do (
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
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<MTP1.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>MTP1.txt.new
endlocal
move /y "MTP1.txt.new" "MTP1.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo MTP - MODE D'INSTALLATION ACTIVÉ
echo -------------------------------------------------
ECHO FICHIERS À TRAITER:
for /f "tokens=*" %%f in (MTP1.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (MTP1.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo VOUS AVEZ AJOUTÉ !conta! FICHIERS À TRAITER
echo .................................................
endlocal

goto checkagain

:s_mtp1_wrongchoice
echo Mauvais choix
echo .............
:start_1install
echo *******************************************************
echo CHOISISSEZ COMMENT TRAITER LES FICHIERS
echo *******************************************************
echo Tapez "1" pour installer des jeux
echo.
ECHO ************************************************
echo Ou tapez "b" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set choice=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" goto select_medium
if %choice%=="none" goto s_mtp1_wrongchoice

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
echo Ou tapez "b" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set medium=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" set "medium=SD"
if /i "%bs%"=="2" set "medium=EMMC"

if %medium%=="none" goto select_medium_wrongchoice

:start_installing
cls
call :program_logo
CD /d "%prog_dir%"

%pycommand% "%squirrel_lb%" -lib_call listmanager filter_list "%prog_dir%MTP1.txt","ext=nsp xci nsz","token=False",Print="False"
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller loop_install -xarg "%prog_dir%MTP1.txt" "destiny=%medium%" "verification=%MTP_verification%" "%w_folder%" "ch_medium=%MTP_aut_ch_medium%" "check_fw=%MTP_chk_fw%" "patch_keygen=%MTP_prepatch_kg%" "ch_base=%MTP_prechk_Base%" "ch_other=%MTP_prechk_Upd%" "install_mode=%MTP_ptch_inst_spec%" "st_crypto=%MTP_stc_installs%"

ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:F_TR
cls
call :program_logo
echo -------------------------------------------------
echo MTP - MODE DE TRANSFERT DE FICHIERS ACTIVÉ
echo -------------------------------------------------
echo *******************************************************
echo SÉLECTIONNEZ LA FONCTION
echo *******************************************************
echo.
echo 1. TRANSFERT DE FICHIERS À PARTIR DE FICHIERS LOCAUX
echo 2. TRANSFERT DE FICHIERS À PARTIR DE BIBLIOTHÈQUES DISTANTES (GDRIVE)
echo 3. CRÉER XCI ET TRANSFÉRER
echo 4. CRÉER MULTI-XCI ET TRANSFÉRER
echo. 
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto F_TR_LOCAL
if /i "%bs%"=="2" goto F_TR_GD
if /i "%bs%"=="3" goto F_TR_C_xci_Transfer
if /i "%bs%"=="4" goto F_TR_C_mxci_Transfer
goto F_TR

:F_TR_LOCAL
call "%prog_dir%ztools\MtpFTLocal_fr.bat"
goto MAIN
:F_TR_GD
call "%prog_dir%ztools\MtpTransferRemote_fr.bat"
goto MAIN
:F_TR_C_xci_Transfer
call "%prog_dir%ztools\MtpCxciFTLocal_fr.bat"
goto MAIN
:F_TR_C_mxci_Transfer
call "%prog_dir%ztools\MtpCmxciFTLocal_fr.bat"
goto MAIN

:AUTOUPDATE
cls
call :program_logo
:select_medium_AUTOUPDATE
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

if %medium%=="none" goto select_medium_AUTOUPDATE
:set_auto_AUTOUPDATE
echo *******************************************************
echo Installation automatique?
echo *******************************************************
echo.
echo 1. COMMENCER L'INSTALLATION APRÈS LA DÉTECTION D'UN NOUVEAU CONTENU (CONTRÔLES INSTALLÉS)
echo 2. SÉLECTIONNER LE CONTENU À INSTALLER (CONTRÔLES INSTALLÉS)
echo 3. SÉLECTIONNER LE CONTENU À INSTALLER (UTILISER LE REGISTRE, INCL. ARCHIVÉ ET REG. XCI)
echo. 
ECHO *********************************************
echo Tapez "0" pour revenir à la liste des options
echo Tapez "b" pour aller au menu précédent
ECHO *********************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set autoupd_aut=none
set "use_archived=False"
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" set "autoupd_aut=True"
if /i "%bs%"=="2" set "autoupd_aut=False"
if /i "%bs%"=="3" set "autoupd_aut=False"
if /i "%bs%"=="3" set "use_archived=True"
if /i "%bs%"=="b" goto select_medium_AUTOUPDATE

if %autoupd_aut%=="none" goto set_auto_AUTOUPDATE

:set_source_AUTOUPDATE
echo *******************************************************
echo SOURCE pour mise à jour automatique
echo *******************************************************
echo.
echo 1. Mise à jour automatique à partir des bibliothèques locales
echo 2. Mise à jour automatique à partir des bibliothèque distante (GOOGLE DRIVE)
echo. 
ECHO *********************************************
echo Tapez "0" pour revenir à la liste des options
echo Tapez "b" pour aller au menu précédent
ECHO *********************************************
echo.
set /p bs="Faite votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto AUTOUPDATE_LOCAL
if /i "%bs%"=="2" goto AUTOUPDATE_GD
if /i "%bs%"=="b" goto set_auto_AUTOUPDATE

if %autoupd_aut%=="none" goto set_auto_AUTOUPDATE

:AUTOUPDATE_GD
CD /d "%prog_dir%"
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_gdrive update_console_from_gd -xarg "libraries=update" "destiny=%medium%" "exclude_xci=%MTP_exclude_xci_autinst%" "prioritize_nsz=%MTP_prioritize_NSZ%" "%prog_dir%MTP1GD.txt" "verification=%MTP_verification%" "ch_medium=%MTP_aut_ch_medium%" "ch_other=%MTP_prechk_Upd%" "autoupd_aut=%autoupd_aut%" "archived=%use_archived%"
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:AUTOUPDATE_LOCAL
CD /d "%prog_dir%"
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller update_console -xarg "libraries=all" "destiny=%medium%" "exclude_xci=%MTP_exclude_xci_autinst%" "prioritize_nsz=%MTP_prioritize_NSZ%" "%prog_dir%MTP1.txt" "verification=%MTP_verification%" "ch_medium=%MTP_aut_ch_medium%" "ch_other=%MTP_prechk_Upd%" "autoupd_aut=%autoupd_aut%" "archived=%use_archived%"

echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:INSTALLED
cls
call :program_logo
echo.
echo 1. DUMPER le contenu installé
echo 2. DÉSINSTALLER LE CONTENU
echo 3. SUPPRIMER LES JEUX ARCHIVÉS
echo. 
ECHO *********************************************
echo Tapez "0" pour revenir à la liste des options
ECHO *********************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto dump_games
if /i "%bs%"=="2" goto uninstall_games
if /i "%bs%"=="3" goto delete_archived
goto INSTALLED

:dump_games
echo.
ECHO ******************************************
echo DUMPER le contenu
ECHO ******************************************
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_game_manager dump_content
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:uninstall_games
echo.
ECHO ******************************************
echo désintallateur de contenu
ECHO ******************************************
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_game_manager uninstall_content
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:delete_archived
echo.
ECHO ******************************************
echo SUPPRIMER LES JEUX ARCHIVÉS
ECHO ******************************************
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_game_manager delete_archived
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:SAVES_wrongchoice
echo Mauvais choix
echo .............
:SAVES
cls
call :program_logo
echo.
ECHO ******************************************
echo Dumper les sauvegardes de jeux
ECHO ******************************************
echo.
echo 1. DUMP TOUTES LES SAUVEGARDES
echo 2. SÉLECTIONNEZ CE QUI DOIT ÊTRE DUMPER
echo 3. SAUVEGARDE UNIQUEMENT INSTALLÉE EN COURS (DBI 155 ou plus récent)
echo.
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set backup_all=none
set onlyinstalled=none
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" set "backup_all=True"
if /i "%bs%"=="1" set "onlyinstalled=False"
if /i "%bs%"=="2" set "backup_all=False"
if /i "%bs%"=="2" set "onlyinstalled=False"
if /i "%bs%"=="3" set "backup_all=True"
if /i "%bs%"=="3" set "onlyinstalled=True"
if %backup_all%=="none" goto SAVES_wrongchoice

%pycommand% "%squirrel_lb%" -lib_call mtp.mtp_game_manager back_up_saves -xarg  %backup_all% %MTP_saves_Inline% %MTP_saves_AddTIDandVer% %romaji% "" %onlyinstalled%
echo.
ECHO ------------------------------------------------------------
ECHO *********** TOUS LES FICHIERS ONT ÉTÉ TRAITÉS! *************
ECHO ------------------------------------------------------------
goto s_exit_choice

:SX_AUTOLOADER
cls
call :program_logo
echo.
ECHO ******************************************
echo OPTIONS DE CHARGEUR AUTOMATIQUE SX
ECHO ******************************************
echo.
echo 1. GÉNÉRER DES FICHIERS AUTOLOADER SX POUR LES JEUX SD
echo 2. GÉNÉRER DES FICHIERS SX AUTOLOADER POUR LES JEUX HDD
echo 3. Envoyer les fichier SX AUTOLOADER vers la console
echo 4. VÉRIFIEZ ET NETTOYEZ LES FICHIERS DU CHARGEUR AUTOMATIQUE (POUR ÉVITER LA COLLISION ENTRE SD ET HDD))
echo.
ECHO ************************************************
echo Ou tapez "0" pour revenir à la liste des options
ECHO ************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set backup_all=none
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtp_game_manager gen_sx_autoloader_sd_files )
if /i "%bs%"=="1" goto s_exit_choice
if /i "%bs%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtp_tools gen_sx_autoloader_files_menu )
if /i "%bs%"=="2" goto s_exit_choice
if /i "%bs%"=="3" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtp_tools push_sx_autoloader_libraries )
if /i "%bs%"=="3" goto s_exit_choice
if /i "%bs%"=="4" ( %pycommand% "%squirrel_lb%" -lib_call mtp.mtp_tools cleanup_sx_autoloader_files )
if /i "%bs%"=="4" goto s_exit_choice
goto SX_AUTOLOADER

:s_exit_choice
if exist MTP1.txt del MTP1.txt
if /i "%va_exit%"=="true" echo LE PROGRAMME SE FERME MAINTENANT
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir à la sélection du mode
echo Tapez "1" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto MAIN
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:DEV_INF_wrongchoice
echo Mauvais choix
echo .............
:DEV_INF
cls
call :program_logo
ECHO ******************************************
echo INFORMATION
ECHO ******************************************
echo Tapez "1" pour afficher les informations sur la console
echo Tapez "2" pour afficher les jeux installés et xci sur la console
echo Tapez "3" pour afficher la liste des nouvelles mises à jour ou dlcs disponibles pour les jeux prêts à jouer
echo Tapez "4" pour afficher les jeux archivés
echo Tapez "5" pour afficher la liste des nouvelles mises à jour ou dlcs disponibles pour les JEUX ARCHIVÉS
echo.
ECHO *********************************************
echo Tapez "0" pour revenir à la liste des options
ECHO *********************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="1" goto DEV_INF2
if /i "%bs%"=="2" goto GAMES_INSTALLED_INFO
if /i "%bs%"=="3" goto NC_AVAILABLE_INFO
if /i "%bs%"=="4" goto ARCHIVED_GAMES_INFO
if /i "%bs%"=="5" goto NC_ARCHIVED_GAMES_INFO
if /i "%bs%"=="0" goto MAIN
goto DEV_INF_wrongchoice

:DEV_INF2
cls
call :program_logo
echo.
"%MTP%" ShowInfo
echo.
PAUSE
goto DEV_INF

:GAMES_INSTALLED_INFO
cls
call :program_logo
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller get_installed_info -xarg "" False "exclude_homebrew=True" "exclude_xci=False"
echo.
PAUSE
goto DEV_INF

:NC_AVAILABLE_INFO
cls
call :program_logo
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller get_installed_info -xarg "" True "exclude_homebrew=True" "exclude_xci=False"
echo.
PAUSE
goto DEV_INF

:ARCHIVED_GAMES_INFO
cls
call :program_logo
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller get_archived_info -xarg False "exclude_homebrew=True" "exclude_xci=False"
echo.
PAUSE
goto DEV_INF

:NC_ARCHIVED_GAMES_INFO
cls
call :program_logo
echo.
%pycommand% "%squirrel_lb%" -lib_call mtp.mtpinstaller get_archived_info -xarg True "exclude_homebrew=True" "exclude_xci=False"
echo.
PAUSE
goto DEV_INF

::///////////////////////////////////////////////////
::NSCB_options.cmd configuration script
::///////////////////////////////////////////////////
:OPT_CONFIG
call "%batconfig%" "%op_file%" "%listmanager%" "%batdepend%"
cls
goto TOP_INIT

:contador_MTP1
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (MTP1.txt) do (
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
echo amusez-vous bien
exit /B

:call_main
call "%prog_dir%\NSCB_fr.bat"
exit /B

:salida
::pause
exit
