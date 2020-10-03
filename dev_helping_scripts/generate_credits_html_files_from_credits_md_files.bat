::script by shadow256
chcp 65001 >nul
@echo off
cd ..
:begin_writing_doc
call :write_begining_of_file "languages\EN_us\doc\files\credits.html"
"tools\gnuwin32\bin\tail.exe" -n+1 <"credits.md" >>"languages\EN_us\doc\files\credits.html"
call :write_ending_of_file "languages\EN_us\doc\files\credits.html"
copy "languages\EN_us\doc\files\credits.html" "languages\FR_fr\doc\files\credits.html"
goto:eof

:write_begining_of_file
set file=%~1
copy nul "%file%" >nul
echo ^<!DOCTYPE HTML^>>>"%file%"
echo ^<html lang="en-US"^>>>"%file%"
echo ^<head^>>>"%file%"
echo ^<title^>Credits^</title^>>>"%file%"
echo ^<meta charset="UTF-8"^>>>"%file%"
echo ^<meta http-equiv="X-UA-Compatible" content="IE=edge"^>>>"%file%"
echo ^<style type="text/css"^>>>"%file%"
echo body {>>"%file%"
echo background-color: #000000;>>"%file%"
echo color: #FFFFFF;>>"%file%"
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