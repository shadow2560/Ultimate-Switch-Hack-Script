set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Use Switch-Lan-Play client %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will install and use the alternative network for playing online games for the Switch.
echo For more information on this function, choose to open the documentation when it will be proposed.
goto:eof

:first_action_choice
echo Switch-Lan-Play client
echo.
echo What do you want to do:
echo.
echo 1: Launch the client?
echo 2: Install Winpcap ^(must be done only one time^)?
echo 0: Launch the documentation?
echo All other choices: Go back to previous menu.
echo.
set /p install_choice=Make your choice: 
goto:eof

:launch_client_choice
echo What do you want to do:
echo.
echo 1: Launch the client in interactive mode ^(recommanded^)?
echo 2: Connect to a server stocked in a list?
echo 3: Servers list management?
echo All other choices: Go back to main action of this menu?
echo.
set /p launch_client_choice=Make your choice: 
goto:eof

:no_server_list_error
echo The server list doesn't exist, the client will be launched in interactive mode.
goto:eof

:choose_server_first_part
echo Choose a server:
goto:eof

:launch_client_in_interactive_mode_message
echo All other choices: Launch the client in interactive mode.
goto:eof

:go_back_message
echo All other choices: Go back to servers management.
goto:eof

:select_server_choice
set /p selected_server=Choose your server: 
goto:eof

:server_choice_not_exist_in_list_error
echo The server doesn't exist in servers list, the client will be launched in interactive mode.
goto:eof

:server_choice_not_exist_in_list_error2
echo The server doesn't exist in servers list, going back to servers list management.
goto:eof

:manage_servers_choice
echo Servers list management
echo.
echo What do you want to do:
echo.
echo 1: Add a server?
echo 2: Modify a server?
echo 3: Remove a server?
echo All other choices: Exit the servers list management.
echo.
set /p manage_choice=Make your choice: 
goto:eof

:server_name_choice
set /p new_server_name=Enter server name: 
goto:eof

:server_name_empty_error
echo The server name couldn't be empty, add canceled.
goto:eof

:server_name_char_error
echo Unauthorised char in server name, add canceled.
goto:eof

:server_addr_choice
set /p new_server_addr=Enter adress of the server: 
goto:eof

:server_addr_empty_error
echo The server adress couldn't be empty, add canceled.
goto:eof

:server_addr_char_error
echo Unauthorised char in server adress, add canceled.
goto:eof

:add_server_success
echo Server added.
goto:eof

:modify_server_name_choice
set /p new_server_name=Enter the new server name ^(if empty, the  name will be kept^): 
goto:eof

:modify_server_addr_choice
set /p new_server_addr=Enter the new server adress ^(if empty, the adress will be kept^): 
goto:eof

:modify_server_success
echo Server modified.
goto:eof

:delete_server_success
echo Server deleted.
goto:eof

:winpcap_install_instructions
echo Winpcap installation will be launched, you must accept the admin elevation  to use it.
goto:eof