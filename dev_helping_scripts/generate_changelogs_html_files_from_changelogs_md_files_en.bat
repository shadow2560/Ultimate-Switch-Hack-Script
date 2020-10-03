::script by shadow256
chcp 65001 >nul
@echo off
cd ..
choice /c yn /n /m "Increment 1 in the english documentation version file? ^(y/n^): "
IF %errorlevel% EQU 2 goto:begin_writing_doc
set /p number=<"languages\EN_us\doc\folder_version.txt"
set /a number+=1
<nul set /p ="%number%">"languages\EN_us\doc\folder_version.txt"
:begin_writing_doc
call :write_begining_of_file "languages\EN_us\doc\files\changelog.html"
call :write_begining_of_file "languages\EN_us\doc\files\packs_changelog.html"
"tools\gnuwin32\bin\tail.exe" -n+1 <"changelog_en.md" >>"languages\EN_us\doc\files\changelog.html"
"tools\gnuwin32\bin\tail.exe" -n+1 <"packs_changelog_en.md" >>"languages\EN_us\doc\files\packs_changelog.html"
call :write_ending_of_file "languages\EN_us\doc\files\changelog.html"
call :write_ending_of_file "languages\EN_us\doc\files\packs_changelog.html"
goto:eof

:write_begining_of_file
set file=%~1
copy nul "%file%" >nul
echo ^<!DOCTYPE HTML^>>>"%file%"
echo ^<html lang="en-US"^>>>"%file%"
echo ^<head^>>>"%file%"
IF "%~1"=="languages\EN_us\doc\files\changelog.html" (
	echo ^<title^>Changelog Ultimate Switch Hack Script^</title^>>>"%file%"
) else IF "%~1"=="languages\EN_us\doc\files\packs_changelog.html" (
	echo ^<title^>Pack Changelog of CFWs/modules/homebrews^</title^>>>"%file%"
)
echo ^<meta charset="UTF-8"^>>>"%file%"
echo ^<meta http-equiv="X-UA-Compatible" content="IE=edge"^>>>"%file%"
echo ^<style type="text/css"^>>>"%file%"
echo body {>>"%file%"
echo background-color: #00000^0;>>"%file%"
echo color: #FFFFFF>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body a {>>"%file%"
echo color: #666666;>>"%file%"
echo text-decoration: underline;>>"%file%"
echo font-weight: bold;>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body a:over {>>"%file%"
echo color: #AAAAAA;>>"%file%"
echo text-decoration: underline;>>"%file%"
echo font-weight: bold;>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body h1 {>>"%file%"
echo.>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body h2 {>>"%file%"
echo.>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body ul {>>"%file%"
echo.>>"%file%"
echo }>>"%file%"
echo.>>"%file%"
echo body ul li {>>"%file%"
echo.>>"%file%"
echo }>>"%file%"
echo ^</style^>>>"%file%"
echo ^</head^>>>"%file%"
echo ^<body^>>>"%file%"
exit /b

:write_ending_of_file
set file=%~1
echo ^</body^>>>"%file%"
echo ^</html^>>>"%file%"
exit /b