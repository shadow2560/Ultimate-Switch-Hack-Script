# Add-on Updater
# Copyright 2018-2023 Joseph Lee, released under GPL.

import pickle
import os
import globalVars
import winVersion


# Not all features are supported on older Windows releases or on specific configurations.
# Set state flags to specific values based on condition check functions.
def isClientOS() -> bool:
	return winVersion.getWinVer().productType == "workstation"


def isWin10ClientOrLater() -> bool:
	return winVersion.getWinVer() >= winVersion.WIN10 and isClientOS()


def isAddonStorePresent() -> bool:
	# Ignore Flake8 F401 as only import check is sufficient.
	try:
		import _addonStore  # NOQA: F401
		return True
	except ModuleNotFoundError:
		return False


updateState = {}


def loadState() -> None:
	# Some flags will have different default values based on current Windows version and edition.
	global updateState
	try:
		# Pickle wants to work with bytes.
		with open(os.path.join(globalVars.appArgs.configPath, "nvda3208.pickle"), "rb") as f:
			updateState = pickle.load(f)
	except (IOError, EOFError, NameError, ValueError, pickle.UnpicklingError):
		updateState["autoUpdate"] = isClientOS()
		updateState["backgroundUpdate"] = False
		updateState["addonStoreNotificationShown"] = False
		updateState["updateNotification"] = "toast"
		updateState["updateSource"] = "addondatastore"
		updateState["lastChecked"] = 0
		updateState["noUpdates"] = []
		updateState["devUpdates"] = []
		updateState["devUpdateChannels"] = {}
		updateState["legacyAddonsFound"] = set()
	# Just to make sure...
	if "autoUpdate" not in updateState:
		updateState["autoUpdate"] = isClientOS()
	if "backgroundUpdate" not in updateState:
		updateState["backgroundUpdate"] = False
	if "addonStoreNotificationShown" not in updateState:
		updateState["addonStoreNotificationShown"] = False
	if "updateNotification" not in updateState:
		updateState["updateNotification"] = "toast"
	if "updateSource" not in updateState:
		updateState["updateSource"] = "addondatastore"
	if "lastChecked" not in updateState:
		updateState["lastChecked"] = 0
	if "noUpdates" not in updateState:
		updateState["noUpdates"] = []
	if "devUpdates" not in updateState:
		updateState["devUpdates"] = []
	if "devUpdateChannels" not in updateState:
		updateState["devUpdateChannels"] = {}
	if "legacyAddonsFound" not in updateState:
		updateState["legacyAddonsFound"] = set()
	# Moving from one-dimensional dev updates list to a dictionary of channels (dev channel by default).
	for entry in updateState["devUpdates"]:
		if entry not in updateState["devUpdateChannels"]:
			updateState["devUpdateChannels"][entry] = "dev"


def saveState(keepStateOnline: bool = False) -> None:
	global updateState
	try:
		with open(os.path.join(globalVars.appArgs.configPath, "nvda3208.pickle"), "wb") as f:
			pickle.dump(updateState, f, protocol=0)
	except IOError:
		pass
	if not keepStateOnline:
		updateState.clear()


# Load and save add-on state if asked by the user.
def reload(factoryDefaults: bool = False) -> None:
	if not factoryDefaults:
		loadState()
	else:
		updateState.clear()
		updateState["autoUpdate"] = isClientOS()
		updateState["backgroundUpdate"] = False
		updateState["addonStoreNotificationShown"] = False
		updateState["updateNotification"] = "toast"
		updateState["updateSource"] = "addondatastore"
		updateState["lastChecked"] = 0
		updateState["noUpdates"] = []
		updateState["devUpdates"] = []
		updateState["devUpdateChannels"] = {}


def save() -> None:
	saveState(keepStateOnline=True)
