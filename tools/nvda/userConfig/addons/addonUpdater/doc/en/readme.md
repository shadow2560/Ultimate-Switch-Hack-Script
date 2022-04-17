# Add-on Updater

* Author: Joseph Lee
* Download [stable version][1]
* NVDA compatibility: 2021.3 and later

This add-on brings NVDA Core issue 3208 to life: ability to check for, download, and apply add-on updates.

To check for updates after installing this add-on, go to NVDA menu/Tools/Check for add-on updates. If updates are available, a list of add-on updates will be shown, with each entry consisting of description, current version, and the new version. Select Update, and NVDA will download and apply updates in sequence, with a prompt to restart your NVDA shown afterwards.

The following add-ons provide built-in update feature and thus updates will not be checked via this add-on:

* Braille Extender
* WeatherPlus

IMPORTANT NOTES:

* This is a proof of concept add-on. Once the [relevant feature is included in NVDA][2], this add-on will be discontinued.
* This add-on is not intended to be used in secure screens. If you have add-ons installed in the secure screen, even if you copy Add-on Updater to secure screen mode, Add-on Updater will not work.
* If the new add-on updates specify a compatibility range (minimum and last tested NVDA versions) and if the NVDA version you are running does not fall within the compatibility range according to NVDA, add-on updating will not proceed.
* Not all add-ons come with development releases. If you are not getting updates after choosing to install development versions of an add-on, switch to stable channel for affected add-ons.
* On some systems (particularly computers joined to a corporate domain), add-on update check functionality may not work properly, therefore add-on updates must be downloaded manually.

## Version 22.03

* Improved security by not loading the add-on when NVDA is running in secure mode.

## Version 22.02

* NVDA 2021.3 or later is required.
* On Windows 10, add-on update toast notifications are localized.

## Version 22.01

* NVDA 2021.2 or later is required.
* On server systems running Windows Server 2016 and later, add-on updates will be presented in a dialog instead of using toast notifications.

## Version 21.10

* It is again possible to check for add-on updates on some systems, notably after a clean Windows installation.

## Version 21.09

* NVDA 2021.1 or later is required.
* on Windows 10 and later, it is possible to select add-on update notification between a toast message and an update dialog. This can be configured from Add-on Updater settings found in NVDA Settings screen.
* Add-on Updater will no longer check minimum Windows release information for add-ons as add-ons such as Windows App Essentials provide better Windows compatibility information.

## Version 21.07

* On Windows 10 and later, a toast notification will be shown when add-on updates are available. Note that you cannot click this notification - you must open NvDA menu/Tools/Check for add-on updates to review updates.
* When legacy add-ons dialog is shown at startup, you can now review legacy add-ons and reasons just like add-on updates.
* Improved add-on update check internals, including use of add-on metadata collection provided by the community to validate add-on compatibility. Among other things, this eliminates add-on releases for adding update checks for new add-ons.

## Version 21.05

* NvDA will no longer play error tones if trying to check updates while using NVDA 2021.1 alpha snapshots, caused by changes to wxPython GUI toolkit.

## Version 21.03

* NVDA 2020.4 or later is required.
* NVDA will present an error dialog if errors occur while checking for add-on updates such as loss of Internet connection.

## Version 20.11

* NVDA 2020.3 or later is required.
* Resolved more coding style issues and potential bugs with Flake8.
* NVDA will no longer play error tones or appear to do nothing when using the add-on while NVDA is running from source code. A message about this fact will be recorded in the log instead.

## Version 20.07

* NVDA 2020.1 or later is required.
* If one or more legacy add-ons (such as Screen Curtain) are installed, Add-on Updater will present a message asking you to disable or uninstall the add-ons listed.
* You can now save, reload, or reset Add-on Updater settings by pressing Control+NVDA+C, Control+NVDA+R once, or Control+NVDA+R three times, respectively.

## Version 20.06

* Resolved many coding style issues and potential bugs with Flake8.

## Version 20.04

* NVDA will no longer appear to do nothing or play error tones when trying to update add-ons through Add-on Updater.
* Resolved an issue where "check for add-on updates" item wasn't present in NVDA Tools menu.

## Version 20.03

* NVDA 2019.3 or later is required.
* When installing add-on updates, Add-on Updater will no longer check for compatibility range. NVDA itself will check add-on compatibility.

## Version 19.11

* When add-on updates are available, NVDA will announce how many updates are available.

## Version 19.09

* Requires NVDA 2019.2 or later.
* Timeout errors seen when attempting to download some add-on updates (notably add-on files hosted on GitHub) has been resolved.

## Version 19.04

* Requires NVDA 2019.1 or later.
* When installing add-on updates, both minimum and last tested versions will be checked.

## Version 19.01

* Requires NVDA 2018.4 or later.
* Improved responsiveness when checking for add-on updates.
* Made the add-on more compatible with Python 3.

## Version 18.12.2

* Python 3 ready.
* Fixed compatibility with recent NVDA alpha snapshots where add-on updates would not download.

## Version 18.12.1

* Added localizations.

## Version 18.12

* Updates for disabled add-ons can be checked. They will stay disabled after updating them.
* During updates, if an add-on requires specific NVDA version and/or Windows release, these will be checked, and if one of these does not match, an error message will be shown and update will be aborted, resulting in no changes to already installed add-on version.
* When automatic update check is enabled and when updates are ready, NVDA will present the updates list instead of asking if you wish to review updates.

## Version 18.10

* Initial stable release (still marked as proof of concept).

[1]: https://addons.nvda-project.org/files/get.php?file=nvda3208

[2]: https://github.com/nvaccess/nvda/issues/3208
