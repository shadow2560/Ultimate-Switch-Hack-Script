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
set keys_file_path=
IF EXIST "update_packages\*.*" rmdir /s /q "update_packages"
IF EXIST "firmware_temp\*.*" rmdir /s /q "firmware_temp" 2>nul
call "%associed_language_script%" "intro"
IF %errorlevel% EQU 2 goto:endscript2
call "%associed_language_script%" "intro_2"
IF %errorlevel% EQU 1 start tools\drivers\automatic_install\drivers.exe
echo.
call "%associed_language_script%" "patched_console_choice"
IF %errorlevel% EQU 1 (
	set patched_console=O
	set method_creation_firmware_unbrick_choice=2
)
IF %errorlevel% EQU 2 (
	set patched_console=N
	set mariko_console=N
)
IF /i "%patched_console%"=="O" (
	call "%associed_language_script%" "mariko_console_choice"
	IF !errorlevel! EQU 1 (
		set mariko_console=O
		goto:keys_file_creation
	) else (
		set mariko_console=N
	)
)

echo.
call "%associed_language_script%" "dump_keys_choice"
IF %errorlevel% EQU 1 (
	call "%associed_language_script%" "dump_keys_instructions_begin"
	IF /i NOT "%patched_console%"=="O" tools\TegraRcmSmash\TegraRcmSmash.exe -w "tools\payloads\Lockpick_RCM.bin"
	call "%associed_language_script%" "dump_keys_instructions_end"
	IF !errorlevel! EQU 2 goto:endscript2
)

	IF /i "%mariko_console%"=="O" goto:keys_file_creation

call "%associed_language_script%" "method_creation_firmware_unbrick_choice"
if "%errorlevel%"=="1" (
	set method_creation_firmware_unbrick_choice=1
) else if "%errorlevel%"=="2" (
	set method_creation_firmware_unbrick_choice=2
	goto:keys_file_creation
) else (
	goto:endscript2
)

if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF EXIST tools\Hactool_based_programs\keys.txt (
		call "%associed_language_script%" "define_new_keys_file_choice"
		IF !errorlevel! equ 1 (
			set define_new_keys_file=o
			goto:keys_file_creation
		)
	)
	IF NOT EXIST tools\Hactool_based_programs\keys.txt (
		IF EXIST tools\Hactool_based_programs\keys.dat (
			rename tools\Hactool_based_programs\keys.dat keys.txt >nul
			goto:skip_keys_file_creation
		)
		call "%associed_language_script%" "keys_file_not_finded"
		goto:keys_file_creation
	) else (
		goto:skip_keys_file_creation
	)
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_selection"
set /p keys_file_path=<"templogs\tempvar.txt"
IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:endscript
)
if "%method_creation_firmware_unbrick_choice%"=="1" (
	copy "%keys_file_path%" "tools\Hactool_based_programs\keys.txt" >nul
)
:skip_keys_file_creation
if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF EXIST tools\Hactool_based_programs\ChoiDuJour_keys.txt del /q tools\Hactool_based_programs\ChoiDuJour_keys.txt >nul
	cd tools\Hactool_based_programs
	..\python3_scripts\Keys_management\keys_management.exe create_choidujour_keys_file ..\Hactool_based_programs\keys.txt >..\..\templogs\result_choidujour_keys_file_creation_file.txt
	cd ..\..
	tools\gnuwin32\bin\tail.exe -n1 <"templogs\result_choidujour_keys_file_creation_file.txt" >templogs\tempvar.txt
	set /p create_choidujour_keys_file=<templogs\tempvar.txt
	echo !create_choidujour_keys_file! | tools\gnuwin32\bin\grep.exe -c "ChoiDuJour_keys.txt" >templogs\tempvar.txt
	set /p temp_count=<templogs\tempvar.txt
	IF "!temp_count!"=="1" (
		set create_choidujour_keys_file_state=0
		goto:skip_choidujour_keys_file_create
	)
	echo !create_choidujour_keys_file! | tools\gnuwin32\bin\grep.exe -c " obligatoire " >templogs\tempvar.txt
	set /p temp_count=<templogs\tempvar.txt
	IF "!temp_count!"=="1" (
		set create_choidujour_keys_file_state=1
		echo !create_choidujour_keys_file! | tools\gnuwin32\bin\cut.exe -d \^" -f 2 >templogs\tempvar.txt
		set /p key_missing=<templogs\tempvar.txt
		del /q tools\Hactool_based_programs\keys.txt >nul
		goto:skip_choidujour_keys_file_create
	)
	echo !create_choidujour_keys_file! | tools\gnuwin32\bin\grep.exe -c " facultative " >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
	IF "!temp_count!"=="1" (
		set create_choidujour_keys_file_state=2
		echo !create_choidujour_keys_file! | tools\gnuwin32\bin\cut.exe -d \^" -f 2 >templogs\tempvar.txt
		set /p key_missing=<templogs\tempvar.txt
		goto:skip_choidujour_keys_file_create
	)
)
:skip_choidujour_keys_file_create
if "%method_creation_firmware_unbrick_choice%"=="1" (
	call "%associed_language_script%" "choidujour_keys_file_creation"
	IF NOT EXIST tools\Hactool_based_programs\ChoiDuJour_keys.txt (
		call "%associed_language_script%" "choidujour_keys_file_create_error"
		goto:endscript
	)
	IF EXIST "downloads\ChoiDuJour_package_6.1.0.zip" del /q "downloads\ChoiDuJour_package_6.1.0.zip" >nul
	IF EXIST "downloads\ChoiDuJour_package_5.1.0.zip" (
		TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\ChoiDuJour_package_5.1.0.zip" -o"." -r
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "extract_error"
			goto:endscript
		)
	)
)
:internet_connection_verif
echo.
"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	goto:endscript
)

if "%keys_file_path%"=="" set keys_file_path=tools\Hactool_based_programs\keys.txt
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_disk_found_error"
	IF !errorlevel! EQU 1 (
		goto:define_volume_letter
	) else IF !errorlevel! EQU 2 (
		goto:endscript2
	)
)
echo.
call "%associed_language_script%" "disk_list_begin"
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
echo.
echo.
set volume_letter=
call "%associed_language_script%" "disk_choice"
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	call "%associed_language_script%" "disk_choice_empty_error"
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:endscript2
set nb=1
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat volume_letter
set i=0
:check_chars_volume_letter
IF %i% LSS %nb% (
	set check_chars_volume_letter=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		IF "!volume_letter:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_volume_letter=1
			goto:check_chars_volume_letter
		)
	)
	IF "!check_chars_volume_letter!"=="0" (
		call "%associed_language_script%" "disk_choice_char_error"
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	call "%associed_language_script%" "disk_choice_not_exist_error"
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	call "%associed_language_script%" "disk_choice_not_in_list_error"
	goto:define_volume_letter
)
set format_choice=
call "%associed_language_script%" "disk_format_choice"
IF %errorlevel% EQU 1 (
	set format_choice=o
	echo.
	set format_type=
	call "%associed_language_script%" "disk_format_type_choice"
) else (
	goto:copy_to_sd
)
IF %errorlevel% EQU 1 goto:format_exfat
IF %errorlevel% EQU 2 goto:format_fat32
set format_choice=
goto:copy_to_sd
:format_exfat
call "%associed_language_script%" "disk_formating_begin"
echo.
chcp 850 >nul
format %volume_letter%: /X /Q /FS:EXFAT
IF %errorlevel% NEQ 0 (
	chcp 65001 >nul
	call "%associed_language_script%" "disk_formating_error"
	goto:endscript
) else (
chcp 65001 >nul
	call "%associed_language_script%" "disk_formating_success"
	echo.
	goto:copy_to_sd
)
:format_fat32
call "%associed_language_script%" "disk_formating_begin"
echo.
TOOLS\fat32format\fat32format.exe -q -c128 %volume_letter%
echo.
IF "%ERRORLEVEL%"=="5" (
	call "%associed_language_script%" "disk_formating_fat32_not_admin_error"
	::echo.
	goto:copy_to_sd
)
IF "%ERRORLEVEL%"=="32" (
	call "%associed_language_script%" "disk_formating_fat32_disk_used_error"
	goto:endscript
)
IF "%ERRORLEVEL%"=="2" (
	call "%associed_language_script%" "disk_formating_fat32_disk_not_exist_error"
	goto:endscript
)
IF NOT "%ERRORLEVEL%"=="1" (
	IF NOT "%ERRORLEVEL%"=="0" (
		call "%associed_language_script%" "disk_formating_fat32_unknown_error"
		goto:endscript
	)
)
IF "%ERRORLEVEL%"=="1" (
	call "%associed_language_script%" "disk_formating_fat32_canceled_info"
)
IF "%ERRORLEVEL%"=="0" (
	call "%associed_language_script%" "disk_formating_success"
)
:copy_to_sd
set md5_try=0
IF NOT EXIST "downloads" mkdir "downloads"
IF NOT EXIST "downloads\firmwares" mkdir "downloads\firmwares"
IF EXIST "firmware_temp" (	
	del /q "firmware_temp" 2>nul
) else (
	mkdir firmware_temp
)
if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF EXIST "downloads\ChoiDuJour_package_5.1.0.zip" goto:define_firmware_choice
	set expected_md5=656823850a70fb3050079423ee177c1a
	set "firmware_link=https://mega.nz/#^!8BplGRQA^!z_2pCeh-8XV2Pf3E_38UfGhDPRSdN3nixb5s5-Q785w"
	set firmware_file_name=Firmware 5.1.0.zip
	set firmware_folder=firmware_temp\
)
:download_firmware_choidujour
if "%method_creation_firmware_unbrick_choice%"=="1" (
	set md5_try=0
	IF EXIST "downloads\firmwares\%firmware_file_name%" goto:verif_md5sum_choidujour
)
:downloading_firmware_choidujour
if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
		call "%associed_language_script%" "firmware_downloading_begin"
	Setlocal disabledelayedexpansion
	TOOLS\megatools\megatools.exe dl --path="templogs\temp.zip" "%firmware_link%"
	endlocal
		TOOLS\gnuwin32\bin\md5sum.exe templogs\temp.zip | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
			set /p md5_verif=<templogs\tempvar.txt
	)
	IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
		IF NOT "!md5_verif!"=="%expected_md5%" (
			IF !md5_try! EQU 3 (
				call "%associed_language_script%" "firmware_downloading_md5_error"
				goto:endscript
			) else (
				call "%associed_language_script%" "firmware_downloading_md5_retry"
				set /a md5_try+=1
				goto:downloading_firmware_choidujour
			)
		)
	)
	set md5_try=0
	move "templogs\temp.zip" "downloads\firmwares\%firmware_file_name%" >nul
	goto:skip_verif_md5sum_choidujour
)
:verif_md5sum_choidujour
if "%method_creation_firmware_unbrick_choice%"=="1" (
	TOOLS\gnuwin32\bin\md5sum.exe "downloads\firmwares\%firmware_file_name%" | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
	set /p md5_verif=<templogs\tempvar.txt
IF NOT "!md5_verif!"=="%expected_md5%" (
		set md5_verif=
		call "%associed_language_script%" "firmware_exist_but_bad_md5_tested_error"
		goto:downloading_firmware_choidujour
	)
)
:skip_verif_md5sum_choidujour
if "%method_creation_firmware_unbrick_choice%"=="1" (
	call "%associed_language_script%" "firmware_downloading_end"
)
:define_firmware_choice
set optional_firmware_download=
if "%method_creation_firmware_unbrick_choice%"=="1" (
	echo.
	call "%associed_language_script%" "optional_firmware_download_choice"
	IF !errorlevel! EQU 2 goto:skip_optional_firmware_download
	IF !errorlevel! EQU 1 set optional_firmware_download=Y
)
set firmware_choice=
call "%associed_language_script%" "firmware_choice_begin"
rem echo 1.0.0?
rem echo 2.0.0?
rem echo 2.1.0?
rem echo 2.2.0?
rem echo 2.3.0?
rem echo 3.0.0?
rem echo 3.0.1?
rem echo 3.0.2?
rem echo 4.0.0?
rem echo 4.0.1?
rem echo 4.1.0?
rem echo 5.0.0?
rem echo 5.0.1?
rem echo 5.0.2?
echo 5.1.0?
rem echo 6.0.0?
rem echo 6.0.1?
echo 6.1.0?
rem echo 6.2.0?
rem echo 7.0.0?
rem echo 7.0.1?
rem echo 8.0.0?
rem echo 8.0.1?
rem echo 8.1.0?
rem echo 8.1.1?
rem echo 9.0.0?
rem echo 9.0.1?
rem echo 9.1.0?
rem echo 9.2.0?
rem echo 10.0.0?
rem echo 10.0.1?
rem echo 10.0.2?
rem echo 10.0.3?
rem echo 10.0.4?
rem echo 10.1.0?
rem echo 10.2.0?
echo 11.0.0?
rem echo 11.0.1?
rem echo 12.0.0?
rem echo 12.0.1?
rem echo 12.0.2?
rem echo 12.0.3?
rem echo 12.1.0?
rem echo 13.0.0?
rem echo 13.1.0?
rem echo 13.2.0?
rem echo 13.2.1?
rem echo 14.0.0?
rem echo 14.1.0?
rem echo 14.1.1?
rem echo 14.1.2?
rem echo 15.0.0?
rem echo 15.0.1?
rem echo 16.0.0?
rem echo 16.0.1?
rem echo 16.0.2?
rem echo 16.0.3?
rem echo 16.1.0?
rem echo 17.0.0?
rem echo 17.0.1?
rem echo 18.0.0?
rem echo 18.0.1?
echo 18.1.0?
echo 19.0.0?
echo 19.0.1?
echo 20.0.0?
echo 20.0.1?
echo 20.1.0?
echo 20.1.1?
echo 20.1.5?
echo 20.2.0?
echo 20.3.0?
echo.
call "%associed_language_script%" "firmware_choice_end"
IF "%firmware_choice%"=="1.0.0" (
	set expected_md5=46e6814359631d3c92bc43ead4328349
	set "firmware_link=https://mega.nz/#^!sVg2RKYS^!MVDYwOWwvL6rUKiXHPhDr7071MhsbTi9ybIn_RABihI"
	set firmware_file_name=Firmware 1.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.0.0" (
	set expected_md5=78fe09c2da202d35e58c7b07bb7f39a8
	set "firmware_link=https://mega.nz/#^!sAIzSQTK^!c1RNFqOrDt3-iW4Rn_M5IkUgx-ormrpImrtZXixNrOQ"
	set firmware_file_name=Firmware 2.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.1.0" (
	set expected_md5=35752c26badc270f9fdd51883922432b
	set "firmware_link=https://mega.nz/#^!gcx3UR5Y^!P4Ka3g4hum5c2tI0YwX8HBokm6SQ4EoCG2OeKtKC8dg"
	set firmware_file_name=Firmware 2.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.2.0" (
	set expected_md5=137f5d416d1b41ad26c35575dd534bc4
	set "firmware_link=https://mega.nz/#^!QVJl0aDA^!MU03vBUo1OXxK5Ha0yP04vli6W0LQjvZILuc_bh_Xq4"
	set firmware_file_name=Firmware 2.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.3.0" (
	set expected_md5=91e06f945e00e6412cc4ac44a0faa72b
	set "firmware_link=https://mega.nz/#^!1IxFgJBD^!kkliIMLOYNjmwIVR0tcr3svn72C6tMOQG5GHYie50q4"
	set firmware_file_name=Firmware 2.3.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.0" (
	set expected_md5=f4b5f8bffded14cca836bc24ecf19c06
	set "firmware_link=https://mega.nz/#^!RUxF3Lwb^!5fYRfHTFTx8KS9HnyYMmTuTTzKKQ4HyaQ4FqC-nyAc4"
	set firmware_file_name=Firmware 3.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.1" (
	set expected_md5=a245bc7d3151cd51687ce602a1d4dfbb
	set "firmware_link=https://mega.nz/#^!pE51RLgI^!pmvw4sfocWw-vZ26P3GjA2PSrLyeBcq-eunnvzmUx94"
	set firmware_file_name=Firmware 3.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.2" (
	set expected_md5=521e4aabc0b3b18d49f99c861cd55196
	set "firmware_link=https://mega.nz/#^!hNo1TLrL^!S1pfSuDaOoeW2eNcpe89bPP3BiW0b3pPqUrJvsVCAuQ"
	set firmware_file_name=Firmware 3.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.0.0" (
	set expected_md5=3cde6a57ebf6c61e8fc8e858cf7614da
	set "firmware_link=https://mega.nz/file/FcxTWYaJ#zHPCMpxuzK8dLj0-_hXt0Mgdpk3GxrdbUvE5lHCQO4M"
	set firmware_file_name=Firmware 4.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.0.1" (
	set expected_md5=3680ddfb0f7a2f01c83495dca909c757
	set "firmware_link=https://mega.nz/#^!NQg1yZaA^!4yuWJbXOGlCp6lryPcsF5ADEydk7jZq08RstUCDMKwY"
	set firmware_file_name=Firmware 4.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.1.0" (
	set expected_md5=fe53dd1eaa323bd9003f75a96822cb31
	set "firmware_link=https://mega.nz/#^!wQ4HGLgI^!ru3dBiMh9FdPJJvVTLJ6ex7EX0Rfma9Tw4J3gRWYU7k"
	set firmware_file_name=Firmware 4.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.0" (
	set expected_md5=de25e742c8c0fa9c7f6d079f65ddbf92
	set "firmware_link=https://mega.nz/#^!IBQlXQqL^!oePY4waKGpSnmVyxgXqEwx_vOeI6FvdBdpg0Wp4Y28c"
	set firmware_file_name=Firmware 5.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.1" (
	set expected_md5=79c2ac770eece2f9b713f3c6b12cc19a
	set "firmware_link=https://mega.nz/#^!BUB3TShb^!VFVqGrzK2j_6OIUTcbwzTvPCm8V5Aab2hXrdJrVmUqk"
	set firmware_file_name=Firmware 5.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.2" (
	set expected_md5=f14d2064255517aa1383e7e468e2ef19
	set "firmware_link=https://mega.nz/#^!wBwDCTgI^!7LsV9WSoYDBI6CamIBRzZYwA3wjCRchXyXw1VTTwXTc"
	set firmware_file_name=Firmware 5.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.1.0" (
	set expected_md5=656823850a70fb3050079423ee177c1a
	set "firmware_link=https://mega.nz/file/jJB1UahJ#ZUJTdBDrf-l6L0gDfQzJFlgSQGYcWwJzwHIlCmqeWG4"
	set firmware_file_name=Firmware 5.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.0.0" (
	set expected_md5=8e107ad46a5aacc1f8f5db7fc83d6945
	set "firmware_link=https://mega.nz/#^!0ZxlgABK^!HN8_ZfQHha-LaVr-95wUiotvGSObIUoEY8RxMwjDgVg"
	set firmware_file_name=Firmware 6.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.0.1" (
	set expected_md5=684f2184d9dd4bdc25ff161e0ea7353d
	set "firmware_link=https://mega.nz/#^!ZAYEhYSQ^!69L4mdQnPNKghHnMY41w3Di5MjvGXr8MhXGMVAxG5GA"
	set firmware_file_name=Firmware 6.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.1.0" (
	set expected_md5=0547222834a00891ed82d4f58d1b2c7b
	set "firmware_link=https://mega.nz/file/bYZgARIZ#10XPM21DHFYz2Bj_zsfbwRJL5cU66NxJzktPhTAoTLQ"
	set firmware_file_name=Firmware 6.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.2.0" (
	set expected_md5=30e4a67c2943465c5441f203bd169ba8
	set "firmware_link=https://mega.nz/file/AUZ20CjD#6qWImbigauDPA8hYNt6F_Uv82uvDKsOVuNZudx551Es"
	set firmware_file_name=Firmware 6.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.0" (
	set expected_md5=7faf4c721a96767f11ddf83d1ea06b4a
	set "firmware_link=https://mega.nz/file/5BQmhADI#GGx9xvwrF9Ayn4u_UvpIR2GbRCHAA-_6V8tG5rci0XE"
	set firmware_file_name=Firmware 7.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.1" (
	set expected_md5=589ab86da5f6028a7f3d39e85e043d4a
	set "firmware_link=https://mega.nz/file/NNRQHKyB#NGCWLzso_10m9qdZu81-utveT9QXQ3dfQZYfxy42uBc"
	set firmware_file_name=Firmware 7.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.0" (
	set expected_md5=e1641978fc281f3ce6b033398ae520dd
	set "firmware_link=https://mega.nz/file/pZhRxYLR#9kiA-fiyXiGQEszvHMJ1Qgi6om5-MHj_rn-48M61n9s"
	set firmware_file_name=Firmware 8.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.1" (
	set expected_md5=1bd7a32f9a2a67ffda6a245f76f06609
	set "firmware_link=https://mega.nz/file/tBphDAJT#sWxKqBScpS2lpHOz9F6FYP-mnW1ZXr_GsmXHx85vLD0"
	set firmware_file_name=Firmware 8.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.0" (
	set expected_md5=85907ab512b028d6a81a2e1b414b59b9
	set "firmware_link=https://mega.nz/file/BZh3BahL#HAprgXGPwnFLNg7zFKZoOLsxLRoP2hBd161KQojfSmA"
	set firmware_file_name=Firmware 8.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.1" (
	set expected_md5=4fc67d5be86e4880612fbca76f6d8e70
	set "firmware_link=https://mega.nz/file/8EQHWKDJ#-ABxIrFEj_1V5N4t-m-MgzSCDdV-w79jotNdNYl0nZs"
	set firmware_file_name=Firmware 8.1.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.0" (
	set expected_md5=0ec9d07322ae98fc1163674d40437305
	set "firmware_link=https://mega.nz/file/IQxhkS4I#JI8zsR6B5ZxE0vucpIf-zHXX8Bh6nVg0XtT9XHd8B7w"
	set firmware_file_name=Firmware 9.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.1" (
	set expected_md5=6c428005c384072e32dcf0bddf971817
	set "firmware_link=https://mega.nz/file/FEhVwSzJ#XmIOiLtThdg-zxXhai7PMFTRpf7S6WpH2pCgyKx-B_4"
	set firmware_file_name=Firmware 9.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.1.0" (
	set expected_md5=b0ed3ce315918e05bccbf31694d52584
	set "firmware_link=https://mega.nz/file/cAhxhQIY#We6qCI1ZYs7LzA8gAh5k_ZVNkDdSO3GlSb90GGYLwCE"
	set firmware_file_name=Firmware 9.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.2.0" (
	set expected_md5=64ffa81de3a4b7bda973036520113cda
	set "firmware_link=https://mega.nz/file/UIxHGIDT#fXNAntIt8HahMeclTXILwM5N2wrQcG1umT-pV7mfgkI"
	set firmware_file_name=Firmware 9.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.0" (
	set expected_md5=ca88f99be9fadc0088210ef9a4b3986a
	set "firmware_link=https://mega.nz/file/xYwVQChQ#dwwNHT_nax71wVzW8oo47Tf6eMhJVTVFxJhxtwX1hBE"
	set firmware_file_name=Firmware 10.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.1" (
	set expected_md5=ddaec6ef4674887c53b9f153eda7e9b6
	set "firmware_link=https://mega.nz/file/URwTCALJ#keo-5YxST1sBsNWEXyY4cYLEZZ57qCbK5WvHZ_7Aynw"
	set firmware_file_name=Firmware 10.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.2" (
	set expected_md5=4b795c906abf70439fe53ee4a6fc636c
	set "firmware_link=https://mega.nz/file/VFYSTSQA#NK2NeduFhA9RPBR98N55nHVYUxfEK5ZCrF4BIyYAF20"
	set firmware_file_name=Firmware 10.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.3" (
	set expected_md5=f15f82570701868246016616979147d8
	set "firmware_link=https://mega.nz/file/UYhz1SbC#ZHr9axJryu5a0QCIcMH4jgLcteDy4CnkabHwBlMmuIE"
	set firmware_file_name=Firmware 10.0.3.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.4" (
	set expected_md5=9816b980f84b1cef8a91f5ce3a697678
	set "firmware_link=https://mega.nz/file/xVwVFazC#sFkKEKkHhp2YEcqR5UQhAg_qxEPfZq8oRUalgleKVDA"
	set firmware_file_name=Firmware 10.0.4.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.1.0" (
	set expected_md5=a2ccac10398351ea0f9d3af30534297c
	set "firmware_link=https://mega.nz/file/wJpxySRI#dc8o9otnt_KHJJaeuxAdoT1nQBQyCsdlD7xO8rzkCrw"
	set firmware_file_name=Firmware 10.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.2.0" (
	set expected_md5=8c18c4e5908178f9af4d8aad183b8ca2
	set "firmware_link=https://mega.nz/file/xF5g0SIB#4fa2DF0CC6sXB2a38l0bsA9ZZojL9HXVbIQeFLVzm3c"
	set firmware_file_name=Firmware 10.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="11.0.0" (
	set expected_md5=7330b3c560f80caeb2fa3d831d5203f2
	set "firmware_link=https://mega.nz/file/yZRh3A7S#kV3EZN8mhDkI0C5gg6UcuoWzZFksBuAP-tioVAKjtqU"
	set firmware_file_name=Firmware 11.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="11.0.1" (
	set expected_md5=53f68ddd2a2f4f79e98edc02ff2ad0bd
	set "firmware_link=https://mega.nz/file/sJRiXTTa#9EDwT_dBFUVmpOvQnvKrLmMsk1RiLVczcOREHkqp3fM"
	set firmware_file_name=Firmware 11.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.0" (
	set expected_md5=d297bdb5a6d0341df6cc24195f604abe
	set "firmware_link=https://mega.nz/file/pJBCBLaC#rwCiDG9-ASH8K8cZYUUsg-UxHNqcmgsqcsmlRyyWmsY"
	set firmware_file_name=Firmware 12.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.1" (
	set expected_md5=12040ddd1533cf58ff2fb690d7bec3ee
	set "firmware_link=https://mega.nz/file/9UoUTYaY#l-rfPBQXpNIQ6I4UBeNRNHJhOE5zb5a7CPA4FAF_qJM"
	set firmware_file_name=Firmware 12.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.2" (
	set expected_md5=939ec032227741b60aafacbedc4e476f
	set "firmware_link=https://mega.nz/file/5IoTzABQ#Sjzs-_kOViyu1leE44Ae_YcloSa_FmgYRvUn9cXXcfk"
	set firmware_file_name=Firmware 12.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.3" (
	set expected_md5=35cb46f7d2d609f7d056c22099d1c469
	set "firmware_link=https://mega.nz/file/4dwk0IRB#48ATk9rdx3klFC2juWzxRukTfSYWI2vBK3tblsOMZQI"
	set firmware_file_name=Firmware 12.0.3.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="12.1.0" (
	set expected_md5=6c8f353daccf73e1da7ee5dd532656f0
	set "firmware_link=https://mega.nz/file/8cpWiR4K#Ina7VLZpVbfi53-9liXSYyes93VIga2BENiFqqAYYxU"
	set firmware_file_name=Firmware 12.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="13.0.0" (
	set expected_md5=9fa654de1a4682e517a15b5a79a7895d
	set "firmware_link=https://mega.nz/file/UFpi3Yra#_UwDAU0c0OrE88oInSHUXuhnwJwhPA2Qm297pbT7KSA"
	set firmware_file_name=Firmware 13.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="13.1.0" (
	set expected_md5=ab837980ed2c83eedaecb28ebf667d9a
	set "firmware_link=https://mega.nz/file/IFx1jIAZ#JZlMks0EjumXZEZPUgQhii_MjovVOzOLaxSP3_SHx8g"
	set firmware_file_name=Firmware 13.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="13.2.0" (
	set expected_md5=f4f0a7e77d39e209d1be0ee8641c9afb
	set "firmware_link=https://mega.nz/file/VdZzXaCT#b2mX02_YfyLqFroFoTbspyswGoTXYtZAZIWMsUl6PJ4"
	set firmware_file_name=Firmware 13.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="13.2.1" (
	set expected_md5=881379299c1c9cd2a4b7a90c18c9ea82
	set "firmware_link=https://mega.nz/file/xYYkyT7K#I0Xr60_co04X_JWUirfVyswg0pR_XnlxeIDMK5YHEYQ"
	set firmware_file_name=Firmware 13.2.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="14.0.0" (
	set expected_md5=816010565838f30b047d0059efa8c3ea
	set "firmware_link=https://mega.nz/file/wEJi0IRQ#p1S-t8LkSUa5xjDoCc_brveXlk6JniZVcmRLCVt-x_8"
	set firmware_file_name=Firmware 14.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.0" (
	set expected_md5=778b4e7854afa1a0baa98c44988e68ac
	set "firmware_link=https://mega.nz/file/YIonGbxR#Ca49NIXk6ktJPmwaqazxDCypA_WsYmizNjFFijmxhv0"
	set firmware_file_name=Firmware 14.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.1" (
	set expected_md5=4e864e134318aa80ac06e7a676eb96d8
	set "firmware_link=https://mega.nz/file/dZwzzCKT#LzuAFUKvUQIzw-LQ6rP77EVswGNsRUH5bDQVvVVAy84"
	set firmware_file_name=Firmware 14.1.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.2" (
	set expected_md5=36808cdb78b5986d02817e6667dfe15b
	set "firmware_link=https://mega.nz/file/gJhWCTQS#Icf6wBAAS30mEZHnvCxTy_tWizbQI2KDcvPVUmpeXyM"
	set firmware_file_name=Firmware 14.1.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="15.0.0" (
	set expected_md5=a7023429f85fdd3a40b4661188f5b65a
	set "firmware_link=https://mega.nz/file/tV5TRIiS#4poFRNnZOwpKsNd-3vvxlYRr1VX0sx-pcTL--agBG4Y"
	set firmware_file_name=Firmware 15.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="15.0.1" (
	set expected_md5=4fe164705b2392592553586f7cf9d03e
	set "firmware_link=https://mega.nz/file/Id5jyRTB#PulAyz8IcSyiR-s6KYb-TwG719YxmxpzvO4utrEMaIs"
	set firmware_file_name=Firmware 15.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.0" (
	set expected_md5=9feda64cab86f851f1630979ae33a6d5
	set "firmware_link=https://mega.nz/file/IB5SyYYJ#ZES4plxEGqLzsN2sX8spGF0KGhqcNWvh6VxY2WQIlIQ"
	set firmware_file_name=Firmware 16.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.1" (
	set expected_md5=cb287286188dc3072352af2bb4830911
	set "firmware_link=https://mega.nz/file/dJh1HBTB#X8FWDuwRCQ4xjDufZI1kPNPVWD2CkAzCTVT_w4LN3pc"
	set firmware_file_name=Firmware 16.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.2" (
	set expected_md5=462c6a0d29daa4170c37ad1b95899bd5
	set "firmware_link=https://mega.nz/file/8MZG2AyR#hXH02mA8mKo_AFaWuvA9UsrV9eX_-B7tSpvbJH3GQXI"
	set firmware_file_name=Firmware 16.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.3" (
	set expected_md5=61e55a44e15f33bc79a80388fa82dd8a
	set "firmware_link=https://mega.nz/file/oYQ2EDoa#1A5AfY0X0Mu0J0zSgW7IlSvzOtVqEmhY59OMVsmUmMk"
	set firmware_file_name=Firmware 16.0.3.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="16.1.0" (
	set expected_md5=c32db52758a4bf6503869db531012e3d
	set "firmware_link=https://mega.nz/file/cFp00ZIR#RCIfq1kIImtQDe8gQz_SkIYBevogzgqeMR-EW1C39Ao"
	set firmware_file_name=Firmware 16.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="17.0.0" (
	set expected_md5=7b6e528486a013b035d9fbb4bd32b15e
	set "firmware_link=https://mega.nz/file/wF5FyApS#eynADdOcXZl8j7unJ8nZXeo3B1GOMzmkoYI75Xif5c8"
	set firmware_file_name=Firmware 17.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="17.0.1" (
	set expected_md5=5a56b448fcdf173aa0785ee95c3bbdad
	set "firmware_link=https://mega.nz/file/hIBGSSDC#6ZBcu7koa3B3hFyeyj1AQRShp3RTQxUOt-nEmZ21oy8"
	set firmware_file_name=Firmware 17.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="18.0.0" (
	set expected_md5=8dbacdbaa4e90be98ed0706f7e90a241
	set "firmware_link=https://mega.nz/file/tFBCBI6B#Hi0mZFb4tP5VRsAJKjKaM24FDlZFUCw9EsqCoclJZBo"
	set firmware_file_name=Firmware 18.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="18.0.1" (
	set expected_md5=70b1e47e6148974e6f35ccb32042d80e
	set "firmware_link=https://mega.nz/file/RBhzQB5R#5p1t8nhLCDrTgAUg0Eh3sHHTDNhwUaX5jVLbaQGTbTE"
	set firmware_file_name=Firmware 18.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="18.1.0" (
	set expected_md5=f8e8a3eea993de6ae4c5ef2f9152d6f7
	set "firmware_link=https://mega.nz/file/Kdx1XRga#H_wenPp371UR4ujfb5Azus72hEdVFoI0i9kgal-ROpA"
	set firmware_file_name=Firmware 18.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="19.0.0" (
	set expected_md5=72d6c73306c7f0b76723f989e7e1bdd1
	set "firmware_link=https://mega.nz/file/SQxB1S4C#sxtiWU4tAUJoifn15Yf93QwDVruUkBvP6SIjQtt7Qg8"
	set firmware_file_name=Firmware 19.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="19.0.1" (
	set expected_md5=ec19f786c1653da36eb59256958a0d00
	set "firmware_link=https://mega.nz/file/3dQExTrC#sB4yOLZpKmGfkVbGdSm0P2tJsCetGbSgmdOwuaILTkA"
	set firmware_file_name=Firmware 19.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.0.0" (
	set expected_md5=674d839e3022d70e75800c822c8e8466
	set "firmware_link=https://mega.nz/file/vRFkjBIY#V_yRlRgA489k_vP68uAUjiZbN5HYmAMF05o40-qoYcg"
	set firmware_file_name=Firmware 20.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.0.1" (
	set expected_md5=552422f6fcb135b47a1250c48ae5a2d7
	set "firmware_link=https://mega.nz/file/TFlj2YRS#6ttxsEZCt0ausr8QpbHShqwVe5EepeDwQ-KMHUDQByQ"
	set firmware_file_name=Firmware 20.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.1.0" (
	set expected_md5=4d1c20eb807813c6838fc0732cb6452e
	set "firmware_link=https://mega.nz/file/uBcFSS5A#IcMVzD-dmNQVtjaDaBQCuWZC__JgJvIJJ2QwDKnGnvM"
	set firmware_file_name=Firmware 20.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.1.1" (
	set expected_md5=1727c9e364ed61e6397564804bce10d5
	set "firmware_link=https://mega.nz/file/yMdjBIYT#6aE1Zf-jB8OFlia-FSrZv5cvk7SZzPzi_uqTYOcUG6I"
	set firmware_file_name=Firmware 20.1.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.1.5" (
	set expected_md5=15ee8529617fd186b147ade3ec24d4e0
	set "firmware_link=https://mega.nz/file/bdo1CCrJ#99rpZEpGMfx33xBOydknTcftUlhG8yIS4VapgLamKfc"
	set firmware_file_name=Firmware 20.1.5.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.2.0" (
	set expected_md5=ec2b100c2c77766e61b9ceebd2efad6e
	set "firmware_link=https://mega.nz/file/qE52wCCJ#z5BikdY72Zw3xl8uXvQEfr_efO_LK7-h6bKtN89sojE"
	set firmware_file_name=Firmware 20.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="20.3.0" (
	set expected_md5=1904f1a696694e0ae25a035ed5912050
	set "firmware_link=https://mega.nz/file/GUxVwDbT#UDz659kze0ZJMafw01ZaLBK-xHzHX0HWOZYUjYfH3oY"
	set firmware_file_name=Firmware 20.3.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
goto:endscript2

:download_firmware
set md5_try=0
IF EXIST "downloads\firmwares\%firmware_file_name%" goto:verif_md5sum
:downloading_firmware
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	call "%associed_language_script%" "firmware_downloading_begin"
Setlocal disabledelayedexpansion
echo %firmware_link% | TOOLS\gnuwin32\bin\grep.exe -c "mega.nz/" >templogs\tempvar.txt
set /p mega_link_verif=<templogs\tempvar.txt
IF "%mega_link_verif%"=="0" (
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "templogs\temp.zip" "%firmware_link%"
) else (
	IF EXIST "templogs\temp.zip" del /q "templogs\temp.zip" >nul
	TOOLS\megatools\megatools.exe dl --path="templogs\temp.zip" "%firmware_link%"
)
endlocal
	TOOLS\gnuwin32\bin\md5sum.exe templogs\temp.zip | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
		set /p md5_verif=<templogs\tempvar.txt
)
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	IF NOT "%md5_verif%"=="%expected_md5%" (
		IF %md5_try% EQU 3 (
			call "%associed_language_script%" "firmware_downloading_md5_error"
			goto:endscript
		) else (
			call "%associed_language_script%" "firmware_downloading_md5_retry"
			set /a md5_try+=1
			goto:downloading_firmware
		)
	)
)
set md5_try=0
move "templogs\temp.zip" "downloads\firmwares\%firmware_file_name%" >nul
goto:skip_verif_md5sum
:verif_md5sum
TOOLS\gnuwin32\bin\md5sum.exe "downloads\firmwares\%firmware_file_name%" | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
set /p md5_verif=<templogs\tempvar.txt
IF NOT "%md5_verif%"=="%expected_md5%" (
	set md5_verif=
	call "%associed_language_script%" "firmware_exist_but_bad_md5_tested_error"
	del /q "downloads\firmwares\%firmware_file_name%" >nul
	goto:downloading_firmware
)
:skip_verif_md5sum
call "%associed_language_script%" "firmware_downloading_end"

call "%associed_language_script%" "extract_firmware_begin"
TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\firmwares\%firmware_file_name%" -o"firmware_temp" -r
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "extract_error"
	goto:endscript
)
if "%method_creation_firmware_unbrick_choice%"=="1" (
	if exist "%volume_letter%:\FW_%firmware_choice%" rmdir /s /q "%volume_letter%:\FW_%firmware_choice%"
	%windir%\System32\Robocopy.exe firmware_temp %volume_letter%:\FW_%firmware_choice% /e >nul
	call :daybreak_convert "%volume_letter%:\FW_%firmware_choice%"
)
:skip_optional_firmware_download
if "%method_creation_firmware_unbrick_choice%"=="1" (
	IF EXIST "downloads\ChoiDuJour_package_5.1.0.zip" goto:copy_all_to_sd
	IF NOT "%firmware_choice%"=="5.1.0" (
		rmdir /s /q firmware_temp
		mkdir firmware_temp
		TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\firmwares\Firmware 5.1.0.zip" -o"firmware_temp" -r
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "extract_error"
			goto:endscript
		)
	)
	set fspatches=--fspatches=nocmac,nogc
)
IF EXIST "update_packages" (
	del /q "update_packages" 2>nul
	rmdir /s /q "update_packages" 2>nul
)
mkdir "update_packages"
cd "update_packages"
if "%method_creation_firmware_unbrick_choice%"=="1" (
	"..\tools\Hactool_based_programs\tools\ChoiDujour.exe" --keyset="..\tools\Hactool_based_programs\ChoiDuJour_keys.txt" %fspatches% "..\firmware_temp"
	IF !errorlevel! EQU 0 (
		..\tools\7zip\7za.exe a -y -tzip -sccUTF-8 "..\downloads\ChoiDuJour_package_5.1.0".zip "..\update_packages" -r
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "create_choidujour_package_backup_warning"
			IF EXIST "..\downloads\ChoiDuJour_package_5.1.0.zip" del /q "..\downloads\ChoiDuJour_package_5.1.0.zip" >nul
			pause
		)
		call "%associed_language_script%" "package_creation_success"
	) else (
		call "%associed_language_script%" "package_creation_error"
		cd ..
		rmdir /s /q "firmware_temp"
		rmdir /s /q "update_packages"
		goto:endscript
	)
	cd ..
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	IF /i NOT "%mariko_console%"=="O" (
		IF /i NOT "%patched_console%"=="O" (
			set autorcm=
			call "%associed_language_script%" "autorcm_param_choice"
			IF !errorlevel! EQU 2 set autorcm=--no-autorcm
		) else (
			set autorcm=--no-autorcm
			
		)
	)
	goto:skip_old_emmchacgen_file_copy
	:old_emmchacgen_file_copy
	copy /v "..\tools\EmmcHaccGen_old\save.stub.v4" save.stub.v4 >nul
	copy /v "..\tools\EmmcHaccGen_old\save.stub.v5" save.stub.v5 >nul
	IF /i NOT "%mariko_console%"=="O" (
		"..\tools\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" !autorcm! --fw "..\firmware_temp"
	) else (
		"..\tools\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" --mariko --no-autorcm --fw "..\firmware_temp"
	)
	:skip_old_emmchacgen_file_copy
	set winget_use=n
	winget -v >nul 2>&1
	IF %errorlevel% EQU 0 (
		"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
		IF !errorlevel! EQU 0 (
			set winget_use=Y
		)
	)
	IF /i NOT "%mariko_console%"=="O" (
		"..\tools\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" !autorcm! --fw "..\firmware_temp"
	) else (
		"..\tools\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" --mariko --no-autorcm --fw "..\firmware_temp"
	)
	IF %errorlevel% EQU 0 (
		call "%associed_language_script%" "package_creation_success"
		goto:skip_old_emmchacgen_process
	) else (
		call "%associed_language_script%" "emmchaccgen_package_creation_first_error"
		if !errorlevel! EQU 1 (
			if "%winget_use%"=="Y" (
				winget install Microsoft.DotNet.DesktopRuntime.7
			) else (
				if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
					"..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x64.exe" /passive
				) else (
					"..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x86.exe" /passive
				)
			)
			IF !errorlevel! NEQ 0 (
				call "%associed_language_script%" "netfx7_install_error"
				cd ..
				rmdir /s /q "firmware_temp"
				rmdir /s /q "update_packages"
				goto:endscript
			) else (
				if "%winget_use%"=="Y" (
					winget install Microsoft.DotNet.AspNetCore.7
				) else (
					if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
						"..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x64.exe" /passive
					) else (
						"..\EmmcHaccGen\windowsdesktop-runtime-7.0.14-win-x86.exe" /passive
					)
				)
				IF !errorlevel! NEQ 0 (
					call "%associed_language_script%" "netfx7_install_error"
					cd ..
					rmdir /s /q "firmware_temp"
					rmdir /s /q "update_packages"
					goto:endscript
				)
			)
			IF /i NOT "%mariko_console%"=="O" (
				"..\tools\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" !autorcm! --fw "..\firmware_temp"
			) else (
				"..\tools\EmmcHaccGen\EmmcHaccGen.exe" --keys "%keys_file_path%" --mariko --no-autorcm --fw "..\firmware_temp"
			)
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "package_creation_success"
				goto:skip_old_emmchacgen_process
			) else (
				call "%associed_language_script%" "emmchaccgen_package_creation_second_error"
				cd ..
				rmdir /s /q "firmware_temp"
				rmdir /s /q "update_packages"
				goto:endscript
			)
		) else (
			cd ..
			rmdir /s /q "firmware_temp"
			rmdir /s /q "update_packages"
			goto:endscript2
		)
	)
	:old_emmchacgen_process
	IF !errorlevel! EQU 0 (
		call "%associed_language_script%" "package_creation_success"
	) else (
		call "%associed_language_script%" "emmchaccgen_package_creation_first_error"
		if !errorlevel! EQU 1 (
			::Dism /online /NoRestart /Enable-Feature /FeatureName:"NetFx3"
			IF /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
				"..\tools\EmmcHaccGen_old\dotnet-runtime-3.1.12-win-x64.exe" /install /passive
			) else (
				"..\tools\EmmcHaccGen_old\dotnet-runtime-3.1.12-win-x86.exe" /install /passive
			)
			if !error_level! NEQ 0 (
				call "%associed_language_script%" "netfx3_install_error"
				cd ..
				rmdir /s /q "firmware_temp"
				rmdir /s /q "update_packages"
				goto:endscript
			) else (
				IF /i NOT "%mariko_console%"=="O" (
					"..\tools\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" !autorcm! --fw "..\firmware_temp"
				) else (
					"..\tools\EmmcHaccGen_old\EmmcHaccGen.exe" --keys "%keys_file_path%" --fw "..\firmware_temp" --mariko --no-autorcm
				)
				IF !errorlevel! EQU 0 (
					call "%associed_language_script%" "package_creation_success"
				) else (
					call "%associed_language_script%" "emmchaccgen_package_creation_second_error"
					cd ..
					rmdir /s /q "firmware_temp"
					rmdir /s /q "update_packages"
					goto:endscript
				)
			)
		) else (
			cd ..
			rmdir /s /q "firmware_temp"
			rmdir /s /q "update_packages"
			goto:endscript2
		)
	)
	del /q save.stub.v4 >nul
	del /q save.stub.v5 >nul
	:skip_old_emmchacgen_process
	cd ..
	dir /A:D /B update_packages >templogs\tempvar.txt
	set /p emmchaccgen_firmware_folder=<templogs\tempvar.txt
)
:copy_all_to_sd
rmdir /s /q firmware_temp
echo.
IF /i "%mariko_console%"=="O" goto:pass_boot0_creation
call "%associed_language_script%" "boot0_keyblobs_reparation_choice"
IF %errorlevel% EQU 3 goto:endscript2
IF %errorlevel% EQU 2 (
	if "%method_creation_firmware_unbrick_choice%"=="1" (
		copy "update_packages\NX-5.1.0_exfat\BOOT0.bin" "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak" >nul
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "boot0_keyblobs_reparation_error"
			pause
		) else (
			"tools\python3_scripts\boot0_rewrite\boot0_rewrite.exe" -i "update_packages\NX-5.1.0_exfat\BOOT0.bin" -o "update_packages\NX-5.1.0_exfat\BOOT0.bin" -k "%keys_file_path%" >nul
			IF !errorlevel! NEQ 0 (
				call "%associed_language_script%" "boot0_keyblobs_reparation_first_error"
				if !errorlevel! EQU 2 (
				IF EXIST "update_packages\NX-5.1.0_exfat\BOOT0.bin" del /q "update_packages\NX-5.1.0_exfat\BOOT0.bin" >nul
					rename "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				)
				set /p common_prod_keys_file=<templogs\tempvar.txt
				if "!common_prod_keys_file!"=="" (
					rename "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				)
				"tools\python3_scripts\boot0_rewrite\boot0_rewrite.exe" -i "update_packages\NX-5.1.0_exfat\BOOT0.bin" -o "update_packages\NX-5.1.0_exfat\BOOT0.bin" -k "%keys_file_path%" -c "!common_prod_keys_file!" >nul
				IF !errorlevel! NEQ 0 (
					IF EXIST "update_packages\NX-5.1.0_exfat\BOOT0.bin" del /q "update_packages\NX-5.1.0_exfat\BOOT0.bin" >nul
					rename "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				) else (
					del /q "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak"
					call "%associed_language_script%" "boot0_keyblobs_reparation_success"
					pause
					goto:pass_boot0_creation
				)
			) else (
				del /q "update_packages\NX-5.1.0_exfat\BOOT0.bin.bak"
				call "%associed_language_script%" "boot0_keyblobs_reparation_success"
				pause
				goto:pass_boot0_creation
			)
		)
	) else if "%method_creation_firmware_unbrick_choice%"=="2" (
		copy "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak" >nul
		IF !errorlevel! NEQ 0 (
			call "%associed_language_script%" "boot0_keyblobs_reparation_error"
			pause
		) else (
			"tools\python3_scripts\boot0_rewrite\boot0_rewrite.exe" -i "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" -o "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" -k "%keys_file_path%" >nul
			IF !errorlevel! NEQ 0 (
				call "%associed_language_script%" "boot0_keyblobs_reparation_first_error"
				if !errorlevel! EQU 2 (
					rename "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				)
				set /p common_prod_keys_file=<templogs\tempvar.txt
				if "!common_prod_keys_file!"=="" (
					rename "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				)
				"tools\python3_scripts\boot0_rewrite\boot0_rewrite.exe" -i "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" -o "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" -k "%keys_file_path%" -c "!common_prod_keys_file!" >nul
				IF !errorlevel! NEQ 0 (
					IF EXIST "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" del /q "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin" >nul
					rename "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak" "BOOT0.bin" >nul
					call "%associed_language_script%" "boot0_keyblobs_reparation_error"
					pause
					goto:pass_boot0_creation
				) else (
					del /q "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak"
					call "%associed_language_script%" "boot0_keyblobs_reparation_success"
					pause
					goto:pass_boot0_creation
				)
			) else (
				del /q "update_packages\%emmchaccgen_firmware_folder%\BOOT0.bin.bak"
				call "%associed_language_script%" "boot0_keyblobs_reparation_success"
				pause
				goto:pass_boot0_creation
			)
		)
	)
)
:pass_boot0_creation
call "%associed_language_script%" "copy_begin_info"
IF EXIST "%volume_letter%:\cdj_package_files" rmdir /s /q "%volume_letter%:\cdj_package_files"
mkdir "%volume_letter%:\cdj_package_files"
IF !errorlevel! NEQ 0 (
	call "%associed_language_script%" "copy_to_sd_error"
	goto:endscript
)
mkdir "%volume_letter%:\cdj_package_files\SYSTEM"
IF !errorlevel! NEQ 0 (
	call "%associed_language_script%" "copy_to_sd_error"
	goto:endscript
)
IF EXIST "%volume_letter%:\bootloader\patches.ini" rename "%volume_letter%:\bootloader\patches.ini" "patches.ini.bak" >nul
%windir%\System32\Robocopy.exe tools\unbrick_special_SD_files %volume_letter%:\ /e >nul
IF EXIST "%volume_letter%:\bootloader\patches.ini.bak" (
	del /q "%volume_letter%:\bootloader\patches.ini" >nul
	rename "%volume_letter%:\bootloader\patches.ini.bak" "patches.ini" >nul
)
if "%method_creation_firmware_unbrick_choice%"=="1" (
	%windir%\System32\Robocopy.exe update_packages\NX-5.1.0_exfat\SYSTEM %volume_letter%:\cdj_package_files\SYSTEM /e >nul
	copy "update_packages\NX-5.1.0_exfat\*.bin" "%volume_letter%:\cdj_package_files" >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copy_to_sd_error"
		goto:endscript
	)
	copy "update_packages\NX-5.1.0_exfat\microSD\FS510-exfat_nocmac_nogc.kip1" "%volume_letter%:\cdj_package_files\FS510-exfat_nocmac_nogc.kip1" >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copy_to_sd_error"
		goto:endscript
	)
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	%windir%\System32\Robocopy.exe "update_packages\!emmchaccgen_firmware_folder!\SYSTEM " %volume_letter%:\cdj_package_files\SYSTEM /e >nul
	copy "update_packages\!emmchaccgen_firmware_folder!\*.bin" "%volume_letter%:\cdj_package_files" >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copy_to_sd_error"
		goto:endscript
	)
)
IF NOT EXIST "%volume_letter%:\tegraexplorer" mkdir "%volume_letter%:\tegraexplorer"
IF NOT EXIST "%volume_letter%:\tegraexplorer\scripts" mkdir "%volume_letter%:\tegraexplorer\scripts"
copy "%language_path%\tegra_scripts\cdj_restore_firmware_TE4.te" "%volume_letter%:\tegraexplorer\scripts\cdj_restore_firmware.te" >nul
IF !errorlevel! NEQ 0 (
	call "%associed_language_script%" "copy_to_sd_error"
	goto:endscript
)
IF EXIST "%volume_letter%:\atmosphere\contents\010000000000000D\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\010000000000000D"
IF EXIST "%volume_letter%:\atmosphere\contents\010000000000002B\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\010000000000002B"
IF EXIST "%volume_letter%:\atmosphere\contents\010000000000003C\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\010000000000003C"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000008\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000008"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000032\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000032"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000034\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000034"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000036\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000036"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000037\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000037"
IF EXIST "%volume_letter%:\atmosphere\contents\0100000000000042\*.*" rmdir /s /q "%volume_letter%:\atmosphere\contents\0100000000000042"
IF EXIST "%volume_letter%:\sept\payload.bin" del /q "%volume_letter%:\sept\payload.bin" >nul
IF EXIST "%volume_letter%:\atmosphere\fusee-mtc.bin" del /q "%volume_letter%:\atmosphere\fusee-mtc.bin" >nul
IF EXIST "%volume_letter%:\atmosphere\kip_patches\default_nogc\*.*" rmdir /s /q "%volume_letter%:\atmosphere\kip_patches\default_nogc" >nul
IF EXIST "%volume_letter%:\atmosphere\config\BCT.ini" del /q "%volume_letter%:\atmosphere\config\BCT.ini" >nul
IF EXIST "%volume_letter%:\atmosphere\config_templates\BCT.ini" del /q "%volume_letter%:\atmosphere\config_templates\BCT.ini" >nul
IF EXIST "%volume_letter%:\atmosphere\fusee-secondary.bin" del /q "%volume_letter%:\atmosphere\fusee-secondary.bin" >nul
IF EXIST "%volume_letter%:\atmosphere\flags\clean_stratosphere_for_0.19.0.flag" del /q "%volume_letter%:\atmosphere\flags\clean_stratosphere_for_0.19.0.flag" >nul
del /Q /S "%volume_letter%:\Atmosphere_fusee-primary.bin" >nul 2>&1
del /Q /S "%volume_letter%:\atmosphere\.emptydir" >nul
del /Q /S "%volume_letter%:\bootloader\.emptydir" >nul
del /q "%volume_letter%:\folder_version.txt" >nul
IF /i "%mariko_console%"=="O" (
	rmdir /s /q "%volume_letter%:\payloads" >nul
	rmdir /s /q "%volume_letter%:\switch\ChoiDuJourNX" >nul
	rmdir /s /q "%volume_letter%:\switch\Payload_Launcher" >nul
)
echo.
set restore_method=
IF /i "%patched_console%"=="O" (
	set restore_method=1
	goto:end_copy_to_sd
)
call "%associed_language_script%" "restore_method_choice"
IF %errorlevel% equ 1 (
	set restore_method=1
	goto:end_copy_to_sd
)
IF %errorlevel% equ 2 (
	set restore_method=2
	goto:end_copy_to_sd
)
goto:endscript2
:end_copy_to_sd
call "%associed_language_script%" "copying_end"

:launch_tegraexplorer
echo.
call "%associed_language_script%" "tegraexplorer_launch_begin"
IF /i NOT "%patched_console%"=="O" tools\TegraRcmSmash\TegraRcmSmash.exe -w "tools\payloads\TegraExplorer.bin"
IF /i NOT "%patched_console%"=="O" call "%associed_language_script%" "tegraexplorer_launch_correctly_question"
IF /i NOT "%patched_console%"=="O" (
	IF %errorlevel% EQU 2 goto:launch_tegraexplorer
)
call "%associed_language_script%" "tegraexplorer_launch_end"
pause
IF NOT "%restore_method%"=="2" goto:launch_hekate
:hacdiskmount_step
echo.
call "%associed_language_script%" "memloader_launch_begin"
IF /i NOT "%patched_console%"=="O" tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\memloader\memloader_usb.bin --dataini="tools\memloader\mount_discs\ums_emmc.ini"
IF /i NOT "%patched_console%"=="O" call "%associed_language_script%" "memloader_launch_correctly_question"
IF /i NOT "%patched_console%"=="O" (
	IF %errorlevel% EQU 2 goto:hacdiskmount_step
)
call "%associed_language_script%" "memloader_launch_end"
pause
start tools\HacDiskMount\HacDiskMount.exe
if "%method_creation_firmware_unbrick_choice%"=="1" (
	start explorer.exe "update_packages\NX-5.1.0_exfat"
) else if "%method_creation_firmware_unbrick_choice%"=="2" (
	start explorer.exe "update_packages\%emmchaccgen_firmware_folder%"
)
:launch_hekate
echo.
IF /i NOT "%patched_console%"=="O" call "%associed_language_script%" "hekate_launch_begin"
IF /i NOT "%patched_console%"=="O" (
	IF %errorlevel% EQU 2 goto:launch_hekate_end
)
:hekate_after_first_launch
IF /i NOT "%patched_console%"=="O" call "%associed_language_script%" "hekate_rcm_instruction"
IF /i NOT "%patched_console%"=="O" tools\TegraRcmSmash\TegraRcmSmash.exe -w "tools\payloads\hekate.bin"
:launch_hekate_end
IF /i NOT "%patched_console%"=="O" call "%associed_language_script%" "hekate_launch_end"
IF /i NOT "%patched_console%"=="O" (
	IF %errorlevel% EQU 1 goto:hekate_after_first_launch
)
call "%associed_language_script%" "script_end_message"
goto:endscript

:daybreak_convert
IF NOT EXIST "tools\Hactool_based_programs\keys.txt" (
	call "%associed_language_script%" "daybreak_keys_file_select_passed"
	IF NOT "!temp_choice!"=="" set temp_choice=!temp_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "temp_choice" "o/n_choice"
	IF /i "!temp_choice!"=="O" (
		call :daybreak_convert_2 "%~1"
	)
	exit /b
)
call "%associed_language_script%" "daybreak_convert_begin"
rem set /a count_loop = 0
for /d %%f in ("%~1\*.nca") do (
	move "%%f" "%%f.bak" >nul
	move "%%f.bak\00" "%%f" >nul
	rmdir "%%f.bak"
)
for %%f in ("%~1\*.nca") do (
	IF NOT EXIST "%%f\*.*" (
		set temp_file_name=%%f
		IF NOT "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			rem tools\Hactool_based_programs\tools\hactool.exe -k "%keys_file_path%" -i "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\Hactool_based_programs\hactoolnet.exe -k "tools\Hactool_based_programs\keys.txt" "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\gnuwin32\bin\grep.exe -c -i "ERROR: Unable to decrypt NCA section." <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
				call "%associed_language_script%" "daybreak_convert_keys_warning"
				IF NOT "!temp_choice!"=="" set temp_choice=!temp_choice:~0,1!
				call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "temp_choice" "o/n_choice"
				IF /i "!temp_choice!"=="O" (
					call :daybreak_convert_2 "%~1"
				)
				exit /b
			)
			rem pause
			rem notepad "templogs\temptest.txt"
			tools\gnuwin32\bin\grep.exe -c -i -e "Content Type: *Meta" <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
			rem echo Meta trouvé.
			move "!temp_file_name!" "!temp_file_name:~0,-3!cnmt.nca" >nul
			)
		) else IF "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			rem tools\Hactool_based_programs\tools\hactool.exe -k "tools\Hactool_based_programs\keys.txt" -i "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\Hactool_based_programs\hactoolnet.exe -k "tools\Hactool_based_programs\keys.txt" "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\gnuwin32\bin\grep.exe -c -i "ERROR: Unable to decrypt NCA section." <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF NOT "!temp_count!"=="0" (
				call "%associed_language_script%" "daybreak_convert_keys_warning"
				IF NOT "!temp_choice!"=="" set temp_choice=!temp_choice:~0,1!
				call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "temp_choice" "o/n_choice"
				IF /i "!temp_choice!"=="O" (
					call :daybreak_convert_2 "%~1"
				)
				exit /b
			)
			rem pause
			rem notepad "templogs\temptest.txt"
			tools\gnuwin32\bin\grep.exe -c -i -e "Content Type: *Meta" <"templogs\temptest.txt" >templogs\tempvar.txt
			set /p temp_count=<templogs\tempvar.txt
			IF "!temp_count!"=="0" (
			rem echo NCA mal nommé.
			move "!temp_file_name!" "!temp_file_name:~0,-8!nca" >nul
			)
		)
	)
)
rem echo %count_loop%
exit /b

:daybreak_convert_2
rem set /a count_loop = 0
for /d %%f in ("%~1\*.nca") do (
	move "%%f" "%%f.bak" >nul
	move "%%f.bak\00" "%%f" >nul
	rmdir "%%f.bak"
)
for %%f in ("%~1\*.nca") do (
	set temp_file_size=%%~zf
	IF NOT EXIST "%%f\*.*" (
		set temp_file_name=%%f
		IF NOT "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			IF !temp_file_size! LEQ 8192 (
				rem echo Meta trouvé.
				move "!temp_file_name!" "!temp_file_name:~0,-3!cnmt.nca" >nul
			)
		) else IF "!temp_file_name:~-9,9!"==".cnmt.nca" (
			rem set /a count_loop = !count_loop!+1
			IF NOT !temp_file_size! LEQ 8192 (
				rem echo %%f
				rem echo NCA mal nommé.
				move "!temp_file_name!" "!temp_file_name:~0,-8!nca" >nul
			)
		)
	)
)
rem echo %count_loop%
exit /b

:endscript
pause
:endscript2
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp"
IF EXIST "update_packages" rmdir /s /q "update_packages"
rmdir /s /q templogs
endlocal