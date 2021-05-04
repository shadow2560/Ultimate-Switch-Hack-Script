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
call "%associed_language_script%" "display_title"
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	goto:end_script
)
set md5_try=0
call "%associed_language_script%" "intro"
pause 
:define_action_type
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
cls
set action_type=
call "%associed_language_script%" "action_choice"
IF NOT "%action_type%"=="" set action_type=%action_type:~0,1%
IF "%action_type%"=="4" (
	cls
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
echo.
call "%associed_language_script%" "firmware_choice_end"
IF NOT EXIST "downloads" mkdir "downloads"
IF NOT EXIST "downloads\firmwares" mkdir "downloads\firmwares"
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
) else (
	mkdir firmware_temp
)
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
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.0" (
	set expected_md5=550b0091304d54b67e3e977900c83dcc
	set "firmware_link=https://mega.nz/#^!kdJWQKBT^!G15TiWusLkrS7JT2KHNYXOfNAUOb2PWdhXsfe-kRtxg"
	set firmware_file_name=Firmware 7.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.1" (
	set expected_md5=c5440e557b8b62eabedf754e508ded2f
	set "firmware_link=https://mega.nz/#^!EERwCayT^!KPGACrRhEVQdhsaqbfqpNTwzAyRIoZRLvfqqmxhNT80"
	set firmware_file_name=Firmware 7.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.0" (
	set expected_md5=c0dab852378c289dc1fb135ed2a36f01
	set "firmware_link=https://mega.nz/#^!gU4B3KDa^!H5QKqthWmIAc5IM-pouiRFp-vOSkEfDTSMoSDFTUPps"
	set firmware_file_name=Firmware 8.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.1" (
	set expected_md5=c3a2a6ac6ef5956cdda6ce172ccd2053
	set "firmware_link=https://mega.nz/#^!lM4wSKCL^!_-38B-DFq9dqqUqu4EorS0hnBi099dY6JbkXYard51A"
	set firmware_file_name=Firmware 8.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="8.1.0" (
	set expected_md5=31c69ecb30326193afb141e1da8ff053
	set "firmware_link=https://mega.nz/#^!NQZnUKiJ^!IF9MawZaDgTWcszyu3zzuE4RRM1Kdo_4OKII93VBbQw"
	set firmware_file_name=Firmware 8.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.0" (
	set expected_md5=2e9d6fceed9f698a7625b1ea97986bde
	set "firmware_link=https://mega.nz/#^!sI5xyYqB^!3K1L3HsHmNkhvEoCiZvQp-GlUi9wUEx_9nU3wnuuOYY"
	set firmware_file_name=Firmware 9.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.0.1" (
	set expected_md5=f0a42373f582cc13b0b26cff09812714
	set "firmware_link=https://mega.nz/#^!4Z4BBIjR^!c8XwjWGeSQUTAuqk2d9ulK571_-BvRlItIv1Jx0S1so"
	set firmware_file_name=Firmware 9.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.1.0" (
	set expected_md5=9936bae12d9ada861a160a6a29c0b6dc
	set "firmware_link=https://mega.nz/#^!oJo2RCRb^!xMklUfjgiIXiDrCF4QLwtU0oQzMKqbVKbwuV4tGToY4"
	set firmware_file_name=Firmware 9.1.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="9.2.0" (
	set expected_md5=1a83c5642eb66acc44aa02fafa16b770
	set "firmware_link=https://mega.nz/#^!tRo0UahC^!Z5MntwPeB4Dv1643Q5novzsuZrhNQWxEND2sIzXg4aI"
	set firmware_file_name=Firmware 9.2.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.0" (
	set expected_md5=1b86a71fb9488bb2783a19d94f77e978
	set "firmware_link=https://mega.nz/file/wJplVTzS#49uqh5vyjgb8ZB_eZsmuQBk9ouRlHgwIQnd7MCwh1l8"
	set firmware_file_name=Firmware 10.0.0.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.1" (
	set expected_md5=946b52949dc35dab7a029adea14e99f8
	set "firmware_link=https://mega.nz/file/YRgBhB7b#gck6TCgkvaOL4rlTazJgkbALmTUCjg8fXmhTaaTOv-I"
	set firmware_file_name=Firmware 10.0.1.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.2" (
	set expected_md5=78702cba5d6024bc1c70870058b4dbb4
	set "firmware_link=https://mega.nz/file/kQBRnYzL#AxCTCgZf4kEjtUW5z1MUSSnlcwjEe6AptanmYtr1WN8"
	set firmware_file_name=Firmware 10.0.2.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.3" (
	set expected_md5=94d60ba229a00c16e11f2ea959a64123
	set "firmware_link=https://mega.nz/file/QRpGBI7C#UQZGw-FD8dfzIJg-Dw6PJeV0nFd8DNOQzZ5smriA32s"
	set firmware_file_name=Firmware 10.0.3.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.0.4" (
	set expected_md5=b39d012222fc5a9d236c9fa1c887b287
	set "firmware_link=https://mega.nz/file/FFRjyAwa#qeFAOzFjAecKVhaPTbZCKiajnVpYPplexG6X72vDO_0"
	set firmware_file_name=Firmware 10.0.4.zip
	set firmware_folder=firmware_temp\
	call :cdj_test_max_firmware
	IF !errorlevel! EQU 1 goto:define_firmware_choice
	goto:download_firmware
)
IF "%firmware_choice%"=="10.1.0" (
	set expected_md5=ef4e13f1842b0a0472359d0d4de80145
	set "firmware_link=https://mega.nz/file/wQ4WBShJ#Tw7k2pCqB5IkkPPwFnwC7UAmQWvXzNs2-4D2Ldj267Q"
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
	set expected_md5=73200c7e53c864f06f648c121ee78677
	set "firmware_link=https://mega.nz/file/Yd5V0KgT#TYiu_F0Pmvqm758JHlqxivv9geMn7RQ7N2L4MCRo10g"
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
	goto:downloading_firmware
)
:skip_verif_md5sum
call "%associed_language_script%" "firmware_downloading_end"
IF "%action_type%"=="5" (
	pause
	goto:define_action_type
)
call "%associed_language_script%" "extract_firmware_begin"
TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\firmwares\%firmware_file_name%" -o"firmware_temp" -r
IF "%action_type%"=="1" goto:define_volume_letter
IF "%action_type%"=="2" (
	call tools\storage\create_update.bat "%~dp0..\..\firmware_temp"
	call "%associed_language_script%" "display_title"
	mkdir templogs
	goto:define_action_type
)
IF "%action_type%"=="6" (
	call tools\storage\create_update_2.bat "%~dp0..\..\firmware_temp"
	call "%associed_language_script%" "display_title"
	mkdir templogs
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
IF "%action_type%"=="1" (
	call "%associed_language_script%" "copying_begin"
	if exist "%volume_letter%:\FW_%firmware_choice%" rmdir /s /q "%volume_letter%:\FW_%firmware_choice%"
	%windir%\System32\Robocopy.exe "firmware_temp" %volume_letter%:\FW_%firmware_choice% /e >nul
	call :daybreak_convert "%volume_letter%:\FW_%firmware_choice%"
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
	%windir%\System32\Robocopy.exe "firmware_temp" %volume_letter%:\FW_%firmware_choice% /e >nul
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
	exit /b 1
)
IF %action_type% EQU 3 (
	set cdjnx_use=
	call "%associed_language_script%" "choidujour_max_firmware_error"
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
	pause
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
				pause
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
				pause
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

:end_script
pause 
:end_script_2
IF EXIST "templogs" rmdir /s /q templogs 2>nul
IF EXIST "firmware_temp" rmdir /s /q "firmware_temp" 2>nul
endlocal