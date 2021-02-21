goto:%~1

:display_title
title Menu de mises à jour et de débrickage %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Menu de mises à jour et de débrickage
echo.
echo Attention: N'utilisez surtout aucune de ces fonctions sur une console équipées de puces SX Core/SX Lite sous peine de brick de la console et surtout n'utilisez pas ChoiDuJour-NX sur ces consoles.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Préparer une mise à jour via ChoiDuJour-NX sur la SD et/ou un package de mise à jour via ChoiDuJour en téléchargeant le firmware via internet?
echo 2: Débricker une console ^(fonction en beta^)?
echo 3: Créer un package de mise à jour de la Switch via ChoiDuJour via un fichier ou un dossier déjà téléchargé??
echo 4: Créer un fichier BOOT0 pour réparrer une erreurs sur les keyblobs ^(fonction en beta^)?
echo 5: Débrickage sur PRODINFO ^(fonction en beta^)?
echo 6: Créer un package de mise à jour de la Switch via EmmcHaccGen via un  dossier déjà téléchargé??
echo 7: Créer les sig_patches pour Atmosphere?
echo 0: Obtenir une assistance sur le débrickage?
echo.
echo N'importe quel autre choix: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof