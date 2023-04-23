goto:%~1

:display_title
title Gestion des puces %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de gérer quelques manipulations avec les puces ou certains dongles UF2 en se basant particulièrement sur le projet Switchboot mais pas que.
goto:eof

:main_action_choice
echo Gestion des puces
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Passer la puce type Trinket en mode UF2 grâce au lancement d'un payload ^(vous devrez appuyer sur le bouton "reset" de la puce deux fois une fois le payload lancé^)?
echo 2: Lancer le payload de Switchboot ^(puces type Trinket uniquement^)?
echo 3: Flasher un fichier UF2 sur la puce ou sur certains dongles?
echo 4: Flasher Fusee_Suite sur la puce type Trinket?
echo 5: Organiser les payloads de la SD pour Switchboot ou Fusee_Suite ^(puces type Trinket uniquement^)?
echo 6: Flasher une puce SX_Core ou SX_Lite ou HWFly?
echo 7: Flasher Switchboot sur la puce type Trinket ou sur certains dongles?
echo 8: Préparer les fichiers de base sur la SD pour Switchboot ^(puces type Trinket uniquement^)?
echo 0: Voir le sujet consacré à Fusee_Suite sur Gbatemp?
echo 00: Voir le sujet consacré à Switchboot sur Gbatemp?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:begin_uf2_choice
echo Choisir un fichier UF2 à copier.
goto:eof

:end_uf2_choice
echo 0: Choisir un fichier UF2?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p uf2_number=Entrez le numéro du fichier UF2 à copier: 
goto:eof

:select_uf2_file
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers uf2 ^(*.uf2^)|*.uf2|" "Sélection du fichier UF2" "templogs\tempvar.txt"
goto:eof

:uf2_file_empty_error
echo Aucun fichier UF2 sélectionné, retour aux actions principales.
goto:eof

:select_uf2_device
echo Vous allez devoir sélectionner un périphérique UF2.
pause
goto:eof

:select_modchip_device
echo Sélection de la puce ou du dongle à flasher:
echo.
echo 1: Feather M0 Express modchip?
echo 2: Gemma M0 modchip?
echo 3: Itsybitsy M0 modchip?
echo 4: RCM-X86 modchip?
echo 5: Rebug SwitchME modchip?
echo 6: Trinket M0 modchip?
IF "%~2"=="fusee_suite" goto:skip_dongle_choice
echo 7: Generic Gemma dongle?
echo 8: Generic Trinket dongle?
echo 9: RCMX86 dongle?
:skip_dongle_choice
echo N'importe quel autre choix: Revenir aux actions principales?
echo.
echo.
set /p modchip_choice=Faites votre choix: 
goto:eof

:switchboot_part1_type
echo Quelle sera la façon de fonctionner de la puce ^(Switchboot part1)?
echo 1: CFW permanant?
echo 2: Dual boot?
echo N'importe quel autre choix: Revenir aux actions principales?
echo.
echo.
set /p switchboot_part1_type=Faites votre choix: 
goto:eof

:switchboot_part2_type
echo Quelle sera la façon de fonctionner de la puce ^(Switchboot part2)?
echo 1: Lancer un payload "payload.bin" situé à la racine de la SD?
echo 2: Lancer Switchboot?
echo N'importe quel autre choix: Revenir aux actions principales?
echo.
echo.
set /p switchboot_part2_type=Faites votre choix: 
goto:eof

:select_uf2_device_again
echo De nouveau, vous allez devoir sélectionner un périphérique UF2 pour le flash de la seconde partie.
pause
goto:eof

:switchboot_flash_end
echo Flash de la puce ou du dongle avec Switchboot terminé.
goto:eof

:select_sd_device
echo Vous allez devoir sélectionner la carte SD sur laquelle copier les fichiers.
pause
goto:eof

:copy_base_switchboot_on_sd_finished
echo Copie des fichiers de base pour Switchboot sur la SD terminée.
goto:eof

:select_switchboot_payload_number
set /p switchboot_payload_number=Entrez un numéro pour le payload à copier ^(1 à 8, laisser vide pour revenir aux actions principales^): 
goto:eof

:switchboot_payload_number_select_error
echo Une erreur a été détectée dans le choix du numéro du payload pour Switchboot.
goto:eof

:select_if_payload_1_is_unic
set /p payload1_is_unic=Ce payload sera-t-il le seul à être lancé par la puce? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:manage_payloads_switchboot_finished
echo Le payload a été copié sur la SD avec les paramètres choisis.
goto:eof

:begin_payload_choice
echo Choisir un payload. 
goto:eof

:end_payload_choice
echo 0: Choisir un fichier de payload 
echo N'importe quel autre choix: Revenir aux actions principales.
echo.
set /p payload_number=Entrez le numéro du payload à lancer: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de payload Switch ^(*.bin^)|*.bin|" "Sélection du payload" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo Aucun payload sélectionné, retour à la sélection de payloads. 
goto:eof

:sx_flasher_launch_intro
echo Ceci permet de flasher une puce SX Core ou SX Lite ou HWFly.
echo Pour cela, vous devez connecter votre puce en USB.
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Utiliser SX_Flasher pour flasher un firmware officiel ^(seulement SX Core/lite^)?
echo 2: Flasher HWFly bootloader/firmware?
echo 3: Flasher le bootloader de SXOS ^(seulement SX Core/lite^)?
echo 4: Flasher le firmware de SXOS ^(seulement SX Core/lite^)?
echo 5: Flasher le bootloader de HWFly?
echo 6: Flasher le firmware de HWFly?
echo 7: Vérifier le firmware de Spacecraft dans un fichier BOOT0 dumpé sur une console?
echo 8: Flasher le firmware HWFly via la SD ^(HWFly doit déjà être mis en place sur la puce, fonction instable, n'est pas compatible avec toutes les puces donc préférer l'utiliser sur les puces SX Core/Lite^)?
echo 9: Flasher le firmware réparant le bug de débogage USB présent sur certaines puces pour consoles Oled ^(non testé^)?
echo N'importe quel autre choix: Revenir aux actions principales?
echo.
set /p sx_core_lite_action_choice=Faites votre choix: 
goto:eof

:sx_flasher_launch_infos
echo Dans le programme qui va se lancer, choisissez un firmware puis cliquez sur le bouton "Update".
echo Vous pourez trouver les firmwares disponibles dans le dossier "tools\SX_Core_Lite\firmwares" à partir de la racine de ce script.
goto:eof

:spacecraft_begin_flash
echo Flash de la puce avec HWFly en cours...
goto:eof

:spacecraft_error_flash
echo Erreur durant le flash de la puce avec HWFly.
goto:eof

:spacecraft_end_flash
echo Flash de la puce avec HWFly terminé avec succès.
goto:eof

:sx_bootloader_begin_flash
echo Flash de la puce avec le bootloader de SXOS en cours...
goto:eof

:sx_bootloader_error_flash
echo Erreur durant le flash de la puce avec le bootloader de SXOS.
goto:eof

:sx_bootloader_end_flash
echo Flash de la puce avec le bootloader de SXOS terminé avec succès.
goto:eof

:sx_firmware_begin_flash
echo Flash de la puce avec le firmware de SXOS en cours...
goto:eof

:sx_firmware_error_flash
echo Erreur durant le flash de la puce avec le firmware de SXOS.
goto:eof

:sx_firmware_end_flash
echo Flash de la puce avec le firmware de SXOS terminé avec succès.
goto:eof

:spacecraft_bootloader_begin_flash
echo Flash de la puce avec le bootloader de HWFly en cours...
goto:eof

:spacecraft_bootloader_error_flash
echo Erreur durant le flash de la puce avec le bootloader de HWFly.
goto:eof

:spacecraft_bootloader_end_flash
echo Flash de la puce avec le bootloader de HWFly terminé avec succès.
goto:eof

:spacecraft_firmware_begin_flash
echo Flash de la puce avec le firmware de HWFly en cours...
goto:eof

:spacecraft_firmware_error_flash
echo Erreur durant le flash de la puce avec le firmware de HWFly.
goto:eof

:spacecraft_firmware_end_flash
echo Flash de la puce avec le firmware de HWFly terminé avec succès.
goto:eof

:flash_spacecraft_sd_instructions
echo Maintenant il suffit de démarrer la console avec la SD et le firmware HWFly devrait se mettre à jour. Sinon, il faut utiliser le payload "hwfly_toolbox.bin" via Hekate, mettre à jour le Sdloader, éteindre la console, démarrer la console en maintenant "VOL+" pour passer la puce en mode flash, relancer le payload "hwfly_toolbox.bin" et flasher le firmware.
echo En cas de problèmes, reflasher via l'USB de la puce ou via une autre méthode.
goto:eof

:select_boot0_file
echo Vérification de la version de Spacecraft dans un fichier BOOT0
echo.
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier BOOT0" "templogs\tempvar.txt"
goto:eof

:boot0_file_empty_error
echo Aucun fichier BOOT0 sélectionné.
goto:eof

:no_compatible_disk_found_error
echo Aucun disque compatible trouvé. Veuillez insérer un périphérique compatible puis relancez l'action.
goto:eof

:disk_list_begin
echo Liste des disques: 
goto:eof

:disk_list_choice
echo 0: Revenir à la sélection de l'action principale de ce script.
echo.
echo.
set /p volume_letter=Entrez la lettre du volume  que vous souhaitez utiliser: 
goto:eof

:disk_choice_empty_error
echo La lettre de lecteur ne peut être vide. Réessayez. 
goto:eof

:disk_choice_char_error
echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez. 
goto:eof

:disk_choice_not_exist_error
echo Ce volume n'existe pas. Recommencez. 
goto:eof

:disk_choice_letter_not_exist_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez. 
goto:eof

:copy_uf2_file_error
echo Une erreur s'est produite durant la copie du fichier UF2.
goto:eof

:reset_uf2_device_to_flash
echo Copie terminée avec succès.
echo.
echo Si le périphérique UF2 n'a pas été automatiquement déconnecté durant l'opération, appuyez sur le bouton "reset" de la puce pour flasher le fichier UF2.
pause
goto:eof