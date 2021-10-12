@ECHO OFF
:: Check Windows version
IF NOT "%OS%"=="Windows_NT" GOTO Syntax

:: Keep variables local
SETLOCAL

:: Check command line arguments
SET Append=0
IF /I [%1]==[-a] (
	SET Append=1
	SHIFT
)
IF     [%1]==[] GOTO Syntax
IF NOT [%2]==[] GOTO Syntax

:: Test for invalid wildcards
SET Counter=0
FOR /F %%A IN ('DIR /A /B %1 2^>NUL') DO CALL :Count "%%~fA"
IF %Counter% GTR 1 (
	SET Counter=
	GOTO Syntax
)

:: A valid filename seems to have been specified
SET File=%1

:: Check if a directory with the specified name exists
DIR /AD %File% >NUL 2>NUL
IF NOT ERRORLEVEL 1 (
	SET File=
	GOTO Syntax
)

:: Specify /Y switch for Windows 2000 / XP COPY command
SET Y=
VER | FIND "Windows NT" > NUL
IF ERRORLEVEL 1 SET Y=/Y

:: Flush existing file or create new one if -a wasn't specified
IF %Append%==0 (COPY %Y% NUL %File% > NUL 2>&1)

:: Actual TEE
FOR /F "tokens=1* delims=]" %%A IN ('FIND /N /V ""') DO (
	>  CON    ECHO.%%B
	>> %File% ECHO.%%B
)

:: Done
ENDLOCAL
GOTO:EOF


:Count
SET /A Counter += 1
SET File=%1
GOTO:EOF


:Syntax
ECHO.
ECHO Tee.bat,  Version 2.11a for Windows NT 4 / 2000 / XP
ECHO Display text on screen and redirect it to a file simultaneously
ECHO.
IF NOT "%OS%"=="Windows_NT" ECHO Usage:  some_command  ³  TEE.BAT  [ -a ]  filename
IF NOT "%OS%"=="Windows_NT" GOTO Skip
ECHO Usage:  some_command  ^|  TEE.BAT  [ -a ]  filename
:Skip
ECHO.
ECHO Where:  "some_command" is the command whose output should be redirected
ECHO         "filename"     is the file the output should be redirected to
ECHO         -a             appends the output of the command to the file,
ECHO                        rather than overwriting the file
ECHO.
ECHO Written by Rob van der Woude
ECHO http://www.robvanderwoude.com
ECHO Modified by Kees Couprie
ECHO http://kees.couprie.org
ECHO and Andrew Cameron
