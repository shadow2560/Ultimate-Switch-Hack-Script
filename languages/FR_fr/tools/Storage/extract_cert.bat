goto:%~1

:display_title
title Extraction certificat console %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'extraire le certificat d'une console via la partition PRODINFO déchiffrée de celle-ci.
echo Pour obtenir ce fichier, il va vous falloir les Bis Keys ^(Bis Key 0^) qui peuvent être obtenuent grâce au payload BiskeyDump.
echo Ensuite il y a deux possibilités, soit extraire le fichier d'une Switch directement en montant la partition EMMC de celle-ci ou soit extraire le fichier d'un dump de la nand.
echo Dans les deux cas, il faudra utiliser HacDiskMount pour extraire le fichier en lui indiquant les Bis Keys requises avant l'extraction.
echo Pendant le script, il vous sera proposer d'éventuellement lancer le payload BiskeyDump, de monter la partition EMMC d'une Switch puis de lancer HacDiskMount pour tenter d'obtenir le fichier PRODINFO.bin nécessaire mais il faut savoir comment s'y prendre pour l'extraction dans HacDiskMount car ceci ne peut être automatisé.
goto:eof

:launch_biskeydump_choice
set /p biskey=Souhaitez-vous lancer le payload BiskeyDump? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:mount_emmc_choice
set /p mount_emmc=Souhaitez-vous monter la partition EMMC de la Switch? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:rcm_instructions
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1^) Connecter la Switch en USB et l'éteindre
echo 2^) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3^) Faire un appui long sur VOLUME UP + appui court sur POWER ^(l'écran restera noir^)
echo En attente d'une Switch en mode RCM...
goto:eof

:after_rcm_instructions_choice
echo Le disque devrait être monté sur votre système. Pour le démonter, éjecter le périphérique à l'aide du bouton "retirer le périphérique en toute sécurité" situé sur la barre des tâches en bas à droite puis forcer l'extinction de la Switch en maintenant le bouton POWER pendant 10 secondes ^(Attention à ne pas écrire/lire de données pendant cette opération sous peine d'endommager gravement les données de votre nand^).
echo Pour explorer la mémoire interne de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur ^(nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la nand^). Si vous souhaitez faire un dump de la nand via cette méthode, le dump peut prendre du temps ^(environ trois heures^).
echo Parfois, le disque n'est pas reconu automatiquement. Vous devez ouvrir le gestionnaire de périphérique, trouver le périphérique avec un point d'exclamation nommé "Périphérique d’entrée USB" ^(testé sous Windows 7^), faire un clique droit dessus, cliquer sur "Mettre à jour le pilote...", cliquer sur "Rechercher automatiquement un pilote mis à jour" puis cliquer sur "Fermer". Le périphérique devrait maintenant être utilisable.
set /p launch_devices_manager=Souhaitez-vous lancer le gestionnaire de périphérique? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:launch_hacdiskmount_choice
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:prodinfo_file_choice
echo Vous allez devoir sélectionner le fichier "PRODINFO.bin" décrypter de la Switch dont le certificat doit être extrait.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers bin ^(*.bin^)|*.bin|" "Sélection du fichier PRODINFO.bin" "templogs\tempvar.txt"
goto:eof

:prodinfo_no_file_selected_error
echo Aucun fichier sélectionné, oppération annulée.
goto:eof

:certificat_first_success
ECHO Le fichier nx_tls_client_cert.pfx a été sauvegardé dans le répertoire "Certificat" à la racine du script.
ECHO Mot de passe = switch
goto:eof

:certificat_extraction_success
ECHO Le fichier nx_tls_client_cert.pem a été sauvegardé dans le répertoire "Certificat" à la racine du script.
ECHO Toutes les oppérations ont été complétées!
goto:eof