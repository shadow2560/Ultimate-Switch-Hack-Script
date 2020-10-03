::Attention, veuillez traduire les commentaires

::Configurations basiques
set language_authors=shadow256 sur certains forums, shadow2560 sur Github.
set language_name=Français France
set lng_yes_choice=o
set lng_no_choice=n
set lng_always_choice=t
set lng_never_choice=j

::Configurations à laissez par défaut en cas de doute
set language_chcp=65001
set language_temp_dir=templogs
set language_echo=off

::Laisser cette variable à 0 s'il s'agit d'une langue officiellement supportée par le script, mettre à 1 en cas de personnalisation, cela empêchera la mise à jour automatique du dossier de la langue
set language_custom=0

::traitements automatisés
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