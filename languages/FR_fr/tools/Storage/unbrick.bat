goto:%~1

:display_title
title Débrickage %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Bienvenue dans ce script permettant de débricker une console.
echo.
echo Veuillez bien suivre les instructions qui vous seront données tout au long de la procédure.
echo.
echo Je ne pourrais être tenu pour responsable en cas de problèmes suite à l'exécution de cette procédure.
echo.
echo Veuillez, si vous ne l'avez pas fait avant, faire une sauvegarde complète de votre nand ainsi que de tout élément que vous souhaitez sauvegarder, ceci ne sera pas couvert par ce script.
echo.
echo Attention, à la fin de cette procédure, toutes les données de la sysnand ^(nand de la console^) seront supprimées.
echo Notez également que le firmware qui sera installé sera le firmware 5.1.0 si vous choisissez la méthode ChoiDuJour.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous continuer la procédure? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:intro_2
echo.
echo Pour continuer, il sera nécessaire d'avoir une connexion à internet, 1 GO de libre sur le disque dur ^(peut être moins, cela dépend des éléments à télécharger durant le script^), une SD avec 500 MO d'espace libre ^(préférablement une SD vierge ou sinon sauvegarder les dossiers "atmosphere" et "sept" de la SD s'ils existent pour pouvoir les restaurer facilement après cette procédure^) et une Switch  connectée au PC via un câble USB et qui pourra être démarée en RCM à tout moment.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous installer les drivers pour que le PC reconnaisse les Switch en mode RCM ^(à ne faire qu'une seul fois par PC^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:dump_keys_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous dumper les clés de votre console non patchée ^(très vivement recommandé pour vérifier si la console peut éventuellement être débricker via cette méthode ou nécessaire si la méthode via EmmcHaccGen est utilisée^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:dump_keys_instructions_begin
echo.
echo Insérez votre SD dans la Switch et allumez-là en mode RCM.
echo ATTENTION: Si votre firmware actuel est supérieur au firmware 7.0.0, le dossier "sept" d'Atmosphere est nécessaire pour pouvoir dumper les clés donc veuillez copier celui-ci à la racine de votre SD.
echo Attention: Si votre console est un modèle patché, vous devrez lancer le payload Lockpick-RCM via une méthode non prise en charge via ce script.
goto:eof

:dump_keys_instructions_end
echo Le payload devrait être lancé sur votre console.
echo Appuyez sur le bouton "Power" pour lancer le dump des clés.
echo.
echo Si le dump n'a pas fonctionné, veuillez le préciser dans le choix qui va suivre pour arrêter le script.
echo Si vous n'avez pas copié le dossier "sept" d'Atmosphere à la racine de votre SD, faites-le et relancez le script.
echo Si cela ne fonctionne toujours pas, le problème de la console ne pourra probablement pas être résolu seulement avec cette méthode de débrickage.
echo.
echo Si le dump a fonctionné ou que vous souhaitez tout de même continuer la procédure, vous pouvez remettre la SD dans le PC pour la suite, le fichier de clés sera le fichier "switch\prod.keys" situé sur la SD.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Le dump des clés s'est-il bien passé? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:patched_console_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous débricker une console patchée? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:mariko_console_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous débricker une console Mariko ^(numéro de série ne commençant pas par "XA"^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:method_creation_firmware_unbrick_choice
echo Quelle méthode souhaitez-vous utiliser pour créer le firmware du package de débrickage:
echo 1: Méthode via ChoiDuJour ^(méthode plus universelle ne nécessitant pas un prod.keys lié à la console^)?
echo 2: Méthode via EmmcHaccGen ^(méthode nécessitant le prod.keys de la console et donc package utilisable uniquement sur une console spécifique^)?
echo 0: Quitter le script sans rien faire?
echo.
choice /c 120 /n /m "Faites votre choix: "
goto:eof

:extract_error
echo Une erreur s'est produite durant une extraction de fichiers, le script va s'arrêter.
echo Vérifiez l'espace disque sur lequel vous exécutez le script et que celui-ci est exécuté en tant qu'administrateur.
goto:eof

:define_new_keys_file_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous définir un nouveau fichier de clés par défaut? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:keys_file_not_finded
echo Fichiers clés non trouvé, veuillez suivre les instructions.
goto:eof

:keys_file_selection
if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF /i NOT "%define_new_keys_file%"=="o" (
		echo Veuillez renseigner le fichier de clés dans la fenêtre suivante, préférez le fichiers prod.keys lié à votre console si vous l'avez.
	)
) else (
	echo Veuillez renseigner le fichier de clés dans la fenêtre suivante, le fichiers prod.keys lié à votre console.
)
	pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:choidujour_keys_file_creation
IF "%create_choidujour_keys_file_state%"=="0" (
	echo Création du fichier "ChoiDuJour_keys.txt" effectuée avec succès.
) else IF "%create_choidujour_keys_file_state%"=="1" (
	echo La clé "%key_missing%" obligatoire ne se trouve pas dans le fichier de clé, le script ne peux pas continuer.
) else IF "%create_choidujour_keys_file_state%"=="2" (
	echo La dernière clé facultative trouvée est la clé "%key_missing%", vous ne pourrez générer que des packages de mise à jour jusqu'au firmware n'utilisant que les clés jusqu'à celle-ci.
)
goto:eof

:choidujour_keys_file_create_error
echo Il semble que le fichier de clés nécessaire à ChoiDuJour n'ait pu être créé, veuillez vérifier votre fichier de clés et relancer le script.
echo Pour vous aider, regarder les clés incorrectes qui se sont affichées juste avant.
goto:eof

:no_internet_connection_error
echo Aucune connexion à internet disponible, le script va s'arrêter.
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous tenter de recharger la liste de disques ^(si non, le script se terminera^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:disk_list_begin
echo Liste des disques:
goto:eof

:disk_choice
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser ou entrez "0" pour quitter le script: 
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

:disk_format_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous formater la SD ^(volume "%volume_letter%"^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:disk_format_type_choice
echo Quel type de formatage souhaitez-vous effectuer:
echo 1: EXFAT ^(la Switch doit avoir le support pour ce format d'installé^)?
echo 2: FAT32 ^(limité au fichier de moins de 4 GO^)?
echo 0: Annule le formatage.
echo.
choice /c 120 /n /m "Choisissez le type de formatage à effectuer: "
goto:eof

:disk_formating_begin
echo Formatage en cours...
goto:eof

:disk_formating_error
echo Un problème s'est produit pendant la tentative de formatage, le script va maintenant s'arrêter.
goto:eof

:disk_formating_success
echo Formatage effectué avec succès.
goto:eof

:disk_formating_fat32_not_admin_error
echo La demande d'élévation n'a pas été acceptée, le formatage est annulé.
goto:eof

:disk_formating_fat32_disk_used_error
echo Le formatage n'a pas été effectué.
echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script.
echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_disk_not_exist_error
echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_unknown_error
echo Une erreur inconue s'est produite pendant le formatage.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_canceled_info
echo Le formatage a été annulé par l'utilisateur.
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

:copy_to_sd_error
echo Une erreur s'est produite durant la copie de fichiers sur la SD, le script va s'arrêter.
echo Vérifiez l'espace disponible sur votre SD ou que celle-ci ne soit pas protégée en écriture.
goto:eof

:optional_firmware_download_choice
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous ajouter un firmware optionnel pour pouvoir faire une mise à jour via ChoiDuJour-NX lorsque la console sera débrickée? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:firmware_choice_begin
if "%method_creation_firmware_unbrick_choice%"=="1" (
	echo Choisissez le firmware que vous souhaitez installer via ChoiDuJourNX lorsque la console fonctionnera de nouveau.
) else (
	echo Choisissez le firmware que vous souhaitez préparer via EmmcHaccGen.
)
echo.
echo Liste des firmwares:
goto:eof

:firmware_choice_end
echo N'importe quel autre choix: Terminer ce script.
echo.
set /p firmware_choice=Entrez le firmware souhaité ou une action à faire: 
goto:eof

:create_choidujour_package_backup_warning
echo Une erreur s'est produite durant la sauvegarde du package de ChoiDuJour, vérifiez votre espace disque sur lequel s'exécute ce script.
echo Cependant, le script peut continuer.
goto:eof

:package_creation_success
echo Firmware créé avec succès.
goto:eof

:package_creation_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
goto:eof

:emmchaccgen_package_creation_first_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
echo.
echo Cependant, il est aussi possible que .net Framework 3 ne soit pas installé sur votre système.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous installer .net Framework 3 sur votre système? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:netfx3_install_error
echo Erreur durant l'installation de .net Framework 3.
goto:eof

:emmchaccgen_package_creation_second_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
echo.
echo Cependant, il est aussi possible que votre système nécessite un redémarrage.
echo Vous pouvez essayer de quitter le script, redémarrer votre système et retenter la procédure.
goto:eof

:boot0_keyblobs_reparation_choice
echo Vous pouvez réparer les keyblobs dans le fichier BOOT0 si vous avez des erreurs liées à celles-ci lors du dump des clés via Lockpick-RCM.
echo Attention, ceci est une opération avancée et rarement nécessaire, ne l'effectuer que si vous savez se que vous faites.
echo Attention également, il est nécessaire d'avoir choisi le fichier de clés lié à la console et dumpé avec Lockpick-RCM sur celle-ci lors de votre choix du fichier de clés durant ce script.
echo.
echo Que souhaitez-vous faire?
echo 1: Ne pas modifier le fichier BOOT0 et continuer (recommandé^).
echo 2: Modifier le fichier BOOT0 et continuer.
echo 0: Terminer ce script.
echo.
choice /c 120 /n /m "Faites votre choix: "
goto:eof

:boot0_keyblobs_reparation_error
echo Une erreur s'est produite durant la tentative de modification de BOOT0, le script va continuer avec les fichiers originaux.
echo.
echo Cette erreur peut signifier qu'il manque certaines clés  dans votre fichier de clés, veuillez donc le vérifier avant de réessayer cette procédure de débrickage.
echo.
echo Clés communes nécessaires, trouvable assez facilement sur internet:
echo keyblob_00 à keyblob_05, keyblob_key_source_00 à keyblob_key_source_05, keyblob_mac_key_source
echo.
echo Clés uniques à la console nécessaires:
echo secure_boot_key, tsec_key, 
echo.
echo Clés uniques à la console optionnelles, au moins un des deux groupes nécessaires mais les deux seraient évidemment mieux:
echo keyblob_key_00 à keyblob_key_05, keyblob_mac_key_00 à keyblob_mac_key_05
echo.
goto:eof

:boot0_keyblobs_reparation_first_error
echo Une erreur s'est produite durant la création du fichier BOOT0 à reconstruire.
echo.
echo Si vous possédez un fichier contenant les clés communes nécessaire ^(un fichier récupéré via une console fonctionnelle par exemple^) vous pouvez tenter de le renseigner.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous renseigner un fichier de clés complémentaire? ^(%lng_yes_choice%/%lng_no_choice%^): "
if !errorlevel! EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier complémentaire de clés" "templogs\tempvar.txt"
)
goto:eof

:boot0_keyblobs_reparation_success
echo Fichier BOOT0 modifié avec succès, souvenez-vous bien que celui-ci ne devra pas être utilisé sur une autre console que celle liée au clés utilisées durant ce script.
goto:eof

:copy_begin_info
echo Copie sur la SD en cours...
goto:eof

:restore_method_choice
echo Quelle méthode de restauration souhaitez-vous effectuer?
echo 1: Méthode uniquement via TegraExplorer, recommandée dans la plupart des cas?
echo 2: Méthode via TegraExplorer et HacDiskMount, par exemple si vous restaurez la nand via une autre console que celle à laquelle la nand est liée, à ne faire que si vous savez vraiment se que vous faites?
echo 0: Terminer ce script.
echo.
choice /c 120 /n /m "Faites votre choix: "
goto:eof

:copying_end
echo Les fichiers nécessaires ont été préparés, vous pouvez remettre la SD dans la Switch.
goto:eof

:tegraexplorer_launch_begin
echo La restauration de la nand va commencer, si vous n'avez pas encore fait un dump de la nand via Hekate par exemple c'est le moment ou jamais de le faire, ceci ne sera pas couvert ici.
pause
echo.
echo Maintenant, avec l'aide de TegraExplorer, nous allons restaurer la nand.
echo.
echo Passer la console en RCM.
echo.
echo Attention: Pour les consoles patchées, le lancement des payloads doit se faire via une méthode non traitée par ce script.
goto:eof

:tegraexplorer_launch_correctly_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Le payload TegraExplorer s'est-il lancé sur la console? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:tegraexplorer_launch_end
echo.
echo Une fois le payload lancé, vous devriez voir un script nomé "cdj_restore_firmware".
echo Aller dessus avec les flèches dirrectionnel ou avec les boutons de volume et valider avec le bouton "A" ou le bouton "Power".
echo Le script se lance et présente un menu.
echo En premier lieu, lancer le choix "Sauvegarder BOOT0, BOOT1, PRODINFO et PRODINFOF" ^(à ne faire qu'une seule fois^) et garder les fichiers créés de côté, se sont les fichiers les plus importants à avoir absoluement en cas de problèmes.
IF "%restore_method%"=="1" (
	echo Sélectionner le choix "Restaurer avec suppression de données" ^(attention, une fois ce script exécuté, toutes les données de la sysnand seront supprimés^) ou le choix "Restaurer sans suppression de données" ^(moins de chances de fonctionner^).
) else IF "%restore_method%"=="2" (
	echo Sélectionner le choix "Restaurer seulement les partitions BOOT0, BOOT1 et BCPKG2-*".
	echo Attention, une fois le script exécuté, il faudra ensuite restaurer les partitions SYSTEM et USER grâce à Memloader et HacDiskMount ou via une autre méthode.
)
echo Attention, ce script de TegraExplorer nécessite des fichiers précédemment copiés par ce script, ne jamais l'exécuter autrement que durant cette procédure.
echo Attention également, n'utiliser la possibilité de choix du dossier à restaurer que si vous savez se que vous faites, sinon gardez les actions par défaut.
echo Notez également que la console, si le script a bien fonctionné, est maintenant en auto-RCM donc simplement appuyer sur le bouton "Power" au démarrage ou brancher la console éteinte à une prise USB démarrera la console en RCM.
echo.
IF "%restore_method%"=="1" (
	echo Une fois le script sur la console terminé sans erreur, éteindre la console ou redémarrer sur le payload Hekate via TegraExplorer.
) else IF "%restore_method%"=="2" (
	echo Une fois le script sur la console terminé sans erreur, éteindre la console.
)
goto:eof

:memloader_launch_begin
echo Grâce à Memloader et HacDiskMount, nous allons maintenant restaurer le contenu des partitions SYSTEM et USER.
echo.
echo Passer la console en RCM.
goto:eof

:memloader_launch_correctly_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Le payload Memloader s'est-il lancé sur la console ^(l'écran devrait être légèrement allumé^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:memloader_launch_end
echo Attention, si l'ordinateur demande de formater un disque, refuser absolument ce choix.
echo Attention, pour la suite vous devrez avoir activé l'affichage des fichiers cachées ainsi que l'affichage des fichiers systèmes sur Windows, ceci ne sera pas traité ici.
echo.
echo Maintenant, HacDiskMount va se lancer.
if "%method_creation_firmware_unbrick_choice%"=="1" (
	echo Vous verrez aussi l'ouverture d'un dossier "NX-5.1.0_exfat" dans une fenêtre d'explorateur de fichiers, il sera très utile.
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	echo Vous verrez aussi l'ouverture d'un dossier "%emmchaccgen_firmware_folder%" dans une fenêtre d'explorateur de fichiers, il sera très utile.
)
echo.
echo Dans HacDiskMount, vous devrez cliquer sur "file" puis sur "Open physical drive" et sélectionnez le disque de la Switch.
echo Une fois cela fait, la liste des partitions devrait s'afficher.
echo Faites un double-clique sur la partition "SYSTEM".
echo Si le driver n'est pas installé, cliquez sur "Install" dans la section "Virtual drive" et acceptez les éventuels message qui s'afficheront.
echo Entrez les clés puis cliquez sur "Test". Si un message de couleur verte s'affiche, cliquez sur "Save". Attention, si un message en rouge s'affiche, inutile de continuer.
echo Revenez en arrière et faire un double-clique sur la partition "USER".
echo Entrez les clés puis cliquez sur "Test". Si un message de couleur verte s'affiche, cliquez sur "Save". Attention, si un message en rouge s'affiche, inutile de continuer.
echo Revenir sur la partition "SYSTEM".
echo Dans la section "Virtual drive", sélectionnez une lettre de lecteur dans la liste, cocher la case "Passthrough zeroes" et enfin cliquez sur "Mount".
echo Vous devriez voir un nouveau disque avec la lettre de lecteur choisi dans votre poste de travail ^(parfois appelé "ordinateur" ou "ce pc" selon la version de Windows installée^), entrez dedans et supprimez tout se qui s'y trouve.
if "%method_creation_firmware_unbrick_choice%"=="1" (
	echo Dans le dossier "NX-5.1.0_exfat" qui s'est également ouvert en même temps que HacDiskMount, allez dans le dossier "SYSTEM", copiez tout se qui s'y trouve et collez-le dans le lecteur créé par HacDiskMount.
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	echo Dans le dossier "%emmchaccgen_firmware_folder%" qui s'est également ouvert en même temps que HacDiskMount, allez dans le dossier "SYSTEM", copiez tout se qui s'y trouve et collez-le dans le lecteur créé par HacDiskMount.
)
echo Une fois terminé sans erreurs, fermez le lecteur créé par HacDiskMount, revenez sur ce dernier, cliquez sur "Unmount" et revenez sur la liste des partitions.
echo Faites exactement comme vous venez de procéder avec la partition "SYSTEM" mais en remplaçant "SYSTEM" par "USER".
echo Fermez HacDiskMount et éteindre la console en maintenant le bouton "Power" de celle-ci jusqu'à son extinction.
echo.
goto:eof

:hekate_launch_begin
echo Maintenant, avec l'aide de Hekate, nous allons essayer de lancer le firmware restauré.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous lancer le payload Hekate? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:hekate_rcm_instruction
echo Passer la console en RCM.
goto:eof

:hekate_launch_end
echo.
if "%method_creation_firmware_unbrick_choice%"=="1" (
	echo Une fois le payload lancé, cliquez sur "More configs" ^(second icône à gauche^).
	echo Ensuite, cliquez sur "sysnand first launch FW 5.1.0" ^(premier icône en haut à gauche^).
	echo.
	IF "%optional_firmware_download%"=="Y" (
		echo Si la console a démarrée, vous pourez démarrer Atmosphere avec une des configurations disponibles dans le menu "More configs" de Hekate puis mettre à jour sur le firmware que vous avez choisi au début de ce script grâce à ChoiDuJourNX ^(choisir de préférence le firmware EXFAT que vous proposera ChoiDuJourNX, le reste des instructions ne seront pas couverte ici^). Vous pouvez aussi mettre à jour la console de manière officielle si celle-ci n'est pas bannie, attention rien n'est garantie sur la sureté de mise à jour via cette procédure.
	) else (
		echo Si la console a démarrée, vous pouvez faire se que vous voulez avec elle.
	)
	echo Attention: La configuration "sysnand first launch FW 5.1.0" dans Hekate ne doit pas être relancée si la console a bien démarrée au moins une fois.
	echo.
	echo Si la console n'a pas démarré, réessayez de lancer de nouveau Hekate et choisir la même configuration à lancer ou une des autres disponibles dans le menu "More configs".
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	echo Une fois le payload lancé, cliquez sur "Payloads" ^(troisième icône à gauche^).
	echo Ensuite, cliquez sur "Atmosphere_fusee-primary.bin".
	echo Atmosphere devrait démarrer. Vous pouvez aussi utiliser les options normales de Hekate pour booter en mode stock si vous ne souhaitez pas lancer Atmosphere, méthode non traitée ici.
)
echo Si cela ne fonctionne toujours pas, soit quelque chose s'est mal passé durant le script et dans ce cas refaire les opérations depuis le début ou soit le problème ne peut être résolu via cette méthode.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous relancer Hekate? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:script_end_message
echo Merci d'avoir utilisé ce script.
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