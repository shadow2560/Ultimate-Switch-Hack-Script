@echo off
rem del /q "openhelper.exe"
rem gcc -municode -O2 -o openhelper.exe openhelper.c -lole32 -luuid -loleaut32 -lcomdlg32 -lshlwapi -lshfolder -lshell32
if exist "openhelper.exe" (
	certutil -encode openhelper.exe openhelper.b64
	pause
)