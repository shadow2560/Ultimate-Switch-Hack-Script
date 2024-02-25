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
title Update manager %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:autoupdate_choice
echo Set the auto-update setting:
echo.
echo The updates are verified when you launch a functionality or a group of functionnality. If you try to use a functionnality that is not yet installed, the update will be forced to install it even if you disable the updates verification.
echo In the following choice, if you choose an not definitive option, this question will be asked often.
echo If you choose to always verify updates, some functions will take time to load, for example the main menu or the SD preparation script or the Nand Toolbox but the functionnalities will always be up to date.
echo If you choose to never verify updates, you could only update the script via the "About" function but launching a functionnality will be more fast.
echo Note that you always an reset this setting via the "settings menu" of the script.
echo Not that even if you disable the updates verification and if a previous update has failed, the update will be done to prevent some bugs.
echo.
echo What do you want to do?
echo %lng_yes_choice%: Verify updates this time.
echo %lng_no_choice%: Don't verify updates this time.
echo %lng_always_choice%: Always verify updates.
echo %lng_never_choice%: Never verify updates.
echo.
set /p auto_update=Do you want to activate the auto-update? ^(%lng_yes_choice%/%lng_no_choice%/%lng_always_choice%/%lng_never_choice%^): 
goto:eof

:autoupdate_bad_value_error
echo Bad value configured, it will be reset.
goto:eof

:autoupdate_empty_value_error
echo This value couldn't be empty.
goto:eof

:autoupdate_choice_not_permited_error
echo This choice doesn't exist.
goto:eof

:no_internet_connection_error
echo No internet connection, the script couldn't verify the updates.
goto:eof

:no_internet_connection_for_new_installation_error
echo With this, the function launched is a new functionnality, the script will exit for security reason.
goto:eof

:update_manager_updater_update
echo The Update Manager should update itself before continuing.
echo To do it, the script will launch an other special script.
echo When update will be completed, the script will restart.
goto:eof

:new_installation_choice
echo Be careful, it seems that you wish to use a functionnality that is not yet installed.
echo The installation will be forced if you select to do it; an internet connection will be required.
echo If you couldn't use internet, the functionnality couldn't be launched and the script will close for security reason.
set /p new_install_choice=Do you want to launch the installation? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:begin_update
echo Verifying and updating...
goto:eof

:script_version_not_initialized_info
echo The script's version seems to be not initialized, the script will need to restart to initialize it.
goto:eof

:language_config_update_info
echo The language config file was updated, the script will need to restart to use it.
goto:eof

:end_update_restart_needed
echo End of verifications and updates, the script will restart.
goto:eof

:end_update
echo End of verifications and updates.
goto:eof

:update_all_begin
echo Script integral updating...
goto:eof

:languages_update_begin
echo Updating languages...
goto:eof

:languages_update_end
echo Languages updated.
goto:eof

:update_all_end
echo End of the script integral update.
goto:eof

:update_basic_elements_begin
echo Verifying and updating general elements of the script...
goto:eof

:update_basic_elements_end
echo End of the general elements update, the script will need to restart to use them.
goto:eof

:update_file_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Error during update of the "%temp_file_path%" file, the script will close and will not automaticaly relaunch the update on next restart.
	) else (
	echo Error during update of the "%temp_file_path%" file, the script will close and will relaunch the update on next restart.
)
goto:eof

:update_file.version_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Error during update of the "%temp_file_path%.version" file, the script will close and will not automaticaly relaunch the update on next restart.
	) else (
	echo Error during update of the "%temp_file_path%.version" file, the script will close and will relaunch the update on next restart.
)
goto:eof

:update_file_success
echo Update of "%temp_file_path%" success.
goto:eof

:update_folder_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Error during update of the "%temp_folder_path%" folder, the script will close and will not automaticaly relaunch the update on next restart.
) else (
	echo Error during update of the "%temp_folder_path%" folder, the script will close and will relaunch the update on next restart.
)
goto:eof

:update_folder_success
echo Update of "%temp_folder_path%" success.
goto:eof

:write_access_test_error
echo The script is in a folder witch needs admin write authorisation to be written. Reload the script with a right click and select "launch as administrator".
goto:eof

:del_hold_files_begin
echo Verifying and removing old files...
goto:eof

:del_hold_files_end
echo End of old files removing.
goto:eof

:retroarch_no_internet_connection
echo No internet connection, the last  Retroarch version couldn't be downloaded.
goto:eof

:retroarch_updating
echo Downloading Retroarch, this could take some time...
goto:eof

:retroarch_end_updating
echo Retroarch download success.
goto:eof