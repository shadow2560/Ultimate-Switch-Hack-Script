# -*- coding: UTF-8 -*-
# addonHandler.py
# A part of NonVisual Desktop Access (NVDA)
# Copyright (C) 2012-2023 Rui Batista, NV Access Limited, Noelia Ruiz Martínez, Joseph Lee
# This file is covered by the GNU General Public License.
# See the file COPYING for more details.

# Proof of concept implementation of NVDA Core issue 3208.

from __future__ import annotations
from typing import Optional
import os
import threading
import concurrent.futures
import wx
import addonHandler
import extensionPoints
from logHandler import log
from . import addonUtils
from . import addonUpdateProc
from .addonUpdateProtocols import AvailableUpdateProtocols
addonHandler.initTranslation()


# Add-ons with all features integrated into NVDA or declared "legacy" by authors.
# For the latter case, update check functionality will be disabled upon authors' request.

# Translators: legacy add-on, features included in NVDA.
LegacyAddonIncludedInNVDA: str = _("features included in NVDA")
# Translators: legacy add-on, declared by add-on developers.
LegacyAddonAuthorDeclaration: str = _("declared legacy by add-on developers")

LegacyAddons: dict[str, str] = {
	# Bit Che is no longer maintained as of 2021, therefore the add-on is unnecessary, according to the author.
	"bitChe": LegacyAddonAuthorDeclaration,
	"enhancedAria": LegacyAddonIncludedInNVDA,
	# Advanced focus highlight customizations are not implemented in NVDA yet,
	# but legacy add-on in terms of functionality.
	"focusHighlight": LegacyAddonIncludedInNVDA,
	"screenCurtain": LegacyAddonIncludedInNVDA,
	# Team Viewer is no longer used by the add-on author.
	"teamViewer": LegacyAddonAuthorDeclaration,
}


def shouldNotUpdate() -> list[str]:
	# Returns a list of descriptions for add-ons that should not update.
	return [
		addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in addonUtils.updateState["noUpdates"]
	]


def preferDevUpdates() -> list[str]:
	# Returns a list of descriptions for add-ons that prefers development releases.
	return [
		addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in addonUtils.updateState["devUpdates"]
	]


def detectLegacyAddons() -> dict[str, str]:
	# Returns a dictionary of add-on name and summary for legacy add-ons.
	return {
		addon.name: addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in LegacyAddons
	}


def autoAddonUpdateCheck() -> None:
	t = threading.Thread(target=_showAddonUpdateUI)
	t.daemon = True
	t.start()


# Only stored when update toast appears.
_updateInfo: Optional[list[addonUpdateProc.AddonUpdateRecord]] = None
updateSuccess = extensionPoints.Action()
updateSources: dict[str, str] = {protocol.key: protocol.description for protocol in AvailableUpdateProtocols}


def _showAddonUpdateUI() -> None:
	def _showAddonUpdateUICallback(info: Optional[list[addonUpdateProc.AddonUpdateRecord]]) -> None:
		import gui
		from .addonGuiEx import AddonUpdatesDialog
		gui.mainFrame.prePopup()
		AddonUpdatesDialog(gui.mainFrame, info).Show()
		gui.mainFrame.postPopup()
	try:
		info = addonUpdateProc.checkForAddonUpdates()
	except:
		info = None
		raise
	if info is not None and len(info):
		# Show either the update notification toast (Windows 10 and later),
		# the results dialog (other Windows releases and server systems),
		# or download add-ons if background updating is on (Windows 10 and later).
		# On Windows 10 and later (client versions), this behavior is configurable.
		# If toast is shown, checking for add-on updates from tools menu will merely show the results dialog.
		# wxPython 4.1.0 (and consequently, wxWidges 3.1.0) simplifies this by
		# allowing action handlers to be defined for toasts, which will then show the results dialog on the spot.
		# However it doesn't work for desktop apps such as NVDA,
		# and in case of NVDA, it sort of works if it is actually installed.
		import config
		if (
			addonUtils.isWin10ClientOrLater()
			and addonUtils.updateState["updateNotification"] == "toast"
			and config.isInstalledCopy()
		):
			# To reduce intrusiveness, background updates notification will be shown.
			global _updateInfo
			if not addonUtils.updateState["backgroundUpdate"]:
				# Translators: menu item label for reviewing add-on updates.
				updateSuccess.notify(label=_("Review &add-on updates ({updateCount})...").format(updateCount=len(info)))
				updateMessage: str = _(
					# Translators: presented as part of add-on update notification message.
					"One or more add-on updates from {updateSource} are available. "
					"Go to NVDA menu, Tools, Review add-on updates to review them."
				).format(updateSource=updateSources[addonUtils.updateState["updateSource"]])
			else:
				# Ignore all this if all add-ons to be updated are disabled.
				if all([not addon.isEnabled for addon in info]):
					return
				updateMessage = _(
					# Translators: presented as part of add-on update notification message.
					"One or more add-on updates from {updateSource} are being downloaded and installed."
				).format(updateSource=updateSources[addonUtils.updateState["updateSource"]])
			# Translators: title of the add-on update notification message.
			wx.adv.NotificationMessage(_("NVDA add-on updates"), updateMessage).Show(timeout=30)
			if addonUtils.updateState["backgroundUpdate"]:
				threading.Thread(target=downloadAndInstallAddonUpdates, args=[info]).start()
				return
			_updateInfo = info
		else:
			wx.CallAfter(_showAddonUpdateUICallback, info)


_backgroundUpdate: bool = False


# Download and install add-ons in the background.
def downloadAndInstallAddonUpdates(addons: list[addonUpdateProc.AddonUpdateRecord]) -> None:
	import tempfile
	import globalVars
	global _updateInfo, _backgroundUpdate
	# Disable GUI (enable minimal flag) for the duration of this function.
	minimal = globalVars.appArgs.minimal
	globalVars.appArgs.minimal = True
	downloadedAddons: list[tuple[str, addonUpdateProc.AddonUpdateRecord]] = []
	for addon in addons:
		# Skip background updates for disabled add-ons.
		if not addon.isEnabled:
			log.debug(f"nvda3208: {addon.summary} is disabled, skipping")
			addons.remove(addon)
	# Are there updates with disabled add-ons removed?
	if not len(addons):
		return
	# By default, Python 3.7 sets max workers to five times number of processors/cores, wasting resources.
	# Therefore, use Python 3.8 formula ((core count + 4) or 32, whichever is smaller).
	# See if resource usage can be minimized if downloading few add-on packages.
	# Safely ignore os.cpu_count type issue.
	workers = min(len(addons), os.cpu_count() + 4, 32)  # type: ignore[operator]
	with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as downloader:
		downloads = {}
		for addon in addons:
			destPath: str = tempfile.mktemp(prefix="nvda_addonUpdate-", suffix=".nvda-addon")
			log.debug(f"nvda3208: downloading {addon.summary}, URL is {addon.url}, destpath is {destPath}")
			downloads[downloader.submit(
				addonUpdateProc.downloadAddonUpdate, addon.url, destPath, addon.hash
			)] = [destPath, addon]
		for download in concurrent.futures.as_completed(downloads):
			destPath, addon = downloads[download]
			log.debug(f"nvda3208: downloading {addon.summary}")
			try:
				download.result()
			except RuntimeError:
				log.debug(f"nvda3208: failed to download {addon.summary}", exc_info=True)
			else:
				downloadedAddons.append((destPath, addon))
	successfullyInstalledCount: int = 0
	# Gather successful update records for presentation later.
	_updateInfo = []
	for entry in downloadedAddons:
		log.debug(f"nvda3208: installing {entry[1].summary} from {entry[0]}")
		installStatus: int = addonUpdateProc.installAddonUpdate(entry[0], entry[1].summary)
		if installStatus == addonUpdateProc.AddonInstallStatus.AddonInstallSuccess:
			successfullyInstalledCount += 1
			_updateInfo.append(entry[1])
		log.debug(f"nvda3208: add-on install status is {installStatus}")
		try:
			os.remove(entry[0])
		except OSError:
			pass
	log.debug(f"nvda3208: install success count: {successfullyInstalledCount}")
	# Restore minimal flag.
	globalVars.appArgs.minimal = minimal
	# Now present review add-on updates notification if add-ons were installed.
	if successfullyInstalledCount:
		updateSuccess.notify(label=_("Review &add-on updates ({updateCount})...").format(
			updateCount=successfullyInstalledCount
		))
		updateMessage: str = _(
			# Translators: presented as part of add-on update notification message.
			"One or more add-on updates from {updateSource} were installed. "
			"Go to NVDA menu, Tools, Review add-on updates to review them. "
			"Then restart NVDA to finish updating add-ons."
		).format(updateSource=updateSources[addonUtils.updateState["updateSource"]])
		_backgroundUpdate = True
	else:
		# Translators: presented as part of add-on update notification message.
		updateMessage = _("Could not update add-ons.")
	wx.adv.NotificationMessage(_("NVDA add-on updates"), updateMessage).Show(timeout=30)
