set verif_free_space=
Setlocal enabledelayedexpansion
set value=%~1
set max=%~2
call "%~dp0\strlen.bat" nb "%value%"
set /a len_value=%nb%
call "%~dp0\strlen.bat" nb "%max%"
set /a len_max=%nb%
IF %len_value% GTR %len_max% (
	endlocal
	set verif_free_space=OK
	goto:eof
) else IF %len_value% LSS %len_max% (
	endlocal
	goto:eof
)
set /a len_max-=1
set /a i=0
:begin_verif
IF %i% GTR %len_max% goto:end_verif
set temp1=!value:~%i%,1!
set temp2=!max:~%i%,1!
	IF %i% LSS %len_max% (
		IF %temp1% GTR %temp2% (
			endlocal
			set verif_free_space=OK
			goto:eof
		) else IF %temp1% LSS %temp2% (
			endlocal
			goto:eof
		)
	) else (
		IF %temp1% GEQ %temp2% (
			endlocal
			set verif_free_space=OK
			goto:eof
		)
	)
set /a i+=1
goto:begin_verif
:end_verif

endlocal