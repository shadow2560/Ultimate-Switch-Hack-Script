::Pay attention, you must translate comments

::Basic configurations
set language_authors=shadow256 on some forums, shadow2560 on Github, eliboa.
set language_name=English US
set lng_yes_choice=y
set lng_no_choice=n
set lng_always_choice=a
set lng_never_choice=j

::Leave these configurations by default if you have any doubts
set language_chcp=65001
set language_temp_dir=templogs
set language_echo=off

::Leave this var to 0 if this is an official language of the script, set it to 1 if you customize it because this will prevent update of the language files 
set language_custom=0

::Automatic instructions, mustn't be touched
set language_folder=languages
set temp_language_id=%~p0
set /a temp_count=2
:define_id
IF NOT "!temp_language_id:~-%temp_count%,1!"=="\" (
	set /a temp_count+=1
	goto:define_id
)
set /a temp_count-=1
set language_id=!temp_language_id:~-%temp_count%!
set language_id=%language_id:~0,-1%
set temp_language_id=
set temp_count=
set language_path=%language_folder%\%language_id%