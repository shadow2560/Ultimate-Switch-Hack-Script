::Script by Eliboa, modified by Shadow256
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
del /q tools\shofel2\kernel\Image.gz 2>nul
cd tools\shofel2
if not exist conf\imx_usb.conf set MISSING=1
if not exist conf\switch.conf set MISSING=1
if not exist coreboot\cbfs.bin set MISSING=1
if not exist coreboot\coreboot.rom set MISSING=1
if not exist dtb\tegra210-nintendo-switch.dtb set MISSING=1
if not exist image\switch.scr.img set MISSING=1
if not exist kernel\*.* set MISSING=1
cd ..\..
IF "%MISSING%"=="1" (
	call "%associed_language_script%" "missing_files_error"
	pause
	set MISSING=
	goto:end_script
)
:choose_kernel
set choose_kernel=
call "%associed_language_script%" "kernel_choice"
IF "%choose_kernel%"=="0" (
	mkdir templogs
	call "%associed_language_script%" "kernel_file_choice"
	set /p kernel_path=<templogs\tempvar.txt
	rmdir /s /q templogs
)
IF "%choose_kernel%"=="0" (
	IF "%kernel_path%"=="" (
		call "%associed_language_script%" "no_kernel_selected_error"
		pause
		goto:end_script
	) else (
		copy "%kernel_path%" tools\shofel2\kernel\Image.gz
		set kernel_path=
		goto:launch_linux
	)
)
IF "%choose_kernel%"=="1" (
	IF NOT EXIST "tools\linux_kernels\Image_1.gz" (
	call "%associed_language_script%" "missing_files_error"
	pause
	goto:end_script
	)
	copy tools\linux_kernels\Image_1.gz tools\shofel2\kernel\Image.gz
) else IF "%choose_kernel%"=="2" (
	copy tools\linux_kernels\Image_2.gz tools\shofel2\kernel\Image.gz
) else (
	goto:end_script
)
:launch_linux
call "%associed_language_script%" "rcm_instructions"
tools\TegraRcmSmash\TegraRcmSmash.exe -w --relocator= "tools\shofel2\coreboot\cbfs.bin" "CBFS:tools\shofel2\coreboot\coreboot.rom"
call "%associed_language_script%" "waiting"
SLEEP 5
cd tools\shofel2\
imx_usb.exe -c conf\
cd ..\..
call "%associed_language_script%" "reboot_waiting"
tools\TegraRcmSmash\TegraRcmSmash.exe -w --relocator= "tools\shofel2\coreboot\cbfs.bin" "CBFS:tools\shofel2\coreboot\coreboot.rom"
call "%associed_language_script%" "waiting"
SLEEP 5
cd tools\shofel2\
imx_usb.exe -c conf\
cd ..\..
call "%associed_language_script%" "end_launch"
pause
:end_script
set choose_kernel=
del /q tools\shofel2\kernel\Image.gz 2>nul
endlocal