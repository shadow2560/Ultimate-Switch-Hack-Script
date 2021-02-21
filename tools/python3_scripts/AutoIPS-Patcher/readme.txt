Scripts rewrite by shadow256

This is a little improvement of an existing set of python scripts to create sig_patches for Atmosphere by yourself.

For loader patches, put the "fusee-primary.bin" file on root of this program.

For ES and FS patches, put the firmware you want to make the patches in a folder named "firmware" in root of this program and put a "keys.dat" file containing all the last keys of the Switch in the "scripts" folder.

You can also choose to use custom paths in the menu if you want.

To launch this script, use python 3.X to launch "menu.py", with a command line this could be:
path_to_python3.X\python.exe .\menu.py

Credits for Hactool, Hactoolnet and the originals set of python scripts goes to:
https://github.com/SciresM/hactool
https://github.com/Thealexbarney/LibHac/releases
https://gbatemp.net/threads/autoips-sig-patcher.574126/