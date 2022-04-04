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
title bootlogos creation %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allow to create bootlogos for Atmosphere.
echo.
echo You have to redo the logo for Atmosphere each time you update Atmosphere based on the file "fusee-secondary.bin" or "package3" of it. The size of the logo is 1250X720, it will be resized if it is not at the right size but it is recommended to use a logo already correctly sized.
echo.
echo For the Nintendo logo, it will have to be redone if you change the firmware. The size of the logo is 308X350, it can be resized if it is not the right size but it is recommended to use a logo already correctly sized.
echo.
echo Note that the logos will be created respecting the tree structure necessary for them to be used on the SD, so I advise to use the root of the SD as output folder.
goto:eof

:action_choice
echo What do you want to do:
echo 1: Create a logo to replace the logo of Atmosphere ^(when launching via fusee.bin^)?
echo 2: Create a logo to replace the Nintendo Switch logo?
echo All other choices: Back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:logo_file_selection
echo Please select the image file to be used for the new logo in the next window.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "image files^(*.jpg;*.png;*.bmp^)|*.jpg;*.png;*.bmp|" "Logo file selection" "templogs\tempvar.txt"
goto:eof

:no_logo_file_selected_error
echo No image file selected, the script will stop.
goto:eof

:fusee_file_selection
echo Please select the file "fusee-secondary.bin" or "package3" of the Atmosphere version you are using in the next window.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "All files^(*.*^)|*.*|" "fusee-secondary.bin or package3 file selection" "templogs\tempvar.txt"
goto:eof

:no_fusee_file_selected_error
echo No "fusee-secondary.bin" or "package3" file selected, the script will stop.
goto:eof

:resize_image_choice
set /p resize_image=Do you want to resize the image to the good size? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:image_conversion_error
echo The image has not been converted, the script will stop.
goto:eof

:outdir_folder_select
echo You will have to select the folder where the logo will be created ^(root of your SD recommanded^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Logo output folder selection"
goto:eof

:no_outdir_source_selected_error
echo No output folder selected, the script will stop.
goto:eof

:logo_creation_error
echo An error occured during the logo creation.
goto:eof

:logo_creation_success
echo Logo successfuly created.
goto:eof