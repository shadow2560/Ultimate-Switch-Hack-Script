goto:%~1

:display_title
title Boîte à outils de logiciels %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Bienvenue dans la boîte à outils.
echo.
echo Ici, vous pouvez gérer le lancement de programmes ayant une interface graphique et qui ne sont donc pas interractif avec mon script.
echo Vous trouverez une liste d'outils par défaut qui interviennent parfois dans mon script et cette liste ne sera pas modifiable.
echo Par contre, vous pouvez également gérer votre liste de programmes personnel et donc en ajouter ou en supprimer un.
echo.
echo Attention, du fait du fonctionnement qui peut différer pour chaque programme, vous vous devez de gérer vous-même les dépendances de ceux-ci, cette boîte à outils ne sert qu'à lancer ou organiser vos outils.
goto:eof

:first_action_choice
echo Boîte à outils
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un programme?
echo 2: Ouvrir le dossier principal d'un programme de la liste de programmes personnels?
echo 3: Gérer la liste de programmes personnels?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:launch_software_begin
echo Lancement d'un logiciel
echo.
echo Liste des logiciels:
echo.
echo Logiciels par défaut:
goto:eof

:software_personal_list_begin
echo Logiciels personnels:
goto:eof

:launch_software_choice
echo N'importe quel autre chiffres: Revenir au menu de sélection du mode de la toolbox.
echo.
set /p launch_software_choice=Choisissez un logiciel à lancer ou une action à faire: 
goto:eof

:bad_char_error
echo Un caractère non-autorisé a été saisie.
goto:eof

:no_personal_software_defined_error
echo Aucun logiciel personnel défini, cette fonctionnalité ne peut donc pas être utilisée.
goto:eof

:launch_working_dir_choice
echo N'importe quel autre chiffres: Revenir au menu de sélection du mode de la toolbox.
echo.
set /p launch_software_choice=Choisissez un logiciel pour lequel son dossier de travail sera ouvert ou une action à faire: 
goto:eof

:manage_action_choice
echo Configuration de la liste des logiciels de la boîte à outils
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Ajouter un logiciel?
echo 2: Modifier le nom d'un logiciel?
echo 3: Supprimer un logiciel?
echo N'importe quel autre choix: Revenir au menu de sélection du mode de la toolbox.
echo.
set /p manage_choice=Faites votre choix: 
goto:eof

:software_name_choice
set /p software_name=Entrez le nom du logiciel: 
goto:eof

:software_name_empty_error
echo Le nom du logiciel ne peut être vide.
goto:eof

:software_name_char_error
echo Un caractère non autorisé a été saisie dans le nom du logiciel.
goto:eof

:software_copy_type_choice
set /p software_copy=Souhaitez-vous copier le logiciel dans le répertoire de travail du script? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:software_already_exist_error
echo Ce logiciel semble déjà avoir été copié dans le répertoire "toolbox" du script, l'ajout est donc annulé.
goto:eof

:software_type_choice
	echo Quel est le type du logiciel?
	echo.
	echo 1: Un logiciel n'utilisant qu'un seul fichier pour être lancé?
	echo 2: Un logiciel contenu dans un dossier dont les autres fichiers/dossiers de ce dossier sont nécessaires à sont fonctionnement?
	echo 0: Annuler la configuration de cet ajout et revenir au menu précédent.
	echo.
	set /p software_type=Faites votre choix: 
goto:eof

:choice_not_allowed_error
echo Ce choix n'est pas disponible.
goto:eof

:add_software_file_choice
echo Dans la prochaine étape, vous devrez indiquer où se trouve le logiciel sur votre ordinateur.
echo Si vous avez choisi de copier le logiciel et selon le type de logiciel choisi, le fichier indiqué et/ou le dossier qui le contient seront copiés dans le dossier "tools\toolbox" du script et le chemin sera adapté pour n'être qu'un chemin relatif vers l'exécutable choisi.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file2.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier principal de votre logiciel" "templogs\tempvar.txt"
goto:eof

:no_software_file_selected_error
echo Le fichier n'a pas été indiqué, la procédure d'ajout est annulée.
goto:eof

:add_software_success
echo Logiciel ajouté.
goto:eof

:modify_software_choice
echo N'importe quel autre chiffres: Revenir au menu  précédent.
echo.
set /p launch_software_choice=Faites votre choix: 
goto:eof

:modify_software_name_choice
set /p new_software_name=Entrez le nouveau nom du logiciel ^(si vide ou si le nom est exactement le même, l'ancien nom sera gardé^): 
goto:eof

:modify_software_not_renamed_error
echo Le logiciel n'a pas été renommé, retour au menu précédent.
goto:eof

:modify_software_success
echo Nom du logiciel modifié.
goto:eof

:del_software_success
echo Logiciel supprimé.
goto:eof