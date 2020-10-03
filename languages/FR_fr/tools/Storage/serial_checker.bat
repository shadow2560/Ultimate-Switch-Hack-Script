goto:%~1

:display_title
title Vérification de numéro de séries pour exploit Fusee Gelee %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre de tester un ou plusieurs numéro^(s^) de série  de console^(s^) pour savoir si celle^(s^)-ci est/sont patchée^(s^), peut-être patchée^(s^) ou non-patchée^(s^).
echo.
echo Ces données peuvent parfois être imprécises, si vous rencontrez une situation contradictoire avec le résultat de ce script, merci de m'en avertir  en indiquant les dix premiers chiffres du numéro de série ainsi que la base de données utilisée, le résultat obtenu et enfin la contradiction.
echo Il est important de rapporter également les données concernant des consoles pour lequel le résultat est "peut-être patchée", cela permettra d'affiner la base de données des numéros de série compatible ou non avec plus de certitudes.
echo.
echo Un grand merci à AkdM de logic-sunrise pour le script python qui sera utilisé tout au long de ce script et merci à tout ceux qui m'ont aider et m'aideront à affiner la base de données.
echo.
echo Attention: Il est recommandé d'avoir une connexion à internet pour exécuter ce script pour que la base de donnée soit mise à jour vers la dernière version.
goto:eof

:begin_update_database
echo Mise à jour de la base de données...
goto:eof

:no_database_and_no_internet_connection_error
echo Aucune connexion à internet et il n'y a aucun fichier de base de donnée de téléchargé, le script ne peut pas continuer et va donc revenir au menu précédent.
goto:eof

:no_internet_connection_info
echo Aucune connexion à internet pour télécharger la base de données, la dernière version téléchargée sera donc utilisée.
goto:eof

:database_choice
echo Choix de la base de données à télécharger:
echo.
echo 1: Base de données classique, moins précise mais plus juste et plus testée?
echo 2: Base de données beta, plus précise mais peut contenir plus d'erreurs?
echo 0: Terminer ce script et revenir au menu précédent?
echo N'importe quel autre choix: Ne pas télécharger de base de données et utiliser la dernière version qui a été téléchargée?
echo.
set /p database_choice=Faites votre choix: 
	goto:eof

:update_database_success
echo Mise à jour de la base de donnée effectuée avec succès.
goto:eof

:serial_choice
echo Que souhaitez-vous faire?
echo.
echo 0: Revenir au menu précédent.
echo 1: M'avertir  sur une incohérence ou un résultat permettant d'affiner la vérification.
echo 2: Changer de base de données ^(nécessite une connexion à internet^)?
echo.
set /p console_serial=Entrez un numéro de série ou choisissez une option: 
goto:eof

:serial_empty_error
echo Ce choix ne peut être vide.
goto:eof

:serial_patched
echo La console %console_serial% est patchée.
goto:eof

:serial_warning
echo La console %console_serial% est peut-être patchée.
goto:eof

:serial_safe
echo La console %console_serial% n'est pas patchée.
goto:eof

:serial_bad_value
echo Le numéro de série entré est incorrect.
goto:eof

:serial_error
echo Une erreur inconnue s'est produite, réessayez.
goto:eof