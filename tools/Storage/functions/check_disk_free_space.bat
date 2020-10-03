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
for /l %%i in (0,1,%len_max%) do (
	IF %%i LSS %len_max% (
		IF !value:~%%i,1! GTR !max:~%%i,1! (
			endlocal
			set verif_free_space=OK
			goto:eof
		) else IF !value:~%%i,1! LSS !max:~%%i,1! (
			endlocal
			goto:eof
		)
	) else (
		IF !value:~%%i,1! GEQ !max:~%%i,1! (
			endlocal
			set verif_free_space=OK
			goto:eof
		)
	)
)
endlocal