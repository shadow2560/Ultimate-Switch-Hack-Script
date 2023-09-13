import gui
import wx
import addonHandler

addonHandler.initTranslation()

def onInstall():
	for addon in addonHandler.getAvailableAddons():
		if addon.name == "remote" and not addon.isDisabled:
			result = gui.messageBox(
				# Translators: message asking the user wether NVDA Remote whould be disabled or not
				_("NVDA Remote has been detected on your NVDA installation. In order for TeleNVDA to work without conflicts, NVDA Remote must be disabled. Otherwise, TeleNVDA will refuse to work. Would you like to disable NVDA Remote now?"),
				# Translators: question title
				_("Running NVDA Remote detected"),
				wx.YES_NO|wx.ICON_QUESTION, gui.mainFrame)
			if result == wx.YES:
				addon.enable(False)
			return
