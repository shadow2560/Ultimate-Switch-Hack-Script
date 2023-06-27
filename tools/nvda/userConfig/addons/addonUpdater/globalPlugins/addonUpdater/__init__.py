# Add-on Updater
# Copyright 2018-2023 Joseph Lee, released under GPL.

# Note: proof of concept implementation of NVDA Core issue 3208
# URL: https://github.com/nvaccess/nvda/issues/3208

import globalPluginHandler
import time
import gui
from gui.nvdaControls import CustomCheckListBox, AutoWidthColumnListCtrl
import wx
# What if this is run from NVDA source?
try:
	import updateCheck  # NOQA: F401
	canUpdate = True
except RuntimeError:
	canUpdate = False
import globalVars
import config
from logHandler import log
from . import addonHandlerEx
from . import addonGuiEx
from . import addonUtils
from .addonUpdateProtocols import AvailableUpdateProtocols
from .skipTranslation import translate
import addonHandler
addonHandler.initTranslation()

# Overall update check routine was inspired by StationPlaylist Studio add-on (Joseph Lee).)

addonUpdateCheckInterval = 86400
updateChecker = None


# To avoid freezes, a background thread will run after the global plugin constructor calls wx.CallAfter.
def autoUpdateCheck() -> None:
	currentTime = time.time()
	whenToCheck = addonUtils.updateState["lastChecked"] + addonUpdateCheckInterval
	if currentTime >= whenToCheck:
		addonUtils.updateState["lastChecked"] = currentTime
		if addonUtils.updateState["autoUpdate"]:
			startAutoUpdateCheck(addonUpdateCheckInterval)
		addonHandlerEx.autoAddonUpdateCheck()
	else:
		startAutoUpdateCheck(whenToCheck - currentTime)


# Start or restart auto update checker.
def startAutoUpdateCheck(interval: int) -> None:
	global updateChecker
	if updateChecker is not None:
		wx.CallAfter(updateChecker.Stop)
	updateChecker = wx.PyTimer(autoUpdateCheck)
	wx.CallAfter(updateChecker.Start, interval * 1000, True)


def endAutoUpdateCheck() -> None:
	global updateChecker
	addonUtils.updateState["lastChecked"] = time.time()
	if updateChecker is not None:
		wx.CallAfter(updateChecker.Stop)
		wx.CallAfter(autoUpdateCheck)


if canUpdate:
	addonGuiEx.AddonUpdaterManualUpdateCheck.register(endAutoUpdateCheck)


# Check if legacy add-ons are found, and if yes, notify user and disable automatic add-on update checks.
# Legacy add-ons can include add-ons with all features integrated into NVDA
# or declared as legacy by add-on authors.
def legacyAddonsFound() -> bool:
	def _showLegacyAddonsUICallback(info):
		gui.mainFrame.prePopup()
		LegacyAddonsDialog(gui.mainFrame, info).Show()
		gui.mainFrame.postPopup()
	legacyAddons = addonHandlerEx.detectLegacyAddons()
	# Installed add-ons marked "legacy" takes precedence (do set intersection).
	addonUtils.updateState["legacyAddonsFound"] &= set(legacyAddons.keys())
	legacyAddonsFound = [
		addon for addon in legacyAddons.keys()
		if addon not in addonUtils.updateState["legacyAddonsFound"]
	]
	if len(legacyAddonsFound):
		legacyAddonsInfo = {}
		for addon in legacyAddonsFound:
			legacyAddonsInfo[legacyAddons[addon]] = addonHandlerEx.LegacyAddons[addon]
			addonUtils.updateState["legacyAddonsFound"].add(addon)
		wx.CallAfter(_showLegacyAddonsUICallback, legacyAddonsInfo)
		return True
	return False


# Present a message if add-on store client is included in NVDA.
# NV Access add-on store replaces Add-on Updater once deployed.
def addonStorePresent() -> bool:
	# Do not present the below message if NVDA itself is updating at the moment.
	if globalVars.appArgs.install and globalVars.appArgs.minimal:
		return False
	if addonUtils.isAddonStorePresent():
		addonStoreMessage = _(
			# Translators: message presented when add-on store is available in NVDA.
			"You are using an NVDA release with add-on store included. "
			"Visit NVDA add-on store (NVDA menu, Tools, add-on store) to check for add-on updates. "
			"Add-on Updater can still be used to check for add-on updates in the meantime."
		)
		if not addonUtils.updateState["addonStoreNotificationShown"]:
			wx.CallAfter(
				gui.messageBox, addonStoreMessage, _("Add-on Updater"), wx.OK | wx.ICON_INFORMATION
			)
			addonUtils.updateState["addonStoreNotificationShown"] = True
		# For now allow Add-on Updater to check for add-on updates.
		# return True
	return False


# Security: disable the global plugin altogether in secure mode.
def disableInSecureMode(cls):
	return globalPluginHandler.GlobalPlugin if globalVars.appArgs.secure else cls


# Process add-on specific command-line switches.
def processArgs(cliArgument: str) -> bool:
	"""if cliArgument:
		# Remove the command-line switch from sys.argv so the add-on can
		# function normally unless restarted with these switches added.
		# This should not be part of global plugin terminate method because sys.argv is kept
		# when NVDA is restarted from Exit NVDA dialog.
		import sys
		sys.argv.remove(cliArgument)
		return True"""
	return False


@disableInSecureMode
class GlobalPlugin(globalPluginHandler.GlobalPlugin):

	def __init__(self):
		super(GlobalPlugin, self).__init__()
		# Return early if add-on store client is present.
		# For now do it after loading update state to set message presented flag to true
		# (show the message only once).
		# In the future this should be done as soon as the constructor runs.
		if globalVars.appArgs.secure or config.isAppX:
			return
		# #4: warn and quit if this is a source code of NVDA.
		if not canUpdate:
			log.info("nvda3208: update check not supported in source code version of NVDA")
			return
		# Tell NVDA that the add-on accepts additional command-line switches.
		# This is not supported properly on NVDA releases before 2022.1.
		addonHandler.isCLIParamKnown.register(processArgs)
		addonUtils.loadState()
		# Don't go further if add-on store client is present.
		if addonStorePresent():
			return
		self.toolsMenu = gui.mainFrame.sysTrayIcon.toolsMenu
		self.addonUpdater = self.toolsMenu.Append(
			# Translators: menu item label for checking add-on updates.
			wx.ID_ANY, _("Check for &add-on updates..."), _("Check for NVDA add-on updates")
		)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, addonGuiEx.onAddonUpdateCheck, self.addonUpdater)
		gui.settingsDialogs.NVDASettingsDialog.categoryClasses.append(AddonUpdaterPanel)
		config.post_configSave.register(addonUtils.save)
		config.post_configReset.register(addonUtils.reload)
		addonHandlerEx.updateSuccess.register(self.updateMenuItemLabel)
		if legacyAddonsFound():
			return
		if addonUtils.updateState["autoUpdate"]:
			# But not when NVDA itself is updating.
			if not (globalVars.appArgs.install and globalVars.appArgs.minimal):
				wx.CallAfter(autoUpdateCheck)

	def terminate(self):
		super(GlobalPlugin, self).terminate()
		# #4: no, do not go through all this if this is a source code copy of NVDA.
		if not canUpdate:
			return
		# Do not continue if add-on store client is present.
		if addonUtils.isAddonStorePresent():
			return
		addonHandlerEx.updateSuccess.unregister(self.updateMenuItemLabel)
		config.post_configSave.unregister(addonUtils.save)
		config.post_configReset.unregister(addonUtils.reload)
		gui.settingsDialogs.NVDASettingsDialog.categoryClasses.remove(AddonUpdaterPanel)
		try:
			self.toolsMenu.Remove(self.addonUpdater)
		except (RuntimeError, AttributeError):
			pass
		global updateChecker
		if updateChecker and updateChecker.IsRunning():
			updateChecker.Stop()
		updateChecker = None
		addonUtils.saveState()

	def updateMenuItemLabel(self, label=_("Check for &add-on updates...")):
		self.addonUpdater.SetItemLabel(label)


class AddonUpdaterPanel(gui.SettingsPanel):
	# Translators: This is the label for the Add-on Updater settings panel.
	title = _("Add-on Updater")

	def makeSettings(self, settingsSizer):
		sHelper = gui.guiHelper.BoxSizerHelper(self, sizer=settingsSizer)

		self.autoUpdateCheckBox = sHelper.addItem(
			# Translators: This is the label for a checkbox in the
			# Add-on Updater settings panel.
			wx.CheckBox(self, label=_("Automatically check for add-on &updates"))
		)
		self.autoUpdateCheckBox.SetValue(addonUtils.updateState["autoUpdate"])

		# Toasts and background updates are available if NVDA is actually installed on Windows 10 and later.
		if addonUtils.isWin10ClientOrLater() and config.isInstalledCopy():
			updateNotificationChoices = [
				# Translators: one of the add-on update notification choices.
				("toast", _("toast")),
				# Translators: one of the add-on update notification choices.
				("dialog", _("dialog")),
			]
			self.updateNotification = sHelper.addLabeledControl(
				# Translators: This is the label for a combo box in the
				# Add-on Updater settings panel.
				_("&Add-on update notification:"), wx.Choice, choices=[x[1] for x in updateNotificationChoices]
			)
			self.updateNotification.Bind(wx.EVT_CHOICE, self.onNotificationSelection)
			self.updateNotification.SetSelection(
				next((x for x, y in enumerate(updateNotificationChoices)
				if y[0] == addonUtils.updateState["updateNotification"]))
			)
			# Only enable this checkbox if update notification is set to toast (Windows 10 and later).
			self.backgroundUpdateCheckBox = sHelper.addItem(
				# Translators: This is the label for a checkbox in the
				# Add-on Updater settings panel.
				wx.CheckBox(self, label=_("Update add-ons in the &background"))
			)
			self.backgroundUpdateCheckBox.Enable(addonUtils.updateState["updateNotification"] == "toast")
			self.backgroundUpdateCheckBox.SetValue(addonUtils.updateState["backgroundUpdate"])

		# Checkable list comes from NVDA Core issue 7491 (credit: Derek Riemer and Babbage B.V.).
		# Some add-ons come with pretty badly formatted summary text,
		# so try catching them and exclude them from this list.
		self.noAddonUpdates = sHelper.addLabeledControl(_("Do &not update add-ons:"), CustomCheckListBox, choices=[
			addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
			if isinstance(addon.manifest['summary'], str)
		])
		self.noAddonUpdates.SetCheckedStrings(addonHandlerEx.shouldNotUpdate())
		self.noAddonUpdates.SetSelection(0)

		self.devAddonUpdates = sHelper.addLabeledControl(
			_("Prefer &development releases:"), CustomCheckListBox, choices=[
				addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
				if isinstance(addon.manifest['summary'], str)
			]
		)
		self.devAddonUpdates.SetCheckedStrings(addonHandlerEx.preferDevUpdates())
		self.devAddonUpdates.Bind(wx.EVT_CHECKLISTBOX, self.onDevUpdateCheck)
		self.devAddonUpdates.Bind(wx.EVT_LISTBOX, self.onDevAddonUpdateSelected)
		self.devAddonUpdates.SetSelection(0)
		# A two-dimensional array will be used (add-on name: channel).
		self.devUpdateChannels = []
		for addon in addonHandler.getAvailableAddons():
			self.devUpdateChannels.append(
				[addon.name, addonUtils.updateState["devUpdateChannels"].get(addon.name)]
			)
		self.devUpdateChannel = sHelper.addLabeledControl(
			# Translators: This is the label for a combo box in the
			# Add-on Updater settings panel.
			_("Development release &channel:"), wx.Choice, choices=["dev", "beta"]
		)
		self.devUpdateChannel.Bind(wx.EVT_CHOICE, self.onChannelSelection)
		self.devUpdateChannel.SetSelection(0)
		self.onDevAddonUpdateSelected(None)

		self.updateSourceKeys = [protocol.key for protocol in AvailableUpdateProtocols]
		self.updateSource = sHelper.addLabeledControl(
			# Translators: This is the label for a combo box in the
			# Add-on Updater settings panel.
			_("Add-on update &source:"), wx.Choice,
			choices=[protocol.description for protocol in AvailableUpdateProtocols]
		)
		self.updateSource.SetSelection(
			[protocol.key for protocol in AvailableUpdateProtocols].index(
				addonUtils.updateState["updateSource"]
			)
		)

	def onNotificationSelection(self, evt):
		# Enable/disable background update checkbox based on update notification selection.
		# Toast is the first item in update notification list (index 0).
		if hasattr(self, "updateNotification") and hasattr(self, "backgroundUpdateCheckBox"):
			self.backgroundUpdateCheckBox.Enable(self.updateNotification.Selection == 0)

	def onDevAddonUpdateSelected(self, evt):
		if self.devAddonUpdates.IsChecked(self.devAddonUpdates.GetSelection()):
			self.devUpdateChannel.Enable()
			updateChannel = self.devUpdateChannels[self.devAddonUpdates.GetSelection()][1]
			if updateChannel is None:
				updateChannel = "dev"
			self.devUpdateChannel.SetSelection(["dev", "beta"].index(updateChannel))
			self.devUpdateChannels[self.devAddonUpdates.GetSelection()][1] = updateChannel
		else:
			self.devUpdateChannel.Disable()

	def onDevUpdateCheck(self, evt):
		evt.Skip()
		# Present dev (prerelease) update channels (dev/beta).
		if self.devAddonUpdates.IsChecked(self.devAddonUpdates.GetSelection()):
			self.devUpdateChannel.Enable()
			updateChannel = self.devUpdateChannels[self.devAddonUpdates.GetSelection()][1]
			if updateChannel is None:
				updateChannel = "dev"
			self.devUpdateChannel.SetSelection(["dev", "beta"].index(updateChannel))
			self.devUpdateChannels[self.devAddonUpdates.GetSelection()][1] = updateChannel
		else:
			self.devUpdateChannel.Disable()

	def onChannelSelection(self, evt):
		updateChannel = self.devUpdateChannel.GetStringSelection()
		self.devUpdateChannels[self.devAddonUpdates.GetSelection()][1] = updateChannel

	def isValid(self):
		# Present a message if about to switch to a different add-on update source.
		selectedSource = self.updateSource.GetSelection()
		if addonUtils.updateState["updateSource"] != self.updateSourceKeys[selectedSource]:
			return gui.messageBox(
				_(
					# Translators: Presented when about to switch add-on update sources.
					"You are about to switch to a different add-on update source. "
					"Are you sure you wish to change update source to {updateSourceDescription}?"
				).format(updateSourceDescription=self.updateSource.GetStringSelection()),
				# Translators: Title of the add-on update source dialog.
				_("Add-on update source change"), wx.YES | wx.NO | wx.ICON_WARNING, self
			) == wx.YES
		return super(AddonUpdaterPanel, self).isValid()

	def onSave(self):
		noAddonUpdateSummaries = self.noAddonUpdates.GetCheckedStrings()
		addonUtils.updateState["noUpdates"] = [
			addon.name for addon in addonHandler.getAvailableAddons()
			if addon.manifest["summary"] in noAddonUpdateSummaries
		]
		devAddonUpdateSummaries = self.devAddonUpdates.GetCheckedStrings()
		addonUtils.updateState["devUpdates"] = [
			addon.name for addon in addonHandler.getAvailableAddons()
			if addon.manifest["summary"] in devAddonUpdateSummaries
		]
		addonUtils.updateState["devUpdateChannels"].clear()
		for entry in self.devUpdateChannels:
			if entry[0] in addonUtils.updateState["devUpdates"]:
				addonUtils.updateState["devUpdateChannels"][entry[0]] = entry[1]
		addonUtils.updateState["autoUpdate"] = self.autoUpdateCheckBox.IsChecked()
		addonUtils.updateState["updateSource"] = self.updateSourceKeys[self.updateSource.GetSelection()]
		if hasattr(self, "updateNotification"):
			addonUtils.updateState["updateNotification"] = ["toast", "dialog"][self.updateNotification.GetSelection()]
		if hasattr(self, "backgroundUpdateCheckBox"):
			addonUtils.updateState["backgroundUpdate"] = self.backgroundUpdateCheckBox.IsChecked()
		global updateChecker
		if updateChecker and updateChecker.IsRunning():
			updateChecker.Stop()
		updateChecker = None
		if addonUtils.updateState["autoUpdate"]:
			addonUtils.updateState["lastChecked"] = time.time()
			wx.CallAfter(autoUpdateCheck)


# Legacy add-ons (startup) dialog
# Inspired by NVDA's incompatible add-ons dialog (credit: NV Access)
# The ideal place is add-on GUI but is placed here since add-on GUI module might not be importable.
class LegacyAddonsDialog(wx.Dialog):

	def __init__(self, parent, legacyAddonInfo):
		# Translators: The title of the legacy add-ons dialog.
		super(LegacyAddonsDialog, self).__init__(parent, title=_("Legacy add-ons found"))
		mainSizer = wx.BoxSizer(wx.VERTICAL)
		settingsSizer = wx.BoxSizer(wx.VERTICAL)
		addonsSizerHelper = gui.guiHelper.BoxSizerHelper(self, sizer=settingsSizer)

		introText = _(
			# Translators: message displayed if legacy add-ons are found
			# (add-ons with all features included in NVDA or declared as legacy by add-on authors).
			"One or more legacy add-ons were found in your NVDA installation. "
			"Features from these add-ons are now part of the NVDA version you are using "
			"or declared legacy by add-on developers. "
			"Please disable or uninstall these add-ons by going to NVDA menu, Tools, Manage Add-ons.\n"
		)
		legacyAddonsIntroLabel = wx.StaticText(self, label=introText)
		legacyAddonsIntroLabel.Wrap(550)
		addonsSizerHelper.addItem(legacyAddonsIntroLabel)
		# Translators: the label for the legacy add-ons list.
		entriesLabel = _("Legacy add-ons")
		self.addonsList = addonsSizerHelper.addLabeledControl(
			entriesLabel,
			AutoWidthColumnListCtrl,
			style=wx.LC_REPORT | wx.LC_SINGLE_SEL,
		)
		self.addonsList.InsertColumn(0, translate("Package"), width=150)
		# Translators: The label for a column in legacy add-ons list used to show legacy add-on reason.
		self.addonsList.InsertColumn(1, _("Legacy reason"), width=180)
		# Unlike add-on updates dialog, legacy add-on info is a simple mapping of addon:legacyReason.
		for addon, legacyReason in legacyAddonInfo.items():
			self.addonsList.Append((addon, legacyReason))
		self.addonsList.Select(0)
		self.addonsList.SetItemState(0, wx.LIST_STATE_FOCUSED, wx.LIST_STATE_FOCUSED)

		bHelper = addonsSizerHelper.addDialogDismissButtons(gui.guiHelper.ButtonHelper(wx.HORIZONTAL))
		closeButton = bHelper.addButton(self, wx.ID_CLOSE, label=translate("&Close"))
		closeButton.Bind(wx.EVT_BUTTON, self.onClose)
		self.Bind(wx.EVT_CLOSE, lambda evt: self.onClose)
		self.EscapeId = wx.ID_CLOSE

		mainSizer.Add(settingsSizer, border=gui.guiHelper.BORDER_FOR_DIALOGS, flag=wx.ALL)
		self.Sizer = mainSizer
		mainSizer.Fit(self)
		self.CenterOnScreen()
		wx.CallAfter(self.Show)

	def onClose(self, evt):
		self.Destroy()
