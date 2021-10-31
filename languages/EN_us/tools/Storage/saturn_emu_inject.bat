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
title Sega Saturn game inject %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
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
echo   	       	        *************         Presents:        ***********               
echo   	       	          ************                        **********   ***               
echo   	       	           *************     NS Saturn Game Injector    *************   ****           
echo   	       	              *************     v1.0   *************    *********        
echo   	       	               *********************  *************   ************       
echo   	       	                 ******************  *************    *************      
echo   	       	                  ***************  *************       *************    
echo   	       	                   ***********   *************          *************   
echo.
echo 	-=======================================================================================================-
echo							What do you want to do:
echo							1: Display help
echo							2: Start injection
echo 3: Launch CDmage to convert  CD images to the .cue and .bin format, the only format supported by the injection process.
echo 4: Save your prod.keys file to pass the demand for this file during futur injections.
echo							All other choices: Go back to menu.
echo 	-=======================================================================================================-
set /p begin=Make your choice: 
goto:eof

:nsp_source_choice
IF /i "%display_good_saved_games%"=="Y" (
	echo Which games do you want to use as a base source:
	IF NOT "%filename0_path%"=="" echo 1: %filename0%
	IF NOT "%filename1_path%"=="" echo 2: %filename1%
	IF NOT "%filename2_path%"=="" echo 3: %filename2%
	echo 0: Select a NSP
	echo All other choices: Go back tou previous menu.
	echo.
	set /p br=Make your choice: 
	IF "!br!"=="0" %windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Nintendo Switch nsp files^(*.nsp^)|*.nsp|" "Select the Saturn nsp source file" "%ushs_base_path%templogs\tempvar.txt"
) else (
	echo Please choose the Saturn nsp source file in the following window.
	echo If you close the window you will return to the menu.
	pause
	%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Nintendo Switch nsp files^(*.nsp^)|*.nsp|" "Select the Saturn nsp source file" "%ushs_base_path%templogs\tempvar.txt"
)
goto:eof

:set_gamemaker_game_source
echo Please choose the Saturn's cue file  to inject in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "cue files^(*.cue^)|*.cue|" "Select the Saturn cue  file to inject" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:cue_file_error
echo An error occured during cue file analyse.
goto:eof

:set_keys_path
echo Please choose the prod.keys file in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files^(*.*^)|*.*|" "Select the prod.keys file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_title_keys_path
echo Please choose the title.keys file in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files^(*.*^)|*.*|" "Select the title.keys file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_icon_type_choice
set /p bs=Do you want to choose your own icon file for the game? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_icon_path
echo Please choose the icon file in the following window.
echo If you close the window you will return to the icon type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "jpg and png files^(*.jpg;*.png^)|*.jpg;*.png|" "Select the icon file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_ini_choice
set /p custom_ini_choice=Do you want to choose your own ini config file for the emulator for the game? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_ini_path
echo Please choose the ini file in the following window.
echo If you close the window you will return to the ini type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "ini files^(*.ini^)|*.ini|" "Select the custom ini file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_wallpaper_choice
set /p custom_wallpaper_choice=Do you want to choose your own wallpaper folder for the game ^(the folder must contain the four files named "WP_001.tex" to "WP_004.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_wallpaper_folder_path
echo Please choose the wallpaper folder in the following window.
echo If you close the window you will return to the wallpaper type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Wallpaper folder select"
goto:eof

:set_custom_credit_choice
set /p custom_credit_choice=Do you want to choose your own credit folder for the game ^(the folder must contain the two files named "00.tex" and "01.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_credit_folder_path
echo Please choose the credit folder in the following window.
echo If you close the window you will return to the credit type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Credit folder select"
goto:eof

:set_custom_playingguide_choice
set /p custom_playingguide_choice=Do you want to choose your own playing guide folder for the game ^(the folder must contain the files named "00.tex" to maximum "03.tex"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_playingguide_folder_path
echo Please choose the playing guide folder in the following window.
echo If you close the window you will return to the playing guide type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%tools\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Playing guide folder select"
goto:eof

:set_custom_texture_choice
set /p custom_texture_choice=Do you want to choose your own texture  file for the game? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_texture_path
echo Please choose the texture file in the following window.
echo If you close the window you will return to the texture type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "tex files^(*.tex^)|*.tex|" "Select the custom texture file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_custom_nodata_choice
set /p custom_nodata_choice=Do you want to choose your own "no_data.tex" file for the game? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:set_custom_nodata_path
echo Please choose the "no_data.tex" file in the following window.
echo If you close the window you will return to the "no_data.tex" type choice.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "tex files^(*.tex^)|*.tex|" "Select the custom ^"no_data.tex^" file" "%ushs_base_path%templogs\tempvar.txt"
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
set /p name=Enter the game name to display ^(128 chars max^): 
goto:eof

:could_not_be_empty_error
echo This value couldn't be empty.
goto:eof

:name_length_error
echo Error, the name must be maximum 128 chars long.
goto:eof

:name_char_error
echo An unauthorized char has been entred in the game's name.
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

:set_save_size
set /p save_size=Enter the save size in octets ^(leave empty to ceep the default size^): 
goto:eof

:set_nsp_path
echo Please choose the folder where to create the game nsp in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\select_dir.vbs" "%ushs_base_path%templogs\tempvar.txt" "Select the folder where to create the game nsp"
goto:eof

:set_confirm_nsp_duplicated_deletion
choice /c %lng_yes_choice%%lng_no_choice% /n /m "The file ^"%nsp_path%%name%_%id%.nsp^" already exist, do you want to erase the file ^(if yes the file will be deleted just after this choice, if no the script will finish without doing anything^)? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:set_confirm_nsp_creation
echo Informations on the Saturn game to create:
IF "%br_choice%"=="" echo Saturn game NSP source path: %br%
IF NOT "%br_choice%"=="" echo Game base used: !filename%br_choice%!
echo Saturn game cue file path to inject: %saturn_game_source%
echo ID: %id%
echo Game name: %name%

IF /i "%bs%"=="o" echo Custom icon path: %bz%
IF /i NOT "%bs%"=="o" echo Default icon.

IF /i "%custom_ini_choice%"=="o" echo Custom ini file path: %custom_ini_path%
IF /i NOT "%custom_ini_choice%"=="o" echo Default ini file.

IF /i "%custom_wallpaper_choice%"=="o" echo Custom wallpaper folder path: %custom_wallpaper_folder_path%
IF /i NOT "%custom_wallpaper_choice%"=="o" echo Default wallpaper folder.

IF /i "%custom_playingguide_choice%"=="o" echo Custom playing guide folder path: %custom_playingguide_folder_path%
IF /i NOT "%custom_playingguide_choice%"=="o" echo Default playing guide folder.

IF /i "%custom_credit_choice%"=="o" echo Custom credit folder path: %custom_credit_folder_path%
IF /i NOT "%custom_credit_choice%"=="o" echo Default credit folder.

IF /i "%custom_texture_choice%"=="o" echo Custom texture file path: %custom_texture_path%
IF /i NOT "%custom_texture_choice%"=="o" echo Default texture file.

IF /i "%custom_nodata_choice%"=="o" echo Custom no_data file path: %custom_nodata_path%
IF /i NOT "%custom_nodata_choice%"=="o" echo Default no_data file.

echo Author: %author%
echo Version: %version%
IF %save_size% EQU -1 (
	echo Default save size.
) else (
	echo Save size: %save_size%
)
echo prod.keys path: %keys_path%
rem IF "%br_choice%"=="" echo title.keys path: %title_keys_path%
echo NSP output path: %nsp_path%%name%_%id%.nsp
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Do you want to continue with theses settings? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:extract_nsp_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 1:  Extract Saturn game NSP source...
ECHO.
ECHO 	=========================================================================================================
goto:eof

:conversion_error
echo An error occurred during the process, check your source files and the remaining space on the hard drives.
goto:eof

:nca_step
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 2:   Extract Decrypted NCA...
Echo.
ECHO 	=========================================================================================================
goto:eof

:nsp_source_not_allowed
echo The source NSP chosen is not compatible with this script.
goto:eof

:icon_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 3:   Icon Changing...
echo.
ECHO 	=========================================================================================================
goto:eof

:icon_copy_error
echo The selected file is not a png or jpg file, a generic icon will be used.
goto:eof

:create_game_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 4:   Creating game...
echo.
ECHO 	=========================================================================================================
goto:eof

:end_process
echo 			Enjoy your game, you can now install your "%nsp_path%%td%" generated file on your console.
goto:eof

:keys_file_save_successful
echo Keys file successfuly saved.
goto:eof

:keys_file_save_error
echo Error while saving the keys file.
goto:eof

:howtouse_text
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 How to use this software:
Echo.
ECHO 	=========================================================================================================
Echo 	-Indicate a NSP from retail Saturn Game for sourcing
Echo 	-Indicate your Saturn Game cue file to inject
Echo 	-Indicate your prod.keys file
Echo 	-Icon can be JPG or PNG and will be resized at good size by the process
Echo 	-Indicate an output folder for your NSP
echo Indicate the other informations when asked to customize your injection.
Echo.
Echo.
Echo 	Greetings:
Echo 			https://gbatemp.net/threads/saturn-emulation-using-cotton-guardian-force-testing-and-debug.600756/
Echo 			The-4n for Hacpack tool, Thealexbarney for Hactoolnet
Echo 			You know who you are!
Echo. 	           
goto:eof