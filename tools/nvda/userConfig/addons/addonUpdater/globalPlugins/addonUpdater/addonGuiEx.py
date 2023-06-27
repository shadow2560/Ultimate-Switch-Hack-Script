# gui/addonGui.py
# A part of NonVisual Desktop Access (NVDA)
# This file is covered by the GNU General Public License.
# See the file COPYING for more details.
# Copyright (C) 2012-2023 NV Access Limited, Beqa Gozalishvili, Joseph Lee, Babbage B.V., Ethan Holliger

# Proof of concept user interface for add-on update dialog (NVDA Core issue 3208)

from __future__ import annotations
import os
import threading
import tempfile
import concurrent.futures
import wx
import gui
from gui import guiHelper, addonGui
from logHandler import log
import addonHandler
import extensionPoints
from gui.nvdaControls import AutoWidthColumnCheckListCtrl, AutoWidthColumnListCtrl
from .skipTranslation import translate
from . import addonUtils
from . import addonUpdateProc
from .addonUpdateProtocols import AvailableUpdateProtocols
# Temporary
addonHandler.initTranslation()

AddonUpdaterManualUpdateCheck = extensionPoints.Action()

_progressDialog = None
updateSources: dict[str, str] = {protocol.key: protocol.description for protocol in AvailableUpdateProtocols}


# The following event handler comes from a combination of StationPlaylist and Windows App Essentials.
def onAddonUpdateCheck(evt):
	from . import addonHandlerEx
	addonHandlerEx.updateSuccess.notify()
	# If toast was shown, this will launch the results dialog directly as there is already update info.
	# Update info is valid only once, and this check will nullify it.
	# Also nullify background update flag.
	if addonHandlerEx._updateInfo is not None:
		wx.CallAfter(
			AddonUpdatesDialog,
			gui.mainFrame,
			addonHandlerEx._updateInfo,
			auto=False,
			updatesInstalled=addonHandlerEx._backgroundUpdate
		)
		addonHandlerEx._updateInfo = None
		addonHandlerEx._backgroundUpdate = False
		return
	AddonUpdaterManualUpdateCheck.notify()
	global _progressDialog
	_progressDialog = gui.IndeterminateProgressDialog(
		gui.mainFrame,
		# Translators: The title of the dialog presented while checking for add-on updates.
		_("Add-on update check"),
		# Translators: The message displayed while checking for add-on updates.
		_("Checking for add-on updates from {updateSource}...").format(
			updateSource=updateSources[addonUtils.updateState["updateSource"]]
		)
	)
	t = threading.Thread(target=addonUpdateCheck)
	t.daemon = True
	t.start()


def addonUpdateCheck():
	global _progressDialog
	try:
		info = addonUpdateProc.checkForAddonUpdates()
	except:
		info = None
		wx.CallAfter(_progressDialog.done)
		_progressDialog = None
		wx.CallAfter(gui.messageBox, _("Error checking for add-on updates."), translate("Error"), wx.ICON_ERROR)
		raise
	wx.CallAfter(_progressDialog.done)
	_progressDialog = None
	wx.CallAfter(AddonUpdatesDialog, gui.mainFrame, info, auto=False)


class AddonUpdatesDialog(wx.Dialog):

	def __init__(self, parent, addonUpdateInfo, auto=True, updatesInstalled=False):
		# Translators: The title of the add-on updates dialog.
		title = _("NVDA Add-on Updates ({updateSource})").format(
			updateSource=updateSources[addonUtils.updateState["updateSource"]]
		)
		super(AddonUpdatesDialog, self).__init__(parent, title=title)
		mainSizer = wx.BoxSizer(wx.VERTICAL)
		addonsSizerHelper = guiHelper.BoxSizerHelper(self, orientation=wx.VERTICAL)
		self.addonUpdateInfo = addonUpdateInfo
		self.auto = auto
		self.updatesInstalled = updatesInstalled

		if addonUpdateInfo:
			addonUpdateCount = len(addonUpdateInfo)
			if not updatesInstalled:
				# Translators: Message displayed when add-on updates are available.
				updateText = _("Add-on updates available: {updateCount}").format(updateCount=addonUpdateCount)
			else:
				# Translators: Message displayed when add-on updates were installed.
				updateText = _("Add-ons pending install: {updateCount}").format(updateCount=addonUpdateCount)
			addonsSizerHelper.addItem(wx.StaticText(self, label=updateText))
			entriesSizer = wx.BoxSizer(wx.VERTICAL)
			# Present checkboxes if add-ons were not downloaded yet,
			# a regular list control if pending install.
			if not updatesInstalled:
				self.addonsList = AutoWidthColumnCheckListCtrl(
					self, -1, style=wx.LC_REPORT | wx.LC_SINGLE_SEL, size=(550, 350)
				)
				self.addonsList.Bind(wx.EVT_CHECKLISTBOX, self.onAddonsChecked)
			else:
				self.addonsList = AutoWidthColumnListCtrl(
					self, -1, style=wx.LC_REPORT | wx.LC_SINGLE_SEL, size=(550, 350)
				)
			self.addonsList.InsertColumn(0, translate("Package"), width=150)
			# Translators: The label for a column in add-ons updates list
			# used to identify current add-on version (example: version is 0.3).
			self.addonsList.InsertColumn(1, _("Current version"), width=50)
			# Translators: The label for a column in add-ons updates list
			# used to identify new add-on version (example: version is 0.4).
			self.addonsList.InsertColumn(2, _("New version"), width=50)
			# Translators: The label for a column in add-ons updates list
			# used to identify add-on update channel (example: stable ).
			self.addonsList.InsertColumn(3, _("Update channel"), width=50)
			entriesSizer.Add(self.addonsList, proportion=8)
			for addon in self.addonUpdateInfo:
				updateChannel = addon.updateChannel
				if updateChannel is None:
					updateChannel = "stable"
				self.addonsList.Append((addon.summary, addon.installedVersion, addon.version, updateChannel))
				if not updatesInstalled:
					# Items are unchecked by default, which should be the case for disabled add-ons.
					if addon.isEnabled:
						self.addonsList.CheckItem(self.addonsList.GetItemCount() - 1)
			self.addonsList.Select(0)
			self.addonsList.SetItemState(0, wx.LIST_STATE_FOCUSED, wx.LIST_STATE_FOCUSED)
			addonsSizerHelper.addItem(entriesSizer)
		else:
			# Translators: Message displayed when no add-on updates are available.
			addonsSizerHelper.addItem(wx.StaticText(self, label=_("No add-on update available.")))

		bHelper = addonsSizerHelper.addDialogDismissButtons(guiHelper.ButtonHelper(wx.HORIZONTAL))
		if addonUpdateInfo and not updatesInstalled:
			# Translators: The label of a button to update add-ons.
			label = _("&Update add-ons")
			self.updateButton = bHelper.addButton(self, label=label)
			self.updateButton.Bind(wx.EVT_BUTTON, self.onUpdate)
			self.onAddonsChecked(None)

		closeButton = bHelper.addButton(self, wx.ID_CLOSE, label=translate("&Close"))
		closeButton.Bind(wx.EVT_BUTTON, self.onClose)
		self.Bind(wx.EVT_CLOSE, lambda evt: self.onClose)
		self.EscapeId = wx.ID_CLOSE

		mainSizer.Add(addonsSizerHelper.sizer, border=guiHelper.BORDER_FOR_DIALOGS, flag=wx.ALL)
		self.Sizer = mainSizer
		mainSizer.Fit(self)
		self.CenterOnScreen()
		wx.CallAfter(self.Show)

	def onAddonsChecked(self, evt):
		if any([self.addonsList.IsChecked(addon) for addon in range(self.addonsList.GetItemCount())]):
			self.updateButton.Enable()
		else:
			self.updateButton.Disable()

	def onUpdate(self, evt):
		addonsToBeUpdated = []
		disabledAddonsPresent = False
		for addon in range(self.addonsList.GetItemCount()):
			if self.addonsList.IsChecked(addon):
				addonsToBeUpdated.append(self.addonUpdateInfo[addon])
				if not self.addonUpdateInfo[addon].isEnabled:
					disabledAddonsPresent = True
		# Present a messagf attempting to update at least one disabled add-on.
		if disabledAddonsPresent:
			if gui.messageBox(
				_(
					# Translators: Presented when attempting to udpate disabled add-ons.
					"One or more add-ons are currently disabled. "
					"These add-ons will be enabled after updating. "
					"Are you sure you wish to update disabled add-ons anyway?"
				),
				# Translators: Title of the add-on update confirmation dialog.
				_("Update disabled add-ons"), wx.YES | wx.NO | wx.ICON_WARNING, self
			) == wx.NO:
				return
		self.Destroy()
		# #3208: do not display add-ons manager while updates are in progress.
		# Also, Skip the below step if this is an automatic update check.
		if not self.auto:
			self.Parent.Hide()
		updateAddons(addonsToBeUpdated)

	def onClose(self, evt):
		self.Destroy()
		if self.updatesInstalled:
			wx.CallLater(100, addonGui.promptUserForRestart)


_downloadProgressDialog = None


def downloadAndInstallAddonUpdates(addons: list[addonUpdateProc.AddonUpdateRecord]) -> None:
	global _downloadProgressDialog
	downloadedAddons: list[tuple[str, str]] = []
	currentPos: int = 0
	totalCount: int = len(addons)
	# By default, Python 3.7 sets max workers to five times number of processors/cores, wasting resources.
	# Therefore, use Python 3.8 formula ((core count + 4) or 32, whichever is smaller).
	# See if resource usage can be minimized if downloading few add-on packages.
	# Safely ignore os.cpu_count type issue.
	workers = min(totalCount, os.cpu_count() + 4, 32)  # type: ignore[operator]
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
				downloadPercent: int = int((currentPos / totalCount) * 100)
				log.debug(f"nvda3208: download percent: {downloadPercent}")
				wx.CallAfter(
					_downloadProgressDialog.Update, downloadPercent,
					_("Downloading {addonName}").format(addonName=addon.summary)
				)
				wx.CallAfter(_downloadProgressDialog.Fit)
				download.result()
			except RuntimeError:
				log.debug(f"nvda3208: failed to download {addon.summary}", exc_info=True)
				gui.messageBox(
					# Translators: A message indicating that an error occurred while downloading an update to NVDA.
					_("Error downloading update for {name}.").format(name=addon.summary),
					translate("Error"),
					wx.OK | wx.ICON_ERROR)
			else:
				downloadedAddons.append((destPath, addon.summary))
			currentPos += 1
	_downloadProgressDialog.Update(100, "Downloading add-on updates")
	_downloadProgressDialog.Hide()
	_downloadProgressDialog.Destroy()
	_downloadProgressDialog = None
	gui.mainFrame.postPopup()
	if len(downloadedAddons):
		wx.CallAfter(installAddons, downloadedAddons)


def installAddons(addons: list[tuple[str, str]]) -> None:
	progressDialog = gui.IndeterminateProgressDialog(
		gui.mainFrame,
		# Translators: The title of the dialog presented while an Addon is being updated.
		_("Updating add-ons"),
		# Translators: The message displayed while an addon is being updated.
		_("Please wait while add-ons are being updated.")
	)
	successfullyInstalledCount: int = 0
	for addon in addons:
		log.debug(f"nvda3208: installing {addon[1]} from {addon[0]}")
		installStatus: int = addonUpdateProc.installAddonUpdate(addon[0], addon[1])
		log.debug(f"nvda3208: install status is {installStatus}")
		# Handle errors first.
		if installStatus == addonUpdateProc.AddonInstallStatus.AddonReadBundleFailed:
			gui.messageBox(
				# Translators: The message displayed when an error occurs
				# when trying to update an add-on package due to package problems.
				_("Cannot update {name} - missing file or invalid file format").format(name=addon[1]),
				translate("Error"),
				wx.OK | wx.ICON_ERROR
			)
		elif installStatus in (
			addonUpdateProc.AddonInstallStatus.AddonMinVersionNotMet,
			addonUpdateProc.AddonInstallStatus.AddonNotTested
		):
			# NVDA itself will check add-on compatibility range.
			# As such, the below fragment was borrowed from NVDA Core (credit: NV Access).
			# Assuming that tempfile is readable, open the bundle again
			# so NVDA can actually show compatibility dialog.
			bundle = addonHandler.AddonBundle(addon[0])
			if installStatus == addonUpdateProc.AddonInstallStatus.AddonMinVersionNotMet:
				addonGui._showAddonRequiresNVDAUpdateDialog(gui.mainFrame, bundle)
			elif installStatus == addonUpdateProc.AddonInstallStatus.AddonNotTested:
				addonGui._showAddonTooOldDialog(gui.mainFrame, bundle)
		elif installStatus == addonUpdateProc.AddonInstallStatus.AddonInstallGenericError:
			gui.messageBox(
				# Translators: The message displayed when an error occurs when installing an add-on package.
				_("Failed to update {name} add-on").format(name=addon[1]),
				translate("Error"),
				wx.OK | wx.ICON_ERROR
			)
		else:
			successfullyInstalledCount += 1
		try:
			os.remove(addon[0])
		except OSError:
			pass
	progressDialog.done()
	progressDialog.Hide()
	progressDialog.Destroy()
	progressDialog = None
	log.debug(f"nvda3208: install success count: {successfullyInstalledCount}")
	# Only present messages if add-ons were actually updated.
	if successfullyInstalledCount:
		wx.CallLater(100, addonGui.promptUserForRestart)


def updateAddons(addons: list[addonUpdateProc.AddonUpdateRecord], auto: bool = True) -> None:
	if not len(addons):
		return
	global _downloadProgressDialog
	gui.mainFrame.prePopup()
	_downloadProgressDialog = wx.ProgressDialog(
		# Translators: The title of the dialog displayed while downloading add-on update.
		_("Downloading Add-on Update"),
		# Translators: The progress message indicating the name of the add-on being downloaded.
		_("Downloading add-on updates"),
		# PD_AUTO_HIDE is required because ProgressDialog.Update blocks at 100%
		# and waits for the user to press the Close button.
		style=wx.PD_CAN_ABORT | wx.PD_ELAPSED_TIME | wx.PD_REMAINING_TIME | wx.PD_AUTO_HIDE,
		parent=gui.mainFrame
	)
	_downloadProgressDialog.CentreOnScreen()
	_downloadProgressDialog.Raise()
	threading.Thread(target=downloadAndInstallAddonUpdates, args=[addons]).start()
