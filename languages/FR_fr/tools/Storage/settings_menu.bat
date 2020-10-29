goto:%~1

:display_title
title Menu des paramètres %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Menu de Paramètres
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Sauvegarder les fichiers importants du script?
echo.
echo 2: Restaurer les fichiers importants du script?
echo.
echo 3: Réinitialiser complètement le script?
echo.
echo 4: Réinitialiser le paramètre de mise à jour automatique du script?
echo.
echo 5: Réinitialiser la liste de programmes personnels de la Toolbox ^(supprimera également les programmes incluent dans le dossier "tools\toolbox"^)?
echo.
echo 6: Réinitialiser la liste de serveurs de Switch-Lan-Play?
echo.
echo 7: Supprimer le fichiers de clés utilisé par NSC_Builder?
echo.
echo 8: Supprimer les fichiers de clés utilisés par Hactool, XCI-Explorer, ChoiDuJour...?
echo.
echo 9: Configurer les profiles généraux utilisés lors de la préparation d'une SD?
echo.
echo 10: Configurer les profiles de copie de homebrews utilisés lors de la préparation d'une SD?
echo.
echo 11: Configurer les profiles de copie de cheats utilisés lors de la préparation d'une SD?
echo.
echo 12: Configurer les profiles de copie d'émulateurs utilisés lors de la préparation d'une SD?
echo.
echo 13: Configurer les profiles de copie de modules utilisés lors de la préparation d'une SD?
echo.
echo 14: Configurer les profiles de copie d'overlays utilisés lors de la préparation d'une SD?
echo.
echo 15: Configurer les profiles d'emummc d'Atmosphere utilisés lors de la préparation d'une SD?
echo.
echo 16: Configurer les profiles de copie de modules Salty-nx utilisés lors de la préparation d'une SD?
echo.
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof

:auto_update_reset_success
echo Paramètre de mise à jour automatique réinitialisé.
goto:eof

:toolbox_reset_success
echo Programmes personnels de la Toolbox réinitialisés.
goto:eof

:switchlanplay_reset_success
echo Liste de serveurs Switch-Lan-Play réinitialisée.
goto:eof

:nscbuilder_keys_file_reset_success
echo Fichier de clés pour NSC_Builder supprimé.
goto:eof

:hactool_keys_file_reset_success
echo Fichiers de clés pour les outils basés sur Hactool supprimés.
goto:eof