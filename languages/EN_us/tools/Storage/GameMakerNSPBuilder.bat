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
echo   	       	        *************         Presents:        ***********               
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
echo							What do you want to do:
echo							1: Display help
echo							2: Start conversion
echo							All other choices: Go back to menu.
echo 	-=======================================================================================================-
set /p begin=Make your choice: 
goto:eof

:nsp_source_choice
echo Please choose the GameMaker nsp source file in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Nintendo Switch nsp files^(*.nsp^)|*.nsp|" "Select the GameMaker nsp source file" "%ushs_base_path%templogs\tempvar.txt"
goto:eof

:set_gamemaker_game_source
echo Please choose the GameMaker game folder to convert in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\select_dir.vbs" "%ushs_base_path%templogs\tempvar.txt" "Select the GameMaker game folder to convert"
goto:eof

:set_keys_path
echo Please choose the key file in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\open_file.vbs" "" "Switch keys list files^(*.*^)|*.*|" "Select the keys file" "%ushs_base_path%templogs\tempvar.txt"
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
set /p name=Enter the name that will be displayed: 
goto:eof

:could_not_be_empty_error
echo This value couldn't be empty.
goto:eof

:set_author
set /p author=Enter the author name to display: 
goto:eof

:set_version
set /p version=Enter the version to display: 
goto:eof

:set_nsp_path
echo Please choose the folder where to create the game nsp in the following window.
echo If you close the window you will return to the menu.
pause
%windir%\system32\wscript.exe //Nologo "%ushs_base_path%TOOLS\Storage\functions\select_dir.vbs" "%ushs_base_path%templogs\tempvar.txt" "Select the folder where to create the game nsp"
goto:eof

:extract_nsp_step
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 1:  Extract GameMaker game NSP...
ECHO.
ECHO 	=========================================================================================================
goto:eof

:nca_step
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 Step 2:   Extract Decrypted NCA...
Echo.
ECHO 	=========================================================================================================
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

:howtouse_text
ECHO.
ECHO 	=========================================================================================================
ECHO.
ECHO	 		        			 How to use this software:
Echo.
ECHO 	=========================================================================================================
Echo 	-Indicate a NSP from retail GameMaker Game for sourcing
Echo 	-Indicate your GameMaker Game folder to convert
Echo 	-Indicate your keys file
Echo 	-Icon can be JPG or PNG and will be resized at good size by the process
Echo 	-Indicate an output folder for your NSP
Echo.
Echo.
Echo 	Greetings:
Echo 			Kardch ^& Chocolate2890 from GBATemp for manual method,
Echo 			The-4n for Hacpack tool,SciresM for Hactool
Echo 			YoYo Games for GameMaker Studio and all Nintendo Switch Scene
Echo 			You know who you are!
Echo. 	           
goto:eof