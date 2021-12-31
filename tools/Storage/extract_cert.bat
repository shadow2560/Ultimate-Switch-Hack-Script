::CertNXtractionPack by SocraticBliss and SimonMKWii, modified by Shadow256
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
IF EXIST "Certificat" (
	rmdir /s /q "Certificat" 2>nul
	del /q Certificat 2>nul
)
mkdir "Certificat"
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
set biskey=
call "%associed_language_script%" "launch_biskeydump_choice"
IF NOT "%biskey%"=="" set biskey=%biskey:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "biskey" "o/n_choice"
IF /i "%biskey%"=="o" call TOOLS\Storage\biskey_dump.bat
set mount_emmc=
call "%associed_language_script%" "mount_emmc_choice"
IF NOT "%mount_emmc%"=="" set mount_emmc=%mount_emmc:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "mount_emmc" "o/n_choice"
IF /i "%mount_emmc%"=="o" (
	call "%associed_language_script%" "rcm_instructions"
	tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\memloader\memloader.bin --dataini="tools\memloader\mount_discs\ums_emmc.ini"
	echo.
	set launch_devices_manager=
	call "%associed_language_script%" "after_rcm_instructions_choice"
	echo.
	IF NOT "!launch_devices_manager!"=="" set launch_devices_manager=!launch_devices_manager:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_devices_manager" "o/n_choice"
	IF /i "!launch_devices_manager!"=="o" start devmgmt.msc
)
call "%associed_language_script%" "launch_hacdiskmount_choice"
IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_hacdiskmount" "o/n_choice"
IF /i "%launch_hacdiskmount%"=="o" start tools\HacDiskMount/HacDiskMount.exe
echo.
call "%associed_language_script%" "prodinfo_file_choice"
set /p filepath=<templogs\tempvar.txt
IF "!filepath!"=="" (
	call "%associed_language_script%" "prodinfo_no_file_selected_error"
	rmdir /s /q "Certificat"
	goto:endscript
)
cd "Certificat"
copy /v "%filepath%" "PRODINFO.bin"
SET ERROR_LEVEL=0
REM Check the file dependencies
FOR %%G IN (PRODINFO.bin) DO (
	IF NOT EXIST "%%G" call "%associed_language_script%" "prodinfo_not_found_error" "%%g" && SET ERROR_LEVEL=1
)
IF %ERROR_LEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Exécution du Script #1
chcp 1250 >nul
..\TOOLS\python2_scripts\CertNXtractionPack\CertNXtractionPack.exe
chcp 65001 >nul
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Exécution du Script #2
..\TOOLS\python3_scripts\Cert_extraction\Convert_to_der.exe
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Création du fichier de certificat au format "PFX"
..\TOOLS\openssl\openssl.exe x509 -inform DER -in clcert.der -outform PEM -out clcert.pem >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

..\TOOLS\openssl\openssl.exe rsa -inform DER -in privkey.der -outform PEM -out privkey.pem >NUL 2>&1
TYPE clcert.pem privkey.pem > nx_tls_client_cert.pem 2>&1
..\TOOLS\openssl\openssl.exe pkcs12 -export -in nx_tls_client_cert.pem -out nx_tls_client_cert.pfx -passout pass:switch >NUL 2>&1
DEL privk.bin >NUL 2>&1
DEL clcert.der >NUL 2>&1
DEL privkey.der >NUL 2>&1
DEL clcert.pem >NUL 2>&1
DEL privkey.pem >NUL 2>&1
DEL nx_tls_client_cert.pem >NUL 2>&1

ECHO:
call "%associed_language_script%" "certificat_first_success"
ECHO:

REM Convertion du fichier "PFX" au format "PEM"
..\TOOLS\python3_scripts\Cert_extraction\pfx_to_pem.exe nx_tls_client_cert.pfx
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && goto:end_script)

ECHO:
call "%associed_language_script%" "certificat_extraction_success"

ECHO:
cd ..
:end_script
rmdir /s /q templogs
IF EXIST "Certificat\PRODINFO.bin" del /q "Certificat\PRODINFO.bin"
pause 
endlocal