set lng_label_exist=0
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title NSP forwarder creation %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to create a forwarder for a NRO file or a rom launched by a Retroarch core.
echo.
echo You will need a key file and a 255x255 image.
goto:eof

:action_choice
echo What do you want to do:
echo 1: Create a forwrder for a NRO?
echo 2: Create a forwarder for a Retroarch rom?
echo 3: Launch a graphical interface to create forwarders?
echo All other choices: Go back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:set_id
echo Enter the content ID ^(must be unique on the console it is installed on and must be 16 hexadecimal characters long ^(0-9, A-F^)^), leave blank to generate a random ID.
set /p id=ID: 
goto:eof

:id_too_small_error
echo Error, the ID must start from "01".
goto:eof

:id_length_error
echo Error, the ID must be 16 chars long.
goto:eof

:bad_char_error
echo An unauthorized character has been entered.
goto:eof

:set_name
set /p name=Enter the name to display ^(128 chars max^): 
goto:eof

:could_not_be_empty_error
echo This value couldn't be empty.
goto:eof

:name_length_error
echo Error, the name must be maximum 128 chars long.
goto:eof

:set_icon_path
echo Please choose the forwarder icon file in the following window, a square image of 255X255 is prefered.
echo If you close the window, the script will end without doing anything.
pause
%windir%\system32\wscript.exe //Nologo tools\storage\functions\open_file.vbs "" "Image files ^(*.png;*.jpg;*.jpeg;*.bmp;*.gif^)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|All files (*.*)|*.*|" "Select the forwarder icon" "templogs\tempvar.txt"
goto:eof

:set_resize_icon_image
set /p resize_icon_image=Do you want to resize the icon image to square 256X256? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_logo_path
echo Please choose the forwarder logo file in the following window, a rectangle image of 160X40 is prefered.
echo If you close the window, the default logo will be used.
pause
%windir%\system32\wscript.exe //Nologo tools\storage\functions\open_file.vbs "" "Image files (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|All files (*.*)|*.*|" "Select the forwarder logo" "templogs\tempvar.txt"
goto:eof

:set_resize_logo_image
set /p resize_logo_image=Do you want to resize the logo image to rectangle 160X40? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_nro_path
IF "%nsp_type%"=="nro" (
	set /p nro_path=Enter the path to the NRO to launch: sdmc:/
) else IF "%nsp_type%"=="rom" (
	set /p nro_path=Enter the path to the NRO of the Retroarch core to use: sdmc:/
)
goto:eof

:set_rom_path
set /p rom_path=Enter the path to the rom to launch: sdmc:/
goto:eof

:set_author
set /p author=Enter the author name to display ^(64 chars max^): 
goto:eof

:author_length_error
echo Error, the author must be maximum 64 chars long.
goto:eof

:set_version
set /p version=Enter the version to display ^(4 chars max^): 
goto:eof

:version_length_error
echo Error, the version must be maximum 4 chars long.
goto:eof

:set_keys_path
echo Please choose the key file in the following window.
echo If you close the window, the script will end without doing anything.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files^(*.*^)|*.*|" "Select the keys file" "templogs\tempvar.txt"
goto:eof

:set_nsp_path
echo Please choose the folder where to create the forwarder in the following window.
echo If you close the window, the script will end without doing anything.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select the folder where to create the forwarder"
goto:eof

:set_confirm_nsp_duplicated_deletion
choice /c %lng_yes_choice%%lng_no_choice% /n /m "The file ^"%nsp_path%%name%_%id%.nsp^" already exist, do you want to erase the file ^(if yes the file will be deleted just after this choice, if no the script will finish without doing anything^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:set_confirm_nsp_creation
echo Informations on the forwarder to create:
IF "%nsp_type%"=="nro" (
	echo Forwarder type: NRO
) else IF "%nsp_type%"=="rom" (
	echo Forwarder type: Retroarch rom
)
echo ID: %id%
echo Name: %name%
echo Icon: %icon_path%
IF /i "%resize_icon_image%"=="o" (
	echo Icon resize: Yes
) else (
	echo Icon resize: No
)
IF "%logo_path%"=="" (
	echo Default logo.
) else (
	echo Logo path: %logo_path%
	IF /i "%resize_logo_image%"=="o" (
		echo Logo resize: Yes
	) else (
		echo Icon resize: No
	)
)
IF "%nsp_type%"=="nro" (
	echo Nro path: %nro_path%
) else IF "%nsp_type%"=="rom" (
	echo Retroarch core path: %nro_path%
	echo Rom path: %rompath%
)
echo Author: %author%
echo Version: %version%
echo keys path: %keys_path%
echo NSP output path: %nsp_path%
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to continue with theses settings? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:nsp_build_begin
echo Building forwarder...
goto:eof

:icon_convert_error
echo An error occurred during the icon image conversion, the creation of the forwarder will stop.
goto:eof

:logo_convert_error
echo An error occurred during the logo image conversion, the creation of the forwarder will stop.
goto:eof

:forwarder_build_error
echo An error occurred during the creation of the forwarder.
echo.
echo Make sure that the provided key file is correct and that you have enough space on the disk to write the forwarder.
goto:eof

:forwarder_build_success
echo "%nsp_path%%name%_%id%.nsp" created with success.
goto:eof