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
title Update of the old Linux launch method %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo No internet connection, update canceled.
goto:eof

:update_begin
echo Updating...
goto:eof

:download_error
echo Error during the   Shofel2 download, the script couldn't continue.
goto:eof

:extract_error
echo Error during the   Shofel2 extraction, the script couldn't continue.
goto:eof

:update_end
echo Update success.
goto:eof