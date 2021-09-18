goto:%~1

:display_title
title Lancer le contrôle à distance via NVDA et Nvdaremote %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet juste de lancer NVDA et Nvdaremote pour permettre le contrôle à distance de cet ordinateur via ceux-ci.
echo.
echo Le serveur utilisé est "nvdaremote.com" et la clé est "ushshelp".
echo.
echo Pour arrêter le contrôle à distance il suffit de quitter NVDA en faisant un clique gauche sur l'icône de NVDA qui est apparu dans la barre permettant par exemple de gérer le volume du son de l'ordinateur puis de sélectionner "Quitter".
goto:eof

:launch_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous vraiment lancer le contrôle à distance? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:nvda_launched
echo NVDA a été lancé, le contrôle à distance devrait maintenant être possible.
goto:eof