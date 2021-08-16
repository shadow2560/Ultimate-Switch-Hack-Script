goto:%~1

:display_title
title Création d'un forwarder NSP %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de créer un forwarder pour un fichier NRO ou une rom lancée par un coeur de Retroarch.
echo.
echo Vous aurez besoin d'un fichier de clés ainsi que d'une image au format 255x255.
goto:eof

:action_choice
echo Que souhaitez-vous faire:
echo 1: Créer un forwarder pour un NRO?
echo 2: Créer un forwarder pour une rom de Retroarch?
echo 3: Lancer une interface graphique pour créer des forwarders?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:set_id
echo Entrez l'ID du contenu ^(doit être unique sur la console sur lequel il est installé et doit faire 16 caractères hexadécimaux ^(0-9, A-F^)^), laissez vide pour générer un ID aléatoirement.
set /p id=ID: 
goto:eof

:id_too_small_error
echo Erreur, l'ID ne peut commencer qu'à partir de "01".
goto:eof

:id_length_error
echo Erreur, l'ID doit faire 16 caractères.
goto:eof

:bad_char_error
echo Un caractère non autorisé a été saisie.
goto:eof

:set_name
set /p name=Entrez le nom qui sera affiché: 
goto:eof

:could_not_be_empty_error
echo Cette valeur ne peut être vide.
goto:eof

:set_icon_path
echo Veuillez renseigner le fichier de l'icône du forwarder dans la fenêtre suivante, préférablement une image carré de 255X255.
echo Si vous fermez la fenêtre, le script se terminera sans rien faire.
pause
%windir%\system32\wscript.exe //Nologo tools\storage\functions\open_file.vbs "" "Fichiers d\'image standard ^(*.png;*.jpg;*.jpeg;*.bmp;*.gif^)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de l\'icône du forwarder" "templogs\tempvar.txt"
goto:eof

:set_resize_icon_image
set /p resize_icon_image=Souhaitez-vous changer la taille de l'image de l'icône pour qu'elle fasse 256X256 en carré? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_logo_path
echo Veuillez renseigner le fichier du logo du forwarder dans la fenêtre suivante, préférablement une image rectangle de 160X40.
echo Si vous fermez la fenêtre, le logo par défaut sera utilisé.
pause
%windir%\system32\wscript.exe //Nologo tools\storage\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection du logo du forwarder" "templogs\tempvar.txt"
goto:eof

:set_resize_logo_image
set /p resize_logo_image=Souhaitez-vous changer la taille de l'image du logo pour qu'elle fasse 160X40 en rectangle? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_nro_path
IF "%nsp_type%"=="nro" (
	set /p nro_path=Entrez le chemin du NRO à lancer: sdmc:/
) else IF "%nsp_type%"=="rom" (
	set /p nro_path=Entrez le chemin du NRO du coeur de Retroarch à utiliser: sdmc:/
)
goto:eof

:set_rom_path
set /p rom_path=Entrez le chemin de la rom à lancer: sdmc:/
goto:eof

:set_author
set /p author=Entrez le nom de l'auteur à afficher: 
goto:eof

:set_version
set /p version=Entrez la version à afficher: 
goto:eof

:set_keys_path
echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
echo Si vous fermez la fenêtre, le script se terminera sans rien faire.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "templogs\tempvar.txt"
goto:eof

:set_nsp_path
echo Veuillez renseigner le dossier vers lequel créer le forwarder dans la fenêtre suivante.
echo Si vous fermez la fenêtre, le script se terminera sans rien faire.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier vers lequel créer le forwarder"
goto:eof

:set_confirm_nsp_duplicated_deletion
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Le fichier ^"%nsp_path%%name%_%id%.nsp^" existe déjà, souhaitez-vous écraser le fichier ^(si oui le fichier sera effacé juste après ce choix, si non le script s'arrêtera sans rien faire^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:set_confirm_nsp_creation
echo Informations sur le forwarder à créer:
IF "%nsp_type%"=="nro" (
	echo Type de forwarder: NRO
) else IF "%nsp_type%"=="rom" (
	echo Type de forwarder: Retroarch rom
)
echo ID: %id%
echo Nom du forwarder: %name%
echo Chemin de l'icône: %icon_path%
IF /i "%resize_icon_image%"=="o" (
	echo Redimensionnement de l'icône: Oui
) else (
	echo Redimensionnement de l'icône: Non
)
IF "%logo_path%"=="" (
	echo Logo par défaut.
) else (
	echo Chemin du logo: %logo_path%
	IF /i "%resize_logo_image%"=="o" (
		echo Redimensionnement du logo: Oui
	) else (
		echo Redimensionnement du logo: Non
	)
)
IF "%nsp_type%"=="nro" (
	echo Chemin du NRO à lancer sur la SD: %nro_path%
) else IF "%nsp_type%"=="rom" (
	echo Coeur de Retroarch à lancer sur la SD: %nro_path%
	echo Chemin de la rom sur la SD: %rompath%
)
echo Auteur: %author%
echo Version: %version%
echo Chemin du fichier de clés: %keys_path%
echo Chemin de sortie du NSP: %nsp_path%
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous continuer avec ces paramètres? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:nsp_build_begin
echo Construction du forwarder...
goto:eof

:icon_convert_error
echo Une erreur s'est produite durant la convertion de l'image de l'icône, la création du forwarder va s'arrêter.
goto:eof

:logo_convert_error
echo Une erreur s'est produite durant la convertion de l'image du logo, la création du forwarder va s'arrêter.
goto:eof

:forwarder_build_error
echo Une erreur s'est produite durant la création du forwarder.
echo.
echo Assurez-vous que le fichier de clés fourni est correct et que vous avez assez d'espace sur le disque pour écrire le forwarder.
goto:eof

:forwarder_build_success
echo "%nsp_path%%name%_%id%.nsp" a été créé avec succès.
goto:eof