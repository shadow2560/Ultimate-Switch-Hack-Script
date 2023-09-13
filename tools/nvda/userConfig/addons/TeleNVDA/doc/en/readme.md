[[!meta title="TeleNVDA"]]

* Authors: Asociación Comunidad Hispanohablante de NVDA and other contributors. Original work by Tyler Spivey and Christopher Toth
* NVDA Compatibility: 2019.3 and beyond
* Download [stable version][1]

Note: in order to make download easier for users who need assistance or training and have limited computing skills, we provide an alternate link to the latest stable version which is easy to remember and share. You can go to [nvda.es/tele](https://nvda.es/tele) and download the add-on directly, without intermediate web pages.

Welcome to the TeleNVDA addon, which will allow you to connect to another computer running the free NVDA screen reader. With this add-on, you can connect to another person's computer, or allow a trusted person to connect to your system to perform routine maintenance, diagnose a problem, or provide training. This add-on is a modified version of the [NVDA Remote add-on](https://nvdaremote.com), and is maintained by the NVDA spanish community. It's fully compatible with NVDA Remote. These are the current differences:

* An option allows blocking remote speech commands different from text.
* Improved support for proxy servers and TOR hidden services ([Proxy support add-on](https://addons.nvda-project.org/addons/proxy.en.html) is required).
* Ability to change the f11 key to another gesture. Now this works as a common script so, you can assign gestures in the "Input Gestures" dialog.
* Ability to ignore the next immediate gesture completely, it is useful if you need to send to the remote machine the gesture used to toggle between host and remote machine.
* Ability to exchange small files (up to 10 MB) among users connected to the same session.
* Ability to forward ports via UPNP.
* Ability to use a custom portcheck service.
* Some GUI tweaks.
* Several bug fixes.

## Before You Begin

You will need to have installed NVDA on both computers, and obtain the TeleNVDA addon.

The installation of both NVDA and the TeleNVDA addon are standard. If you need more information, this can be found in NVDA's User Guide.

## Updating

When updating the addon, if you have installed TeleNVDA on the secure desktop, it is recommended that you also update the copy on the secure desktop.

To do this, first update your existing addon. Then open the NVDA menu, preferences, General settings, and press the button labeled "Use currently saved settings on the logon and other secure screens (requires administrator privileges)".

## Starting a remote session through a relay server

### On the computer to be controlled

1. Open the NVDA menu, Tools, Remote, Connect. Or directly press NVDA+alt+page up. This gesture can be modified from the NVDA input gestures dialog.
2. Choose client in the first radio button.
3. Select Allow this machine to be controlled in the second set of radio buttons.
4. In the host field, enter the host of the server you are connecting to, for example remote.nvda.es. When the particular server uses an alternative port, you can enter the host in the form &lt;host&gt;:&lt;port&gt;, for example remote.nvda.es:1234. If you are connecting to an IPV6 address, enter it between square brackets, for example [2603:1020:800:2::32].
5. Enter a key into the key field, or press the generate key button. The key is what others will use to control your computer. The machine being controlled and all its clients need to use the same key.
6. Press ok. Once done, you will hear a tone and connected. If the server includes a message of the day, it will be displayed in a dialog box. You will see this dialog everytime you connect or only the first time, depending on the server configuration.

### On the machine that is to be the controlling computer

1. Open the NVDA menu, Tools, Remote, Connect. Or directly press NVDA+alt+page up. This gesture can be modified from the NVDA input gestures dialog.
2. Choose client in the first radio button.
3. Select Control another machine in the second set of radio buttons.
4. In the host field, enter the host of the server you are connecting to, for example remote.nvda.es. When the particular server uses an alternative port, you can enter the host in the form &lt;host&gt;:&lt;port&gt;, for example remote.nvda.es:1234. If you are connecting to an IPV6 address, enter it between square brackets, for example [2603:1020:800:2::32].
5. Enter a key into the key field, or press the generate key button. The machine being controlled and all its clients need to use the same key.
6. Press ok. Once done, you will hear a tone and connected. If the server includes a message of the day, it will be displayed in a dialog box. You will see this dialog everytime you connect or only the first time, depending on the server configuration.

### Connection security warning

If you connect to a server without a valid SSL certificate, you will receive a connection security warning.

This may mean that your connection is insecure. If you trust this server fingerprint, you can press "Connect" to connect once, or "Connect and do not ask again for this server" to connect and save the fingerprint.

## Direct connections

The server option in the connect dialog allows you to set up a direct connection.

Once selecting this, select which mode your end of the connection will be in.

The other person will connect to you using the opposite.

Once the mode is selected, you can use the Get External IP button to get your external IP address and make sure the port which is entered in the port field is forwarded correctly. If enabled on your router, you can forward the port using UPNP before performing portcheck.

If portcheck detects that your port (6837 by default) is not reachable, a warning will appear.

Forward your port and try again. Also, ensure that the NVDA process is allowed through Windows firewall.

Note: The process for forwarding ports, enabling UPNP or configuring Windows firewall is outside of the scope of this document. Please consult the information provided with your router for further instruction.

Enter a key into the key field, or press generate. The other person will need your external IP along with the key to connect. If you entered a port other than the default (6837) in the port field, make sure that the other person appends the alternative port to the host address in the form &lt;external ip&gt;:&lt;port&gt;.

If you want to forward the chosen port using UPNP, enable the "Use UPNP to forward this port if possible" checkbox.

Once ok is pressed, you will be connected. When the other person connects, you can use TeleNVDA normally.

## Controlling the remote machine

Once the session is connected, the user of the controlling machine can press f11 to start controlling the remote machine (e.g. by sending keyboard keys or braille input). This gesture can be changed from NVDA Input Gestures Dialog.

When NVDA says controlling remote machine, the keyboard and braille display keys you press will go to the remote machine. Furthermore, when the controlling machine is using a braille display, information from the remote machine will be displayed on it. Press f11 again to stop sending keys and switch back to the controlling machine.

For best compatibility, please ensure that the keyboard layouts on both machines match.

## Sharing your session

To share a link so someone else can easily join your TeleNVDA session, select Copy Link from the Remote menu. You can also assign gestures from the NVDA Input Gestures dialog to speed up this task.

You can choose between two link formats. First one is compatible with both NVDA Remote and TeleNVDA, and is the most recommended for now. Second one is compatible only with TeleNVDA.

IF you are connected as the controlling computer, this link will allow someone else to connect and be controlled.

If instead you have set up your computer to be controlled, the link will allow people who you share it with to control your machine.

Many applications will allow users to activate this link automatically, but if it does not run from within a specific app, it can be coppied to the clipboard and run from the run dialog.

Note that the shared link may not work if you copy it from a server running in direct connection mode.

## Send Ctrl+Alt+Del

While sending keys, it is not possible to send the CTRL+Alt+del combination normally.

If you need to send CTRL+Alt+del, and the remote system is on the secure desktop, use this command.

## Send toggle key between local and remote computer

Usually when you press the assigned gesture to switch between the local and the remote machine, it won't be sent to the remote machine; it will switch between the local machine and the remote machine instead.

If you need to send this or any gesture to the remote machine, you can override this behavior for the next immediate gesture by activating the ignore next gesture script.

By default, this script is assigned to the control + f11 key. This gesture can be changed from NVDA Input Gestures Dialog.

When this script is called, the next gesture will be ignored and will be sent to the remote machine, including the gesture to activate the ignore next gesture script. Once the next gesture has been sent, it will return to the usual behavior.

## Remotely Controlling an Unattended Computer

Sometimes, you may wish to control one of your own computers remotely. This is especially helpful if you are traveling, and you wish to control your home PC from your laptop. Or, you may want to control a computer in one room of your house while sitting outside with another PC. A little advanced preparation makes this convenient and possible.

1. Enter the NVDA menu, and choose Tools, then Remote. Finally, press Enter on Options.
2. Check the box that says, "Auto connect to control server on startup".
3. Select whether to use a remote relay server or to locally host the connection. If you decide to host the connection, you can try to forward ports using UPNP by checking the provided checkbox.
4. Select Allow this machine to be controlled in the second set of radio buttons.
5. If you host the connection yourself, you will need to ensure that the port entered in the port field (6837 by default) on the controlled machine can be accessed from the controlling machines.
6. If you wish to use a relay server, Fill in both the Host and Key fields, tab to OK, and press Enter. The Generate Key option is not available in this situation. It is best to come up with a key you will remember so you can easily use it from any remote location.

For advanced use, you can also configure NVDA Remote to automatically connect to a local or remote relay server in controlling mode. If you want this, select Control another machine in the second set of radio buttons.

Note: The autoconnect at startup-related options in the options dialog do not apply until NVDA is restarted.

## Muting Speech on the Remote Computer

If you do not wish to hear the remote computer's speech or NVDA specific sounds, simply access the NVDA menu, Tools, and Remote. Arrow down to Mute Remote, and press Enter. Please note that this option will not disable remote braille output to the controlling display when the controlling machine is sending keys.

## Ending a remote Session

To end a remote session, do the following:

1. On the controlling computer, press F11 to stop controlling the remote machine. You should hear or read the message: "Controlling local machine." If you instead hear or read a message that you are controlling the remote machine, press F11 once more.
2. Access the NVDA menu, then Tools, Remote, and press Enter on Disconnect.

Alternatively, you can press NVDA+alt+page down to directly disconnect the session. This gesture can be changed from NVDA Input Gestures Dialog. To keep the other end safe, you may press this gesture while sending keys to disconnect the remote computer.

## Push clipboard

The Push clipboard option in the remote menu allows you to push text from your clipboard.

When activated, any text on the clipboard will be pushed to the other machines.

## Sending files

The Send file option in the remote menu allows you to send small files to all session members, including the controlled machine. Please note, you can only send files smaller than 10 MB. Sending or receiving files on secure screens is not allowed.

Also note that sending files may consume too much network traffic on the server, depending on the file size, the computers connected to the same session and the amount of files sent. Contact your server administrator and ask them if the traffic is billed. In that case, consider using another platform to exchange files.

When the file is received on the remote machines, a Save as dialog will pop up, allowing you to choose where to save the file.

## Configuring TeleNVDA to Work on a Secure Desktop

In order for TeleNVDA to work on the secure desktop, the addon must be installed in the NVDA running on the secure desktop.

1. From the NVDA menu, select Preferences, then General Settings.
2. Tab to the Use Currently Saved Settings on the Logon and Other Secure Screens (requires administrator privileges) button, and press Enter.
3. Answer Yes to the prompts regarding copying your settings and about copying plugins, and respond to the User Account Control prompt that may appear.
4. When settings are copied, press Enter to dismiss the OK button. Tab to OK and Enter once more to exit the dialog.

Once TeleNVDA is installed on the secure desktop, if you are currently being controlled in a remote session, you will have speech and braille access to the secure desktop when switched to.

## Clearing SSL certificate fingerprints

If you no longer want to trust the server fingerprints you've trusted, you can clear all of the trusted fingerprints by pressing the "Delete all trusted fingerprints" button in the Options dialog.

## Using a custom portcheck service

By default, TeleNVDA checks open ports using a service provided by the NVDA spanish community. You can change the service URL from the options dialog. Ensure that the port to check is part of the custom URL and the results are returned in the expected format. A portcheck sample script is distributed in TeleNVDA repository, so you can host your own copy if desired.

## Altering TeleNVDA

This project is covered by the GNU General Public License, version 2 or later. You may clone [this repo][2] to make alteration to TeleNVDA, provided that you read, understand and respect the license terms. The MiniUPNP module is licensed under a BSD-3 clause license.

### 3rd Party dependencies

These can be installed with pip:

* Markdown
* scons

In order to build the URL handler executable, you need Visual Studio 2019 or later.

### To package the add-on for distribution:

1. Open a command line, change to the root of [this repo][2]
2. Run the **scons** command. The created add-on, if there were no errors, is placed in the current directory.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
