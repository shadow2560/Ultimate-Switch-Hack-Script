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
IF NOT EXIST templogs (
	mkdir templogs
) else (
	rmdir /s /q templogs
	mkdir templogs
)
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
call "%associed_language_script%" "display_title"
"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	goto:end_script
)
set md5_try=0
IF "%~1" == "unbrick_package_creation" set special_launch=unbrick_package_creation
IF "%~1"=="firmware_create_cdj" (
	set action_param=firmware_download
	set action_type=2
)
IF "%~1"=="firmware_create_ehg" (
	set action_param=firmware_download
	set action_type=6
)
IF "%~1"=="firmware_download_and_extract" (
	set action_param=firmware_download_and_extract
	set action_type=6
)
IF "%~3"=="no_dir_choice" set no_dir_choice=Y
IF "%action_param%"=="firmware_download" goto:define_firmware_choice
IF "%action_param%"=="firmware_download_and_extract" goto:define_firmware_choice
call "%associed_language_script%" "intro"
pause 
:define_action_type
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
cls
set action_type=
call "%associed_language_script%" "action_choice"
IF NOT "%action_type%"=="" set action_type=%action_type:~0,1%
IF "%special_launch%" == "unbrick_package_creation" (
	IF "%action_type%"=="1" (
		set action_type=2
		cls
		goto:define_firmware_choice
	)
	IF "%action_type%"=="2" (
		set action_type=6
		cls
		goto:define_firmware_choice
	)
) else (
	IF "%action_type%"=="4" (
		cls
		IF EXIST "tools\Storage\prepare_sd_switch.bat" (
			call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat"
		) else (
			call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat" "force"
		)
		call tools\storage\prepare_sd_switch.bat
		call "%associed_language_script%" "display_title"
		@echo off
		goto:define_action_type
	)
	IF "%action_type%"=="1" cls & goto:define_firmware_choice
	IF "%action_type%"=="2" cls & goto:define_firmware_choice
	IF "%action_type%"=="3" cls & goto:define_firmware_choice
	IF "%action_type%"=="5" cls & goto:define_firmware_choice
	IF "%action_type%"=="6" cls & goto:define_firmware_choice
)
goto:end_script_2
:define_firmware_choice
set firmware_choice=
call "%associed_language_script%" "firmware_choice_begin"
echo 1.0.0?
echo 2.0.0?
echo 2.1.0?
echo 2.2.0?
echo 2.3.0?
echo 3.0.0?
echo 3.0.1?
echo 3.0.2?
echo 4.0.0?
echo 4.0.1?
echo 4.1.0?
echo 5.0.0?
echo 5.0.1?
echo 5.0.2?
echo 5.1.0?
echo 6.0.0?
echo 6.0.1?
echo 6.1.0?
echo 6.2.0?
echo 7.0.0?
echo 7.0.1?
echo 8.0.0?
echo 8.0.1?
echo 8.1.0?
echo 8.1.1?
echo 9.0.0?
echo 9.0.1?
echo 9.1.0?
echo 9.2.0?
echo 10.0.0?
echo 10.0.1?
echo 10.0.2?
echo 10.0.3?
echo 10.0.4?
echo 10.1.0?
echo 10.2.0?
echo 11.0.0?
echo 11.0.1?
echo 12.0.0?
echo 12.0.1?
echo 12.0.2?
echo 12.0.3?
echo 12.1.0?
echo 13.0.0?
echo 13.1.0?
echo 13.2.0?
echo 13.2.1?
echo 14.0.0?
echo 14.1.0?
echo 14.1.1?
echo 14.1.2?
echo 15.0.0?
echo 15.0.1?
echo 16.0.0?
echo 16.0.1?
echo 16.0.2?
echo 16.0.3?
echo 16.1.0?
echo 17.0.0?
echo 17.0.1?
echo 18.0.0?
echo 18.0.1?
echo 18.1.0?
echo.
call "%associed_language_script%" "firmware_choice_end"
IF NOT "%no_dir_choice%"=="Y" (
	IF /i "%firmware_choice%"=="C" (
		call :firmware_folder_choice
		IF %errorlevel% NEQ 0 (
			goto:define_firmware_choice
		)
		goto:end_extract
	)
)
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
)
mkdir firmware_temp
IF NOT EXIST "downloads" mkdir "downloads"
IF NOT EXIST "downloads\firmwares" mkdir "downloads\firmwares"
IF /i "%firmware_choice%"=="F" (
	start explorer.exe "%~dp0..\..\downloads\firmwares"
	goto:define_firmware_choice
)

echo %firmware_choice%>templogs\firmware_chosen.txt
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
	set "firmware_link=https://mega.nz/#^!8BplGRQA^!z_2pCeh-8XV2Pf3E_38UfGhDPRSdN3nixb5s5-Q785w"
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
	set "firmware_link=https://mega.nz/file/wAJQWYqa#X1LYmiJ7HrLyTo97lKuw8wzs6h2M_Ks-Jxf9NUXnFTw"
	set firmware_file_name=Firmware 6.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.2.0" (
	set expected_md5=30e4a67c2943465c5441f203bd169ba8
	set "firmware_link=https://mega.nz/file/AUZ20CjD#6qWImbigauDPA8hYNt6F_Uv82uvDKsOVuNZudx551Es"
	set firmware_file_name=Firmware 6.2.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.0" (
	set expected_md5=7faf4c721a96767f11ddf83d1ea06b4a
	set "firmware_link=https://mega.nz/file/5BQmhADI#GGx9xvwrF9Ayn4u_UvpIR2GbRCHAA-_6V8tG5rci0XE"
	set firmware_file_name=Firmware 7.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.1" (
	set expected_md5=589ab86da5f6028a7f3d39e85e043d4a
	set "firmware_link=https://mega.nz/file/NNRQHKyB#NGCWLzso_10m9qdZu81-utveT9QXQ3dfQZYfxy42uBc"
	set firmware_file_name=Firmware 7.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.0" (
	set expected_md5=e1641978fc281f3ce6b033398ae520dd
	set "firmware_link=https://mega.nz/file/pZhRxYLR#9kiA-fiyXiGQEszvHMJ1Qgi6om5-MHj_rn-48M61n9s"
	set firmware_file_name=Firmware 8.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.1" (
	set expected_md5=1bd7a32f9a2a67ffda6a245f76f06609
	set "firmware_link=https://mega.nz/file/tBphDAJT#sWxKqBScpS2lpHOz9F6FYP-mnW1ZXr_GsmXHx85vLD0"
	set firmware_file_name=Firmware 8.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.0" (
	set expected_md5=85907ab512b028d6a81a2e1b414b59b9
	set "firmware_link=https://mega.nz/file/BZh3BahL#HAprgXGPwnFLNg7zFKZoOLsxLRoP2hBd161KQojfSmA"
	set firmware_file_name=Firmware 8.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.1" (
	set expected_md5=4fc67d5be86e4880612fbca76f6d8e70
	set "firmware_link=https://mega.nz/file/8EQHWKDJ#-ABxIrFEj_1V5N4t-m-MgzSCDdV-w79jotNdNYl0nZs"
	set firmware_file_name=Firmware 8.1.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.0" (
	set expected_md5=0ec9d07322ae98fc1163674d40437305
	set "firmware_link=https://mega.nz/file/IQxhkS4I#JI8zsR6B5ZxE0vucpIf-zHXX8Bh6nVg0XtT9XHd8B7w"
	set firmware_file_name=Firmware 9.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.1" (
	set expected_md5=6c428005c384072e32dcf0bddf971817
	set "firmware_link=https://mega.nz/file/FEhVwSzJ#XmIOiLtThdg-zxXhai7PMFTRpf7S6WpH2pCgyKx-B_4"
	set firmware_file_name=Firmware 9.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.1.0" (
	set expected_md5=b0ed3ce315918e05bccbf31694d52584
	set "firmware_link=https://mega.nz/file/cAhxhQIY#We6qCI1ZYs7LzA8gAh5k_ZVNkDdSO3GlSb90GGYLwCE"
	set firmware_file_name=Firmware 9.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.2.0" (
	set expected_md5=64ffa81de3a4b7bda973036520113cda
	set "firmware_link=https://mega.nz/file/UIxHGIDT#fXNAntIt8HahMeclTXILwM5N2wrQcG1umT-pV7mfgkI"
	set firmware_file_name=Firmware 9.2.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.0" (
	set expected_md5=ca88f99be9fadc0088210ef9a4b3986a
	set "firmware_link=https://mega.nz/file/xYwVQChQ#dwwNHT_nax71wVzW8oo47Tf6eMhJVTVFxJhxtwX1hBE"
	set firmware_file_name=Firmware 10.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.1" (
	set expected_md5=ddaec6ef4674887c53b9f153eda7e9b6
	set "firmware_link=https://mega.nz/file/URwTCALJ#keo-5YxST1sBsNWEXyY4cYLEZZ57qCbK5WvHZ_7Aynw"
	set firmware_file_name=Firmware 10.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.2" (
	set expected_md5=4b795c906abf70439fe53ee4a6fc636c
	set "firmware_link=https://mega.nz/file/VFYSTSQA#NK2NeduFhA9RPBR98N55nHVYUxfEK5ZCrF4BIyYAF20"
	set firmware_file_name=Firmware 10.0.2.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.3" (
	set expected_md5=f15f82570701868246016616979147d8
	set "firmware_link=https://mega.nz/file/UYhz1SbC#ZHr9axJryu5a0QCIcMH4jgLcteDy4CnkabHwBlMmuIE"
	set firmware_file_name=Firmware 10.0.3.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.4" (
	set expected_md5=9816b980f84b1cef8a91f5ce3a697678
	set "firmware_link=https://mega.nz/file/xVwVFazC#sFkKEKkHhp2YEcqR5UQhAg_qxEPfZq8oRUalgleKVDA"
	set firmware_file_name=Firmware 10.0.4.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.1.0" (
	set expected_md5=a2ccac10398351ea0f9d3af30534297c
	set "firmware_link=https://mega.nz/file/wJpxySRI#dc8o9otnt_KHJJaeuxAdoT1nQBQyCsdlD7xO8rzkCrw"
	set firmware_file_name=Firmware 10.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.2.0" (
	set expected_md5=8c18c4e5908178f9af4d8aad183b8ca2
	set "firmware_link=https://mega.nz/file/xF5g0SIB#4fa2DF0CC6sXB2a38l0bsA9ZZojL9HXVbIQeFLVzm3c"
	set firmware_file_name=Firmware 10.2.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="11.0.0" (
	set expected_md5=7330b3c560f80caeb2fa3d831d5203f2
	set "firmware_link=https://mega.nz/file/YRZjWSqC#D2IFvaI8t0mMQMbEZRIiNH5PPR5dOUx17IkhEYqhcfM"
	set firmware_file_name=Firmware 11.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="11.0.1" (
	set expected_md5=53f68ddd2a2f4f79e98edc02ff2ad0bd
	set "firmware_link=https://mega.nz/file/sJRiXTTa#9EDwT_dBFUVmpOvQnvKrLmMsk1RiLVczcOREHkqp3fM"
	set firmware_file_name=Firmware 11.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.0" (
	set expected_md5=d297bdb5a6d0341df6cc24195f604abe
	set "firmware_link=https://mega.nz/file/pJBCBLaC#rwCiDG9-ASH8K8cZYUUsg-UxHNqcmgsqcsmlRyyWmsY"
	set firmware_file_name=Firmware 12.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.1" (
	set expected_md5=12040ddd1533cf58ff2fb690d7bec3ee
	set "firmware_link=https://mega.nz/file/9UoUTYaY#l-rfPBQXpNIQ6I4UBeNRNHJhOE5zb5a7CPA4FAF_qJM"
	set firmware_file_name=Firmware 12.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.2" (
	set expected_md5=939ec032227741b60aafacbedc4e476f
	set "firmware_link=https://mega.nz/file/5IoTzABQ#Sjzs-_kOViyu1leE44Ae_YcloSa_FmgYRvUn9cXXcfk"
	set firmware_file_name=Firmware 12.0.2.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="12.0.3" (
	set expected_md5=35cb46f7d2d609f7d056c22099d1c469
	set "firmware_link=https://mega.nz/file/4dwk0IRB#48ATk9rdx3klFC2juWzxRukTfSYWI2vBK3tblsOMZQI"
	set firmware_file_name=Firmware 12.0.3.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="12.1.0" (
	set expected_md5=6c8f353daccf73e1da7ee5dd532656f0
	set "firmware_link=https://mega.nz/file/8cpWiR4K#Ina7VLZpVbfi53-9liXSYyes93VIga2BENiFqqAYYxU"
	set firmware_file_name=Firmware 12.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="13.0.0" (
	set expected_md5=9fa654de1a4682e517a15b5a79a7895d
	set "firmware_link=https://mega.nz/file/UFpi3Yra#_UwDAU0c0OrE88oInSHUXuhnwJwhPA2Qm297pbT7KSA"
	set firmware_file_name=Firmware 13.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="13.1.0" (
	set expected_md5=ab837980ed2c83eedaecb28ebf667d9a
	set "firmware_link=https://mega.nz/file/IFx1jIAZ#JZlMks0EjumXZEZPUgQhii_MjovVOzOLaxSP3_SHx8g"
	set firmware_file_name=Firmware 13.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="13.2.0" (
	set expected_md5=f4f0a7e77d39e209d1be0ee8641c9afb
	set "firmware_link=https://mega.nz/file/VdZzXaCT#b2mX02_YfyLqFroFoTbspyswGoTXYtZAZIWMsUl6PJ4"
	set firmware_file_name=Firmware 13.2.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="13.2.1" (
	set expected_md5=881379299c1c9cd2a4b7a90c18c9ea82
	set "firmware_link=https://mega.nz/file/xYYkyT7K#I0Xr60_co04X_JWUirfVyswg0pR_XnlxeIDMK5YHEYQ"
	set firmware_file_name=Firmware 13.2.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="14.0.0" (
	set expected_md5=816010565838f30b047d0059efa8c3ea
	set "firmware_link=https://mega.nz/file/wEJi0IRQ#p1S-t8LkSUa5xjDoCc_brveXlk6JniZVcmRLCVt-x_8"
	set firmware_file_name=Firmware 14.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.0" (
	set expected_md5=778b4e7854afa1a0baa98c44988e68ac
	set "firmware_link=https://mega.nz/file/YIonGbxR#Ca49NIXk6ktJPmwaqazxDCypA_WsYmizNjFFijmxhv0"
	set firmware_file_name=Firmware 14.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.1" (
	set expected_md5=4e864e134318aa80ac06e7a676eb96d8
	set "firmware_link=https://mega.nz/file/dZwzzCKT#LzuAFUKvUQIzw-LQ6rP77EVswGNsRUH5bDQVvVVAy84"
	set firmware_file_name=Firmware 14.1.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="14.1.2" (
	set expected_md5=36808cdb78b5986d02817e6667dfe15b
	set "firmware_link=https://mega.nz/file/gJhWCTQS#Icf6wBAAS30mEZHnvCxTy_tWizbQI2KDcvPVUmpeXyM"
	set firmware_file_name=Firmware 14.1.2.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="15.0.0" (
	set expected_md5=a7023429f85fdd3a40b4661188f5b65a
	set "firmware_link=https://mega.nz/file/tV5TRIiS#4poFRNnZOwpKsNd-3vvxlYRr1VX0sx-pcTL--agBG4Y"
	set firmware_file_name=Firmware 15.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="15.0.1" (
	set expected_md5=4fe164705b2392592553586f7cf9d03e
	set "firmware_link=https://mega.nz/file/Id5jyRTB#PulAyz8IcSyiR-s6KYb-TwG719YxmxpzvO4utrEMaIs"
	set firmware_file_name=Firmware 15.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.0" (
	set expected_md5=9feda64cab86f851f1630979ae33a6d5
	set "firmware_link=https://mega.nz/file/IB5SyYYJ#ZES4plxEGqLzsN2sX8spGF0KGhqcNWvh6VxY2WQIlIQ"
	set firmware_file_name=Firmware 16.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.1" (
	set expected_md5=cb287286188dc3072352af2bb4830911
	set "firmware_link=https://mega.nz/file/dJh1HBTB#X8FWDuwRCQ4xjDufZI1kPNPVWD2CkAzCTVT_w4LN3pc"
	set firmware_file_name=Firmware 16.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.2" (
	set expected_md5=462c6a0d29daa4170c37ad1b95899bd5
	set "firmware_link=https://mega.nz/file/8MZG2AyR#hXH02mA8mKo_AFaWuvA9UsrV9eX_-B7tSpvbJH3GQXI"
	set firmware_file_name=Firmware 16.0.2.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="16.0.3" (
	set expected_md5=61e55a44e15f33bc79a80388fa82dd8a
	set "firmware_link=https://mega.nz/file/oYQ2EDoa#1A5AfY0X0Mu0J0zSgW7IlSvzOtVqEmhY59OMVsmUmMk"
	set firmware_file_name=Firmware 16.0.3.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="16.1.0" (
	set expected_md5=c32db52758a4bf6503869db531012e3d
	set "firmware_link=https://mega.nz/file/cFp00ZIR#RCIfq1kIImtQDe8gQz_SkIYBevogzgqeMR-EW1C39Ao"
	set firmware_file_name=Firmware 16.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="17.0.0" (
	set expected_md5=7b6e528486a013b035d9fbb4bd32b15e
	set "firmware_link=https://mega.nz/file/wF5FyApS#eynADdOcXZl8j7unJ8nZXeo3B1GOMzmkoYI75Xif5c8"
	set firmware_file_name=Firmware 17.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="17.0.1" (
	set expected_md5=5a56b448fcdf173aa0785ee95c3bbdad
	set "firmware_link=https://mega.nz/file/hIBGSSDC#6ZBcu7koa3B3hFyeyj1AQRShp3RTQxUOt-nEmZ21oy8"
	set firmware_file_name=Firmware 17.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="18.0.0" (
	set expected_md5=8dbacdbaa4e90be98ed0706f7e90a241
	set "firmware_link=https://mega.nz/file/tFBCBI6B#Hi0mZFb4tP5VRsAJKjKaM24FDlZFUCw9EsqCoclJZBo"
	set firmware_file_name=Firmware 18.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="18.0.1" (
	set expected_md5=f8b3c0b18f4c432d637715517f9a0889
	set "firmware_link=https://mega.nz/file/SAQwzbhL#nxW1QUQu4O1zMKdR2LidTSHPyVeHIfmTe_s_d3sSrVg"
	set firmware_file_name=Firmware 18.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="18.1.0" (
	set expected_md5=f8e8a3eea993de6ae4c5ef2f9152d6f7
	set "firmware_link=https://mega.nz/file/Kdx1XRga#H_wenPp371UR4ujfb5Azus72hEdVFoI0i9kgal-ROpA"
	set firmware_file_name=Firmware 18.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%action_param%"=="firmware_download" (
	endlocal
	exit /b 400
)
IF "%action_param%"=="firmware_download_and_extract" (
	endlocal
	exit /b 400
)
goto:define_action_type

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
			pause
			IF "%action_param%"=="firmware_download" (
				endlocal
				exit /b 400
			)
			IF "%action_param%"=="firmware_download_and_extract" (
				endlocal
				exit /b 400
			)
			goto:define_action_type
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
IF "%action_param%"=="firmware_download" goto:extract_firmware
IF "%action_param%"=="firmware_download_and_extract" goto:extract_firmware
IF "%action_type%"=="5" (
	pause
	goto:define_action_type
)
:extract_firmware
call "%associed_language_script%" "extract_firmware_begin"
TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\firmwares\%firmware_file_name%" -o"firmware_temp" -r
:end_extract
echo %firmware_folder%>templogs\firmware_folder.txt
IF "%action_param%"=="firmware_download_and_extract" goto:end_script_2
IF "%action_type%"=="1" goto:define_volume_letter
IF "%action_type%"=="2" (
	call tools\storage\create_update.bat "%~dp0..\..\firmware_temp"
	call "%associed_language_script%" "display_title"
	mkdir templogs
	IF "%action_param%"=="firmware_download" goto:end_script_2
	goto:define_action_type
)
IF "%action_type%"=="6" (
	IF "%~2"=="exfat_force" (
		call tools\storage\create_update_2.bat "%~dp0..\..\firmware_temp" "exfat_force"
	) else (
		call tools\storage\create_update_2.bat "%~dp0..\..\firmware_temp"
	)
	call "%associed_language_script%" "display_title"
	mkdir templogs
	IF "%action_param%"=="firmware_download" goto:end_script_2
	goto:define_action_type
)
IF "%action_type%"=="3" goto:define_volume_letter
:define_volume_letter
set volume_letter=
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
set disk_not_finded_choice=
IF "%tempcount%"=="0" (
	call "%associed_language_script%" "no_disk_found_error"
	IF NOT "!disk_not_finded_choice!"=="" set disk_not_finded_choice=!disk_not_finded_choice:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "disk_not_finded_choice" "o/n_choice"
	IF /i "!disk_not_finded_choice!"=="o" (
		goto:define_volume_letter
	) else (
		goto:end_script_2
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
call "%associed_language_script%" "disk_list_choice"
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	call "%associed_language_script%" "disk_choice_empty_error"
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:define_action_type
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
	call "%associed_language_script%" "disk_choice_letter_not_exist_error"
	goto:define_volume_letter
)
	TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 3 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
	set /p temp_volume_format=<templogs\tempvar.txt
IF NOT "%temp_volume_format%"=="FAT32" (
	call "%associed_language_script%" "disk_choice_not_fat32_formated_choice"
)
IF NOT "%cancel_script%"=="" set cancel_script=%cancel_script:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "cancel_script" "o/n_choice"
IF /i "%cancel_script%"=="o" goto:define_action_type
set daybreak_method_choice=
IF "%action_type%"=="1" (
	call "%associed_language_script%" "copying_begin"
	if exist "%volume_letter%:\FW_%firmware_choice%" rmdir /s /q "%volume_letter%:\FW_%firmware_choice%"
	%windir%\System32\Robocopy.exe "firmware_temp " %volume_letter%:\FW_%firmware_choice% /e >nul
	echo.
	call "%associed_language_script%" "daybreak_convert_choice"
	IF "!daybreak_method_choice!"=="1" (
		call :daybreak_convert "%volume_letter%:\FW_%firmware_choice%"
	)
	IF "!daybreak_method_choice!"=="2" (
		call :daybreak_convert_2 "%volume_letter%:\FW_%firmware_choice%"
	)
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX.nro" del /q "%volume_letter%:\switch\ChoiDuJourNX.nro"
	IF NOT EXIST "%volume_letter%:\switch" mkdir "%volume_letter%:\switch"
	IF NOT EXIST "%volume_letter%:\switch\ChoiDuJourNX" mkdir "%volume_letter%:\switch\ChoiDuJourNX"
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" (
		del /q "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	)
	copy /V /B "tools\sd_switch\mixed\modular\ChoiDuJourNX\switch\ChoiDuJourNX\ChoiDuJourNX.nro" "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" >nul
	call "%associed_language_script%" "copying_end"
)
IF "%action_type%"=="3" (
	call "%associed_language_script%" "copying_begin"
	if exist "%volume_letter%:\FW_%firmware_choice%" rmdir /s /q "%volume_letter%:\FW_%firmware_choice%"
	%windir%\System32\Robocopy.exe "firmware_temp " %volume_letter%:\FW_%firmware_choice% /e >nul
	call :daybreak_convert "%volume_letter%:\FW_%firmware_choice%"
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX.nro" del /q "%volume_letter%:\switch\ChoiDuJourNX.nro"
	IF NOT EXIST "%volume_letter%:\switch" mkdir "%volume_letter%:\switch"
	IF NOT EXIST "%volume_letter%:\switch\ChoiDuJourNX" mkdir "%volume_letter%:\switch\ChoiDuJourNX"
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" (
		del /q "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	)
	copy /V /B "tools\sd_switch\mixed\modular\ChoiDuJourNX\switch\ChoiDuJourNX\ChoiDuJourNX.nro" "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" >nul
	call "%associed_language_script%" "copying_end"
	echo.
	call "%associed_language_script%" "choidujour_special_message"
	echo.
	pause
	call tools\storage\create_update.bat "%~dp0..\..\firmware_temp"
	call "%associed_language_script%" "display_title"
	mkdir templogs
)
echo.
call "%associed_language_script%" "choidujournx_doc_launch_choice"
IF NOT "%launch_choidujournx_doc%"=="" set launch_choidujournx_doc=%launch_choidujournx_doc:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_choidujournx_doc" "o/n_choice"
IF /I "%launch_choidujournx_doc%"=="o" start "" "%language_path%\doc\files\choidujournx.html"
goto:define_action_type

:cdj_test_max_firmware
IF %action_type% EQU 2 (
	call "%associed_language_script%" "choidujour_max_firmware_error"
	pause
	exit /b 1
)
IF %action_type% EQU 3 (
	set cdjnx_use=
	call "%associed_language_script%" "choidujour_max_firmware_error"
	pause
	IF NOT "!cdjnx_use!"=="" set cdjnx_use=!cdjnx_use:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "cdjnx_use" "o/n_choice"
	IF /i NOT "!cdjnx_use!"=="o" (
		exit /b 1
	) else (
		set action_type=1
	)
)
exit /b

:daybreak_convert
set keys_file_path=
call "%associed_language_script%" "daybreak_keys_file_select"
IF "%keys_file_path%"=="" (
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
			tools\Hactool_based_programs\hactoolnet.exe -k "%keys_file_path%" "!temp_file_name!" >templogs\temptest.txt 2>&1
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
			rem tools\Hactool_based_programs\tools\hactool.exe -k "%keys_file_path%" -i "!temp_file_name!" >templogs\temptest.txt 2>&1
			tools\Hactool_based_programs\hactoolnet.exe -k "%keys_file_path%" "!temp_file_name!" >templogs\temptest.txt 2>&1
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

:firmware_folder_choice
set firmware_folder=
call "%associed_language_script%" "package_folder_select"
set /p firmware_folder=<"templogs\tempvar.txt"
IF "%firmware_folder%"=="" (
	call "%associed_language_script%" "no_firmware_source_selected_error"
	exit /b 400
)
set firmware_folder=%firmware_folder%\
set firmware_folder=%firmware_folder:\\=\%
rem %windir%\System32\Robocopy.exe "%firmware_folder% " firmware_temp\ /e >nul
rem set firmware_folder=firmware_temp\
exit /b

:end_script
pause 
:end_script_2
IF "%~1"=="" (
	IF EXIST "templogs" rmdir /s /q templogs 2>nul
)
IF NOT "%~1"=="firmware_download_and_extract" (
	IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
)
endlocal