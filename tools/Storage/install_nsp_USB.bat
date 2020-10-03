::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%ushs_base_path%=!
	set associed_language_script=%ushs_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	endlocal
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
set script_path=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
start tools\Goldtree\Goldtree.exe
goto:endscript
:select_install_type
echo.
::echo Que souhaitez-vous faire:
::echo 1: Installer plusieurs NSP en sélectionnant un dossier sans la prise en compte des sous-dossiers?
::echo 2: Installer plusieurs NSP en sélectionnant un dossier avec la prise en compte des sous-dossiers (fonctions expérimentale, peut contenir des bugs)?
::echo.
::set /p install_type=Choisissez la méthode d'installation: 
set install_type=1
IF NOT "%install_type%"=="" set install_type=%install_type:~0,1%
IF "%install_type%"=="1" (
	echo Sélectionnez un dossier contenant des NSP (les sous-dossiers ne sont pas pris en compte^) dans la fenêtre qui va s'ouvrir.
	pause
	%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		echo Installation annulée.
		pause
		goto:endscript
	)
) else IF "%install_type%"=="2" (
	%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		echo Installation annulée.
		pause
		goto:endscript
	)
) else (
	echo Ce choix n'existe pas, veuillez réessayer.
	set install_type=
	goto:select_install_type
)
set filepath=%filepath:\\=\%
IF "%install_type%"=="1" (
	"%script_path%\..\python3_scripts\USB_NSP\USB_NSP.exe" "%filepath%"
	IF !errorlevel! NEQ 0 (
		echo Une erreur s'est produite.
		echo.
	)
)
IF "%install_type%"=="2" (
	%filepath:~0,1%:
	cd "!filepath!"
	"%script_path%\..\gnuwin32\bin\find.exe" -name "*.nsp" > "%script_path%\..\..\templogs\nsp_list.txt"
	"%script_path%\..\gnuwin32\bin\grep.exe" -c "" <"%script_path%\..\..\templogs\nsp_list.txt" >"%script_path%\..\..\templogs\count.txt"
	set /p tempcount=<"%script_path%\..\..\templogs\count.txt"
	del /q "%script_path%\..\..\templogs\count.txt"
	IF "!tempcount!"=="0" (
		echo Il n'y a aucun fichier NSP à installer dans ce dossier ou ses sous-dossiers.
		goto:endscript
	)
	:installing
	IF "!tempcount!"=="0" (
		goto:finish_installing
	)
	"%script_path%\..\gnuwin32\bin\head.exe" -!tempcount! <"%script_path%\..\..\templogs\nsp_list.txt" | "%script_path%\..\gnuwin32\bin\tail.exe" -1>"%script_path%\..\..\templogs\nsp_list2.txt"
	set /p temp_nsp=<"%script_path%\..\..\templogs\nsp_list2.txt"
	set count_nsp_dir_extract=0
)
:extract_folder_name
IF "%install_type%"=="2" (
	set /a count_nsp_dir_extract+=1
)
IF "%install_type%"=="2" (
	IF "!temp_nsp:~-%count_nsp_dir_extract%,1!"=="/" (
		set /a count_nsp_dir_extract-=1
		goto:end_extract_folder_path
	) else (
		goto:extract_folder_name
	)
)
:end_extract_folder_path
IF "%install_type%"=="2" (
	set temp_nsp=!temp_nsp:~0,-%count_nsp_dir_extract%!
	echo !temp_nsp!
	IF NOT "!temp_nsp!"=="!temp_dir!" (
		set temp_dir=!temp_nsp!
		"%script_path%\..\python3_scripts\USB_NSP\USB_NSP.exe" "%filepath%\!temp_dir!"
		IF !errorlevel! NEQ 0 (
			echo Erreur d'installation pour le dossier %filepath%\!temp_dir!
			echo.
		)
	)
	set temp_nsp=
	set /a tempcount-=1
	goto:installing
	:finish_installing
	%script_path:~0,1%:
	cd "%script_path%\..\.."
)
echo.
echo Installation terminée.
:endscript
::pause
rmdir /s /q templogs
endlocal