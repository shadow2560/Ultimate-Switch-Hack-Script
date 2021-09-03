goto:%~1

:display_title
title GameMaker NSP Builder %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_menu
echo.
echo 		************      ************   ************                         
echo   	    	 *************    ************    ******************                       
echo   	      	  ***********    ************    *********************                     
echo   	       	   ********   ************    Markus95    *************                    
echo   	       	    ******  *************        ^&         **************                  
echo   	       	     ***  ************          Red-J         ************                 
echo   	       	         *************                         ************                
echo   	       	        *************         Présentent:        ***********               
echo   	       	          ************                        **********   ***               
echo   	       	           *************     GameMaker    *************   ****           
echo   	       	            **************   NSP Builder  ************    ******          
echo   	       	              *************     v1.0   *************    *********        
echo   	       	               *********************  *************   ************       
echo   	       	                 ******************  *************    *************      
echo   	       	                  ***************  *************       *************    
echo   	       	                   ***********   *************          *************   
echo.
echo 	-=======================================================================================================-
echo							Que souhaitez-vous faire:
echo							1: Afficher l'aide
echo							2: Commencer la convertion
echo							Tout autre choix: Revenir au menu précédent
echo 	-=======================================================================================================-
set /p begin=Faites votre choix: 
goto:eof

:nsp_source_choice
echo Choisissez  le fichier NSP source du jeu GameMaker  dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier nsp nintendo Switch ^(*.nsp^)|*.nsp|" "Sélection du fichier nsp source du jeu GameMaker" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_gamemaker_game_source
echo Choisissez le répertoire du jeu GameMaker à convertir dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\select_dir.vbs" "%ushs_base_path%templogs\tempvar.txt" "Sélection du répertoire du jeu GameMaker à convertir"
goto:eof

:set_keys_path
echo Choisissez le fichier de clés dans la fenêtre suivante.
echo Si vous refermez la fenêtre vous retournerez au menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Fichier de clés switch ^(*.*^)|*.*|" "Sélection du fichier de clés" "%ushs_base_path%templogs\tempvar.txt"
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
echo Informations sur le jeu GameMaker à créer:
echo Chemin du NSP source du jeu GameMaker: %br%
echo Chemin du répertoire contenant le jeu GameMaker à injecter: %gamemaker_source%
echo ID: %id%
echo Nom du jeu: %name%
IF /i "%bs%"=="o" (
	echo Chemin de l'icône personnalisé: %bz%
) else (
	echo Icône par défaut.
)
echo Auteur: %author%
echo Version: %version%
echo Chemin du fichier de clés: %keys_path%
echo Chemin de sortie du NSP: %nsp_path%
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous continuer avec ces paramètres? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:extract_nsp_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Etape 1:  Extraction du NSP source du jeu GameMaker...
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
Echo 	-Indiquez un NSP d'un jeu officiel GameMaker qui servira de source
Echo 	-Indiquez le répertoire contenant les fichiers du jeu GameMaker à mettre en place
Echo 	-Indiquez votre fichier de clés
Echo 	-L'icône peut être un JPG ou un PNG et sera redimensionné à la bonne taille durant le processus
Echo 	-Indiquez un répertoire de sortie pour le NSP
Echo.
Echo.
Echo 	Remerciements:
Echo 			Kardch ^& Chocolate2890 de GBATemp pour la méthode manuelle,
Echo 			The-4n pour Hacpack,SciresM pour Hactool
Echo 			YoYo Games pour GameMaker Studio et toute la scène Nintendo Switch
Echo 			Vous saurez vous reconnaître!
Echo. 	           
goto:eof