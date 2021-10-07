@echo off
if not defined trace set trace=rem
%trace% on
%trace% Script founded to https://stackoverflow.com/questions/5737658/how-do-i-display-integers-in-hexadecimal-from-a-batch-file/5742015
%trace% Modified by shadow256

SetLocal
    if "%1"=="/?" (
        call :help %0
        goto :eof
    )
    Set MinInBase=
    if /i "%2" EQU "Bin" call :DoBin %1
    if /i "%2" EQU "Hex" call :DoHex %1
    If not defined BinStr call :DoDec %1
EndLocal & set RET=%RET%
goto :eof

:DoBin
    Set MinInBase=2
    Set ShiftBy=1
    Set StartSyn=0b
    call :DoCalc %1
exit /b 

:DoHex
    Set MinInBase=16
    Set ShiftBy=4
    Set StartSyn=0x
    call :DoCalc %1
exit /b

:DoDec
    if {%1} EQU {} exit /b
    set  /a BinStr=%1
    set RET=%BinStr%
    echo %RET%
exit /b 

:DoCalc 
    Set BinStr= 
    SET /A A=%1
    %Trace% %A%
:StartSplit
    SET /A B="A>>%ShiftBy%"
    %Trace% %B%
    SET /A C="B<<%ShiftBy%"
    %Trace% %C%
    SET /A C=A-C
    %Trace% %C%
    call :StringIt %C%
    If %B% LSS %MinInBase% goto :EndSplit 
    set A=%B%
goto :StartSplit    
:EndSplit
    call :StringIt %B%
    set RET=%StartSyn%%BinStr%
    Echo %RET%
EndLocal & set RET=%RET%
exit /b 

:StringIt
    set Bin=0123456789ABCDEF
    FOR /F "tokens=*" %%A in ('echo "%%BIN:~%1,1%%"') do set RET=%%A
    set ret=%ret:"=%
    Set BinStr=%Ret%%BinStr%
exit /b 

:help
    echo %1 syntax:
    echo.
    echo %1 Calculation [Hex^|Bin]
    echo.
    echo eg %1 12*2 Hex
    echo.
    echo gives 0x18.
exit /b 