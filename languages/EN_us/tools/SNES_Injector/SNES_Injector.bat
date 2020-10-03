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
title SNES Injector %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will prepare the Snes Classic Edition emulator with your images and games.
echo If you include this emulator during the SD preparation, these modifications will be included.
echo Important: The images and games will be reset, the previous configuration will be deleted just after the games folder selection.
goto:eof

:no_game_in_source_folder_error
echo No games in "%source_roms%" folder, the script couldn't do anything.
goto:eof

:operations_success
echo Success.
goto:eof

:no_image_for_the_game_warning
echo No image found for the  game "%space%, a default image will be copied.
goto:eof

:images_folder_choice
echo You will need to select the images folder. Be careful, the image file name should correspond to the game file name.
echo If the source is empty, the default image will be used for all games.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "select images folder"
goto:eof

:no_images_folder_defined_warning
echo No images source folder, the script will use the default image for all games.
goto:eof

:roms_folder_choice
echo You will need to select the games folder.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select games folder"
goto:eof

:no_roms_folder_defined_error
echo The games source couldn't be empty.
goto:eof