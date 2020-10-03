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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
echo.
set cut_type=
call "%associed_language_script%" "cut_type_choice"
IF NOT "%cut_type%"=="" set cut_type=%cut_type:~0,1%
IF "%cut_type%"=="1" goto:NSP_cut
IF "%cut_type%"=="2" goto:XCI_cut
goto:finish_script
:NSP_cut
echo.
call "%associed_language_script%" "nsp_split_type_choice"
IF NOT "%split_type%"=="" set split_type=%split_type:~0,1%
IF "%split_type%"=="1" (
	set params=
) else IF "%split_type%"=="2" (
	set params=-q
) else (
	goto:finish_script
)
echo.
call "%associed_language_script%" "nsp_input_file_choice"
set /p nsp_path=<"templogs\tempvar.txt"
IF "%nsp_path%"=="" (
	call "%associed_language_script%" "no_nsp_input_file_selected_error"
	goto:end_script
	)
IF "%split_type%"=="1" (
	echo.
	call "%associed_language_script%" "nsp_output_folder_choice"
	set /p filepath=<templogs\tempvar.txt
)
IF "%split_type%"=="1" (
	IF "%filepath%"=="" (
		call "%associed_language_script%" "no_nsp_output_folder_selected_error"
		goto:end_script
	)
)
IF "%split_type%"=="1" set filepath=%filepath%\
IF "%split_type%"=="1" set filepath=%filepath:\\=\%
IF "%split_type%"=="2" (
	"tools\python3_scripts\splitNSP\splitNSP.exe" %params% "%nsp_path%"
) else (
	"tools\python3_scripts\splitNSP\splitNSP.exe" %params% -o %filepath% "%nsp_path%"
)
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "nsp_split_error"
	goto:end_script
)
echo.
call "%associed_language_script%" "nsp_split_success"
goto:end_script
:XCI_cut
call "%associed_language_script%" "launch_xcicutter_message"
pause
"tools\XCI-Cutter\XCI-Cutter.exe"
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal