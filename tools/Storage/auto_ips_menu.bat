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
:menu_choice
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" (
	call :create_loader_patches
	goto:menu_choice
)
IF "%action_choice%"=="2" (
	call :create_fs_and_es_patches
	goto:menu_choice
)
IF "%action_choice%"=="3" (
	call :create_fs_patches
	goto:menu_choice
)
IF "%action_choice%"=="4" (
	call :create_es_patches
	goto:menu_choice
)
goto:end_script

:create_loader_patches
call :fusee-secondary_choice
IF %errorlevel% EQU 0 (
	call :outdir_choice
	IF !errorlevel! EQU 0 (
		tools\python3_scripts\AutoIPS-Patcher\Loader-AutoIPS.exe "!fusee_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
		IF !errorlevel! EQU 0 (
			call "%associed_language_script%" "loader_patches_creation_success"
			pause
		) else (
			call "%associed_language_script%" "loader_patches_creation_error"
			pause
		)
	)
)
exit /b

:create_fs_and_es_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF !errorlevel! EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\FS-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "FS_patches_creation_success"
			) else (
				call "%associed_language_script%" "FS_patches_creation_error"
			)
			tools\python3_scripts\AutoIPS-Patcher\ES-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "ES_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "ES_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:create_fs_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF %errorlevel% EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\FS-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "FS_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "FS_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:create_es_patches
call :keys_file_choice
IF %errorlevel% EQU 0 (
	call :firmware_download_and_choice
	IF %errorlevel% EQU 0 (
		call :outdir_choice
		IF !errorlevel! EQU 0 (
			tools\python3_scripts\AutoIPS-Patcher\ES-AutoIPS.exe "!firmware_folder:\=\\!" "!keys_file_path:\=\\!" "!outdir_path:\=\\!" >nul 2>&1
			IF !errorlevel! EQU 0 (
				call "%associed_language_script%" "ES_patches_creation_success"
				pause
			) else (
				call "%associed_language_script%" "ES_patches_creation_error"
				pause
			)
		)
	)
)
exit /b

:keys_file_choice
set keys_file_path=
call "%associed_language_script%" "keys_file_selection"
set /p keys_file_path=<"templogs\tempvar.txt"
IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	pause
	exit /b 400
)
exit /b

:outdir_choice
set outdir_path=
call "%associed_language_script%" "outdir_folder_select"
set /p outdir_path=<"templogs\tempvar.txt"
IF "%outdir_path%"=="" (
	call "%associed_language_script%" "no_outdir_source_selected_error"
	exit /b 400
)
set outdir_path=%outdir_path%\
set outdir_path=%outdir_path:\\=\%
exit /b

:fusee-secondary_choice
set fusee_file_path=
call "%associed_language_script%" "fusee_file_selection"
set /p fusee_file_path=<"templogs\tempvar.txt"
IF "%fusee_file_path%"=="" (
	call "%associed_language_script%" "no_fusee_file_selected_error"
	exit /b 400
)
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

:firmware_download_and_choice
set firmware_folder=
set firmware_choice=
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	exit /b 400
)
set md5_try=0
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
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
echo.
call "%associed_language_script%" "firmware_choice_end"
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
) else (
	mkdir firmware_temp
)
IF /i "%firmware_choice%"=="C" (
	call :firmware_folder_choice
	IF %errorlevel% NEQ 0 (
		exit /b 400
	)
	goto:daybreak_convert
)
IF NOT EXIST "downloads" mkdir "downloads"
IF NOT EXIST "downloads\firmwares" mkdir "downloads\firmwares"
IF /i "%firmware_choice%"=="F" (
	start explorer.exe "%~dp0..\..\downloads\firmwares"
	goto:define_firmware_choice
)
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
	set expected_md5=69ac6dbac1bd0a12ea9e12c97bc82907
	set "firmware_link=https://mega.nz/#^!EBIDFCrZ^!NaIuX7dvC3skUBAfb113qxhh0hJYzY3mm1mWou7Casc"
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
	set expected_md5=320bd423e073a92b74dff30d92bcffa8
	set "firmware_link=https://mega.nz/#^!QAQ3ha4Y^!7fI6dJmhk3SUwyEl9cj9orRSE7Fjb1rghJxCnliXZRU"
	set firmware_file_name=Firmware 6.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.2.0" (
	set expected_md5=602826f8ad0ed04452a1092fc6d73c8c
	set "firmware_link=https://mega.nz/#^!9F5XFabb^!UdZmY8qpMbDuo-rrn0jI-JCpXrTWKoshKhClZ_H7tkA"
	set firmware_file_name=Firmware 6.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.0" (
	set expected_md5=550b0091304d54b67e3e977900c83dcc
	set "firmware_link=https://mega.nz/#^!kdJWQKBT^!G15TiWusLkrS7JT2KHNYXOfNAUOb2PWdhXsfe-kRtxg"
	set firmware_file_name=Firmware 7.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.1" (
	set expected_md5=c5440e557b8b62eabedf754e508ded2f
	set "firmware_link=https://mega.nz/#^!EERwCayT^!KPGACrRhEVQdhsaqbfqpNTwzAyRIoZRLvfqqmxhNT80"
	set firmware_file_name=Firmware 7.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.0" (
	set expected_md5=c0dab852378c289dc1fb135ed2a36f01
	set "firmware_link=https://mega.nz/#^!gU4B3KDa^!H5QKqthWmIAc5IM-pouiRFp-vOSkEfDTSMoSDFTUPps"
	set firmware_file_name=Firmware 8.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.1" (
	set expected_md5=c3a2a6ac6ef5956cdda6ce172ccd2053
	set "firmware_link=https://mega.nz/#^!lM4wSKCL^!_-38B-DFq9dqqUqu4EorS0hnBi099dY6JbkXYard51A"
	set firmware_file_name=Firmware 8.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.0" (
	set expected_md5=31c69ecb30326193afb141e1da8ff053
	set "firmware_link=https://mega.nz/#^!NQZnUKiJ^!IF9MawZaDgTWcszyu3zzuE4RRM1Kdo_4OKII93VBbQw"
	set firmware_file_name=Firmware 8.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.0" (
	set expected_md5=2e9d6fceed9f698a7625b1ea97986bde
	set "firmware_link=https://mega.nz/#^!sI5xyYqB^!3K1L3HsHmNkhvEoCiZvQp-GlUi9wUEx_9nU3wnuuOYY"
	set firmware_file_name=Firmware 9.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.1" (
	set expected_md5=f0a42373f582cc13b0b26cff09812714
	set "firmware_link=https://mega.nz/#^!4Z4BBIjR^!c8XwjWGeSQUTAuqk2d9ulK571_-BvRlItIv1Jx0S1so"
	set firmware_file_name=Firmware 9.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.1.0" (
	set expected_md5=9936bae12d9ada861a160a6a29c0b6dc
	set "firmware_link=https://mega.nz/#^!oJo2RCRb^!xMklUfjgiIXiDrCF4QLwtU0oQzMKqbVKbwuV4tGToY4"
	set firmware_file_name=Firmware 9.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="9.2.0" (
	set expected_md5=1a83c5642eb66acc44aa02fafa16b770
	set "firmware_link=https://mega.nz/#^!tRo0UahC^!Z5MntwPeB4Dv1643Q5novzsuZrhNQWxEND2sIzXg4aI"
	set firmware_file_name=Firmware 9.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.0" (
	set expected_md5=1b86a71fb9488bb2783a19d94f77e978
	set "firmware_link=https://mega.nz/file/wJplVTzS#49uqh5vyjgb8ZB_eZsmuQBk9ouRlHgwIQnd7MCwh1l8"
	set firmware_file_name=Firmware 10.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.1" (
	set expected_md5=946b52949dc35dab7a029adea14e99f8
	set "firmware_link=https://mega.nz/file/YRgBhB7b#gck6TCgkvaOL4rlTazJgkbALmTUCjg8fXmhTaaTOv-I"
	set firmware_file_name=Firmware 10.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.2" (
	set expected_md5=78702cba5d6024bc1c70870058b4dbb4
	set "firmware_link=https://mega.nz/file/kQBRnYzL#AxCTCgZf4kEjtUW5z1MUSSnlcwjEe6AptanmYtr1WN8"
	set firmware_file_name=Firmware 10.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.3" (
	set expected_md5=94d60ba229a00c16e11f2ea959a64123
	set "firmware_link=https://mega.nz/file/QRpGBI7C#UQZGw-FD8dfzIJg-Dw6PJeV0nFd8DNOQzZ5smriA32s"
	set firmware_file_name=Firmware 10.0.3.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.4" (
	set expected_md5=b39d012222fc5a9d236c9fa1c887b287
	set "firmware_link=https://mega.nz/file/FFRjyAwa#qeFAOzFjAecKVhaPTbZCKiajnVpYPplexG6X72vDO_0"
	set firmware_file_name=Firmware 10.0.4.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="10.1.0" (
	set expected_md5=ef4e13f1842b0a0472359d0d4de80145
	set "firmware_link=https://mega.nz/file/wQ4WBShJ#Tw7k2pCqB5IkkPPwFnwC7UAmQWvXzNs2-4D2Ldj267Q"
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
	set "firmware_link=https://mega.nz/file/YRZjWSqC#D2IFvaI8t0mMQMbEZRIiNH5PPR5dOUx17IkhEYqhcfM"
	set firmware_file_name=Firmware 11.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="11.0.1" (
	set expected_md5=73200c7e53c864f06f648c121ee78677
	set "firmware_link=https://mega.nz/file/Yd5V0KgT#TYiu_F0Pmvqm758JHlqxivv9geMn7RQ7N2L4MCRo10g"
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
	set expected_md5=26d79bde70476ab1c20ceefd8b0fd4c5
	set "firmware_link=https://mega.nz/file/lB5UTIqB#YSUkChTrftWSPJH7ulH537s9OgFWqrNr2OCEx7eGgSw"
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
goto:define_action_type

:download_firmware
set md5_try=0
IF EXIST "downloads\firmwares\%firmware_file_name%" goto:verif_md5sum
:downloading_firmware
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	call "%associed_language_script%" "firmware_downloading_begin"
Setlocal disabledelayedexpansion
TOOLS\megatools\megatools.exe dl --path="templogs\temp.zip" "%firmware_link%"
endlocal
	TOOLS\gnuwin32\bin\md5sum.exe templogs\temp.zip | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
		set /p md5_verif=<templogs\tempvar.txt
)
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	IF NOT "%md5_verif%"=="%expected_md5%" (
		IF %md5_try% EQU 3 (
			call "%associed_language_script%" "firmware_downloading_md5_error"
			pause
			exit /b 400
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
:daybreak_convert
call :daybreak_convertion "%firmware_folder%"
exit /b 0

:daybreak_convertion
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
				pause
				exit /b 400
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
				pause
				exit /b 400
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

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
)
endlocal