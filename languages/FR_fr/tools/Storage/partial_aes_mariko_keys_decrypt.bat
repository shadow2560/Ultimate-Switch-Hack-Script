goto:%~1

:display_title
title Déchifrage des clés partielles des console Mariko %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de déchiffrer les clés partielles obtenues via Lockpick-RCM sur les consoles Mariko.
echo.
echo Vous aurez besoin du fichier "partialaes.keys" obtenu via Lockpick-RCM sur la console concernée et vous devrez également indiquer le fichier "prod.keys" de la console obtenu également via Lockpick-RCM pour que les clés ainsi déchiffrées y soit ajoutées.
echo.
echo Notez que cette opération peut prendre pas mal de temps, celui-ci dépendant de votre processeur.
goto:eof

:partial_keys_input_file_select_choice
echo Sélectionnez le fichier "partialaes.keys" à déchiffrer.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier partialaes.keys" "templogs\tempvar.txt"
goto:eof

:partial_keys_input_file_empty_error
echo Le fichier "partialaes.keys" ne peut être vide, le script va s'arrêter.
goto:eof

:prod_keys_file_select_choice
echo Sélectionnez le fichier "prod.keys" contenant les clés dumpée sur la console via Lockpick-RCM.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier de clés de la console" "templogs\tempvar.txt"
goto:eof

:prod_keys_file_empty_error
echo Le fichier de clés ne peut être vide, le script va s'arrêter.
goto:eof

:num_threads_choose
set /p num_threads=Choisissez le nombre de threads à utiliser pour les opérations de déchiffrage ^(1 si vide, une valeur plus élevé augmente la vitesse de traitement mais utilise plus de ressources, à choisir selon  les capacités de votre processeur^): 
goto:eof

:char_not_authorized
echo Un caractère non autorisé a été entré.
goto:eof

:mariko_kek_already_present_message
echo La clé "mariko_kek" a été trouvée dans le fichier "prod.keys", elle ne sera donc pas traitée.
goto:eof

:mariko_bek_already_present_message
echo La clé "mariko_bek" a été trouvée dans le fichier "prod.keys", elle ne sera donc pas traitée.
goto:eof

:secure_boot_key_already_present_message
echo La clé "secure_boot_key" a été trouvée dans le fichier "prod.keys", elle ne sera donc pas traitée.
goto:eof

:secure_storage_key_already_present_message
echo La clé "secure_storage_key" a été trouvée dans le fichier "prod.keys", elle ne sera donc pas traitée.
goto:eof

:create_partial_keys_error
echo Une erreur s'est produite durant le déchiffrement du fichier "partialaes.keys".
goto:eof

:create_partial_keys_success
echo Déchiffrement du fichier "partialaes.keys" effectué avec succès, les clés ont été ajoutées à la fin de votre fichier "prod.keys".
goto:eof