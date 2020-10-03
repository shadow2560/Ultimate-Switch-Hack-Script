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
title Shadow256 Ultimate Switch Hack Script Update Manager Updater%this_script_version% - 
goto:eof

:begin_update
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script Update Manager Updater::
echo.
echo Updating Update Manager...
goto:eof

:no_internet_connection_error
echo No internet connexion, the script couldn't continue and the script will close.
goto:eof

:update_file_error
echo Update of "%temp_file_path%" file error, the script will close and will retry the update on the next launch.
goto:eof

:update_file.version_error
echo Update of "%temp_file_path%.version" file error, the script will close and will retry the update on the next launch.
goto:eof

:update_language_file_error
echo Update of "%language_path%\%temp_file_path%" file error, the script will close and will retry the update on the next launch.
goto:eof

:update_language_file.version_error
echo Update of "%language_path%\%temp_file_path%.version" file error, the script will close and will retry the update on the next launch.
goto:eof

:update_success
echo Update of Update Manager success, the script will restart.
goto:eof