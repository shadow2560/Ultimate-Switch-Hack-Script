goto:%~1

:display_title
title Sega Saturn Game Inject %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_menu
echo.
echo 		************      ************   ************                         
echo   	    	 *************    ************    ******************                       
echo   	      	  ***********    ************    *********************                     
echo   	       	   ********   ************    Markus95    *************                    
echo   	       	    ******  *************        ^&         **************                  
echo   	       	     ***  ************          Red-J         ************                 
echo   	       	     ***  ************        shadow256         ************                 
echo   	       	         *************                         ************                
echo   	       	        *************         Présentent:        ***********               
echo   	       	          ************                        **********   ***               
echo   	       	           *************     NS Saturn Game Injector    *************   ****           
echo   	       	              *************     v1.0   *************    *********        
echo   	       	               *********************  *************   ************       
echo   	       	                 ******************  *************    *************      
echo   	       	                  ***************  *************       *************    
echo   	       	                   ***********   *************          *************   
echo.
echo 	-=======================================================================================================-
echo							Que souhaitez-vous faire:
echo							1: Afficher l'aide
echo							2: Commencer l'injection
echo 3: Lancer CDmage pour convertir des images CD en format .cue et .bin, seul format supporté pour l'injection.
echo							Tout autre choix: Revenir au menu précédent
echo 	-=======================================================================================================-
set /p begin=Faites votre choix: 
goto:eof

:nsp_source_choice
IF /i "%display_good_saved_games%"=="Y" (
	echo Quel jeux souhaitez-vous utiliser comme base source:
	IF NOT "%filename0_path%"=="" echo 1: %filename0%
	IF NOT "%filename1_path%"=="" echo 2: %filename1%
	IF NOT "%filename2_path%"=="" echo 3: %filename2%
	echo 0: Sélectionner un NSP
	echo Tout autres choix: Revenir au menu précédent.
	echo.
	set /p br=Faites votre choix: 
	IF "!br!"=="0" %windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier nsp nintendo Switch ^(*.nsp^)|*.nsp|" "Sélection du fichier nsp source du jeu Saturn" "%ushs_base_path%templogs\tempvar.txt"
) else (
	echo Choisissez  le fichier NSP source du jeu saturn  dans la fenêtre suivante.
	echo Si vous refermez la fenêtre vous retournerez au menu.
	pause
	%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier nsp nintendo Switch ^(*.nsp^)|*.nsp|" "Sélection du fichier nsp source du jeu Saturn" "%ushs_base_path%templogs\tempvar.txt"
)
goto:eof

:set_saturn_game_source
echo Choisissez le fichier cue du jeu Saturn à injecter dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichiers cue ^(*.cue^)|*.cue|" "Sélection du fichier cue du jeu Saturn à injecter" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:cue_file_error
echo Une erreur s'est produite durant l'analyse du fichier cue.
goto:eof

:set_keys_path
echo Choisissez le fichier prod.keys dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier de clés switch ^(*.*^)|*.*|" "Sélection du fichier prod.keys" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_title_keys_path
echo Choisissez le fichier title.keys dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier de clés switch ^(*.*^)|*.*|" "Sélection du fichier title.keys" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_icon_type_choice
set /p bs=Souhaitez-vous utiliser votre propre image pour l'icône du jeu? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_icon_path
echo Sélectionnez le fichier de l'icône dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type d'icône.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichiers jpg et png ^(*.jpg;*.png^)|*.jpg;*.png|" "Sélectionner le fichier de l\'icône" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_ini_choice
set /p custom_ini_choice=Souhaitez-vous utiliser votre propre fichier ini de configuration de l'émulateur pour le jeu? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_ini_path
echo Sélectionnez le fichier ini dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type de fichier ini.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichiers ini^(*.ini^)|*.ini|" "Sélectionner un fichier ini personnalisé" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_wallpaper_choice
set /p custom_wallpaper_choice=Souhaitez-vous utiliser votre propre dossier  de fonds d'écran pour le jeu ^(le dossier devra contenir les quatre fichiers nommés "WP_001.tex" à "WP_004.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_wallpaper_folder_path
echo Sélectionnez le dossier de fonds d'écran dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type de fonds d'écran.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier des fonds d'écran"
goto:eof

:set_custom_credit_choice
set /p custom_credit_choice=Souhaitez-vous utiliser votre propre dossier  de crédits pour le jeu ^(le dossier devra contenir les deux fichiers nommés "00.tex" et "01.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_credit_folder_path
echo Sélectionnez le dossier de crédits dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type de crédits.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier des crédits"
goto:eof

:set_custom_playingguide_choice
set /p custom_playingguide_choice=Souhaitez-vous utiliser votre propre dossier  du guide de jeu pour le jeu ^(le dossier devra contenir les fichiers nommés "00.tex" à maximum "03.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_playingguide_folder_path
echo Sélectionnez le dossier du guide de jeu dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type du guide de jeu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier du guide de jeu"
goto:eof

:set_custom_texture_choice
set /p custom_texture_choice=Souhaitez-vous utiliser votre propre fichier de texture pour le jeu? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_texture_path
echo Sélectionnez le fichier de texture dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type de fichier de texture.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichiers tex^(*.tex^)|*.tex|" "Sélectionner un fichier de texture personnalisé" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_nodata_choice
set /p custom_nodata_choice=Souhaitez-vous utiliser votre propre fichier "no_data.tex" pour le jeu? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_nodata_path
echo Sélectionnez le fichier "no_data.tex" dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au choix du type de fichier "no_data.tex".
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichiers tex^(*.tex^)|*.tex|" "Sélectionner un fichier ^"no_data.tex^" personnalisé" "%ushs_base_path%templogs\tempvar.txt"
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
set /p name=Entrez le nom du jeu à afficher ^(128 caractères maximum^): 
goto:eof

:could_not_be_empty_error
echo Cette valeur ne peut être vide.
goto:eof

:name_length_error
echo Erreur, le nom doit faire 128 caractères au maximum.
goto:eof

:name_char_error
echo Un caractère non autorisé a été saisie dans le nom du jeu.
goto:eof

:set_author
set /p author=Entrez le nom de l'auteur à afficher ^(64 caractères maximum^): 
goto:eof

:author_length_error
echo Erreur, l'auteur doit faire 64 caractères au maximum.
goto:eof

:set_version
set /p version=Entrez la version à afficher ^(4 caractères maximum^): 
goto:eof

:version_length_error
echo Erreur, la version doit faire 4 caractères au maximum.
goto:eof

:set_nsp_path
echo Sélectionnez le répertoire dans lequel créer le nsp du jeu dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\select_dir.vbs" "%ushs_base_path%templogs\tempvar.txt" "Sélection du répertoire dans lequel le nsp du jeu sera créé"
goto:eof

:set_confirm_nsp_duplicated_deletion
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Le fichier ^"%nsp_path%%name%_%id%.nsp^" existe déjà, souhaitez-vous écraser le fichier ^(si oui le fichier sera effacé juste après ce choix, si non le script s'arrêtera sans rien faire^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:set_confirm_nsp_creation
echo Informations sur le jeu Saturn à injecter:
IF "%br_choice%"=="" echo Chemin du NSP source du jeu Saturn: %br%
IF NOT "%br_choice%"=="" echo Jeu base utilisé: !filename%br_choice%!
echo Chemin du fichier cue du jeu Saturn à injecter: %saturn_game_source%
echo ID: %id%
echo Nom du jeu: %name%

IF /i "%bs%"=="o" echo Chemin de l'icône personnalisé: %bz%
IF /i NOT "%bs%"=="o" echo Icône par défaut.

IF /i "%custom_ini_choice%"=="o" echo Chemin du fichier ini personnalisé: %custom_ini_path%
IF /i NOT "%custom_ini_choice%"=="o" echo Fichier ini par défaut.

IF /i "%custom_wallpaper_choice%"=="o" echo Chemin du dossier des fonds d'écran personnalisé: %custom_wallpaper_folder_path%
IF /i NOT "%custom_wallpaper_choice%"=="o" echo Dossier des fonds d'écran par défaut.

IF /i "%custom_playingguide_choice%"=="o" echo Chemin du dossier du guide de jeu personnalisé: %custom_playingguide_folder_path%
IF /i NOT "%custom_playingguide_choice%"=="o" echo Dossier du guide de jeu par défaut.

IF /i "%custom_credit_choice%"=="o" echo Chemin du dossier des crédits personnalisé: %custom_credit_folder_path%
IF /i NOT"%custom_credit_choice%"=="o" echo Dossier des crédits par défaut.

IF /i "%custom_texture_choice%"=="o" echo Chemin du fichier de texture personnalisé: %custom_texture_path%
IF /i NOT "%custom_texture_choice%"=="o" echo Fichier de texture par défaut.

IF /i "%custom_nodata_choice%"=="o" echo Chemin du fichier no_data personnalisé: %custom_nodata_path%
IF /i NOT "%custom_nodata_choice%"=="o" echo Fichier no_data par défaut.

echo Auteur: %author%
echo Version: %version%
echo Chemin du fichier prod.keys: %keys_path%
rem IF "%br_choice%"=="" echo Chemin du fichier title.keys: %title_keys_path%
echo Chemin de sortie du NSP: %nsp_path%%name%_%id%.nsp
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous continuer avec ces paramètres? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:extract_nsp_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Etape 1:  Extraction du NSP source du jeu Saturn...
ECHO.
ECHO 	=========================================================================================================
goto:eof

:conversion_error
echo Une erreur s'est produite durant le processus, vérifiez vos fichiers sources et l'espace restant sur les disques durs.
goto:eof

:nca_step
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Etape 2:   Extraction des NCA déchiffrés...
Echo.
ECHO 	=========================================================================================================
goto:eof

:nsp_source_not_allowed
echo Le NSP source choisi n'est pas compatible avec ce script.
goto:eof

:icon_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Etape 3:   Changement de l'icône...
echo.
ECHO 	=========================================================================================================
goto:eof

:icon_copy_error
echo Le fichier sélectionné n'est pas un  png ou un jpg, un icône générique sera utilisé.
goto:eof

:create_game_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Etape 4:   Création du jeu...
echo.
ECHO 	=========================================================================================================
goto:eof

:end_process
echo 			Profitez de votre jeu, vous pouvez installer votre fichier "%nsp_path%%td%" généré sur votre console.
goto:eof

:howtouse_text
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Comment utiliser ce logiciel:
Echo.
ECHO 	=========================================================================================================
Echo 	-Indiquez un NSP d'un jeu officiel Saturn qui servira de source
Echo 	-Indiquez le répertoire contenant les fichiers du jeu Saturn à injecter
Echo 	-Indiquez votre fichier prod.keys
Echo 	-L'icône peut être un JPG ou un PNG et sera redimensionné à la bonne taille durant le processus
Echo 	-Indiquez un répertoire de sortie pour le NSP
Echo.
Echo.
Echo 	Remerciements:
Echo 			https://gbatemp.net/threads/saturn-emulation-using-cotton-guardian-force-testing-and-debug.600756/
Echo 			The-4n pour Hacpack tool, Thealexbarney pour Hactoolnet
Echo 			Vous saurez vous reconnaître!
Echo. 	           
goto:eof