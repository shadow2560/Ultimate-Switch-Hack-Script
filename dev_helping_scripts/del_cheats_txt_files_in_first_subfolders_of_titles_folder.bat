@echo off
cd ..\tools\sd_switch\cheats\titles
for /D %%i in (*) do (
cd %%i
del /q *.txt >nul
cd ..
)