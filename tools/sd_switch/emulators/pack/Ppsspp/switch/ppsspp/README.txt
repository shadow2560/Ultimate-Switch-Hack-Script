PPSSPP Standalone Switch Public Beta by m4xw
============================================

This is the first Standalone Release for PPSSPP.

It's based on my libretro port with some few distinctions:
-Includes a GLES2 and GL version (use GLES2 for GTA's or other troubling games, otherwise GL version is always recommended as it's far more stable and bug free).
-JIT improvements (should now work on all Horizon version), masking is no longer required, thus JIT masking bugs are a thing of the past (will be backported to the libretro ver. this week).
-All config files reside in /switch/ppsspp/, the path can not be changed for the time being.
-You can copy your PPSSPP files from /retroarch/cores/savefiles/PPSSPP/ (savefiles are compatible, savestates are NOT, however I will add a export option to the Core soon-ish).

Note:
-Due to a toolchain Issue, starting like 15~ games in a row might lead to a crash, your mileage might vary depending of the number of JIT buffer allocations

Installation Instructions
============================================
Drag & drop the switch folder to the root of your SD, overwriting every file.
If you don't copy my controls.ini, you will need to remap your controls as it defaults to keyboard values.
Assets are bundled, so you don't have to bother with that.

DO NOT USE ALBUM. I REPEAT: DO NOT USE ALBUM.

Notes
============================================

-If you are using ANY method of loading PPSSPP OTHER than Atmosphere's title redirection feature, DO NOT report issues that you encounter.
-Don't use NSP's.
-After upstreaming, this port will likely become the official

Support
============================================
Special thanks to hrydgard for everything he has done for the PPSSPP Project.
If you want to support his work, consider buying PPSSPP Gold https://central.ppsspp.org/buygold even if you don't use it!

My Patreon: https://www.patreon.com/m4xwdev

Links
============================================
Switch Port Github: https://github.com/m4xw/ppsspp/
Upstream Github: https://github.com/hrydgard/ppsspp

Changelog
============================================
-Fixed "Home" Button in PPSSPP (Not the Switch Home button)
-Fixed in-game menu continue after Settings open (might not properly refresh some GPU settings, but said refresh caused the Issue)
-Fixed the 10th launch Issue
-Fixed CurrentDirectory (you might need to manually edit the ini if it isn't created new)
-Fixed Recent launched games (clear old entries!)
-Bundled controls.ini / Drag & Drop Bundle (careful if you don't want to lose your own mappings)
-Added "fake GLES2" -> Performs way better in GTA's, however breaks many other games if internal res > 1x
-Added GLES3 build -> Less Bugs, about same perf as libretro port
-Added Browser applet to some links in the Menu (because why not)
-Enabled NXLink Support (for dev/debug)
-Updated again, now one NRO resides in /switch and another in /switch/ppsspp, essentially allowing to show both NRO's in the hbmenu
If it still show's the PPSSPP folder in hbmenu, make sure that theres only 1 NRO in /switch/ppsspp (it doesn't matter which).
Both access assets, config and flash from /switch/ppsspp
-GLES3 has been replaced by GL (GL is superior in every way)
-Re-worked JIT, Masking is no longer required, thus there should be no more JIT bugs that desktop standalone / Lakka don't have (this change will be added to libretro too next week)
-However doing this we have less space to work with due to a libnx bug (virtmem stopping working), so it might crash if you launch ~15 games in a row without returning to hbmenu / home menu.
That number will vary depending on how much memory the jit buffer allocate depending on the Game
-Add some other JIT sanity checks + fixes
-The GL version should be pretty much on par with standalone- while the GLES2 ver has a few more gfx Issues but better perf in some games (most of them are GTA's)
-General system stability improvements to enhance the user's experience.
-Fixed Homebrew store
-Fixed Ad-Hoc Multiplayer and Server
-Updated libnx, full 9.0.0 support
-Rebased to Latest Upstram 11.03.2020
^-This fixes some recent regressions and remote iso loading for Switch!

-Rebased to latest upstream, v1.10.3
-Improved stability of Feedback reports + timeout
-Reworked JIT Integration, now uses writeable pointer for code output (recently introduced upstream for the Switch PR)
^-Should fix all remaining JIT Issues!
-Fixed build without miniUPNP library / Fixes for PortManager
-Improved UI Scaling
