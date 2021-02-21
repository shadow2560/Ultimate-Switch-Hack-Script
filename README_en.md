# Ultimate-Switch-Hack-Script

This is a set of batch scripts that automates many things.

The GPL V3 license applies to the batch scripts at the root of this project, the translation scripts as well as the "tools/python3_scripts/ssnc/serials.json.safe" file, the "tools/python3_scripts/ssnc/serials.json.beta" file, the "tools\python3_scripts\Keys_management\keys_management.py" file and all files in the "tools\Storage" folder of this project. For the rest, the licenses specific to the software concerned apply.

## Features:

<ul>
<li>Possibility of automatic updating of scripts/functionalities.</li>
<li>Multi-language support.</li>
<li>Installation of the RCM mode drivers ( "APX" driver) and the libnx_USB_comms mode used by Tinfoil ( "libnx_USB_comms" driver) of the Switch, see the documentation  for more informations.</li>
<li>Launching a payload via the RCM mode of the Switch. You can place the payloads in a "Payloads" folder located at the root of this script or choose a payload file via an explorer. Note that the Switch's RCM mode drivers must be installed for this to work.</li>
<li>Preparations to be able to use <a target="_blank" href="https://github.com/pixel-stuck/nereba">the Nereba exploit</a>, thanks to <a target="_blank" href="https://github.com/reswitched/pegaswitch">Pegaswitch</a>. The Caffeine exploit can also be used via this method.</li>
<li>Help to install Switchboot on modchips and some UF2 dongles; and some other functions linked to the modchips.</li>
<li>Installation of applications on Android via the USB debug mode of Android.</li>
<li>Management of a toolbox allowing to launch software in autonomous mode with the possibility to manage a list of personal software. It should be noted that the programs can be integrated into the "tools\toolbox" folder of the script, which allows you to have a portability option if you wish. Finally, avoid modifying the toolbox configuration files by hand, prefer the script.</li>
<li>Obsolete: Launching Linux via the Switch's RCM mode (either with the official kernel, or via <a target="_blank" href="https://gbatemp.net/attachments/image-gz-zip.121538/">a patched kernel</a> (thanks Krazer89 from GBATemp and Killua from Logic-sunrise for the info) for SDs not compatible with the official kernel), or with a  kernel file that you can select via a file explorer. Note that the Switch's RCM mode drivers must be installed for this to work.</li>
<li>Obsolete: Downloading/updating Shofel2 binaries.</li>
<li>Biskey retrieval thanks to the Biskeydump payload in the "biskey.txt" file which will be located at the root of the script (biskeys start at line 7 of the file). Note that the Switch's RCM mode drivers must be installed for this to work.</li>
<li>Check if a console is patched, can be patched or not patched.</li>
<li>Mounting the Boot0, Boot1, EMMC or SD card partition as a USB storage device on the PC.</li>
<li>Nand management (file or physical disk) to get information about the nand, dump the nand or a specific partition of it or restore a nand dump or a dumped partition. Note that for these features using a physical disk you will need to mount the part of the nand you want to work on via Memloader, the script to do this is integrated.</li>
<li>Reunification of the files of a nand dump performed by Hekate or SX OS on an SD formatted in FAT32 or on an SD too small to host the dump at once in a "rawnand.bin" file that can then be reused to restore the nand.</li>
<li>Split a dump of the rawnand that could be used by the emunand of Atmosphere.</li>
<li>Creation of a file from a complete dump of the nand allowing to prepare the emunand on a dedicated partition of the SD.</li>
<li>Creation of update packages via ChoiDuJour with all parameters.</li>
<li>Downloading a firmware and preparing the SD with it for ChoiDuJourNX or Daybreak, the homebrew is also copied during this script. This script also allows you to create the update package via ChoiDuJour in the process. To know how to use ChoiDuJourNX, you can refer to the documentation.</li>
<li>Checking a key file ( "prod.keys", "keys.txt", "keys.dat", etc.).</li>
<li>Preparation of an SD, from formatting (FAT32 or EXFAT) to the implementation of different solutions, see the documentation for more informations on the content of the packs.</li>
<li>Creating sig_patches for Atmosphere.</li>
<li>Simplified unbricking functions.</li>
<li>Repairing a BOOT0 file witch have corrupted keyblobs (the concerned console keys mendatory).</li>
<li>Launch of NSC_Builder. This script is useful for converting XCIs or NSPs to XCIs or NSPs. Files converted via this script are cleaned and made, in theory, undetectable by Nintendo, especially for NSPs. Finally, this script also allows you to create NSPs or XCIs containing the game, its updates and DLCs in a single file. For more information, see <a target="_new" href="https://github.com/julesontheroad/NSC_BUILDER">this page</a>.</li>
<li>Conversion of XCI files to NSP.</li>
<li>Conversion of an NSP file to make it compatible with the lowest possible switch firmware.</li>
<li>Installation of NSP via Goldleaf and the network.</li>
<li>Backup, restore and reset important files used by the script.</li>
<li>Verification of the NSPs.</li>
<li>Converting a Zelda Breath Of The Wild backup from Wii U format to Switch or vice versa.</li>
<li>Extraction of the certificate from a console via the decrypted "PRODINFO.bin" file.</li>
<li>Installation of NSP via Goldleaf via USB.</li>
<li>Cutting of NSP or XCI to be able to put them on an SD formatted in FAT32.</li>
<li>Launch of the necessary to play online on the alternative network, see the documentation for more information. A list of servers can also be created.</li>
<li>Creation and launch of a personal server for Switch-Lan-Play.</li>
<li>Launch of the companion for the HID_mitm module.</li>
<li>Using NSZip to compress/uncompress games.</li>
<li>Configuration of the Nes Classic Edition and Snes Classic Edition emulators.</li>
<li>Extract files from a Switch gamesave.</li>
<li>And more...</li>
</ul>

## Known bugs:

<ul>
<li>The Nes Classic Edition and Snes Classic Edition configuration scripts display all games that can only be played by one player, so this must be manually fixed in the emulator's game configuration file for now.</li>
<li>The use of quotation marks and a few other signs in the user entries causes the script to crash.</li>
<li>When a console output made by an "echo" is performed, it produces an error in the log file. UTF-8 encoding seems to be the cause of this problem but I haven't found a way to solve it yet.</li>
<li>The biskey dump also retrieves the result of the TegraRcmSmash program, the bis keys starts from line 7 of the file.</li>
</ul>

## Download:

You can download the last base version on <a target="_blank" href="https://github.com/shadow2560/Ultimate-Switch-Hack-Script/releases">this page</a> (the functions used will be added during their use) or you can the last full version of the project by <a href="https://github.com/shadow2560/Ultimate-Switch-Hack-Script/archive/master.zip">clicking here</a>.

## Credits:

There are really too many people to thank for all the projects included in this script but I thank each contributor of these projects because without them this script could not even exist (some are credited in the documentation or on <a href="https://github.com/shadow2560/Ultimate-Switch-Hack-Script/blob/master/credits.md">this page</a>). I also thank all those who help me to test the scripts and those who suggest new features.

## Changelogs:

For the script's changelog, see <a href="https://github.com/shadow2560/Ultimate-Switch-Hack-Script/blob/master/changelog_en.md">this page</a> and for the packs changelog, see <a href="https://github.com/shadow2560/Ultimate-Switch-Hack-Script/blob/master/packs_changelog_en.md">this page</a>.