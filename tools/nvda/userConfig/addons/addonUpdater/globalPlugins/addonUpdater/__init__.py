# Add-on Updater
# Copyright 2018-2022 Joseph Lee, released under GPL.

# Note: proof of concept implementation of NVDA Core issue 3208
# URL: https://github.com/nvaccess/nvda/issues/3208

import globalPluginHandler
import time
import gui
from gui.nvdaControls import CustomCheckListBox, AutoWidthColumnListCtrl
import wx
import winVersion
# What if this is run from NVDA source?
try:
	import updateCheck
	canUpdate = True
except RuntimeError:
	canUpdate = False
import globalVars
import config
from logHandler import log
from . import addonHandlerEx
try:
	from . import addonGuiEx
except RuntimeError:
	canUpdate = False
from . import addonUtils
from .skipTranslation import translate
import addonHandler
addonHandler.initTranslation()

# Overall update check routine was inspired by StationPlaylist Studio add-on (Joseph Lee).)

addonUpdateCheckInterval = 86400
updateChecker = None


# To avoid freezes, a background thread will run after the global plugin constructor calls wx.CallAfter.
def autoUpdateCheck():
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
def startAutoUpdateCheck(interval):
	global updateChecker
	if updateChecker is not None:
		wx.CallAfter(updateChecker.Stop)
	updateChecker = wx.PyTimer(autoUpdateCheck)
	wx.CallAfter(updateChecker.Start, interval * 1000, True)


def endAutoUpdateCheck():
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
def legacyAddonsFound():
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


# Security: disable the global plugin altogether in secure mode.
def disableInSecureMode(cls):
	return globalPluginHandler.GlobalPlugin if globalVars.appArgs.secure else cls


@disableInSecureMode
class GlobalPlugin(globalPluginHandler.GlobalPlugin):

	def __init__(self):
		super(GlobalPlugin, self).__init__()
		if globalVars.appArgs.secure or config.isAppX:
			return
		# #4: warn and quit if this is a source code of NVDA.
		if not canUpdate:
			log.info("nvda3208: update check not supported in source code version of NVDA")
			return
		addonUtils.loadState()
		self.toolsMenu = gui.mainFrame.sysTrayIcon.toolsMenu
		self.addonUpdater = self.toolsMenu.Append(
			wx.ID_ANY, _("Check for &add-on updates..."), _("Check for NVDA add-on updates")
		)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, addonGuiEx.onAddonUpdateCheck, self.addonUpdater)
		gui.settingsDialogs.NVDASettingsDialog.categoryClasses.append(AddonUpdaterPanel)
		config.post_configSave.register(addonUtils.save)
		config.post_configReset.register(addonUtils.reload)
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

		if (
			winVersion.getWinVer() >= winVersion.WIN10
			and winVersion.getWinVer().productType == "workstation"
		):
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
			self.updateNotification.SetSelection(
				next((x for x, y in enumerate(updateNotificationChoices)
				if y[0] == addonUtils.updateState["updateNotification"]))
			)

		# Checkable list comes from NVDA Core issue 7491 (credit: Derek Riemer and Babbage B.V.).
		# Some add-ons come with pretty badly formatted summary text,
		# so try catching them and exclude them from this list.
		# Also, Vocalizer add-on family should be excluded from this list (requested by add-on author).
		self.noAddonUpdates = sHelper.addLabeledControl(_("Do &not update add-ons:"), CustomCheckListBox, choices=[
			addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
			if isinstance(addon.manifest['summary'], str) and "vocalizer" not in addon.name
		])
		self.noAddonUpdates.SetCheckedStrings(addonHandlerEx.shouldNotUpdate())
		self.noAddonUpdates.SetSelection(0)

		self.devAddonUpdates = sHelper.addLabeledControl(
			_("Prefer &development releases:"), CustomCheckListBox, choices=[
				addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
				if isinstance(addon.manifest['summary'], str) and "vocalizer" not in addon.name
			]
		)
		self.devAddonUpdates.SetCheckedStrings(addonHandlerEx.preferDevUpdates())
		self.devAddonUpdates.SetSelection(0)

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
		addonUtils.updateState["autoUpdate"] = self.autoUpdateCheckBox.IsChecked()
		if hasattr(self, "updateNotification"):
			addonUtils.updateState["updateNotification"] = ["toast", "dialog"][self.updateNotification.GetSelection()]
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
