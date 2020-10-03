goto:%~1

:display_title
title Monter une partie de la nand d'une console %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Attention: Cette fonctionnalité peut monter la mémoire interne de votre Switch. Effectuer des modifications sur cette partie de la console peut entraîner un brick de celle-ci, vous êtes seul responsable de se que vous ferez avec ce script.
echo Notez que la lecture/écriture est assez lente dans ce mode mais cela peut être util pour copier/modifier/supprimer des données mais cela peut prendre du temps pour de gros fichiers.
echo S'il vous plaît, lisez bien attentivement toutes les informations données pendant le script.
goto:eof

:memory_choice
echo Quelle partie de la mémoire souhaitez-vous monter?
echo.
echo 1: Nand de la console ^(rawnand^).
echo 2: Carte SD.
echo 3: Boot0.
echo 4: Boot1
echo Tout autre choix: Retour au menu précédent.
echo.
set /p disc_mounted=Sélectionner la mémoire à monter: 
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

:after_launch_first_choice
echo Le disque devrait être monté sur votre système. Pour le démonter, éjecter le périphérique à l'aide du bouton "retirer le périphérique en toute sécurité" situé sur la barre des tâches en bas à droite puis forcer l'extinction de la Switch en maintenant le bouton POWER pendant 10 secondes ^(Attention à ne pas écrire/lire de données pendant cette opération sous peine d'endommager gravement les données de votre nand/sd^).
IF "%disc_mounted%"=="1" echo Pour explorer la mémoire interne de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur ^(nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la nand^). Si vous souhaitez faire un dump de la nand via cette méthode, le dump peut prendre du temps ^(environ trois heures^).
echo.
echo Parfois, le disque n'est pas reconu automatiquement. Vous devez ouvrir le gestionnaire de périphérique, trouver le périphérique avec un point d'exclamation nommé "Périphérique d’entrée USB" ^(testé sous Windows 7^), faire un clique droit dessus, cliquer sur "Mettre à jour le pilote...", cliquer sur "Rechercher automatiquement un pilote mis à jour" puis cliquer sur "Fermer". Le périphérique devrait maintenant être utilisable.
set /p launch_devices_manager=Souhaitez-vous lancer le gestionnaire de périphérique? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:hacdiskmount_launch_choice
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof