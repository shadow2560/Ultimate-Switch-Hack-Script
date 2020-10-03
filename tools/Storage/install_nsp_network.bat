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
set script_path=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
set custom_ip=
call "%associed_language_script%" "ip_choice"
:select_install_type
set install_type=
call "%associed_language_script%" "install_type_choice"
IF NOT "%install_type%"=="" set install_type=%install_type:~0,1%
IF "%install_type%"=="1" (
	call "%associed_language_script%" "file_choice"
	set /p filepath=<templogs\tempvar.txt
	IF "!filepath!"=="" (
		call "%associed_language_script%" "canceled"
		goto:endscript
	)
) else IF "%install_type%"=="2" (
	call "%associed_language_script%" "folder_choice"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		call "%associed_language_script%" "canceled"
		goto:endscript
	)
) else IF "%install_type%"=="3" (
	call "%associed_language_script%" "folder_choice"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		call "%associed_language_script%" "canceled"
		goto:endscript
	)
) else (
	goto:finish_script
)
set filepath=%filepath:\\=\%
IF "%install_type%"=="1" (
	TOOLS\python3_scripts\remote_NSP\remote_NSP.exe %custom_ip% "%filepath%"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "install_error"
		goto:endscript
	)
	)
IF "%install_type%"=="2" (
	%filepath:~0,1%:
	cd "%filepath%"
	FOR %%f in (*.nsp) do (
		"%script_path%\..\python3_scripts\remote_NSP\remote_NSP.exe" %custom_ip% "%filepath%\%%f"
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "multi_install_error" "%%f"
			echo.
		)
	)
	%script_path:~0,1%:
	cd "%script_path%\..\.."
)
IF "%install_type%"=="3" (
	%filepath:~0,1%:
	cd "!filepath!"
	"%script_path%\..\gnuwin32\bin\find.exe" -name "*.nsp" > "%script_path%\..\..\templogs\nsp_list.txt"
	"%script_path%\..\gnuwin32\bin\grep.exe" -c "" <"%script_path%\..\..\templogs\nsp_list.txt" >"%script_path%\..\..\templogs\count.txt"
	set /p tempcount=<"%script_path%\..\..\templogs\count.txt"
	del /q "%script_path%\..\..\templogs\count.txt"
	IF "!tempcount!"=="0" (
		call "%associed_language_script%" "no_file_to_install_error"
		goto:endscript
	)
	:installing
	IF "!tempcount!"=="0" (
		goto:finish_installing
	)
	"%script_path%\..\gnuwin32\bin\head.exe" -!tempcount! <"%script_path%\..\..\templogs\nsp_list.txt" | "%script_path%\..\gnuwin32\bin\tail.exe" -1>"%script_path%\..\..\templogs\nsp_list2.txt"
	set /p temp_nsp=<"%script_path%\..\..\templogs\nsp_list2.txt"
	"%script_path%\..\python3_scripts\remote_NSP\remote_NSP.exe" %custom_ip% "%filepath%\!temp_nsp!"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "multi_recursive_install_error"
		echo.
	)
	set temp_nsp=
	set /a tempcount-=1
	goto:installing
	:finish_installing
	%script_path:~0,1%:
	cd "%script_path%\..\.."
)
echo.
call "%associed_language_script%" "install_end"
:endscript
pause
:finish_script
rmdir /s /q templogs
endlocal