set "string=%~2"
set stringLength=0
IF "%string%"=="" goto:end_lengthLoop
:lengthLoop
set "string=%string:~1%"
set /a stringLength +=1
if defined string goto:lengthLoop
:end_lengthLoop
set %~1=%stringLength%