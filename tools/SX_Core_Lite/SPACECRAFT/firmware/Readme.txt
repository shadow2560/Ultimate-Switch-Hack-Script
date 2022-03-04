HWFLY firmware 0.6.2

Changelog:

0.6.2
 - add led pattern to indicate all attempts exhausted (red pulsing)
 - improve reflashing check
 - glitch mechanism: move on slightly faster to next known offset
 - no need to update if your device trained fine

0.6.1
 - glitching mechanism improvement: do not reset pulse width initial training but adjust until correct
 - no need to update if your device trained fine

0.6.0
 - redesigned glitching mechanism; should be faster and more reliable
 - redesigned LED patterns provides clear diagnostics for error scenarios and process progress
 - updated SDloader payload. If SDcard unreadable, press VOL UP & VOL DOWN to boot OFW.
 - added support for SX Core & SX Lite modchips
 

Update is possible in 3 ways.

a) Using USB bootloader (preferred)
 1. Fully power of console.
 2. Insert USB cable. Take extreme caution not to insert incorrectly, this fully kills USB functionality on the chip.
 3. Run flash.bat. This updates both bootloader and firmware.
 4. Remove USB cable.
 5. Power on console.
 
a) Using hwfly-toolbox
This method does not require opening device, but it cannot flash the bootloader.
LED patterns in bootloader will not correspond with documented ones.

 1. Obtain hwfly toolbox from https://github.com/hwfly-nx/hwfly-toolbox/releases
 2. Place hwfly_toolbox.bin in sdcard:/bootloader/payloads/.
 3. Boot switch into hekate, then run hwfly_toolbox.bin payload.
 4. Update SD loader from toolbox menu.
 5. Power off console from menu.
 6. Place firmware.bin and sdloader.enc from hwfly firmware into sdcard root. Do not do so earlier.
    If you have previously flashed a beta firmware, also create empty file .force_update in sdcard root.
 7. Put SD in switch and power on while holding VOL+ (verify: modchip green light keep pulsing while hekate loads).
 7. Run hwfly_toolbox from hekate again.
 8. Update firmware from menu.
 9. Reboot & done.


  
After initial training (up to 5 minutes), modchip is ready.


Note: this will not allow unflashable chips to become flashed. Unflashable ones have a BGA FPGA IC on the board. Flashable ones use a QFN FPGA.