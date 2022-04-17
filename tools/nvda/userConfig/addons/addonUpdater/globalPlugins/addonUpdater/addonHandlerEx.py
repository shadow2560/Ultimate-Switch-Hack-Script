# -*- coding: UTF-8 -*-
# addonHandler.py
# A part of NonVisual Desktop Access (NVDA)
# Copyright (C) 2012-2022 Rui Batista, NV Access Limited, Noelia Ruiz Martínez, Joseph Lee
# This file is covered by the GNU General Public License.
# See the file COPYING for more details.

# Proof of concept implementation of NVDA Core issue 3208.

from urllib.request import urlopen, Request
import threading
import wx
import json
import re
import ssl
import addonHandler
import globalVars
from logHandler import log
from . import addonUtils
addonHandler.initTranslation()

# The URL prefixes are same for add-ons listed below.
names2urls = {
	"addonUpdater": "nvda3208",
	"Access8Math": "access8math",
	"addonsHelp": "addonshelp",
	"audioChart": "audiochart",
	"beepKeyboard": "beepkeyboard",
	"bluetoothaudio": "btaudio",
	"browsernav": "browsernav",
	"calibre": "cae",
	"charInfo": "chari",
	"checkGestures": "cig",
	"classicSelection": "clsel",
	"clipContentsDesigner": "ccd",
	"clipspeak": "cs",
	"clock": "cac",
	"consoleToolkit": "consoletoolkit",
	"controlUsageAssistant": "cua",
	"dayOfTheWeek": "dw",
	"debugHelper": "debughelper",
	"developerToolkit": "devtoolkit",
	"dropbox": "dx",
	"easyTableNavigator": "etn",
	"emoticons": "emo",
	"eMule": "em",
	"enhancedTouchGestures": "ets",
	"extendedWinamp": "ew",
	"focusHighlight": "fh",
	"goldenCursor": "gc",
	"goldwave": "gwv",
	"IndentNav": "indentnav",
	"inputLock": "inputlock",
	"instantTranslate": "it",
	"killNVDA": "killnvda",
	"lambda": "lambda",
	"mp3DirectCut": "mp3dc",
	"Mozilla": "moz",
	"noBeepsSpeechMode": "nb",
	"NotepadPlusPlus": "NotepadPlusPlus",
	"numpadNavMode": "numpadNav",
	"nvSpeechPlayer": "nvsp",
	"objLocTones": "objLoc",
	"objPad": "objPad",
	"ocr": "ocr",
	"outlookExtended": "outlookextended",
	"pcKbBrl": "pckbbrl",
	"phoneticPunctuation": "phoneticpunc",
	"placeMarkers": "pm",
	"proxy": "nvdaproxy",
	"quickDictionary": "quickdictionary",
	"readFeeds": "rf",
	"remote": "nvdaremote",
	"reportPasswords": "rp",
	"reportSymbols": "rsy",
	"resourceMonitor": "rm",
	"reviewCursorCopier": "rccp",
	"sayCurrentKeyboardLanguage": "ckbl",
	"SentenceNav": "sentencenav",
	"speakPasswords": "spp",
	"speechHistory": "sps",
	"stationPlaylist": "spl",
	"switchSynth": "sws",
	"synthRingSettingsSelector": "synthrings",
	"systrayList": "st",
	"textInformation": "txtinfo",
	"textnav": "textnav",
	"timezone": "tz",
	"toneMaster": "tmast",
	"tonysEnhancements": "tony",
	"toolbarsExplorer": "tbx",
	"trainingKeyboardCommands": "trainingkbdcmd",
	"unicodeBrailleInput": "ubi",
	"updateChannel": "updchannelselect",
	"virtualRevision": "VR",
	"VLC": "vlc-18",
	"wintenApps": "w10",
	"winWizard": "winwizard",
	"wordCount": "wc",
	"wordNav": "wordnav",
	"zoomEnhancements": "zoom",
}


# Add-ons with built-in update feature.
addonsWithUpdaters = [
	"BrailleExtender",
	"Weather Plus",
]


# Add-ons with all features integrated into NVDA or declared "legacy" by authors.
# For the latter case, update check functionality will be disabled upon authors' request.

# Translators: legacy add-on, features included in NVDA.
LegacyAddonIncludedInNVDA = _("features included in NVDA")
# Translators: legacy add-on, declared by add-on developers.
LegacyAddonAuthorDeclaration = _("declared legacy by add-on developers")

LegacyAddons = {
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


def shouldNotUpdate():
	# Returns a list of descriptions for add-ons that should not update.
	return [
		addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in addonUtils.updateState["noUpdates"]
	]


def preferDevUpdates():
	# Returns a list of descriptions for add-ons that prefers development releases.
	return [
		addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in addonUtils.updateState["devUpdates"]
	]


def detectLegacyAddons():
	# Returns a dictionary of add-on name and summary for legacy add-ons.
	return {
		addon.name: addon.manifest["summary"] for addon in addonHandler.getAvailableAddons()
		if addon.name in LegacyAddons
	}


# Validate a given add-on metadata, mostly involving type checks.
def validateAddonMetadata(addonMetadata):
	# Make sure that fields are of the right type.
	metadataFieldTypes = {
		"summary": str,
		"author": str,
		"minimumNVDAVersion": list,
		"lastTestedNVDAVersion": list
	}
	metadataValid = [
		isinstance(addonMetadata[field], fieldType)
		for field, fieldType in metadataFieldTypes.items()
	]
	if "addonKey" in addonMetadata:
		metadataValid.append(isinstance(addonMetadata["addonKey"], str))
	return all(metadataValid)


# Check add-on update eligibility with help from community add-ons metadata if present.
def addonCompatibleAccordingToMetadata(addon, addonMetadata):
	# Always return "yes" for development releases.
	# The whole point of development releases is to send feedback to add-on developers across NVDA releases.
	# Although possible, development releases should not be used to dodge around NVDA compatibility checks
	# as add-ons can break without notice.
	if addon in addonUtils.updateState["devUpdates"]:
		return True
	import addonAPIVersion
	minimumNVDAVersion = tuple(addonMetadata["minimumNVDAVersion"])
	lastTestedNVDAVersion = tuple(addonMetadata["lastTestedNVDAVersion"])
	# Is the add-on update compatible with local NVDA version the user is using?
	return (
		minimumNVDAVersion <= addonAPIVersion.CURRENT
		and lastTestedNVDAVersion >= addonAPIVersion.BACK_COMPAT_TO
	)


# Borrowed ideas from NVDA Core.
# Obtain update status for add-ons returned from community add-ons website.
# Use threads for opening URL's in parallel, resulting in faster update check response on multicore systems.
# This is the case when it becomes necessary to open another website.
# Also, check add-on update eligibility based on what community add-ons metadata says if present.
def fetchAddonInfo(info, results, addon, manifestInfo, addonsData):
	addonVersion = manifestInfo["version"]
	# Is this add-on's metadata present?
	try:
		addonMetadata = addonsData["active"][addon]
		addonMetadataPresent = True
	except KeyError:
		addonMetadata = {}
		addonMetadataPresent = False
	# Validate add-on metadata.
	if addonMetadataPresent:
		addonMetadataPresent = validateAddonMetadata(addonMetadata)
	# Add-ons metadata includes addon key in active/addonName/addonKey.
	addonKey = addonMetadata.get("addonKey") if addonMetadataPresent else None
	# If add-on key is None, it can indicate Add-on metadata is unusable or add-on key was unassigned.
	# Therefore use the add-on key map that ships with this add-on, although it may not record new add-ons.
	if addonKey is None:
		try:
			addonKey = names2urls[addon]
		except KeyError:
			return
	# If "-dev" flag is on, switch to development channel if it exists.
	channel = manifestInfo["channel"]
	if channel is not None:
		addonKey += "-" + channel
	# Can the add-on be updated based on community add-ons metadata?
	# What if a different update channel must be used if the stable channel update is not compatible?
	if addonMetadataPresent:
		if not addonCompatibleAccordingToMetadata(addon, addonMetadata):
			return
	try:
		addonUrl = results[addonKey]
	except:
		return
	# Necessary duplication if the URL doesn't end in ".nvda-addon".
	# Some add-ons require traversing another URL.
	if ".nvda-addon" not in addonUrl:
		res = None
		# Some hosting services block Python/urllib in hopes of avoding bots.
		# Therefore spoof the user agent to say this is latest Microsoft Edge.
		# Source: Stack Overflow, Google searches on Apache/mod_security
		req = Request(
			f"https://addons.nvda-project.org/files/get.php?file={addonKey}",
			headers={
				"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.30"  # NOQA: E501
			}
		)
		try:
			res = urlopen(req)
		except IOError as e:
			# SSL issue (seen in NVDA Core earlier than 2014.1).
			if isinstance(e.reason, ssl.SSLCertVerificationError) and e.reason.reason == "CERTIFICATE_VERIFY_FAILED":
				addonUtils._updateWindowsRootCertificates()
				res = urlopen(req)
			else:
				pass
		finally:
			if res is not None:
				addonUrl = res.url
				res.close()
		if res is None or (res and res.code != 200):
			return
	# Note that some add-ons are hosted on community add-ons server directly.
	if "/" not in addonUrl:
		addonUrl = f"https://addons.nvda-project.org/files/{addonUrl}"
	# Announce add-on URL for debugging purposes.
	log.debug(f"nvda3208: add-on URL is {addonUrl}")
	# Build emulated add-on update dictionary if there is indeed a new version.
	# All the info we need for add-on version check is after the last slash.
	# Sometimes, regular expression fails, and if so, treat it as though there is no update for this add-on.
	try:
		version = re.search("(?P<name>)-(?P<version>.*).nvda-addon", addonUrl.split("/")[-1]).groupdict()["version"]
	except:
		log.debug("nvda3208: could not retrieve version info for an add-on from its URL", exc_info=True)
		return
	# If hosted on places other than add-ons server, an unexpected URL might be returned, so parse this further.
	if addon in version:
		version = version.split(addon)[1][1:]
	if addonVersion != version:
		info[addon] = {"curVersion": addonVersion, "version": version, "path": addonUrl}


def checkForAddonUpdate(curAddons):
	# First, fetch current community add-ons via an internal thread.
	def _currentCommunityAddons(results):
		res = None
		try:
			res = urlopen("https://addons.nvda-project.org/files/get.php?addonslist")
		except IOError as e:
			# SSL issue (seen in NVDA Core earlier than 2014.1).
			if isinstance(e.reason, ssl.SSLCertVerificationError) and e.reason.reason == "CERTIFICATE_VERIFY_FAILED":
				addonUtils._updateWindowsRootCertificates()
				res = urlopen("https://addons.nvda-project.org/files/get.php?addonslist")
			else:
				# Inform results dictionary that an error has occurred as this is running inside a thread.
				log.debug("nvda3208: errors occurred while retrieving community add-ons", exc_info=True)
				results["error"] = True
		finally:
			if res is not None:
				results.update(json.load(res))
				res.close()

	# Similar to above except fetch add-on metadata from a JSON file hosted by the NVDA add-ons community.
	def _currentCommunityAddonsMetadata(addonsData):
		res = None
		try:
			res = urlopen("https://nvdaaddons.github.io/data/addonsData.json")
		except IOError as e:
			# SSL issue (seen in NVDA Core earlier than 2014.1).
			if isinstance(e.reason, ssl.SSLCertVerificationError) and e.reason.reason == "CERTIFICATE_VERIFY_FAILED":
				addonUtils._updateWindowsRootCertificates()
				res = urlopen("https://nvdaaddons.github.io/data/addonsData.json")
			else:
				# Clear addon metadata dictionary.
				log.debug("nvda3208: errors occurred while retrieving community add-ons metadata", exc_info=True)
				addonsData.clear()
		finally:
			if res is not None:
				addonsData.update(json.load(res))
				res.close()
	# NVDA community add-ons list is always retrieved for fallback reasons.
	results = {}
	addonsFetcher = threading.Thread(target=_currentCommunityAddons, args=(results,))
	addonsFetcher.start()
	# This internal thread must be joined, otherwise results will be lost.
	addonsFetcher.join()
	# Raise an error if results says so.
	if "error" in results:
		raise RuntimeError("Failed to retrieve community add-ons")
	# Enhanced with add-on metadata such as compatibility info maintained by the community.
	addonsData = {}
	addonsFetcher = threading.Thread(target=_currentCommunityAddonsMetadata, args=(addonsData,))
	addonsFetcher.start()
	# Just like the earlier thread, this thread too must be joined.
	addonsFetcher.join()
	# Fallback to add-ons list if metadata is unusable.
	if len(addonsData) == 0:
		log.debug("nvda3208: add-ons metadata unusable, using add-ons list from community add-ons website")
	else:
		log.debug("nvda3208: add-ons metadata successfully retrieved")
	# The info dictionary will be passed in as a reference in individual threads below.
	# Don't forget to perform additional checks based on add-on metadata if present.
	info = {}
	updateThreads = [
		threading.Thread(target=fetchAddonInfo, args=(info, results, addon, manifestInfo, addonsData))
		for addon, manifestInfo in curAddons.items()
	]
	for thread in updateThreads:
		thread.start()
	for thread in updateThreads:
		thread.join()
	return info


def checkForAddonUpdates():
	# Don't even think about update checks if secure mode flag is set.
	if globalVars.appArgs.secure:
		return
	curAddons = {}
	addonSummaries = {}
	for addon in addonHandler.getAvailableAddons():
		# Skip add-ons that can update themselves.
		# Add-on Updater is included, but is an exception as it updates other add-ons, too.
		if addon.name in addonsWithUpdaters:
			continue
		# Sorry Nuance Vocalizer family, no update checks for you.
		if "vocalizer" in addon.name.lower():
			continue
		manifest = addon.manifest
		name = addon.name
		if name in addonUtils.updateState["noUpdates"]:
			continue
		curVersion = manifest["version"]
		# Check different channels if appropriate.
		updateChannel = manifest.get("updateChannel")
		if updateChannel == "None":
			updateChannel = None
		if updateChannel != "dev" and name in addonUtils.updateState["devUpdates"]:
			updateChannel = "dev"
		elif updateChannel == "dev" and name not in addonUtils.updateState["devUpdates"]:
			updateChannel = None
		curAddons[name] = {"summary": manifest["summary"], "version": curVersion, "channel": updateChannel}
		addonSummaries[name] = manifest["summary"]
	try:
		info = checkForAddonUpdate(curAddons)
	except:
		# Present an error dialog if manual add-on update check is in progress.
		raise RuntimeError("Cannot check for community add-on updates")
	res = info
	for addon in res:
		res[addon]["summary"] = addonSummaries[addon]
		# In reality, it'll be a list of URL's to try.
		res[addon]["urls"] = res[addon]["path"]
	return res if len(res) else None


def autoAddonUpdateCheck():
	t = threading.Thread(target=_showAddonUpdateUI)
	t.daemon = True
	t.start()


# Only stored when update toast appears.
_updateInfo = None


def _showAddonUpdateUI():
	def _showAddonUpdateUICallback(info):
		import gui
		from .addonGuiEx import AddonUpdatesDialog
		gui.mainFrame.prePopup()
		AddonUpdatesDialog(gui.mainFrame, info).Show()
		gui.mainFrame.postPopup()
	try:
		info = checkForAddonUpdates()
	except:
		info = None
		raise
	if info is not None:
		# Show either the update notification toast (Windows 10 and later)
		# or the results dialog (other Windows releases and server systems).
		# On Windows 10 and later (client versions), this behavior is configurable.
		# If toast is shown, checking for add-on updates from tools menu will merely show the results dialog.
		# wxPython 4.1.0 (and consequently, wxWidges 3.1.0) simplifies this by
		# allowing action handlers to be defined for toasts, which will then show the results dialog on the spot.
		# However it doesn't work for desktop apps such as NVDA.
		import winVersion
		winVer = winVersion.getWinVer()
		if (
			winVer >= winVersion.WIN10 and winVer.productType == "workstation"
			and addonUtils.updateState["updateNotification"] == "toast"
		):
			global _updateInfo
			updateMessage = _(
				# Translators: presented as part of add-on update notification message.
				"One or more add-on updates are available. "
				"Go to NVDA menu, Tools, Check for add-on updates to review them."
			)
			# Translators: title of the add-on update notification message.
			wx.adv.NotificationMessage(_("NVDA add-on updates"), updateMessage).Show(timeout=30)
			_updateInfo = info
		else:
			wx.CallAfter(_showAddonUpdateUICallback, info)
