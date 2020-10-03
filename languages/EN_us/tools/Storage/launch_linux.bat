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
title Launch Linux ^(old method^) %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:missing_files_error
echo Missing some files, Linux couldn't be launched.
echo Use  the update Shofel2 option int the previous menu to fix the problem.
goto:eof

:kernel_choice
echo Choose a kernel.
echo.
echo 1: Official kernel ^(recommanded^)
echo 2: Patched kernel ^(if you encounter SD card errors during kernel loading^)
echo 0: Choose a personal kernel file
echo All other choices: Go back to previous menu.
echo.
set /p choose_kernel=Make your choice: 
goto:eof

:kernel_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Linux kernel files (*.gz)|*.gz|" "Select kernel file" "templogs\tempvar.txt"
goto:eof

:no_kernel_selected_error
echo No kernel selected, the Linux launch is canceled.
goto:eof

:rcm_instructions
echo *********************************************
echo ***    Connect the Switch in RCM mode    ***
echo *********************************************
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
goto:eof

:waiting
echo Switch detected. Waiting 5 seconds...
goto:eof

:reboot_waiting
echo *********************************************
echo ***   Wait the restart of the Switch    ***
echo *********************************************
goto:eof

:end_launch
echo *********************************************
echo *** Linux should be launched on the Switch ***
echo *********************************************
goto:eof