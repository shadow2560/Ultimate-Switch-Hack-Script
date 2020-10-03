@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"
set "bat_name=%~n0"
Title NSC_Builder v%program_version% -- Profile: %ofile_name% -- by JulesOnTheRoad

:MAIN
cls
call :program_logo
ECHO ..........................................................
echo Tapez "1" pour entrer en mode TÉLÉCHARGEMENT
echo Tapez "2" pour entrer dans le mode information de fichiers
echo Tapez "0" pour entrer en mode CONFIGURATION
echo.
echo Tapez "N" pour accéder au MODE STANDARD
echo Tapez "M" pour accéder au MODE MTP
echo Tapez "D" pour accéder à GOOGLE DRIVE 
echo Tapez "L" pour accéder à l'ancien MODE
echo ..........................................................
echo.
set /p bs="Faite votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="1" goto DOWNLOADMODE
if /i "%bs%"=="2" goto INFMODE
if /i "%bs%"=="N" goto call_main
if /i "%bs%"=="L" goto LegacyMode
if /i "%bs%"=="M" goto MTPMode
if /i "%bs%"=="0" goto OPT_CONFIG
goto MAIN

:LegacyMode
call "%prog_dir%ztools\LEGACY_fr.bat"
exit /B

:MTPMode
call "%prog_dir%ztools\MtpMode_fr.bat"
exit /B

:DOWNLOADMODE
cls
call :program_logo
%pycommand% "%squirrel_lb%" -lib_call Drive.Download Interface
goto MAIN

:INFMODE
cls
call :program_logo
%pycommand% "%squirrel_lb%" -lib_call Drive.Info Interface
goto MAIN

::///////////////////////////////////////////////////
::NSCB_options.cmd configuration script
::///////////////////////////////////////////////////
:OPT_CONFIG
call "%batconfig%" "%op_file%" "%listmanager%" "%batdepend%"
cls
goto TOP_INIT

::///////////////////////////////////////////////////
::SUBROUTINES
::///////////////////////////////////////////////////

:squirrell
echo                    ,;:;;,
echo                   ;;;;;
echo           .=',    ;:;;:,
echo          /_', "=. ';:;:;
echo          @=:__,  \,;:;:'
echo            _(\.=  ;:;;'
echo           `"_(  _/="`
echo            `"'
exit /B

:program_logo

ECHO                                        __          _ __    __
ECHO                  ____  _____ ____     / /_  __  __(_) /___/ /__  _____
ECHO                 / __ \/ ___/ ___/    / __ \/ / / / / / __  / _ \/ ___/
ECHO                / / / (__  ) /__     / /_/ / /_/ / / / /_/ /  __/ /
ECHO               /_/ /_/____/\___/____/_.___/\__,_/_/_/\__,_/\___/_/
ECHO                              /_____/
ECHO -------------------------------------------------------------------------------------
ECHO                         NINTENDO SWITCH CLEANER AND BUILDER
ECHO                      (THE XCI MULTI CONTENT BUILDER AND MORE)
ECHO -------------------------------------------------------------------------------------
ECHO =============================     BY JULESONTHEROAD     =============================
ECHO -------------------------------------------------------------------------------------
ECHO "                                POWERED BY SQUIRREL                                "
ECHO "                    BASED ON THE WORK OF BLAWAR AND LUCA FRAGA                     "
ECHO                                  VERSION %program_version% (GDRIVE)
ECHO -------------------------------------------------------------------------------------
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Blawar's github:  https://github.com/blawar
ECHO Luca Fraga's github: https://github.com/LucaFraga
ECHO -------------------------------------------------------------------------------------
exit /B

:delay
PING -n 2 127.0.0.1 >NUL 2>&1
exit /B

:thumbup
echo.
echo    /@
echo    \ \
echo  ___\ \
echo (__O)  \
echo (____@) \
echo (____@)  \
echo (__o)_    \
echo       \    \
echo.
echo J'espère que vous passerez un bon moment
exit /B

:call_main
call "%prog_dir%\NSCB_fr.bat"
exit /B

:salida
::pause
exit
