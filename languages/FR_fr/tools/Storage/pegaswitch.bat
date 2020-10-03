goto:%~1

:display_title
title PegaScape/PegaSwitch %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre de préparer le nécessaire pour utiliser l'exploit Nereba et Cafeine ou plus exactement d'utiliser PegaSwitch ou PegaScape via un serveur local.
echo Pour utiliser un CFW ou plus généralement préparer correctement une SD, veuillez en premier lieu préparer une SD via le script approprié ^(ce choix sera proposé dans la suite de ce script^).
goto:eof

:first_action_choice
echo Que souhaitez-vous faire?
echo 1: Préparer la SD avec les exploits.
echo 2: Lancer le serveur Pegaswitch ou PegaScape.
echo 3: Préparer la SD avec les exploits puis lancer le serveur.
echo 0: Lancer le script de préparation d'une SD pour, entre autres, installer un CFW sur celle-ci.
echo Tout autre choix: Revenir au menu précédent.
echo.
set /p nereba_choice=Faites votre choix: 
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD.
echo.
set /p disk_not_finded_choice=Souhaitez-vous tenter de recharger la liste de disques ^(si non, le script se terminera^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Liste des disques:
goto:eof

:disk_choice
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser ou entrez "0" pour annuler la préparation de la SD pour Nereba: 
goto:eof

:disk_choice_empty_error
echo La lettre de lecteur ne peut être vide. Réessayez.
goto:eof

:disk_choice_char_error
echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez.
goto:eof

:disk_choice_not_exist_error
echo Ce volume n'existe pas. Recommencez.
goto:eof

:disk_choice_not_in_list_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez.
goto:eof

:payload_choice_begin
echo Sélectionnez le payload qui sera lancé par l'exploit Cafeine/Nereba:
goto:eof

:payload_choice
echo 0: Choisir un fichier de payload
echo N'importe quel autre choix: Annuler la préparation de la SD pour Nereba.
echo.
set /p payload_number=Entrez le numéro du payload: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de payload Switch ^(*.bin^)|*.bin|" "Sélection du payload" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo Aucun payload sélectionné, retour à la sélection de payloads.
goto:eof

:payload_for_pegascape_official_choice
set /p integrate_pegascape_official=Souhaitez-vous également pouvoir utiliser le payload avec la version officielle de PegaScape ^(remplacera le fichier "reboot_payload.bin" du dossier "atmosphere" de la SD par le payload choisi^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:end_prepare_sd
echo Préparation de la SD terminée.
goto:eof

:server_choice
echo Quel serveur souhaitez-vous utiliser?
echo
echo 1: PegaScape ^(recommandé^)?
echo 2: PegaSwitch?
echo N'importe quel autre choix: Ne pas lancer le serveur et revenir au menu précédent.
echo.
set /p pegaswitch_server_type=Faites votre choix: 
goto:eof

:server_launch_mode_choice
echo Comment souhaitez-vous utiliser PegaSwitch/PegaScape?
echo.
echo 1: Via le test de connexion Wifi ^(firmware 2.0.0 et supérieur^)?
echo 2: Via la webapplet ^(firmware 1.0.0 et la version japonaise de Puyo Puyo Tetris ou si vous utiliser le point d'entrée Fake News^)?
echo N'importe quel autre choix: Ne pas lancer le serveur et revenir au menu précédent.
echo.
set /p pegaswitch_launch_mode=Faites votre choix: 
goto:eof

:begin_launch_server
echo Vous aurez besoin de connaître l'IP de votre PC et de la recopier dans les DNS de la console pour accéder au serveur.
echo La console et le PC doivent se trouver sur le même réseau.
echo.
echo Préparation et lancement du serveur...
goto:eof

:end_launch_server
echo Le serveur pour Pegaswitch devrait être lancé. Pour le fermer, tapper la commande "exit" sans les guillemets dans la fenêtre du serveur.
goto:eof