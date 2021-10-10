goto:%~1

:display_title
title Menu des autres fonctionnalités %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Menu des autres fonctionnalités
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Convertir un fichier XCI ou NCA en NSP?
echo.
echo 2: Convertir un NSP pour le rendre compatible avec le firmware de la Switch le plus bas possible?
echo.
echo 3: Installer des NSP via Goldleaf et le réseau?
echo.
echo 4: Installer des NSP via Goldleaf et l'USB ^(ne fonctionne plus avec les dernières versions de Goldleaf^)?
echo.
echo 5: Convertir une sauvegarde de Zelda Breath Of The Wild du format Wii U vers Switch ou inversement?
echo.
echo 6: Extraire le certificat d'une console?
echo.
echo 7: Vérifier des fichiers NSP?
echo.
echo 8: Découper un fichier NSP ou XCI en fichiers de 4 GO?
echo.
echo 9: Rassembler un XCI ou NSP découpé?
echo.
echo 10: Compresser/décompresser un jeu grâce à nsZip ^(fonctionnalité obsolète^)?
echo.
echo 11: Configurer l'émulateur Nes Classic Edition?
echo.
echo 12: Configurer l'émulateur Snes Classic Edition?
echo.
echo 13: Installer des applications Android ^(mode débogage USB requis^)?
echo.
echo 14: Créer un forwarder?
echo.
echo 15: Créer un nsp pour un jeu GameMaker?
echo.
echo 16: Injecter un jeu Sega Saturn ^(fonction en alpha^)?
echo.
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof