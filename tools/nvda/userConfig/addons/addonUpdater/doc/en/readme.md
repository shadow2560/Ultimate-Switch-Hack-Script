# Add-on Updater

* Author: Joseph Lee, Luke Davis
* Download [stable version][1]
* NVDA compatibility: 2023.1 and later

This add-on brings NVDA Core issue 3208 to life: ability to check for, download, and apply add-on updates.

To check for updates after installing this add-on, go to NVDA menu/Tools/Check for add-on updates (if NVDA did notice updates, the menu item will say "Review add-on updates" followed by update count). If updates are available, a list of add-on updates will be shown, with each entry consisting of description, current version, and the new version. Select Update, and NVDA will download and apply updates in sequence, with a prompt to restart your NVDA shown afterwards.

The following add-ons provide built-in update feature and thus updates will not be checked via this add-on:

* Braille Extender
* Tienda NVDA (Spanish NVDA Community Store)

IMPORTANT NOTES:

* This is a proof of concept add-on. Once the [relevant feature is included in NVDA][2] in the form of [an add-on store][3], this add-on will be discontinued.
* This add-on is not intended to be used in secure screens. If you have add-ons installed in the secure screen, even if you copy Add-on Updater to secure screen mode, Add-on Updater will not work.
* If the new add-on updates specify a compatibility range (minimum and last tested NVDA versions) and if the NVDA version you are running does not fall within the compatibility range according to NVDA, add-on updating will not proceed.
* Not all add-ons come with development releases. If you are not getting updates after choosing to install development versions of an add-on, switch to stable channel for affected add-ons.
* On some systems (particularly computers joined to a corporate domain), add-on update check functionality may not work properly, therefore add-on updates must be downloaded manually.
* Some features require NVDA to be installed on the computer, ideally on a computer running Windows 10 or later.
* Some add-on releases include SHA256 hash values for checking add-on package integrity, and if the hash value does not match, add-on updating will fail.

## Add-on settings

You can configure Add-on Updater settings from NVDA Settings screen (NVDA menu, Preferences, Settings) under Add-on Updater category. Add-on settings are as follows:

* Automatically check for add-on updates: if checked, NVDA will check for add-on updates once a day. Automatic update checks is enabled on Windows client systems and disabled on server systems.
* Add-on update notification (Windows 10 and later): you can choose to receive update notification as a dialog or a toast. On Windows releases earlier than 10 and on server systems, or running portable copy of NVDA, update notification will be shown as a dialog.
* Update add-ons in the background (Windows 10 and later and update notification is set to toast): if checked, Add-on Updater will apply updates in the background. A toast will appear informing you that add-on updates are being downloaded and installed, followed by another message announcing update results. Same limitations as add-on update notification setting and toast must be selected from the above option in order for background updates to work.
* Do not update add-ons: you can choose add-ons that should not be updated.
* Prefer development releases: any add-ons checked in this list will receive development (prerelease) releases.
* Development release channel (selected add-on must be checked from prefer development releases): allows selecting development updates coming from either dev or beta channel.
* Add-on update source: you can choose where to get updates from. Currently Add-on Updater supports downloading updates from the sources listed below. A confirmation message will be shown after changing update source.

The available add-on update sources are:

* NV Access add-on store (default)
* Community add-ons website
* Spanish community add-ons catalog
* Catalogs maintained by NVDA communities in China and Taiwan

## Version 23.06

* NVDA 2023.1 or later is required.
* Changed default add-on update source from community add-ons website to NV Access add-on store.

## Version 23.05

* Add-on update channel will be displayed when reviewing available add-on updates.
* NVDA will present a message about add-on store if using NVDA releases with add-on store included.

## Version 23.04

* Added development update channel setting to let users of development add-ons choose between dev and beta update channels. This option is shown if the selected add-on from prefer development releases list is checked.
* NV Access add-on store is broadly available as an update source from Add-on Updater.

## Version 23.03

* Due to changes made to the website used by some update sources, this must be installed manually.
* Added NV Access add-on store as an experimental add-on update source.

## Version 23.02

* NVDA 2022.4 or later is required.
* NVDA will no longer offer what appears to be older add-on updates for most add-ons after checking for add-on updates. This applies to add-ons with version text of the form number.number.

## Version 23.01

* NVDA will check minimum Windows version for add-on updates if update source is set to NVDA community add-ons website.
* Improved performance when downloading many ad-on updates at once. As a result, the order of add-on downloads shown in download progress dialog will be random.
* Parts of the add-on now use Python's concurrent.futures module to improve performance, specifically update check and download processes.

## Version 22.11

* NVDA 2022.3 or later is required.

## Version 22.10

* Added catalogs from NVDA communities in China and Taiwan as add-on update sources (by Woody Tseng).

## Version 22.09

* NVDA 2022.2 or later is required.
* NVDA will check SHA256 hash values while downloading add-on updates if the add-on update source includes hash values for add-on packages. If hash value is invalid, add-on updating will fail.

## Version 22.08

* Significant internal code reorganization and rewrites.
* On Windows Server systems, automatic add-on update check feature is disabled by default (affects new installations).
* Added ability to select different add-on update sources. Add-on Updater can check for updates hosted on community add-ons website (addons.nvda-project.org) or Spanish community add-ons catalog (nvda.es). A new combo box was added in add-on settings panel to select add-on update source.
* On Windows 10 and later, it is possible to let Add-on Updater check for, download, and install add-on updates in the background provided that NVDA is actually installed and ad-on update notification is set to toast.
* Redesigned add-on update download and install experience for multiple add-on updates, including use of a single dialog to show download progress for all add-ons and updating add-ons after downloading all of them.
* If NVDA is set to announce update notifications as toasts, "check for add-on updates" menu item will become "review add-on updates" when updates become available, with the new name including add-on update count.
* In NVDA 2022.1 and later, Add-on Updater can process command-line switches for this add-on (currently none).
* In add-on updates dialog, add-ons disabled by the user are unchecked by default, and a confirmation message will be shown checking disabled add-ons and attempting to update them as doing so will enable them.

## Version 22.07

* URL's used by the add-on are now constants hosted inside a new module (contributed by Luke Davis).
* Add-on download progress dialog is now centered on screen.


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

* On Windows 10 and later, a toast notification will be shown when add-on updates are available. Note that you cannot click this notification - you must open NVDA menu/Tools/Check for add-on updates to review updates.
* When legacy add-ons dialog is shown at startup, you can now review legacy add-ons and reasons just like add-on updates.
* Improved add-on update check internals, including use of add-on metadata collection provided by the community to validate add-on compatibility. Among other things, this eliminates add-on releases for adding update checks for new add-ons.

## Version 21.05

* NVDA will no longer play error tones if trying to check updates while using NVDA 2021.1 alpha snapshots, caused by changes to wxPython GUI toolkit.

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

[1]: https://www.nvaccess.org/addonStore/legacy?file=addonUpdater

[2]: https://github.com/nvaccess/nvda/issues/3208

[3]: https://github.com/nvaccess/nvda/pull/13985
