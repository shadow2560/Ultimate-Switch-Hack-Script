set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Softwares Toolbox %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Welcome to the Softwares Toolbox.
echo.
echo Here, you could manage and launch softwares witch have a graphical interface.
echo You will find a default list containing programs that are sometime used during the script, this list is not modifiable.
echo But, you can have your personal list where you can add or remove softwares.
echo.
echo Be careful, the dependancies are not verified by this Toolbox, you must install them by yourself if your softwares need some, the Toolbox just organize and launch the softwares.
goto:eof

:first_action_choice
echo Software Toolbox
echo.
echo What do you want to do?
echo.
echo 1: Launch a software?
echo 2: Open the main folder of a personal software?
echo 3: Manage the personal softwares list?
echo All other choices: Go back to previous menu.
echo.
set /p action_choice=Make your choice: 
goto:eof

:launch_software_begin
echo Software launching
echo.
echo Softwares list:
echo.
echo Default softwares:
goto:eof

:software_personal_list_begin
echo Personal softwares:
goto:eof

:launch_software_choice
echo All other numbers: Go back to main menu of the Softwares Toolbox.
echo.
set /p launch_software_choice=Make your choice: 
goto:eof

:bad_char_error
echo Unauthorised char.
goto:eof

:no_personal_software_defined_error
echo No personal software defined, you can't use this function.
goto:eof

:launch_working_dir_choice
echo All other numbers: Go back to main menu of the Softwares Toolbox.
echo.
set /p launch_software_choice=Make your choice: 
goto:eof

:manage_action_choice
echo Manage personal softwares list
echo.
echo What do you want to do?
echo.
echo 1: Add a software?
echo 2: Modify the name of a software?
echo 3: Remove a software?
echo All other choices: Go back to main menu of the Softwares Toolbox.
echo.
set /p manage_choice=Make your choice: 
goto:eof

:software_name_choice
set /p software_name=Enter the software name: 
goto:eof

:software_name_empty_error
echo The software name couldn't be empty.
goto:eof

:software_name_char_error
echo Unauthorised char in software name.
goto:eof

:software_copy_type_choice
set /p software_copy=Do you want to copy the software in the "toolbox" folder of the script? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:software_already_exist_error
echo This software seems to have been already copied in the "toolbox" folder of the script, the add is canceled.
goto:eof

:software_type_choice
	echo What is the software type?
	echo.
	echo 1: A software using only a single file to be launched?
	echo 2: A software contained in a folder witch have some files/folders that are necessary for it to work?
	echo 0: Cancel this software add?
	echo.
	set /p software_type=Make your choice: 
goto:eof

:choice_not_allowed_error
echo Choice not allowed.
goto:eof

:add_software_file_choice
echo You will need to indicate the main file of the software that you want to add.
echo If you have chosen to copy the software and depending the software type chosen, the indicated file or/and the folder containing it will be copied in the "tools\toolbox" folder of the script and the path will  be adapted to be a relative path to the main file of the software chosen.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file2.vbs "" "All files ^(*.*^)|*.*|" "Select the main file of a software" "templogs\tempvar.txt"
goto:eof

:no_software_file_selected_error
echo The software file has not been selected, operation canceled.
goto:eof

:add_software_success
echo Software added.
goto:eof

:modify_software_choice
echo All other numbers: Go back to previous menu.
echo.
set /p launch_software_choice=Make your choice: 
goto:eof

:modify_software_name_choice
set /p new_software_name=Enter the new name of the software ^(if empty, the old name will be kept^): 
goto:eof

:modify_software_not_renamed_error
echo The software has not been renamed, back to previous menu.
goto:eof

:modify_software_success
echo Software name modified.
goto:eof

:del_software_success
echo Software removed.
goto:eof