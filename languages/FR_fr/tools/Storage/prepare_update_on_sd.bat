goto:%~1

:display_title
title Préparation d'une mise à jour du firmware %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo Aucune connexion à internet disponible, le script va s'arrêter.
goto:eof

:intro
IF NOT "%special_launch%" == "unbrick_package_creation" (
	echo Ce script permet de préparer la carte SD avec un firmware spécifique à installer avec ChoiDuJourNX ou Daybreak, le firmware sera téléchargé puis copié sur la SD et ChoiDuJour-NX sera également copié sur la SD. Notez que vous aurez besoin de lancer un CFW pour finaliser la mise à jour sur votre console donc si vous ne l'avez pas fait, veuillez préparer la SD pour le hack avant ou après l'exécution de ce script ^(si après, ne pas formater la carte ou supprimer les données s'y trouvant car sinon vous devrez exécuter de nouveau ce script^).
	echo.
	echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre SD car aucune vérification ne pourra être faites à ce niveau là. 
	echo.
)
echo Pour les utilisateurs avancés, ce script permet de créer un package de mise à jour via ChoiDuJour ou EmmcHaccGen en se basant sur le firmware sélectionné pour mettre à jour manuellement la console via Memloader, Etcher et HacDiskMount.
echo.
echo Attention: Aucune vérification n'est faite sur l'espace disque sur lequel est exécuté ce script ni sur celui de la SD, vous aurez au moins besoin de 800 MO ^(1 GO si vous créez en plus un package via ChoiDuJour^) d'espace libre sur le disque sur lequel s'exécute ce script et d'environ 400 MO sur la SD de la Switch pour y copier le firmware. Notez que ces estimations sont un peu plus large que la réalité mais c'est à vous de faire ces vérifications pour le moment.
echo Notez également qu'une vérification sera tout de même faite pour savoir si le firmware téléchargé n'est pas corrompu via son MD5, seulement l'extraction de celui-ci n'est pas vérifiée donc faites bien attention aux éventuels messages d'erreurs des différents programmes pendant ce script pour savoir si quelque chose s'est mal passé. En cas de problème, vérifiez en premier lieu que vous avez assez d'espace disque sur les périphériques utilisés.
echo.
echo Notez également que les fichiers sont téléchargés via Mega donc certaines limitations pourraient s'appliquer en cas de trop nombreux téléchargements venant d'une même connexion internet. Si vous avez un compte sur Mega.nz, vous pouvez le configurer dans le fichier "tools\megatools\mega.ini" en supprimant les signes "#" devant "Username" et "Password" et en remplaçant les valeurs après le signe "=" par votre nom d'utilisateur et votre mot de passe.
echo.
echo Je ne pourrais être tenu pour responsable en cas de dommage lié à l'utilisation de ce script ou des outils qu'il contient.
goto:eof

:action_choice
echo Préparation d'un package de mise à jour
echo.
Echo Que souhaitez-vous faire?
echo.
IF "%special_launch%" == "unbrick_package_creation" (
	echo 1: Préparer un firmware pour la mise à jour manuel avec ChoiDuJour ^(firmware 6.1.0 maximum^)?
	echo 2: Préparer un firmware pour la mise à jour manuel avec EmmcHaccGen ^(prod.keys de la console requises^)?
	echo N'importe quel autre choix: Revenir au menu précédent.
	echo.
	set /p action_type=Faites votre choix: 
) else (
	echo 1: Préparer un firmware qui sera copié sur la SD pour une installation via ChoiDuJour-NX/Daybreak?
	echo 2: Préparer un firmware pour la mise à jour manuel avec ChoiDuJour ^(firmware 6.1.0 maximum^)?
	echo 3: Effectuer les deux actions.
	echo 4: Préparer une SD avec les différents CFWs et homebrews utiles et revenir à ce menu ensuite?
	echo 5: Seulement télécharger le firmware?
	echo 6: Préparer un firmware pour la mise à jour manuel avec EmmcHaccGen ^(prod.keys de la console requises^)?
	echo N'importe quel autre choix: Revenir au menu précédent.
	echo.
	set /p action_type=Faites votre choix: 
)
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier contenant la mise à jour extraite"
goto:eof

:firmware_choice_begin
echo Choisissez le firmware que vous souhaitez préparer?
echo.
echo Liste des firmwares:
goto:eof

:firmware_choice_end
echo F: Ouvrir le dossier contenant les firmwares déjà téléchargé?
IF NOT "%no_dir_choice%"=="Y" echo C: Choisir un dossier de firmware?
echo N'importe quel autre choix: Terminer ce script et revenir au choix de l'action principale de ce script.
echo.
set /p firmware_choice=Entrez le firmware souhaité ou une action à faire: 
goto:eof

:firmware_downloading_begin
echo Téléchargement du firmware %firmware_choice%...
goto:eof

:firmware_downloading_md5_error
echo Le md5 du firmware ne semble pas être correct. Veuillez vérifier votre connexion internet ainsi que l'espace disponible sur votre disque dur puis relancer le script. 
goto:eof

:firmware_downloading_md5_retry
echo Le md5 du firmware ne semble pas être correct, le téléchargement va être réessayé.
goto:eof

:firmware_exist_but_bad_md5_tested_error
echo Le fichier du firmware semble exister mais son MD5 est incorrect, il va donc être retéléchargé.
goto:eof

:firmware_downloading_end
echo Téléchargement du firmware %firmware_choice% terminé.
goto:eof

:extract_firmware_begin
echo Extraction du firmware pour la suite des traitements...
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD.
	echo.
set /p disk_not_finded_choice=Souhaitez-vous tenter de recharger la liste de disques ^(si non, le script se terminera^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Liste des disques: 
goto:eof

:disk_list_choice
echo 0: Revenir à la sélection de l'action principale de ce script.
echo.
echo.
set /p volume_letter=Entrez la lettre du volume de la carte SD que vous souhaitez utiliser: 
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

:disk_choice_letter_not_exist_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez. 
goto:eof

:disk_choice_not_fat32_formated_choice
	echo Attention: Le support que vous avez choisi n'est pas formaté en FAT32. Si vous n'avez pas installé le driver EXFAT sur votre Switch, il est nécessaire de formater la carte SD en FAT32. 
set /p cancel_script=Souhaitez-vous annuler les oppérations en cours pour formater la SD en FAT32 ^(le firmware ne sera pas à retélécharger^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copying_begin
echo Copie du firmware sur la SD dans le dossier "FW_%firmware_choice%" et copie du homebrew ChoiDuJour-NX...
goto:eof

:copying_end
echo Les fichiers ont été copiés.
goto:eof

:choidujour_special_message
echo Maintenant, la préparation du package de mise à jour avec ChoiDuJour va être lancée et vous allez devoir régler ces options.
goto:eof

:choidujournx_doc_launch_choice
set /p launch_choidujournx_doc=Souhaitez-vous consulter la documentation pour savoir comment utiliser ChoiDuJourNX ^(recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:choidujour_max_firmware_error
echo Impossible d'utiliser ChoiDuJour pour ce firmware, le firmware maximum supporté est le firmware 6.1.0.
goto:eof

:choidujour_max_firmware_error_but_choidujournx_uste_choice
echo Impossible d'utiliser ChoiDuJour pour ce firmware, le firmware maximum supporté est le firmware 6.1.0.
echo Cependant, le firmware peut être téléchargé et utilisé avec ChoiDuJourNX.
set /p cdjnx_use=Souhaitez-vous seulement télécharger le firmware pour l'utiliser avec ChoiDuJourNX? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:daybreak_keys_file_select
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous indiquer un fichier de clés pour vérifier/convertir le firmware pour être utilisé avec Daybreak? ^(%lng_yes_choice%/%lng_no_choice%^): "
IF %errorlevel% EQU 2 goto:eof
IF %errorlevel% EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier contenant les clés" "templogs\tempvar.txt"
	set /p keys_file_path=<"templogs\tempvar.txt"
)
goto:eof

:daybreak_keys_file_select_passed
echo Aucun fichier de clés indiqué, la vérification/conversion du firmware pour Daybreak ne sera pas faite.
goto:eof

:daybreak_convert_begin
echo Conversion du firmware pour Daybreak...
goto:eof

:daybreak_convert_keys_warning
echo Attention: Des clés semblent être manquantes dans votre fichiers de clés, la conversion pour Daybreak ne peut être ni vérifiée ni effectuée.
echo Pour que cela fonctionne, veuillez dumper les dernières clés grâce à la dernière version du payload Lockpick-RCM et indiquez ensuite le fichier dumpé comme fichier de clés.
goto:eof