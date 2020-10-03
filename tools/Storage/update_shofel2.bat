::Script by Shadow256, using a part of a script of Eliboa
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
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	goto:end_script
)
call "%associed_language_script%" "update_begin"
cd tools\shofel2
IF EXIST "master.zip" del /q master.zip
"..\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "master.zip" "https://github.com/SoulCipher/shofel2_linux/archive/master.zip"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "download_error"
	cd ..\..
	goto:end_script
)
if exist conf\ RMDIR /S /Q conf
if exist coreboot\ RMDIR /S /Q coreboot
if exist dtb\ RMDIR /S /Q dtb
if exist image\ RMDIR /S /Q image
if exist kernel\ RMDIR /S /Q kernel
..\7zip\7za.exe x -y -sccUTF-8 "master.zip" -r
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "extract_error"
	del /q master.zip
	rmdir /s/q shofel2_linux-master
	cd ..\..
	goto:end_script
)
del /q master.zip
move shofel2_linux-master\conf .\
move shofel2_linux-master\coreboot .\
move shofel2_linux-master\dtb .\
move shofel2_linux-master\image .\
move shofel2_linux-master\kernel\Image.gz ..\linux_kernels\Image_1.gz
move shofel2_linux-master\kernel .\
rmdir /s/q shofel2_linux-master
cd ..\..
echo.
call "%associed_language_script%" "update_end"
:end_script
pause
endlocal