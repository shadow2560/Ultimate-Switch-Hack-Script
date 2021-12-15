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
call "%associed_language_script%" "display_title"
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
call "%associed_language_script%" "intro"
pause
echo.
call tools\storage\prepare_update_on_sd.bat "firmware_download_and_extract" "" "no_dir_choice"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:endscript
)
IF EXIST "templogs\firmware_folder.txt" (
	set /p firmware_folder=<templogs\firmware_folder.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:endscript
)
IF NOT EXIST "%firmware_folder%\*.*" (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:endscript
)
IF EXIST "templogs\firmware_chosen.txt" (
	set /p firmware_choice=<templogs\firmware_chosen.txt
) else (
	call "%associed_language_script%" "firmware_preparation_error"
	pause
	goto:endscript
)
echo.
call "%associed_language_script%" "output_folder_choice"
set /p output_folder=<templogs\tempvar.txt
IF "%output_folder%"=="" (
	call "%associed_language_script%" "output_folder_empty_error"
	goto:endscript
)
IF NOT "%output_folder%"=="" set output_folder=%output_folder%\
IF NOT "%output_folder%"=="" set output_folder=%output_folder:\\=\%
set titles_output_file=titles_output.txt
tools\Hactool_based_programs\hactoolnet.exe -t switchfs "firmware_temp" --listncas | tools\gnuwin32\bin\grep.exe "0100000000000809" | tools\gnuwin32\bin\grep.exe "Data" | tools\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p fat32=<templogs\tempvar.txt
tools\Hactool_based_programs\hactoolnet.exe -t switchfs "firmware_temp" --listncas | tools\gnuwin32\bin\grep.exe "010000000000081B" | tools\gnuwin32\bin\grep.exe "Data" | tools\gnuwin32\bin\cut.exe -d " " -f 1 >templogs\tempvar.txt
set /p exfat=<templogs\tempvar.txt
IF "%fat32%"=="" (
	call "%associed_language_script%" "extract_error"
	goto:endscript
)
IF "%exfat%"=="" (
	call "%associed_language_script%" "extract_error"
	goto:endscript
)
echo svt, extracted from title 0100000000000809:>"%output_folder%%titles_output_file%"
echo %firmware_choice%,%fat32%.nca>>"%output_folder%%titles_output_file%"
echo.>>"%output_folder%%titles_output_file%"
echo pkgc, extracted from 010000000000081B:>>"%output_folder%%titles_output_file%"
echo %firmware_choice%,%exfat%.nca>>"%output_folder%%titles_output_file%"
echo.
call "%associed_language_script%" "extract_sucess"
goto:endscript

:endscript
pause
:endscript2
rmdir /s /q templogs
IF EXIST "firmware_temp\*.*" rmdir /s /q "firmware_temp"
endlocal