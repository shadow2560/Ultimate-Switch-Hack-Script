:sc1
set "op_file=%~1"
set "listmanager=%~2"
set "batdepend=%~3"
cls
call :logo
echo ********************************************************
echo OPTION - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour les options du mode automatique
echo Tapez "2" pour les OPTIONS globales et manuelles.
echo Tapez "3" pour vérifier le fichier KEYS.TXT 
echo tapez "4" pour la mise à jour de NUTDB
echo Tapez "5" pour les options de l'interface
echo Tapez "6" pour les options du serveur
echo Tapez "7" pour les options de GOOGLE DRIVE
echo Tapez "8" pour les options  MTP
echo.
echo Tapez "c" pour voir le profile actuel
echo Tapez "d" pour remettre les paramètres par défaut
echo Tapez "0" pour revenir au menu principal du script
echo .......................................................
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto sc2
if /i "%bs%"=="2" goto sc3
if /i "%bs%"=="3" goto verify_keys
if /i "%bs%"=="4" goto update_nutdb
if /i "%bs%"=="5" goto interface
if /i "%bs%"=="6" goto server
if /i "%bs%"=="7" goto google_drive
if /i "%bs%"=="8" goto MTP

if /i "%bs%"=="c" call :curr_set1
if /i "%bs%"=="c" call :curr_set2
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set1
if /i "%bs%"=="d" call :def_set2
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause

if /i "%bs%"=="0" goto salida
echo Choix inexistant.
echo.
goto sc1

:sc2
cls
call :logo
echo ********************************************************
echo AUTO-MODE - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour changer le paramètre de réempactage
echo Tapez "2" pour changer le traitement d'un répertoire
echo Tapez "3" pour changer la configuration du patchage RSV
echo Tapez "4" pour changer la configuration de la KEYGENERATION (crypto des NCA)
echo.
echo Tapez "c" pour connaître les paramètres du mode automatique
echo Tapez "d" pour régler les paramètres par défaut du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo .............................................................................
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto op_repack
if /i "%bs%"=="2" goto op_pfolder
if /i "%bs%"=="3" goto op_RSV
if /i "%bs%"=="4" goto op_KGEN

if /i "%bs%"=="c" call :curr_set1
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set1
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause
if /i "%bs%"=="d" goto sc1

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo Choix inexistant.
echo.
goto sc2

:op_repack
cls
call :logo
echo *******************************************************
echo Configuration du réempactage
echo *******************************************************
echo Option de réempactage pour le mode automatique
echo ....................................................................
echo Tapez "1" pour réempacter en NSP
echo Tapez "2" pour réempacter en XCI
echo Tapez "3" pour réempacter dans les deux formats
echo Tapez "4" pour supprimer les DELTAS des mises à jour
echo Tapez "5" pour reconstruire les NSPS par ordre croissant des cnmt
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...................................................................
echo.
set /p bs="Faites votre choix: "
set "v_rep=none"
if /i "%bs%"=="1" set "v_rep=nsp"
if /i "%bs%"=="2" set "v_rep=xci"
if /i "%bs%"=="3" set "v_rep=both"
if /i "%bs%"=="4" set "v_rep=nodelta"
if /i "%bs%"=="5" set "v_rep=rebuild"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_rep%"=="none" echo Choix inexistant
if "%v_rep%"=="none" echo.
if "%v_rep%"=="none" goto op_repack

set v_rep="vrepack=%v_rep%"
set v_rep="%v_rep%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "57" -nl "set %v_rep%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc2

:op_pfolder
cls
call :logo
echo **********************************************************************
echo traitement de répertoire
echo **********************************************************************
echo Comment traiter un répertoire en mode automatique?
echo ..................................................................................................
echo Tapez "1" pour réempacter les fichiers du répertoire individuellement (un fichier pour un contenu)
echo Tapez "2" pour réempacter les fichiers du répertoire ensemble (1 fichier incluant tout le contenu)
echo Tapez "3" pour réempacter les fichiers du dossier par ID BASE
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ..................................................................................................
echo.
set /p bs="Faites votre choix: "
set "v_fold=none"
if /i "%bs%"=="1" set "v_fold=indiv"
if /i "%bs%"=="2" set "v_fold=multi"
if /i "%bs%"=="3" set "v_fold=baseid"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_fold%"=="none" echo Choix inexistant.
if "%v_fold%"=="none" echo.
if "%v_fold%"=="none" goto op_pfolder

set v_fold="fi_rep=%v_fold%"
set v_fold="%v_fold%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "61" -nl "set %v_fold%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc2

:op_RSV
cls
call :logo
echo ***************************************************************************
echo Patch de la version du système requise
echo ***************************************************************************
echo Patch de la version du système requise via les meta des NCA en mode automatique
echo ...............................................................................
echo Patch la version du système requise, permettant que la console ne demande pas 
echo de mettre à jour sur le firmware requis pour lire le jeu.
echo.
echo Tapez "1" pour patcher la version du système requise dans les  meta NCA
echo Tapez "2" pour ne pas patcher la version du système requise dans les  meta NCA
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ..............................................................................
echo.
set /p bs="Faites votre choix: "
set "v_RSV=none"
if /i "%bs%"=="1" set "v_RSV=-pv true"
if /i "%bs%"=="2" set "v_RSV=-pv false"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_RSV%"=="none" echo Choix inexistant.
if "%v_RSV%"=="none" echo.
if "%v_RSV%"=="none" goto op_RSV

set v_RSV="patchRSV=%v_RSV%"
set v_RSV="%v_RSV%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "41" -nl "set %v_RSV%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc2

:op_KGEN
cls
call :logo
echo ***************************************************************************
echo Patcher si la KEYGENERATION est plus grande que
echo ***************************************************************************
echo Changer la  KEYGENERATION si elle est plus grande que le numéro configuré ici en mode automatique.
echo ............................................................................................................
echo Change la kegeneration et recalcul le keyblock pour utiliser une masterkey inférieur pour décrypter les NCA.
echo.
echo Tapez "f" pour ne pas changer la keygeneration
echo Tapez "0" pour configurer la keygeneration à 0 (FW 1.0)
echo Tapez "1" pour configurer la keygeneration à 1 (FW 2.0-2.3)
echo Tapez "2" pour configurer la keygeneration à 2 (FW 3.0)
echo Tapez "3" pour configurer la keygeneration à 3 (FW 3.0.1-3.02)
echo Tapez "4" pour configurer la keygeneration à 4 (FW 4.0.0-4.1.0)
echo Tapez "5" pour configurer la keygeneration à 5 (FW 5.0.0-5.1.0)
echo Tapez "6" pour configurer la keygeneration à 6 (FW 6.0.0-6.1.0)
echo Tapez "7" pour configurer la keygeneration à 7 (FW 6.2.0)
echo Tapez "8" pour configurer la keygeneration à 8 (FW 7.0.0-8.0.1)
echo Tapez "9" pour configurer la keygeneration à 9 (FW 8.1.0)
echo Tapez "10" pour configurer la keygeneration à 10 (FW 9.0.0-9.01)
echo Tapez "11" pour configurer la keygeneration à 11 (FW 9.1.0-10.2.0)
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "c" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ............................................................................................................
echo.
set /p bs="Faites votre choix: "
set "v_KGEN=none"
set "v_CAPRSV=0"
if /i "%bs%"=="f" set "v_KGEN=-kp false"
if /i "%bs%"=="0" set "v_KGEN=-kp 0"
if /i "%bs%"=="0" set "v_CAPRSV=--RSVcap 0"
if /i "%bs%"=="1" set "v_KGEN=-kp 1"
if /i "%bs%"=="1" set "v_CAPRSV=--RSVcap 65796"
if /i "%bs%"=="2" set "v_KGEN=-kp 2"
if /i "%bs%"=="2" set "v_CAPRSV=--RSVcap 201327002"
if /i "%bs%"=="3" set "v_KGEN=-kp 3"
if /i "%bs%"=="3" set "v_CAPRSV=--RSVcap 201392178"
if /i "%bs%"=="4" set "v_KGEN=-kp 4"
if /i "%bs%"=="4" set "v_CAPRSV=--RSVcap 268435656"
if /i "%bs%"=="5" set "v_KGEN=-kp 5"
if /i "%bs%"=="5" set "v_CAPRSV=--RSVcap 335544750"
if /i "%bs%"=="6" set "v_KGEN=-kp 6"
if /i "%bs%"=="6" set "v_CAPRSV=--RSVcap 402653494"
if /i "%bs%"=="7" set "v_KGEN=-kp 7"
if /i "%bs%"=="7" set "v_CAPRSV=--RSVcap 404750336"
if /i "%bs%"=="8" set "v_KGEN=-kp 8"
if /i "%bs%"=="8" set "v_CAPRSV=--RSVcap 469762048"
if /i "%bs%"=="9" set "v_KGEN=-kp 9"
if /i "%bs%"=="9" set "v_CAPRSV=--RSVcap 537919488"
if /i "%bs%"=="10" set "v_KGEN=-kp 10"
if /i "%bs%"=="10" set "v_CAPRSV=--RSVcap 603979776"
if /i "%bs%"=="11" set "v_KGEN=-kp 11"
if /i "%bs%"=="11" set "v_CAPRSV=--RSVcap 605028352"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="c" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_RSV%"=="none" echo Choix inexistant
if "%v_RSV%"=="none" echo.
if "%v_RSV%"=="none" goto op_RSV

set v_KGEN="vkey=%v_KGEN%"
set v_KGEN="%v_KGEN%"
set v_CAPRSV="capRSV=%v_CAPRSV%"
set v_CAPRSV="%v_CAPRSV%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "95" -nl "set %v_KGEN%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "42" -nl "set %v_CAPRSV%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "La ligne de configuration a été modifiée en: "
%pycommand% "%listmanager%" -rl "%op_file%" -ln "42" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc2

:sc3
cls
call :logo
echo **********************************************
echo configuration des options globales
echo **********************************************
echo Tapez "1" pour changer la couleur du texte et du fond
echo Tapez "2" -pour changer le nom du répertoire de travail (répertoire temporaire)
echo Tapez "3" pour changer le nom du répertoire de sortie
echo Tapez "4" Pour changer le traitement des fichiers DELTA
echo Tapez "5" pour changer la configuration zip (cré ou non un fichier zip contenant les NCA)
echo Tapez "6" pour changer l'option de sortie automatique du script
echo Tapez "7" pour configurer l'affichage du message concernant le réglage de la KEY-GENERATION
echo Tapez "8" pour régler le buffer
echo Tapez "9" pour régler les options EXFAT/FAT32
echo Tapez "10" pour régler comment organiser les fichiers en sortie
echo Tapez "11" pour définir le nouveau mode ou l'ancien mode
echo Tapez "12" pour ROMANIZE les noms lors de l'utilisation de direct-multi
echo Tapez "13" pour traduire les lignes de description du jeu dns les informations du fichier
echo Tapez "14" pour changer le nombre de WORKERS IN THREADED OPERATIONS
echo Tapez "15" pour configurer la compression NSZ
echo Tapez "16" pour configurer la compression XCI
echo.
echo Tapez "c" pour voir les paramètres globaux courant
echo Tapez "d" pour remettre les paramètres globaux par défaut
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set /p bs="Faites votre choix: "

if /i "%bs%"=="1" goto op_color
if /i "%bs%"=="2" goto op_wfolder
if /i "%bs%"=="3" goto op_ofolder
if /i "%bs%"=="4" goto op_delta
if /i "%bs%"=="5" goto op_zip
if /i "%bs%"=="6" goto op_aexit
if /i "%bs%"=="7" goto op_kgprompt
if /i "%bs%"=="8" goto op_buffer
if /i "%bs%"=="9" goto op_fat
if /i "%bs%"=="10" goto op_oforg
if /i "%bs%"=="11" goto op_nscbmode
if /i "%bs%"=="12" goto op_romanize
if /i "%bs%"=="13" goto op_translate
if /i "%bs%"=="14" goto op_threads
if /i "%bs%"=="15" goto op_NSZ1
if /i "%bs%"=="16" goto op_NSZ3

if /i "%bs%"=="c" call :curr_set2
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set2
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause
if /i "%bs%"=="d" goto sc1

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

echo Choix inexistant.
echo.
goto sc3

:op_color
cls
call :logo
echo ********************************************************
echo configuration des couleurs
echo ********************************************************
echo --------------------------------------------------------
echo COULEUR DE PREMIER PLAN (Couleur du texte)
echo --------------------------------------------------------
echo Tapez "1" pour changer la couleur du texte en blanc clair (défaut)
echo Tapez "2" pour changer la couleur du texte en noir
echo Tapez "3" pour changer la couleur du texte en bleu
echo Tapez "4" pour changer la couleur du texte en vert
echo Tapez "5" pour changer la couleur du texte en AQUA
echo Tapez "6" pour changer la couleur du texte en rouge
echo Tapez "7" pour changer la couleur du texte en pourpre
echo Tapez "8" pour changer la couleur du texte en jaune
echo Tapez "9" pour changer la couleur du texte en blanc
echo Tapez "10" pour changer la couleur du texte en gris
echo Tapez "11" pour changer la couleur du texte en bleu clair
echo Tapez "12" pour changer la couleur du texte en vert clair
echo Tapez "13" pour changer la couleur du texte en AQUA clair
echo Tapez "14" pour changer la couleur du texte en rouge clair
echo Tapez "15" pour changer la couleur du texte en pourpre clair
echo Tapez "16" pour changer la couleur du texte en jaune clair
echo.
echo Tapez "d" pour remettre la couleur du texte par défaut
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set /p bd="Faite votre choix: "

set "v_colF=F"
if /i "%bd%"=="1" set "v_colF=F"
if /i "%bd%"=="2" set /a "v_colF=0"
if /i "%bd%"=="3" set /a "v_colF=3"
if /i "%bd%"=="4" set /a "v_colF=1"
if /i "%bd%"=="5" set /a "v_colF=2"
if /i "%bd%"=="6" set /a "v_colF=4"
if /i "%bd%"=="7" set /a "v_colF=5"
if /i "%bd%"=="8" set /a "v_colF=6"
if /i "%bd%"=="9" set /a "v_colF=7"
if /i "%bd%"=="10" set /a "v_colF=8"
if /i "%bd%"=="11" set /a "v_colF=9"
if /i "%bd%"=="12" set "v_colF=A"
if /i "%bd%"=="13" set "v_colF=B"
if /i "%bd%"=="14" set "v_colF=C"
if /i "%bd%"=="15" set "v_colF=D"
if /i "%bd%"=="16" set "v_colF=E"

if /i "%bd%"=="d" set "v_colF=F"
if /i "%bd%"=="d" set /a "v_colB=1"
if /i "%bd%"=="d" goto do_set_col

if /i "%bd%"=="b" goto sc3
if /i "%bd%"=="0" goto sc1
if /i "%bd%"=="e" goto salida

echo -----------------------------------------------------
echo Couleur de fond
echo -----------------------------------------------------
echo Tapez "1" pour changer la couleur de fond en bleu (défaut)
echo Tapez "2" pour changer la couleur de fond en noir
echo Tapez "3" pour changer la couleur de fond en vert
echo Tapez "4" pour changer la couleur de fond en AQUA
echo Tapez "5" pour changer la couleur de fond en rouge
echo Tapez "6" pour changer la couleur de fond en pourpre
echo Tapez "7" pour changer la couleur de fond en jaune
echo Tapez "8" pour changer la couleur de fond en blanc
echo Tapez "9" pour changer la couleur de fond en gris
echo Tapez "10" pour changer la couleur de fond en blanc clair
echo Tapez "11" pour changer la couleur de fond en bleu clair
echo Tapez "12" pour changer la couleur de fond en vert clair
echo Tapez "13" pour changer la couleur de fond en AQUA clair
echo Tapez "14" pour changer la couleur de fond en rouge clair
echo Tapez "15" pour changer la couleur de fond en pourpre clair
echo Tapez "16" pour changer la couleur de fond en jaune clair
echo.
echo Tapez "d" pour remettre la couleur de fond par défaut
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set /p bs="Faites votre choix: "

set /a "v_colB=1"
if /i "%bs%"=="1" set /a "v_colB=1"
if /i "%bs%"=="2" set /a "v_colB=0"
if /i "%bs%"=="3" set /a "v_colB=2"
if /i "%bs%"=="4" set /a "v_colB=3"
if /i "%bs%"=="5" set /a "v_colB=4"
if /i "%bs%"=="6" set /a "v_colB=5"
if /i "%bs%"=="7" set /a "v_colB=6"
if /i "%bs%"=="8" set /a "v_colB=7"
if /i "%bs%"=="9" set /a "v_colB=8"
if /i "%bs%"=="10" set "v_colB=F"
if /i "%bs%"=="11" set /a "v_colB=9"
if /i "%bs%"=="12" set "v_colB=A"
if /i "%bs%"=="13" set "v_colB=B"
if /i "%bs%"=="14" set "v_colB=C"
if /i "%bs%"=="15" set "v_colB=D"
if /i "%bs%"=="16" set "v_colB=E"

if /i "%bs%"=="d" set "v_colF=F"
if /i "%bs%"=="d" set /a "v_colB=1"
if /i "%bs%"=="d" goto do_set_col

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

:do_set_col
setlocal enabledelayedexpansion
set "v_col=!v_colB!!v_colF!"
color !v_col!
%pycommand% "%listmanager%" -cl "%op_file%" -ln "3" -nl "couleur !v_col!"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "La ligne de configuration a été modifiée en: "
endlocal
echo.
pause
goto sc3

:op_wfolder
cls
call :logo
echo **************************************
echo Configuration du répertoire de travail
echo **************************************
echo Tapez "1" pour remettre le répertoire de travail par défaut
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set /p bs="Ou entrez un nouveau nom: "
set "v_wf=%bs%"
if /i "%bs%"=="1" set "v_wf=NSCB_temp"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

set v_wf="w_folder=%v_wf%"
set v_wf="%v_wf%"

%pycommand% "%listmanager%" -cl "%op_file%" -ln "8" -nl "set %v_wf%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3


:op_ofolder
cls
call :logo
echo *************************************
echo Configuration du répertoire de sortie
echo *************************************
echo Tapez "1" pour remettre le répertoire de sortie par défaut
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set /p bs="Ou entrez un nouveau nom: "
set "v_of=%bs%"
if /i "%bs%"=="1" set "v_of=NSCB_output"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

set v_of="fold_output=%v_of%"
set v_of="%v_of%"

%pycommand% "%listmanager%" -cl "%op_file%" -ln "10" -nl "set %v_of%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3


:op_delta
cls
call :logo
echo ***************************************************************************
echo Configuration du traitement des fichiers DELTA
echo ***************************************************************************
echo Passer les fichiers NCA DELTA lors de l'extraction d'une mise à jour
echo ..........................................................................................................
echo Les deltas servent à convertir une mise à jour précédente vers la nouvelle, 
echo les mises à jour peuvent contenir la mise à jour complète et les deltas. 
echo Les deltas sont nossives et non nécessaires pour les  xci, ils peuvent servir 
echo à installer un NSP plus rapidement et à convertir une précédente mise à jour vers la nouvelle. 
echo Sans les deltas la mise à jour précédente restera dans le système et devra être désinstallée manuellement.
echo.
echo Tapez "1" pour passer les fichiers  deltas (configuration par défaut)
echo Tapez "2" pour réempacter les fichiers deltas
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ..........................................................................................................
echo.
set /p bs="Faites votre choix: "
set "v_delta=none"
if /i "%bs%"=="1" set "v_delta=--C_clean_ND"
if /i "%bs%"=="1" set "v_delta2_=-ND true"
if /i "%bs%"=="2" set "v_delta=--C_clean"
if /i "%bs%"=="2" set "v_delta2_=-ND false"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_delta%"=="none" echo Choix inexistant.
if "%v_delta%"=="none" echo.
if "%v_delta%"=="none" goto op_delta

set v_delta="nf_cleaner=%v_delta%"
set v_delta="%v_delta%"
set v_delta2_="skdelta=%v_delta2_%"
set v_delta2_="%v_delta2_%"

%pycommand% "%listmanager%" -cl "%op_file%" -ln "36" -nl "set %v_delta%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "La ligne de configuration a été modifiée en: "
echo.
%pycommand% "%listmanager%" -cl "%op_file%" -ln "37" -nl "set %v_delta2_%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "37" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_zip
cls
call :logo
echo ***************************************************************************
echo Génération de fichiers zip
echo ***************************************************************************
echo Génère des fichiers ZIP contenant les KEYBLOCK et les informations du fichier
echo ...........................................................................
echo.
echo Tapez "1" pour générer les fichiers zip 
echo Tapez "2" pour ne pas générer de fichiers zip (configuration par défaut)
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_gzip=none"
if /i "%bs%"=="1" set "v_gzip=true"
if /i "%bs%"=="2" set "v_gzip=false"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_gzip%"=="none" echo Choix inexistant.
if "%v_gzip%"=="none" echo.
if "%v_gzip%"=="none" goto op_zip

set v_gzip="zip_restore=%v_gzip%"
set v_gzip="%v_gzip%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "78" -nl "set %v_gzip%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_aexit
cls
call :logo
echo ***************************************************************************
echo Configuration de la sortie automatique du script en mode manuel
echo ***************************************************************************
echo Quitter le script automatiquement à la fin du traitement ou demander d'appuyez sur une touche pour continuer.
echo ...........................................................................
echo.
echo Tapez "1" pour désactiver la sortie automatique (configuration par défaut)
echo Tapez "2" pour activer la sortie automatique
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_exit=none"
if /i "%bs%"=="1" set "v_exit=false"
if /i "%bs%"=="2" set "v_exit=true"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_exit%"=="none" echo Choix inexistant.
if "%v_exit%"=="none" echo.
if "%v_exit%"=="none" goto op_aexit

set v_exit="va_exit=%v_exit%"
set v_exit="%v_exit%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "101" -nl "set %v_exit%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_kgprompt
cls
call :logo
echo ******************************************************************************************************************
echo Voir ou non le message permettant de configurer la version du système requise et le changement de la KEYGENERATION
echo ******************************************************************************************************************
echo.
echo Tapez "1" pour voir le message de configuration du RSV (option par défaut)
echo Tapez "2" pour ne pas voir le message de configuration du RSV (option par défaut)
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ..................................................................................................................
echo.
set /p bs="Faites votre choix: "
set "skipRSVprompt=none"
if /i "%bs%"=="1" set "skipRSVprompt=false"
if /i "%bs%"=="2" set "skipRSVprompt=true"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%skipRSVprompt%"=="none" echo Choix inexistant.
if "%skipRSVprompt%"=="none" echo.
if "%skipRSVprompt%"=="none" goto op_kgprompt

set skipRSVprompt="skipRSVprompt=%skipRSVprompt%"
set skipRSVprompt="%skipRSVprompt%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "108" -nl "set %skipRSVprompt%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_buffer
cls
call :logo
echo ******************************************************************************************
echo Régler le buffer pour la copie et l'ajout de fichier récupéré ou copier de/vers un NSP\XCI
echo ******************************************************************************************
echo Cette option affecte la vitesse de ces processus et dépend de votre système. 
echo Le buffer par défaut est réglé à 64kB.
echo.
echo Tapez "1" pour régler le buffer à 80kB
echo Tapez "2" pour régler le buffer à 72kB
echo Tapez "3" pour régler le buffer à 64kB (Default)
echo Tapez "4" pour régler le buffer à 56kB
echo Tapez "5" pour régler le buffer à 48kB
echo Tapez "6" pour régler le buffer à 40kB
echo Tapez "7" pour régler le buffer à 32kB
echo Tapez "8" pour régler le buffer à 24kB
echo Tapez "9" pour régler le buffer à 16kB
echo Tapez "10" pour régler le buffer à 8kB

echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_buffer=none"
if /i "%bs%"=="1" set "v_buffer=-b 81920"
if /i "%bs%"=="2" set "v_buffer=-b 73728"
if /i "%bs%"=="3" set "v_buffer=-b 65536"
if /i "%bs%"=="4" set "v_buffer=-b 57344"
if /i "%bs%"=="5" set "v_buffer=-b 49152"
if /i "%bs%"=="6" set "v_buffer=-b 40960"
if /i "%bs%"=="7" set "v_buffer=-b 32768"
if /i "%bs%"=="8" set "v_buffer=-b 24576"
if /i "%bs%"=="9" set "v_buffer=-b 16384"
if /i "%bs%"=="10" set "v_buffer=-b 8192"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_buffer%"=="none" echo Choix inexistant.
if "%v_buffer%"=="none" echo.
if "%v_buffer%"=="none" goto op_buffer

set v_buffer="buffer=%v_buffer%"
set v_buffer="%v_buffer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "32" -nl "set %v_buffer%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_fat
cls
call :logo
echo ***************************************************************************************************
echo Régler l'option permettant de générer des fichiers utilisables sur des cartes SD formatées en FAT32
echo ***************************************************************************************************
echo Le Rommenu de SX OS  supporte les fichiers ns0, ns1,.. pour les fichiers nsp splittés et également 
echo les fichiers 00, 01 dans un répertoire noté comme archivé, c'est pour cela que les deux options sont proposées. 
echo Les autres installeurs ne supporte quand à eux que l'option des répertoires archivées.
echo.
echo Tapez "1" pour utiliser le format exfat (option par défaut)
echo Tapez "2" pour utiliser le format FAT32 spécifique à SX OS (fichiers xc0 et ns0)
echo Tapez "3" pour utiliser le format FAT32 fat32 pour tous les CFWs (répertoire archivé)
echo.
echo Remarque: l'option de dossier d'archivage exporte les fichiers NSP sous forme de dossiers et de fichiers xci. 
echo fichiers fractionnés.
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_fat1=none"
set "v_fat2=none"
if /i "%bs%"=="1" set "v_fat1=-fat exfat"
if /i "%bs%"=="1" set "v_fat2=-fx files"
if /i "%bs%"=="2" set "v_fat1=-fat fat32"
if /i "%bs%"=="2" set "v_fat2=-fx files"
if /i "%bs%"=="3" set "v_fat1=-fat fat32"
if /i "%bs%"=="3" set "v_fat2=-fx folder"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_fat1%"=="none" echo Choix inexistant.
if "%v_fat1%"=="none" echo.
if "%v_fat1%"=="none" goto op_fat
if "%v_fat2%"=="none" echo WRONG CHOICE
if "%v_fat2%"=="none" echo.
if "%v_fat2%"=="none" goto op_fat

set v_fat1="fatype=%v_fat1%"
set v_fat1="%v_fat1%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "116" -nl "set %v_fat1%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "La ligne de configuration a été modifiée en: "
echo.
set v_fat2="fexport=%v_fat2%"
set v_fat2="%v_fat2%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "117" -nl "set %v_fat2%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_oforg
cls
call :logo
echo ***************************************************************************
echo Organisation des fichiers du répertoire de sortie
echo ***************************************************************************
echo.
echo Tapez "1" pour organiser les fichiers séparément (default)
echo Tapez "2" pour organiser les fichiers dans des répertoires selon le contenu
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_oforg=none"
if /i "%bs%"=="1" set "v_oforg=inline"
if /i "%bs%"=="2" set "v_oforg=subfolder"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_oforg%"=="none" echo Choix inexistant.
if "%v_oforg%"=="none" echo.
if "%v_oforg%"=="none" goto op_oforg

set v_oforg="oforg=%v_oforg%"
set v_oforg="%v_oforg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "125" -nl "set %v_oforg%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_nscbmode
cls
call :logo
echo ***************************************************************************
echo Démmarer le programme avec un nouveau mode ou un ancien
echo ***************************************************************************
echo.
echo Tapez "1" pour commencer avec un nouveau mode (par défaut)
echo Tapez "2" pour commencer avec l'ancien mode
echo.
echo Tapez "b" pour revenir aux options globales
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au programme principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_nscbmode=none"
if /i "%bs%"=="1" set "v_nscbmode=new"
if /i "%bs%"=="2" set "v_nscbmode=legacy"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_nscbmode%"=="none" echo Choix inexistant
if "%v_nscbmode%"=="none" echo.
if "%v_nscbmode%"=="none" goto op_nscbmode

set v_nscbmode="NSBMODE=%v_nscbmode%"
set v_nscbmode="%v_nscbmode%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "132" -nl "set %v_nscbmode%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "132" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_romanize
cls
call :logo
echo ***************************************************************************
echo ROMANIZE RESULTING NAMES FOR DIRECT MULTI FUNCTION
echo ***************************************************************************
echo.
echo Tapez "1" pour convertir les noms japonais\asian vers ROMAJI (par défaut)
echo Tapez "2" conserver les noms tels qu'ils sont lus sur  PREVALENT BASEFILE
echo.
echo Tapez "b" pour revenir aux options global
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_roma=none"
if /i "%bs%"=="1" set "v_roma=TRUE"
if /i "%bs%"=="2" set "v_roma=FALSE"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_roma%"=="none" echo Mauvais choix
if "%v_roma%"=="none" echo.
if "%v_roma%"=="none" goto op_romanize

set v_roma="romaji=%v_roma%"
set v_roma="%v_roma%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "139" -nl "set %v_roma%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "139" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_translate
cls
call :logo
echo *******************************************************************************
echo TRADUIRE LES LIGNES DE DESCRIPTION DE JEU EN ANGLAIS, JAPONAIS, CHINOIS, CORÉEN
echo *******************************************************************************
echo.
echo REMARQUE: contrairement à romaji pour les traductions, NSCB effectue des appels d'API à GOOGLE TRANSLATE
echo.
echo Tapez "1" pour traduire les descriptions (par défaut)
echo Tapez "2" pour conserver les descriptions lues dans les fichiers nutdb
echo.
echo Tapez "b" pour revenir aux OPTIONS GLOBAL
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au programme principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_trans=none"
if /i "%bs%"=="1" set "v_trans=TRUE"
if /i "%bs%"=="2" set "v_trans=FALSE"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_trans%"=="none" echo MAUVAIS CHOIX
if "%v_trans%"=="none" echo.
if "%v_trans%"=="none" goto op_translate

set v_trans="transnutdb=%v_trans%"
set v_trans="%v_trans%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "147" -nl "set %v_trans%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "147" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_threads
cls
call :logo
echo ***************************************************************************
echo SET NUMBER OF WORKERS FOR THREADED OPERATIONS
echo ***************************************************************************
echo Actuellement utilisé dans les modes Renomer et construcion de base de donnée
echo Pour plus de valeurs, éditez NSCB_options.cmd avec un éditeur de texte
echo.
echo Tapez "1"  pour utiliser 1 worker (défaut \ désactivé)
echo Tapez "2"  pour utiliser 5 workers
echo Tapez "3"  pour utiliser 10 workers
echo Tapez "4"  pour utiliser 20 workers
echo Tapez "5"  pour utiliser 30 workers
echo Tapez "6"  pour utiliser 40 workers
echo Tapez "7"  pour utiliser 50 workers
echo Tapez "8"  pour utiliser 60 workers
echo Tapez "9"  pour utiliser 70 workers
echo Tapez "10" pour utiliser 80 workers
echo Tapez "11" pour utiliser 90 workers
echo Tapez "12" pour utiliser 100 workers
echo.
echo Tapez "b" pour revenir aux OPTIONS GLOBAL
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au programme principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_workers=none"
if /i "%bs%"=="1" set "v_workers=-threads 1"
if /i "%bs%"=="2" set "v_workers=-threads 5"
if /i "%bs%"=="3" set "v_workers=-threads 10"
if /i "%bs%"=="4" set "v_workers=-threads 20"
if /i "%bs%"=="5" set "v_workers=-threads 30"
if /i "%bs%"=="6" set "v_workers=-threads 40"
if /i "%bs%"=="7" set "v_workers=-threads 50"
if /i "%bs%"=="8" set "v_workers=-threads 60"
if /i "%bs%"=="9" set "v_workers=-threads 70"
if /i "%bs%"=="10" set "v_workers=-threads 80"
if /i "%bs%"=="11" set "v_workers=-threads 90"
if /i "%bs%"=="12" set "v_workers=-threads 100"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_workers%"=="none" echo Mauvais choix
if "%v_workers%"=="none" echo.
if "%v_workers%"=="none" goto op_threads

set v_workers="workers=%v_workers%"
set v_workers="%v_workers%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "153" -nl "set %v_workers%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "153" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto sc3

:op_NSZ1
cls
call :logo
echo ***************************************************************************
echo Option de compression
echo ***************************************************************************
echo ************************
echo Niveau de compression
echo ************************
echo Entrez un niveau de compression compris entre 1 et 22
echo Notes:
echo  + Niveau 1 - Taux de compression rapide et réduit
echo  + Niveau 22 - Taux de compression lent mais meilleur
echo  Les niveaux 10-17 sont recommandés dans la spécification
echo.
echo Tapez "b" pour retourner aux options globales
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "e" pour retourner au menu principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_nszlevels=none"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="x" goto sc1
if /i "%bs%"=="e" goto salida

set "v_nszlevels=%bs%"
set v_nszlevels="compression_lv=%v_nszlevels%"
set v_nszlevels="%v_nszlevels%"
if "%v_nszlevels%"=="none" echo Mauvais choix
if "%v_nszlevels%"=="none" echo.
if "%v_nszlevels%"=="none" goto op_NSZ1
%pycommand% "%listmanager%" -cl "%op_file%" -ln "158" -nl "set %v_nszlevels%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "158" -nl "La ligne de configuration a été modifiée en: "
:op_NSZ2
echo.
echo *******************************************************
echo Nombre de THREADS a utiliser
echo *******************************************************
echo Entrez un nombre de threads à utiliser compris entre 0 et 4
echo Notes:
echo  + En utilisant les threads, vous pouvez gagner un peu de vitesse. 
echo    mais vous perdrez le taux de compression
echo  + Le niveau 22 et 4 threads risquent de manquer de mémoire
echo  + Pour un maximum de threads, une compression de niveau 17 est conseillée
echo    mais vous perdrez le taux de compression
echo.
echo Tapez "b" pour retourner aux options globales
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "e" pour retourner au menu principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set "v_nszthreads=none"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="x" goto sc1
if /i "%bs%"=="e" goto salida

set "v_nszthreads=%bs%"
set v_nszthreads="compression_threads=%v_nszthreads%"
set v_nszthreads="%v_nszthreads%"
if "%v_nszthreads%"=="none" echo Mauvais choix
if "%v_nszthreads%"=="none" echo.
if "%v_nszthreads%"=="none" goto op_NSZ2
%pycommand% "%listmanager%" -cl "%op_file%" -ln "159" -nl "set %v_nszthreads%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "159" -nl "La ligne de configuration a été modifiée en: "
pause
goto sc3
:op_NSZ3
echo.
echo *******************************************************
echo format d'exportation XCI
echo *******************************************************
echo.
echo Tapez "1"  pour exporter en tant que xcz -supertrimmed-(par défaut)
echo Tapez "2"  pour exporter en nsz
echo.
echo N'oubliez pas que tinfoil peut installer les deux formats, donc ce n'est pas
echo conseillé d'exporter en tant que nsz. Si vous voulez vraiment avoir
echo les nsz s'il vous plaît faites-le de cette façon pour faire le nca
echo de restauration des fichiers du jeu.
echo Remarque: cette restauration doit actuellement être décompressée
echo dans le fichier nsp d'abord une restauration directe sera mieux
echo inclus bientôt.
echo.echo.
echo Tapez "b" pour retourner aux option global
echo Tapez "x" pour retourner au menu de configuration
echo Tapez "e" pour retourner au programme principal
echo ...........................................................................
echo.
set "v_xcz_export=none"
set /p bs="Faites votre choix: "

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="x" goto sc1
if /i "%bs%"=="e" goto salida

if /i "%bs%"=="1" set "v_xcz_export=xcz"
if /i "%bs%"=="2" set "v_xcz_export=nsz"
set v_xcz_export="xci_export=%v_xcz_export%"
set v_xcz_export="%v_xcz_export%"
if "%v_xcz_export%"=="none" echo Mauvais choix
if "%v_xcz_export%"=="none" echo.
if "%v_xcz_export%"=="none" goto op_NSZ3
%pycommand% "%listmanager%" -cl "%op_file%" -ln "160" -nl "set %v_xcz_export%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "160" -nl "La ligne de configuration a été modifiée en: "
pause
goto sc3

:def_set1
echo.
echo **Options du mode automatique**
REM vrepack
set "v_rep=both"
set v_rep="vrepack=%v_rep%"
set v_rep="%v_rep%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "57" -nl "set %v_rep%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "La ligne de configuration a été modifiée en: "

REM fi_rep
set "v_fold=multi"
set v_fold="fi_rep=%v_fold%"
set v_fold="%v_fold%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "61" -nl "set %v_fold%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "La ligne de configuration a été modifiée en: "

REM v_RSV
set "v_RSV=-pv false"
set v_RSV="patchRSV=%v_RSV%"
set v_RSV="%v_RSV%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "41" -nl "set %v_RSV%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "La ligne de configuration a été modifiée en: "

REM vkey
set "v_KGEN=-kp false"
set v_KGEN="vkey=%v_KGEN%"
set v_KGEN="%v_KGEN%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "95" -nl "set %v_KGEN%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "La ligne de configuration a été modifiée en: "

exit /B

:def_set2
echo.
echo **Paramètres globaux**
REM OP_COLOR
set "v_colF=F"
set /a "v_colB=1"
setlocal enabledelayedexpansion
set "v_col=!v_colB!!v_colF!"
color !v_col!
%pycommand% "%listmanager%" -cl "%op_file%" -ln "3" -nl "color !v_col!"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "La ligne de configuration a été modifiée en: "
endlocal

REM w_folder
set "v_wf=NSCB_temp"
set v_wf="w_folder=%v_wf%"
set v_wf="%v_wf%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "8" -nl "set %v_wf%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "La ligne de configuration a été modifiée en: "

REM v_of
set "v_of=NSCB_output"
set v_of="fold_output=%v_of%"
set v_of="%v_of%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "10" -nl "set %v_of%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "La ligne de configuration a été modifiée en: "

REM v_delta
set "v_delta=--C_clean_ND"
set v_delta="nf_cleaner=%v_delta%"
set v_delta="%v_delta%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "36" -nl "set %v_delta%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "La ligne de configuration a été modifiée en: "

REM v_delta2
set "v_delta2_=-ND true"
set v_delta2_="skdelta=%v_delta2_%"
set v_delta2_="%v_delta2_%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "37" -nl "set %v_delta2_%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "37" -nl "La ligne de configuration a été modifiée en: "

REM zip_restore
set "v_gzip=false"
set v_gzip="zip_restore=%v_gzip%"
set v_gzip="%v_gzip%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "78" -nl "set %v_gzip%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "La ligne de configuration a été modifiée en: "

REM AUTO-EXIT
set "v_exit=false"
set v_exit="va_exit=%v_exit%"
set v_exit="%v_exit%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "101" -nl "set %v_exit%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "La ligne de configuration a été modifiée en: "

REM skipRSVprompt
set "skipRSVprompt=false"
set skipRSVprompt="skipRSVprompt=%skipRSVprompt%"
set skipRSVprompt="%skipRSVprompt%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "108" -nl "set %skipRSVprompt%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "La ligne de configuration a été modifiée en: "

REM buffer
set "v_buffer=-b 65536"
set v_buffer="buffer=%v_buffer%"
set v_buffer="%v_buffer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "32" -nl "set %v_buffer%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "La ligne de configuration a été modifiée en: "


REM FAT format
set "v_fat1=-fat exfat"
set v_fat1="fatype=%v_fat1%"
set v_fat1="%v_fat1%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "116" -nl "set %v_fat1%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "La ligne de configuration a été modifiée en: "

set "v_fat2=-fx files"
set v_fat2="fexport=%v_fat2%"
set v_fat2="%v_fat2%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "117" -nl "set %v_fat2%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "La ligne de configuration a été modifiée en: "

REM OUTPUT ORGANIZING format
set "v_oforg=inline"
set v_oforg="oforg=%v_oforg%"
set v_oforg="%v_oforg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "125" -nl "set %v_oforg%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "La ligne de configuration a été modifiée en: "

REM NSCB MODE
set "v_nscbmode=new"
set v_nscbmode="NSBMODE=%v_nscbmode%"
set v_nscbmode="%v_nscbmode%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "132" -nl "set %v_nscbmode%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "132" -nl "La ligne de configuration a été modifiée en: "

REM ROMAJI
set "v_roma=TRUE"
set v_roma="romaji=%v_roma%"
set v_roma="%v_roma%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "139" -nl "set %v_roma%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "139" -nl "La ligne de configuration a été modifiée en: "

REM TRANSLATE
set "v_trans=FALSE"
set v_trans="transnutdb=%v_trans%"
set v_trans="%v_trans%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "147" -nl "set %v_trans%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "147" -nl "La ligne de configuration a été modifiée en: "

REM WORKERS
set v_workers="workers=-threads 1"
set v_workers="%v_workers%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "153" -nl "set %v_workers%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "153" -nl "La ligne de configuration a été modifiée en: "

REM COMPRESSION
set "v_nszlevels=17"
set v_nszlevels="compression_lv=%v_nszlevels%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "158" -nl "set %v_nszlevels%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "158" -nl "La ligne de configuration a été modifiée en: "
set "v_nszlevels=0"
set v_nszlevels="compression_threads=%v_nszlevels%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "159" -nl "set %v_nszlevels%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "159" -nl "La ligne de configuration a été modifiée en: "
set "v_xcz_export=xcz"
set v_xcz_export="xci_export=%v_xcz_export%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "160" -nl "set %v_xcz_export%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "160" -nl "La ligne de configuration a été modifiée en: "

exit /B

:curr_set1
echo.
echo **Paramètres actuels du mode automatique**
REM vrepack
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "Le réempaquetage de fichier est défini sur: "

REM fi_rep
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "Le traitement des dossiers est défini sur: "

REM v_RSV
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "Le correctif du systéme demander est défini sur: "

REM vkey
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "La variable Keygénération est définie sur: "

exit /B

:curr_set2
echo.
echo **Paramètres courant des paramètres globaux**
REM OP_COLOR
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "La couleur est définie sur: "
endlocal

REM w_folder
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "Dossier de travail est défini sur: "

REM v_of
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "Le dossier de sortie est défini sur: "

REM v_delta
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "Delta est réglé sur: "

REM v_delta2
%pycommand% "%listmanager%" -rl "%op_file%" -ln "37" -nl "Delta (fonctions directes) est réglé sur: "

REM zip_restore
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "Le fichier zip est défini sur: "

REM AUTO-EXIT
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "La sortie automatique est réglée sur: "

REM skipRSVprompt
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "Ignorer la sélection du RSV est réglé sur: "

REM buffer
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "Le tampon est réglé sur: "

REM FAT format
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "Le format de fichier SD est réglé sur: "
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "Le format découper du NSP est défini sur: "
REM OUTPUT ORGANIZING format
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "L'organisation de sortie est définie sur: "

REM NSCB MODE
%pycommand% "%listmanager%" -rl "%op_file%" -ln "132" -nl "Le mode NSCB est réglé sur: "

REM ROMANIZE
%pycommand% "%listmanager%" -rl "%op_file%" -ln "139" -nl "Le mode ROMANIZE est réglé sur: "

REM TRANSLATE
%pycommand% "%listmanager%" -rl "%op_file%" -ln "147" -nl "L'option TRANSLATE est définie sur: "

REM WORKERS
%pycommand% "%listmanager%" -rl "%op_file%" -ln "153" -nl "l'option WORKERS est définie sur: "

REM COMPRESSION
%pycommand% "%listmanager%" -rl "%op_file%" -ln "158" -nl "L'option NIVEAUX DE COMPRESSION est définie sur: "
%pycommand% "%listmanager%" -rl "%op_file%" -ln "159" -nl "L’option COMPRESSION THREADS est définie sur: "
%pycommand% "%listmanager%" -rl "%op_file%" -ln "160" -nl "L'option compression d'exportation du XCIS est définie sur: "
exit /B

:verify_keys
cls
call :logo
echo ******************************************************************************
echo Vérifiez les clés dans KEYS.TXT CONTRE SHA256 hashes a partir des clés correct
echo ******************************************************************************

%pycommand% "%squirrel%" -nint_keys "%dec_keys%"

echo ...........................................................................
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "1" pour revenir au programme principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

:salida
exit /B

:update_nutdb
cls
call :logo
echo ***************************************************************************
echo Forcer la mise à jour de NUT_DB 
echo ***************************************************************************

%pycommand% "%squirrel_lb%" -lib_call nutdb force_refresh

echo ...........................................................................
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "1" pour revenir au programme principal
echo ...........................................................................
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

:google_drive
cls
call :logo
echo ********************************************************
echo GOOGLE-DRIVE - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour enregistrer le compte
echo Tapez "2" pour actualiser le cache des bibliothèques distantes
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au programme principal
echo .......................................................
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto op_google_drive_account
if /i "%bs%"=="2" ( %pycommand% "%squirrel_lb%" -lib_call workers concurrent_cache )
if /i "%bs%"=="2" goto google_drive

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo Mauvais choix
echo.
goto google_drive

:op_google_drive_account
cls
call :logo
echo ***************************************************************************
echo Enregistrer un compte Google Drive
echo ***************************************************************************
echo Vous avez besoin d'un credentials.json, cela peut être appelé credentials.json ou nom de
echo jeton que vous générez generate.json. Un credentials.json peut être utilisé avec de nombreux comptes
echo pour générer des jetons, mais s'il est utilisé avec un compte différent de celui qui
echo est généré, vous obtiendrez un avertissement.
echo Un système est implémenté pour avoir de nombreuses informations d'identification json dans le dossier des informations d'identification
echo lire le document distribué avec NSCB pour savoir comment obtenir le fichier.
echo.
echo Note. Le nom que vous saisissez à cette étape sera utilisé pour enregistrer le jeton 
echo et pour le chemins.
echo.
echo Example: Un jeton nommé "drive" utilisera des chemins comme drive:/folder/file.nsp
echo.
set /p bs="Tapez le nom du lecteur: "
set "token=%bs%"
echo.
%pycommand% "%squirrel_lb%" -lib_call Drive.Private create_token -xarg "%token%" headless="False"
pause
goto google_drive

:interface
cls
call :logo
echo ********************************************************
echo INTERFACE - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour modifier la configuration de VISIBILITÉ DE DÉMARRAGE
echo Tapez "2" pour choisir un NAVIGATEUR pour l'interface 
echo Tapez "3" pour désactiver la LECTURE VIDÉO
echo Tapez "4" pour configurer PORT
echo Tapez "5" pour configurer HOST
echo Tapez "6" pour configurer le paramètre NOCONSOLE
echo.
echo Tapez "d" pour restaurer les parametres par defauts de l'interface
echo Tapez "0" pour revenir au MENU de CONFIGURATION
echo Tapez "e" pour revenir au programme principal
echo .......................................................
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto op_interface_consolevisibility
if /i "%bs%"=="2" goto op_interface_browser
if /i "%bs%"=="3" goto op_interface_video_playback
if /i "%bs%"=="4" goto op_interface_port
if /i "%bs%"=="5" goto op_interface_host
if /i "%bs%"=="6" goto op_interface_noconsole

if /i "%bs%"=="d" goto op_interface_defaults
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo Mauvais choix
echo.
goto interface

:op_interface_consolevisibility
cls
call :logo
echo ***************************************************************************
echo Démarre l'INTERFACE en mode minimisée
echo ***************************************************************************
echo Contrôle si la console de débogage démarre minimisée avec l'interface Web
echo 
echo.
echo Tapez "1"  pour démarrer en mode minimisée
echo Tapez "2"  pour ne pas démarer en mode minimisée
echo Tapez "D"  pour le mode par défaut (non minimisé)
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'interface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_interface=none"
if /i "%bs%"=="1" set "v_interface=yes"
if /i "%bs%"=="2" set "v_interface=no"
if /i "%bs%"=="d" set "v_interface=no"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

if "%v_interface%"=="none" echo mauvais choix
if "%v_interface%"=="none" echo.
if "%v_interface%"=="none" goto op_interface_consolevisibility

set v_interface="start_minimized=%v_interface%"
set v_interface="%v_interface%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "17" -nl "set %v_interface%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "14" -nl "La ligne de configuration a été modifiée en: "
echo.
pause
goto interface

:op_interface_browser
cls
call :logo
echo ***************************************************************************
echo CHOISISSEZ LE NAVIGATEUR POUR L'INTERFACE DE DÉMARRAGE
echo ***************************************************************************
echo Sélectionne le navigateur utilisé pour démarrer l'interface:
echo Options:
echo 1. Auto. L'ordre est défini dans la base de ztools\chromium ou du navigateur installé dans 
echo système. Ceci est réglé automatiquement par squirrel dans l'ordre suivant:
echo    I.   ztools\chromium (Chromium portable\Slimjet portable)
echo    II.  Chrome ou Chromium installé sur le système
echo    III. Microsoft Edge (Non recommandé)
echo 2. Sytem Default. Utilise le système par défaut (faible compatibilité)
echo 3. Définissez un chemin brut vers un navigateur par l'une des méthodes suivantes.
echo    I.   Chemin absolu vers votre navigateur, se terminant par .exe
echo    II.  Chemin absolu vers un fichier .lnk (raccourci Windows)
echo    III. Nom d'un fichier .lnk dans ztools \ chromium (se terminant par .lnk)
echo         Example: brave.lnk 
echo         This will read ztools\chromium\brave.lnk and redirect to the exe 
echo         path launching brave browser
echo.
echo Tapez "1" or "d" pour régler la variable sur AUTO
echo Tapez "2" pour définir la variable sur SYSTEME DEFAUT
echo Entrez le nom shortcut.lnk dans les méthodes 3.III
echo Entrez un itinéraire absolu vers le navigateur ou un raccourci pour la méthode 3.I ou 3.II
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'inteface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_interface_browser=%bs%"
if /i "%bs%"=="1" set "v_interface_browser=auto"
if /i "%bs%"=="2" set "v_interface_browser=default"
if /i "%bs%"=="d" set "v_interface_browser=auto"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

set v_interface_browser="browserpath=%v_interface_browser%"
set v_interface_browser="%v_interface_browser%"

%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "31" -nl "set %v_interface_browser%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "31" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto interface

:op_interface_video_playback
cls
call :logo
echo ***************************************************************************
echo DÉSACTIVER LA LECTURE VIDÉO
echo ***************************************************************************
echo Désactive le lecteur HLS pour les vidéos Nintendo.com.
echo Ceci est destiné aux anciens ordinateurs qui peuvent se bloquer avec le lecteur javascript HLS 
echo 
echo.
echo Tapez "1"  pour activer la lecture vidéo
echo Tapez "2"  pour désactiver la lecture vidéo
echo Tapez "D"  par défaut (NON MINIMISÉ)
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'interface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_video_playback=none"
if /i "%bs%"=="1" set "v_video_playback=true"
if /i "%bs%"=="2" set "v_video_playback=false"
if /i "%bs%"=="d" set "v_video_playback=false"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

if "%v_video_playback%"=="none" echo Mauvais choix
if "%v_video_playback%"=="none" echo.
if "%v_video_playback%"=="none" goto op_interface_video_playback

set v_video_playback="videoplayback=%v_video_playback%"
set v_video_playback="%v_video_playback%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "35" -nl "set %v_video_playback%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "35" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto interface

:op_interface_port
cls
call :logo
echo ***************************************************************************
echo CHOISIR UN PORT POUR L'INTERFACE
echo ***************************************************************************
echo. 
echo Note "rg8000" localise un port ouvert entre 8000 et 8999, il permet d'ouvrir
echo plusieurs fenêtres d'interface en même temps. Ceci est le paramètre par défaut
echo.
echo Tapez "1" or "d" pour définir la variable sur rg8000
echo ou saisir un NUMÉRO DE PORT
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'interface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_interface_port=%bs%"
if /i "%bs%"=="1" set "v_interface_port=rg8000"
if /i "%bs%"=="d" set "v_interface_port=rg8000"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

set v_interface_port="port=%v_interface_port%"
set v_interface_port="%v_interface_port%"

%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "48" -nl "set %v_interface_port%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "48" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto interface

:op_interface_host
cls
call :logo
echo ***************************************************************************
echo CHOISIR LE PORT POUR L'INTERFACE
echo ***************************************************************************
echo Localhost. L'interface n'est visible que localement (par défaut)
echo 0.0.0.0. l'interface peut être visible sur le même réseau
echo.
echo Tapez "1" ou "D" pour configurer l'hôte localement (Localhost)
echo Tapez "2" pour configurer l'hôte sur le reseau (0.0.0.0) 
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'interface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_interface_host=none"
if /i "%bs%"=="1" set "v_interface_host=localhost"
if /i "%bs%"=="2" set "v_interface_host=0.0.0.0"
if /i "%bs%"=="d" set "v_interface_host=localhost"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

if "%v_interface_host%"=="none" echo Mauvais choix
if "%v_interface_host%"=="none" echo.
if "%v_interface_host%"=="none" goto op_interface_host

set v_interface_host="host=%v_interface_host%"
set v_interface_host="%v_interface_host%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "55" -nl "set %v_interface_host%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "55" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto interface

:op_interface_noconsole
cls
call :logo
echo ***************************************************************************
echo CONSOLE CACHÉE POUR L'INTERFACE
echo ***************************************************************************
echo NoConsole=désactivé: Maque les commandes et redirige les impressions de la console vers l'interface
echo c'est le paramètre par défaut.
echo NoConsole=Activé: Affiche les commandes
echo.
echo Tapez "1" ou "D" pour configurer NOCONSOLE sur désactivé
echo Tapez "2" pour configurer NOCONSOLE sur activé
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au menu de l'interface
echo Tapez "e" pour revenir au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_interface_noconsole=none"
if /i "%bs%"=="1" set "v_interface_noconsole=true"
if /i "%bs%"=="2" set "v_interface_noconsole=false"
if /i "%bs%"=="d" set "v_interface_noconsole=true"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto interface
if /i "%bs%"=="e" goto salida

if "%v_interface_noconsole%"=="none" echo Mauvais choix
if "%v_interface_noconsole%"=="none" echo.
if "%v_interface_noconsole%"=="none" goto op_interface_noconsole

set v_interface_noconsole="noconsole=%v_interface_noconsole%"
set v_interface_noconsole="%v_interface_noconsole%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "61" -nl "set %v_interface_noconsole%"
echo.
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "61" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto interface

:op_interface_defaults
cls
call :logo
::Startup
set v_interface="start_minimized=no"
set v_interface="%v_interface%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "17" -nl "set %v_interface%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "17" -nl "La ligne de configuration a été remplacée par: "
echo.
::Browserpath
set v_interface_browser="browserpath=auto"
set v_interface_browser="%v_interface_browser%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "31" -nl "set %v_interface_browser%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "31" -nl "La ligne de configuration a été remplacée par: "
echo.
::Video playback
set v_video_playback="videoplayback=true"
set v_video_playback="%v_video_playback%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "35" -nl "set %v_video_playback%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "35" -nl "La ligne de configuration a été remplacée par: "
::Port
set v_interface_port="port=rg8000"
set v_interface_port="%v_interface_port%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "48" -nl "set %v_interface_port%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "48" -nl "La ligne de configuration a été remplacée par: "
::Host
set v_interface_host="host=localhost"
set v_interface_host="%v_interface_host%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "55" -nl "set %v_interface_host%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "55" -nl "La ligne de configuration a été remplacée par: "

::NoConsole
set v_interface_noconsole="noconsole=true"
set v_interface_noconsole="%v_interface_noconsole%"
%pycommand% "%listmanager%" -cl "%opt_interface%" -ln "61" -nl "set %v_interface_noconsole%"
%pycommand% "%listmanager%" -rl "%opt_interface%" -ln "61" -nl "La ligne de configuration a été remplacée par: "
pause
goto sc1

:server
cls
call :logo
echo ********************************************************
echo SERVEUR - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour changer la configuration de la VISIBILITÉ DE DÉMARRAGE
echo Tapez "2" pour désactiver la LECTURE VIDÉO
echo Tapez "3" pour configurer le numéro de port
echo Tapez "4" pour configurer l'hôte
echo Tapez "5" pour configurer le paramètre noconsole
echo Tapez "6" pour configurer le paramètre ssl
echo.
echo Tapez "d" pour restaurer les parametres du serveur par defauts
echo Tapez "0" pour revenir au menu de configuration 
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo .......................................................
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto op_server_consolevisibility
if /i "%bs%"=="2" goto op_server_video_playback
if /i "%bs%"=="3" goto op_server_port
if /i "%bs%"=="4" goto op_server_host
if /i "%bs%"=="5" goto op_server_noconsole
if /i "%bs%"=="6" goto op_server_ssl

if /i "%bs%"=="d" goto op_server_defaults
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo mauvaix choix
echo.
goto server

:op_server_consolevisibility
cls
call :logo
echo ***************************************************************************
echo Lancement du fichier SERVER.BAT en mode minimiser?
echo ***************************************************************************
echo Contrôle si la console de débogage démarre minimisée avec le Web
echo interface
echo.
echo Tapez "1" pour démarrer MINIMISÉ
echo Tapez "2" pour NE PAS démarrer MINIMISÉ
echo Tapez "D" par défaut (NON MINIMISÉ)
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_server_vis=none"
if /i "%bs%"=="1" set "v_server_vis=yes"
if /i "%bs%"=="2" set "v_server_vis=no"
if /i "%bs%"=="d" set "v_server_vis=no"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

if "%v_server_vis%"=="none" echo Mauvais choix
if "%v_server_vis%"=="none" echo.
if "%v_server_vis%"=="none" goto op_server_consolevisibility

set v_server_vis="start_minimized=%v_server_vis%"
set v_server_vis="%v_server_vis%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "17" -nl "set %v_server_vis%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "17" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_video_playback
cls
call :logo
echo ***************************************************************************
echo DÉSACTIVER LA LECTURE VIDÉO
echo ***************************************************************************
echo Désactive le lecteur HLS pour les vidéos Nintendo.com.
echo Ceci est destiné aux anciens ordinateurs qui peuvent se bloquer avec le javascript HLS 
echo 
echo.
echo Tapez "1"  pour activer la lecture vidéo
echo Tapez "2"  pour désactiver la lecture vidéo
echo Tapez "D"  par défaut (NON MINIMISÉ)
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_video_playback=none"
if /i "%bs%"=="1" set "v_video_playback=true"
if /i "%bs%"=="2" set "v_video_playback=false"
if /i "%bs%"=="d" set "v_video_playback=false"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

if "%v_video_playback%"=="none" echo Mauvais choix
if "%v_video_playback%"=="none" echo.
if "%v_video_playback%"=="none" goto op_server_video_playback

set v_video_playback="videoplayback=%v_video_playback%"
set v_video_playback="%v_video_playback%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "21" -nl "set %v_video_playback%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "21" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_port
cls
call :logo
echo ***************************************************************************
echo CHOISIR LE PORT POUR LE SERVEUR
echo ***************************************************************************
echo. 
echo Remarque "rg8000" localise un port ouvert entre 8000 et 8999, il permet d'ouvrir
echo plusieurs fenêtres d'interface en même temps. Ceci est le paramètre par défaut
echo.
echo Tapez "1" ou "d" pour définir la variable sur rg8000
echo ou saisissez un NUMÉRO DE PORT
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_server_port=%bs%"
if /i "%bs%"=="1" set "v_server_port=rg8000"
if /i "%bs%"=="d" set "v_server_port=rg8000"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

set v_server_port="port=%v_server_port%"
set v_server_port="%v_server_port%"

%pycommand% "%listmanager%" -cl "%opt_server%" -ln "29" -nl "set %v_server_port%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "29" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_host
cls
call :logo
echo ***************************************************************************
echo CHOISIR UN PORT POUR L'INTERFACE
echo ***************************************************************************
echo Localhost. Le serveur n'est visible que localement (par défaut)
echo 0.0.0.0. L'interface peut être visible sur le même réseau
echo.
echo Tapez "1" ou "D" pour configurer l'hôte comme LOCALHOST 
echo Tapez "2" pour configurer l'hôte en tant que 0.0.0.0 
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_server_host=none"
if /i "%bs%"=="1" set "v_server_host=localhost"
if /i "%bs%"=="2" set "v_server_host=0.0.0.0"
if /i "%bs%"=="d" set "v_server_host=localhost"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

if "%v_server_host%"=="none" echo Mouvais choix
if "%v_server_host%"=="none" echo.
if "%v_server_host%"=="none" goto op_server_host

set v_server_host="host=%v_server_host%"
set v_server_host="%v_server_host%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "36" -nl "set %v_server_host%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "36" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_noconsole
cls
call :logo
echo ***************************************************************************
echo CONSOLE CACHÉE POUR SERVEUR
echo ***************************************************************************
echo NoConsole=Activé. Masque la console cmd et redirige les impressions de la console vers le serveur
echo c'est le paramètre par défaut.
echo NoConsole=Déactivé. Affiche la console cmd
echo.
echo Tapez "1" ou "D" configurer NOCONSOLE sur activé
echo Tapez "2" pour configurer NOCONSOLE sur désactivé
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_server_noconsole=none"
if /i "%bs%"=="1" set "v_server_noconsole=true"
if /i "%bs%"=="2" set "v_server_noconsole=false"
if /i "%bs%"=="d" set "v_server_noconsole=true"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

if "%v_server_noconsole%"=="none" echo Mauvais choix
if "%v_server_noconsole%"=="none" echo.
if "%v_server_noconsole%"=="none" goto op_server_noconsole

set v_server_noconsole="noconsole=%v_server_noconsole%"
set v_server_noconsole="%v_server_noconsole%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "42" -nl "set %v_server_noconsole%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "42" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_ssl
cls
call :logo
echo ***************************************************************************
echo PROTOCOLE SSL
echo ***************************************************************************
echo Si la valeur est activé, le serveur sera servi via https: s'il y a un
echo fichier certificate.pem et key.pem dans zconfig. Si ces fichiers ne sont pas trouvés
echo squirrel se repliera sur http: 
echo.
echo Tapez "1" ou "D" pour désactivé SSL (par défaut)
echo Tapez "2" pour configurer SSL sur activé
echo.
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "b" pour revenir au MENU SERVEUR
echo Tapez "e" pour revenir au PROGRAMME PRINCIPAL
echo.
set /p bs="Faites votre choix: "
set "v_server_SSL=none"
if /i "%bs%"=="1" set "v_server_SSL=false"
if /i "%bs%"=="2" set "v_server_SSL=true"
if /i "%bs%"=="d" set "v_server_SSL=false"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto server
if /i "%bs%"=="e" goto salida

if "%v_server_SSL%"=="none" echo Mauvais choix
if "%v_server_SSL%"=="none" echo.
if "%v_server_SSL%"=="none" goto op_server_ssl

set v_server_SSL="ssl=%v_server_SSL%"
set v_server_SSL="%v_server_SSL%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "48" -nl "set %v_server_SSL%"
echo.
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "48" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto server

:op_server_defaults
cls
call :logo
::Startup
set v_interface="start_minimized=no"
set v_interface="%v_interface%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "17" -nl "set %v_interface%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "17" -nl "La ligne de configuration a été remplacée par: "
echo.
::Video playback
set v_video_playback="videoplayback=true"
set v_video_playback="%v_video_playback%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "21" -nl "set %v_video_playback%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "21" -nl "La ligne de configuration a été remplacée par: "
::Port
set v_interface_port="port=rg8000"
set v_interface_port="%v_interface_port%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "29" -nl "set %v_interface_port%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "29" -nl "La ligne de configuration a été remplacée par: "
::Host
set v_interface_host="host=localhost"
set v_interface_host="%v_interface_host%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "36" -nl "set %v_interface_host%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "36" -nl "La ligne de configuration a été remplacée par: "
::NoConsole
set v_interface_noconsole="noconsole=true"
set v_interface_noconsole="%v_interface_noconsole%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "42" -nl "set %v_interface_noconsole%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "42" -nl "La ligne de configuration a été remplacée par: "
::SSL
set v_server_SSL="ssl=false"
set v_server_SSL="%v_server_SSL%"
%pycommand% "%listmanager%" -cl "%opt_server%" -ln "48" -nl "set %v_server_SSL%"
%pycommand% "%listmanager%" -rl "%opt_server%" -ln "48" -nl "La ligne de configuration a été remplacée par: "

pause
goto sc1

:MTP
cls
call :logo
echo ********************************************************
echo MTP - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour configurer la pré-installation de VERIFICATION
echo Tapez "2" pour prioriser NSZ lors de la mise à jour automatique de l'appareil
echo Tapez "3" pour activer les INSTALLATIONS CRYPTO STANDARD
echo Tapez "4" pour EXCLURE XCI lors de l'installation des mises à jour dans AUTOUPDATE
echo Tapez "5" pour basculer entre SD et EMMC en fonction de l'espace libre
echo Tapez "6" pour vérifier le firmware sur la console avant de faire les installations
echo Tapez "7" pour patcher la génération de clés des fichiers si nécessaire
echo Tapez "8" pour vérifier si le contenu de base est installé avant l'installation
echo Tapez "9" pour vérifier si d'anciennes mises à jour ou dlcs sont installés avant l'installation
echo Tapez "10" pour choisir la configuration du dossier lors du dumping des sauvegardes
echo Tapez "11" pour choisir si ajouter 'titleid' et la 'version' pour enregistrer les dumps
echo Tapez "12" pour choisir comment ajouter des fichiers au cache distant pour les liens publics
echo Tapez "13" pour modifier les FICHIERS PATCHÉS ET LES SPÉCIFICATIONS D'INSTALLATION XCI
echo.
echo Tapez "d" pour restaurer les paramètres par défaut MTP
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au programme principal
echo .......................................................
echo.
set /p bs="Faites votres choix: "
if /i "%bs%"=="1" goto op_MTP_verification
if /i "%bs%"=="2" goto op_MTP_prioritize_NSZ
if /i "%bs%"=="3" goto op_MTP_standard_crypto
if /i "%bs%"=="4" goto op_MTP_exclude_xci_autinst
if /i "%bs%"=="5" goto op_MTP_aut_ch_medium
if /i "%bs%"=="6" goto op_MTP_chk_fw
if /i "%bs%"=="7" goto op_MTP_prepatch_kg
if /i "%bs%"=="8" goto op_MTP_prechk_Base
if /i "%bs%"=="9" goto op_MTP_prechk_Upd
if /i "%bs%"=="10" goto op_MTP_saves_Inline
if /i "%bs%"=="11" goto op_MTP_saves_AddTIDandVer
if /i "%bs%"=="12" goto op_MTP_pdrive_truecopy
if /i "%bs%"=="13" goto op_MTP_ptch_install_spec

if /i "%bs%"=="d" goto op_mtp_defaults
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo Mauvais choix
echo.
goto MTP

:op_MTP_verification
cls
call :logo
echo ***************************************************************************
echo ACTIVER LA VÉRIFICATION DE FICHIER PRÉ-INSTALLATION
echo ***************************************************************************
echo False: Vérification désactivée
echo Vérification niveau 2: Nca sont lisibles, aucun fichier ne manque, la clé de titre est 
echo correcte et la signature 1 est d'origine VÉRIFIABLE légitime. (défaut)
echo Hash: Vérification au niveau 2  + Vérification du Hash
echo.
echo Tapez "1" ou "D" pour configurer la vérification au niveau 2
echo Tapez "2" pour configurer la vérification du Hash
echo Tapez "3" pour DÉSACTIVER LA VÉRIFICATION
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_mtp_verification=none"
if /i "%bs%"=="1" set "v_mtp_verification=True"
if /i "%bs%"=="2" set "v_mtp_verification=Hash"
if /i "%bs%"=="3" set "v_mtp_verification=False"
if /i "%bs%"=="d" set "v_mtp_verification=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_mtp_verification%"=="none" echo Mauvais choix
if "%v_mtp_verification%"=="none" echo.
if "%v_mtp_verification%"=="none" goto op_MTP_verification

set v_mtp_verification="MTP_verification=%v_mtp_verification%"
set v_mtp_verification="%v_mtp_verification%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "166" -nl "set %v_mtp_verification%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "166" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_prioritize_NSZ
cls
call :logo
echo ************************************************************************************************
echo PRIORISER NSZ SUR NSP LORS DE LA RECHERCHE DE NOUVELLES MISES À JOUR ET DLC DANS LA BIBLIOTHÈQUE
echo ************************************************************************************************
echo.
echo Tapez "1" ou "D" pour prioriser NSZ
echo Tapez "2" pour ne pas prioriser NSZ
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_prioritize_NSZ=none"
if /i "%bs%"=="1" set "v_MTP_prioritize_NSZ=True"
if /i "%bs%"=="3" set "v_MTP_prioritize_NSZ=False"
if /i "%bs%"=="d" set "v_MTP_prioritize_NSZ=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_prioritize_NSZ%"=="none" echo Mauvais choix
if "%v_MTP_prioritize_NSZ%"=="none" echo.
if "%v_MTP_prioritize_NSZ%"=="none" goto op_MTP_prioritize_NSZ

set v_MTP_prioritize_NSZ="MTP_prioritize_NSZ=%v_MTP_prioritize_NSZ%"
set v_MTP_prioritize_NSZ="%v_MTP_prioritize_NSZ%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "167" -nl "set %v_MTP_prioritize_NSZ%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "167" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_exclude_xci_autinst
cls
call :logo
echo ***************************************************************************
echo Exclure les XCI des contrôles de mise à jour de nouveaux contenus
echo ***************************************************************************
echo.
echo Tapez "1" ou "D" pour exclure les xci des contrôles
echo Tapez "2" pour ne pas exclure les xci des contrôles
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_exclude_xci_autinst=none"
if /i "%bs%"=="1" set "v_MTP_exclude_xci_autinst=True"
if /i "%bs%"=="2" set "v_MTP_exclude_xci_autinst=False"
if /i "%bs%"=="d" set "v_MTP_exclude_xci_autinst=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_exclude_xci_autinst%"=="none" echo Mauvais choix
if "%v_MTP_exclude_xci_autinst%"=="none" echo.
if "%v_MTP_exclude_xci_autinst%"=="none" goto op_MTP_exclude_xci_autinst

set v_MTP_exclude_xci_autinst="MTP_exclude_xci_autinst=%v_MTP_exclude_xci_autinst%"
set v_MTP_exclude_xci_autinst="%v_MTP_exclude_xci_autinst%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "168" -nl "set %v_MTP_exclude_xci_autinst%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "168" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_aut_ch_medium
cls
call :logo
echo ***************************************************************************
echo MODIFICATION AUTOMATIQUE DU SUPPORT SELON L'ESPACE SUR LE DISPOSITIF
echo ***************************************************************************
echo Si 'activé' change entre SD et EMMC lorsque l'espace est faible dans le
echo support sélectionné. Si 'désactive' saute l'installation. 
echo.
echo Tapez "1" ou "D" pour changer de support en fonction de l'espace sur l'appariel
echo Input "2" pour NE PAS changer de support en fonction de l'espace sur l'appariel
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_aut_ch_medium=none"
if /i "%bs%"=="1" set "v_MTP_aut_ch_medium=True"
if /i "%bs%"=="2" set "v_MTP_aut_ch_medium=False"
if /i "%bs%"=="d" set "v_MTP_aut_ch_medium=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_aut_ch_medium%"=="none" echo Mauvais choix
if "%v_MTP_aut_ch_medium%"=="none" echo.
if "%v_MTP_aut_ch_medium%"=="none" goto op_MTP_aut_ch_medium

set v_MTP_aut_ch_medium="MTP_aut_ch_medium=%v_MTP_aut_ch_medium%"
set v_MTP_aut_ch_medium="%v_MTP_aut_ch_medium%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "169" -nl "set %v_MTP_aut_ch_medium%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "169" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_chk_fw
cls
call :logo
echo ***************************************************************************
echo VÉRIFIEZ LE FIRMWARE SUR LA CONSOLE ET SUR LE FICHIER EN TRAITEMENT
echo ***************************************************************************
echo.
echo Tapez "1" ou "D" pour NE PAS vérifier le FIRMWARE (par défaut)
echo Tapez "2" pour vérifier le FIRMWARE 
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_chk_fw=none"
if /i "%bs%"=="1" set "v_MTP_chk_fw=False"
if /i "%bs%"=="2" set "v_MTP_chk_fw=True"
if /i "%bs%"=="d" set "v_MTP_chk_fw=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_chk_fw%"=="none" echo Mauvais choix
if "%v_MTP_chk_fw%"=="none" echo.
if "%v_MTP_chk_fw%"=="none" goto op_MTP_chk_fw

set v_MTP_chk_fw="MTP_chk_fw=%v_MTP_chk_fw%"
set v_MTP_chk_fw="%v_MTP_chk_fw%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "170" -nl "set %v_MTP_chk_fw%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "170" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_prepatch_kg
cls
call :logo
echo ***************************************************************************
echo Vérifier le FIRMWARE sur la console et sur le fichier en traitement
echo ***************************************************************************
echo Après une vérification du firmware sur la console et le programme de fichiers hte décidera
echo s'il doit patcher ou ignorer le fichier basé sur cette option
echo Note: Actuellement, il est nécessaire de générer un nouveau fichier avant de l'envoyer via MTP
echo car la possibilité de patcher des flux à la volée n'est pas encore implémentée sur
echo le crochet mtp.
echo.
echo Tapez "1" ou "D" pour NE PAS PATCHER LES FICHIERS (par défaut)
echo Tapez "2" pour PATCHER LES FICHIERS
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_prepatch_kg=none"
if /i "%bs%"=="1" set "v_MTP_prepatch_kg=False"
if /i "%bs%"=="2" set "v_MTP_prepatch_kg=True"
if /i "%bs%"=="d" set "v_MTP_prepatch_kg=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_prepatch_kg%"=="none" echo Mauvais choix
if "%v_MTP_prepatch_kg%"=="none" echo.
if "%v_MTP_prepatch_kg%"=="none" goto op_MTP_prepatch_kg

set v_MTP_prepatch_kg="MTP_chk_fw=%v_MTP_prepatch_kg%"
set v_MTP_prepatch_kg="%v_MTP_prepatch_kg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "171" -nl "set %v_MTP_prepatch_kg%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "171" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_prechk_Base
cls
call :logo
echo ***************************************************************************
echo VÉRIFIEZ SI LES BASEGAMES SONT DÉJÀ INSTALLÉS DANS LA CONSOLE
echo ***************************************************************************
echo Si activé, si un jeu de base est dans la console, l'installation sera ignorée
echo Si elle est désactivée, l'installation sera écrasée.
echo.
echo Tapez "1" ou "D" pour VÉRIFIER ET SAUTER LES JEUX DÉJÀ INSTALLÉS (par défaut)
echo Tapez "2" pour NE PAS vérifier et ignorer les jeux déjà installés
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_prechk_Base=none"
if /i "%bs%"=="1" set "v_MTP_prechk_Base=True"
if /i "%bs%"=="2" set "v_MTP_prechk_Base=False"
if /i "%bs%"=="d" set "v_MTP_prechk_Base=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_prechk_Base%"=="none" echo Mauvais choix
if "%v_MTP_prechk_Base%"=="none" echo.
if "%v_MTP_prechk_Base%"=="none" goto op_MTP_prechk_Base

set v_MTP_prechk_Base="MTP_prechk_Base=%v_MTP_prechk_Base%"
set v_MTP_prechk_Base="%v_MTP_prechk_Base%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "173" -nl "set %v_MTP_prechk_Base%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "173" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_prechk_Upd
cls
call :logo
echo ***************************************************************************
echo VÉRIFIEZ SI LES MISES À JOUR ET SONT DÉJÀ INSTALLÉES DANS LA CONSOLE
echo ***************************************************************************
echo Si activé, vérifie si une mise à jour ou un dlc est déjà dans la console si 
echo la version est inférieure à celle envoyé, elle supprime l'ancienne pré-installation
echo pour récupérer de l'espace avant le processus d'installation, si la version dans la
echo console est égal ou supérieur, l'installation est ignorée.
echo Si elle est désactivée, elle permet d'installer des mises à jour ou dlc ainsi que d'écraser
echo les mises à jour avec le même numéro de version.
echo.
echo Tapez "1" ou "D" pour NE PAS VÉRIFIER ET SAUTER les mises à jour ou dlc déjà installé (par défaut)
echo Tapez "2" pour vérifier et sauter les mises à jour ou dlc déjà installé
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votres choix: "
set "v_MTP_prechk_Upd=none"
if /i "%bs%"=="1" set "v_MTP_prechk_Upd=False"
if /i "%bs%"=="2" set "v_MTP_prechk_Upd=True"
if /i "%bs%"=="d" set "v_MTP_prechk_Upd=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_prechk_Upd%"=="none" echo Mauvais choix
if "%v_MTP_prechk_Upd%"=="none" echo.
if "%v_MTP_prechk_Upd%"=="none" goto op_MTP_prechk_Upd

set v_MTP_prechk_Upd="MTP_prechk_Upd=%v_MTP_prechk_Upd%"
set v_MTP_prechk_Upd="%v_MTP_prechk_Upd%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "174" -nl "set %v_MTP_prechk_Upd%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "174" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_saves_Inline
cls
call :logo
echo ***************************************************************************
echo STOCKE LES DUMPS DE SAUVEGARDE DANS DES DOSSIERS OU EN LIGNE
echo ***************************************************************************
echo.
echo Tapez "1" ou "D" pour stocker les sauvegardes dans des dossiers (par défaut)
echo Tapez "2" pour stocker les sauvegardes en ligne
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_saves_Inline=none"
if /i "%bs%"=="1" set "v_MTP_saves_Inline=False"
if /i "%bs%"=="2" set "v_MTP_saves_Inline=True"
if /i "%bs%"=="d" set "v_MTP_saves_Inline=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_saves_Inline%"=="none" echo Mauvais choix
if "%v_MTP_saves_Inline%"=="none" echo.
if "%v_MTP_saves_Inline%"=="none" goto op_MTP_saves_Inline

set v_MTP_saves_Inline="MTP_saves_Inline=%v_MTP_saves_Inline%"
set v_MTP_saves_Inline="%v_MTP_saves_Inline%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "176" -nl "set %v_MTP_saves_Inline%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "176" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_saves_AddTIDandVer
cls
call :logo
echo ***************************************************************************
echo AJOUTER DES ÉTIQUETTES DE TITRE ET DE VERSION AUX SAVEGARDES
echo ***************************************************************************
echo Ceci est destiné à connaître la version du jeu sur la console lorsque la sauvegarde a été effectuée
echo pour éviter les problèmes de compatibilité.
echo.
echo Tapez "1" ou "D" AJOUTER les balises 'titleid' et 'version' au fichier (par défaut)
echo Tapez "2" pour NE PAS AJOUTER les balises 'titleid' et 'version' au fichier (par défaut)
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_saves_AddTIDandVer=none"
if /i "%bs%"=="1" set "v_MTP_saves_AddTIDandVer=False"
if /i "%bs%"=="2" set "v_MTP_saves_AddTIDandVer=True"
if /i "%bs%"=="d" set "v_MTP_saves_AddTIDandVer=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_saves_AddTIDandVer%"=="none" echo Mauvais choix
if "%v_MTP_saves_AddTIDandVer%"=="none" echo.
if "%v_MTP_saves_AddTIDandVer%"=="none" goto op_MTP_saves_AddTIDandVer

set v_MTP_saves_AddTIDandVer="MTP_saves_AddTIDandVer=%v_MTP_saves_AddTIDandVer%"
set v_MTP_saves_AddTIDandVer="%v_MTP_saves_AddTIDandVer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "177" -nl "set %v_MTP_saves_AddTIDandVer%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "177" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_pdrive_truecopy
cls
call :logo
echo ***************************************************************************
echo AJOUTER DES ÉTIQUETTES DE TITRE ET DE VERSION AUX SAVEGARDES
echo ***************************************************************************
echo Lors de l'installation ou du transfert d'un jeu à partir d'un lien public Google Drive NSCB
echo nécessite une configuration d'authentification par jeton et de dossier de cache dans un compte Google Drive pour
echo une meilleure compatibilité.
echo.
echo Le jeu est copié en devenant propriétaire du dossier cache, ce qui évite également
echo problèmes de quota si TRUECOPY est activé.
echo Si TRUECOPY est désactivé, le jeu est ajouté au dossier de cache en tant que lien symbolique, 
echo cela permet au fichier d'être appelé avec le jeton d'authentification mais peut présenter un quota
echo problèmes si le lien a été partagé.
echo.
echo Tapez "1" ou "D" pour activer TRUECOPY (par défaut)
echo Tapez "2" pour ne pas activer TRUECOPY (par défaut)
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_op_MTP_pdrive_truecopy=none"
if /i "%bs%"=="1" set "v_op_MTP_pdrive_truecopy=True"
if /i "%bs%"=="2" set "v_op_MTP_pdrive_truecopy=False"
if /i "%bs%"=="d" set "v_op_MTP_pdrive_truecopy=True"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_op_MTP_pdrive_truecopy%"=="none" echo Mauvais choix
if "%v_op_MTP_pdrive_truecopy%"=="none" echo.
if "%v_op_MTP_pdrive_truecopy%"=="none" goto op_MTP_pdrive_truecopy

set v_op_MTP_pdrive_truecopy="MTP_pdrive_truecopy=%v_op_MTP_pdrive_truecopy%"
set v_op_MTP_pdrive_truecopy="%v_op_MTP_pdrive_truecopy%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "179" -nl "set %v_op_MTP_pdrive_truecopy%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "179" -nl "La ligne de configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_standard_crypto
cls
call :logo
echo ***************************************************************************
echo INSTALLER TOUS LES FICHIERS NSP COMME CRYPTO STANDARD
echo ***************************************************************************
echo Cela signifie que les fichiers nsp sont installés sans tickets ni titres, ce
echo pour garder le ticketblob dans la console propre.
echo.
echo Tapez "1" ou "D" pour INSTALLER AVEC TITLERIGHTS (par défaut)
echo Tapez "2" pour INSTALLER EN TANT QUE CRYPTO STANDARD
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_standard_crypto=none"
if /i "%bs%"=="1" set "v_MTP_standard_crypto=False"
if /i "%bs%"=="2" set "v_MTP_standard_crypto=True"
if /i "%bs%"=="d" set "v_MTP_standard_crypto=False"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_standard_crypto%"=="none" echo Mauvais choix
if "%v_MTP_standard_crypto%"=="none" echo.
if "%v_MTP_standard_crypto%"=="none" goto op_MTP_standard_crypto

set v_MTP_standard_crypto="MTP_stc_installs=%v_MTP_standard_crypto%"
set v_MTP_standard_crypto="%v_MTP_standard_crypto%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "181" -nl "set %v_MTP_standard_crypto%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "181" -nl "La ligne dans la configuration a été remplacée par: "
echo.
pause
goto MTP

:op_MTP_ptch_install_spec
cls
call :logo
echo ***************************************************************************
echo SPÉCIFICATION POUR L'INSTALLATION DE NSP ET XCI PATCHÉS
echo ***************************************************************************
echo Legacy crée le fichier corrigé ou le fichier converti, puis le transfère vers la
echo console.
echo Spec1 crée un patch pour patcher le flux à la volée. Spec1 traite les multifiles
echo comme différents fichiers déclenchant plusieurs installations consécutives.
echo.
echo Tapez "1" ou "D" pour utiliser SPÉCIFICATION Nº 1 (par défaut)
echo Tapez "2" pour utiliser la spécification LEGACY
echo.
echo Tapez "0" pour retourner au menu de configuration
echo Tapez "b" pour retourner au menu MTP
echo Tapez "e" pour retourner au programme principal
echo.
set /p bs="Faites votre choix: "
set "v_MTP_ptch_install_spec=none"
if /i "%bs%"=="1" set "v_MTP_ptch_install_spec=spec1"
if /i "%bs%"=="2" set "v_MTP_ptch_install_spec=legacy"
if /i "%bs%"=="d" set "v_MTP_ptch_install_spec=spec1"

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="b" goto MTP
if /i "%bs%"=="e" goto salida

if "%v_MTP_ptch_install_spec%"=="none" echo Mauvais choix
if "%v_MTP_ptch_install_spec%"=="none" echo.
if "%v_MTP_ptch_install_spec%"=="none" goto op_MTP_ptch_install_spec

set v_MTP_ptch_install_spec="MTP_ptch_inst_spec=%v_MTP_ptch_install_spec%"
set v_MTP_ptch_install_spec="%v_MTP_ptch_install_spec%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "182" -nl "set %v_MTP_ptch_install_spec%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "182" -nl "La ligne dans la configuration a été remplacée par: "
echo.
pause
goto MTP

:op_mtp_defaults
cls
call :logo
::MTP_verification
set v_mtp_verification="MTP_verification=True"
set v_mtp_verification="%v_mtp_verification%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "166" -nl "set %v_mtp_verification%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "166" -nl "La ligne de configuration a été remplacée par: "
::MTP_prioritize_NSZ
set v_MTP_prioritize_NSZ="MTP_prioritize_NSZ=True"
set v_MTP_prioritize_NSZ="%v_MTP_prioritize_NSZ%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "167" -nl "set %v_MTP_prioritize_NSZ%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "167" -nl "La ligne de configuration a été remplacée par: "
::MTP_exclude_xci_autinst
set v_MTP_exclude_xci_autinst="MTP_exclude_xci_autinst=True"
set v_MTP_exclude_xci_autinst="%v_MTP_exclude_xci_autinst%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "168" -nl "set %v_MTP_exclude_xci_autinst%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "168" -nl "La ligne de configuration a été remplacée par: "
::MTP_aut_ch_medium
set v_MTP_aut_ch_medium="MTP_aut_ch_medium=True"
set v_MTP_aut_ch_medium="%v_MTP_aut_ch_medium%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "169" -nl "set %v_MTP_aut_ch_medium%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "169" -nl "La ligne de configuration a été remplacée par: "
::MTP_chk_fw
set v_MTP_chk_fw="MTP_chk_fw=False"
set v_MTP_chk_fw="%v_MTP_chk_fw%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "170" -nl "set %v_MTP_chk_fw%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "170" -nl "La ligne de configuration a été remplacée par: "
::MTP_prepatch_kg
set v_MTP_prepatch_kg="MTP_chk_fw=False"
set v_MTP_prepatch_kg="%v_MTP_prepatch_kg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "171" -nl "set %v_MTP_prepatch_kg%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "171" -nl "La ligne de configuration a été remplacée par: "
::MTP_prechk_Base
set v_MTP_prechk_Base="MTP_prechk_Base=True"
set v_MTP_prechk_Base="%v_MTP_prechk_Base%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "173" -nl "set %v_MTP_prechk_Base%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "173" -nl "La ligne de configuration a été remplacée par: "
::MTP_prechk_Upd
set v_MTP_prechk_Upd="MTP_prechk_Upd=False"
set v_MTP_prechk_Upd="%v_MTP_prechk_Upd%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "174" -nl "set %v_MTP_prechk_Upd%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "174" -nl "La ligne de configuration a été remplacée par: "
::MTP_saves_Inline
set v_MTP_saves_Inline="MTP_saves_Inline=False"
set v_MTP_saves_Inline="%v_MTP_saves_Inline%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "176" -nl "set %v_MTP_saves_Inline%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "176" -nl "La ligne de configuration a été remplacée par: "
::MTP_saves_AddTIDandVer
set v_MTP_saves_AddTIDandVer="MTP_saves_AddTIDandVer=False"
set v_MTP_saves_AddTIDandVer="%v_MTP_saves_AddTIDandVer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "177" -nl "set %v_MTP_saves_AddTIDandVer%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "177" -nl "La ligne de configuration a été remplacée par: "
::MTP_pdrive_truecopy
set v_op_MTP_pdrive_truecopy="MTP_pdrive_truecopy=True"
set v_op_MTP_pdrive_truecopy="%v_op_MTP_pdrive_truecopy%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "179" -nl "set %v_op_MTP_pdrive_truecopy%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "179" -nl "La ligne de configuration a été remplacée par: "
::MTP_standard_crypto
set v_MTP_standard_crypto="MTP_stc_installs=False"
set v_MTP_standard_crypto="%v_MTP_standard_crypto%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "181" -nl "set %v_MTP_standard_crypto%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "181" -nl "La ligne de configuration a été remplacée par: "
::MTP_ptch_install_spec
set v_MTP_ptch_install_spec="MTP_ptch_inst_spec=spec1"
set v_MTP_ptch_install_spec="%v_MTP_ptch_install_spec%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "182" -nl "set %v_MTP_ptch_install_spec%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "182" -nl "La ligne de configuration a été remplacée par: "
pause
goto sc1

:salida
exit /B

:logo
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
ECHO                                    VERSION %program_version%
ECHO -------------------------------------------------------------------------------------
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Blawar's github:  https://github.com/blawar
ECHO Luca Fraga's github: https://github.com/LucaFraga
ECHO -------------------------------------------------------------------------------------
exit /B

:idepend
cls
call :logo
call "%batdepend%"
goto sc1
