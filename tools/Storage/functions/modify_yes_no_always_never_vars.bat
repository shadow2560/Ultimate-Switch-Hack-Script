call :%~2 "%~1"
goto:eof

:o/n_choice
IF /i "!%~1!"=="%lng_yes_choice%" (
	set %~1=o
) else IF /i "!%~1!"=="%lng_no_choice%" (
	set %~1=n
) else (
	set %~1=n
)
exit /b

:o/n/t/j_choice
IF /i "!%~1!"=="%lng_yes_choice%" (
	set %~1=o
) else IF /i "!%~1!"=="%lng_no_choice%" (
	set %~1=n
) else IF /i "!%~1!"=="%lng_always_choice%" (
	set %~1=t
) else IF /i "!%~1!"=="%lng_never_choice%" (
	set %~1=j
) else (
	set %~1=n
)
exit /b