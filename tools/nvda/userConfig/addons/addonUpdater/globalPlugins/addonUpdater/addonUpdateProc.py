# Add-on update process/procedure internals
# Copyright 2022-2023 Joseph Lee, released under GPL

# Proof of concept implementation of NVDA Core issue 3208.
# Split from extended add-on handler and GUI modules in 2022.
# The purpose of this module is to provide implementation of add-on update processes and procedures.
# Specifically, internals of update check, download, and installation steps.
# For update check, this module is responsible for asking different protocols to return update records.
# Note that add-on update record class is striclty part of update procedures/processes.
# Parts will resemble that of extended add-on handler and GUI modules.

from __future__ import annotations
from typing import Optional, Any
from urllib.request import urlopen
import enum
import addonHandler
import globalVars
from logHandler import log
from . import addonUtils
import hashlib
import gui
import extensionPoints
addonHandler.initTranslation()


# Record add-on update information, resembling NVDA add-on manifest.
class AddonUpdateRecord(object):
	"""Resembles add-on manifests but optimized for updates.
	In addition to add-on name, summary, and version, this class records download URL and other data.
	"""

	def __init__(
			self,
			name: str = "",
			summary: str = "",
			version: str = "",
			installedVersion: str = "",
			url: str = "",
			hash: Optional[str] = None,
			minimumNVDAVersion: list[int] = [0, 0, 0],
			lastTestedNVDAVersion: list[int] = [0, 0, 0],
			updateChannel: Optional[str] = "",
			installedChannel: Optional[str] = "",
			isEnabled: bool = True
	) -> None:
		self.name = name
		self.summary = summary
		self.version = version
		self.installedVersion = installedVersion
		self.url = url
		self.hash = hash
		self.minimumNVDAVersion = minimumNVDAVersion
		self.lastTestedNVDAVersion = lastTestedNVDAVersion
		self.updateChannel = updateChannel
		self.installedChannel = installedChannel
		self.isEnabled = isEnabled

	def updateDict(self) -> dict[str, Any]:
		return {
			"name": self.name,
			"summary": self.summary,
			"version": self.version,
			"installedVersion": self.installedVersion,
			"url": self.url,
			"hash": self.hash,
			"minimumNVDAVersion": self.minimumNVDAVersion,
			"lastTestedNVDAVersion": self.lastTestedNVDAVersion,
			"updateChannel": self.updateChannel
		}

	# It might be possible that some protocols may provide version number info.
	def updateAvailable(self, versionNumber: Optional[str] = None) -> bool:
		# If channels are different, just say yes if versions are different.
		if self.updateChannel != self.installedChannel:
			return self.version != self.installedVersion
		versionParsed = self.version.split(".")
		installedVersionParsed = self.installedVersion.split(".")
		try:
			# If all parts are integers, then say yes if the update version is indeed newer (higher).
			# Skip this if version number argument is defined.
			if versionNumber is None:
				updateVersionNumber = tuple(int(ver) for ver in versionParsed)
			installedVersionNumber = tuple(int(ver) for ver in installedVersionParsed)
		except ValueError:
			return self.version != self.installedVersion
		return updateVersionNumber > installedVersionNumber


# Add-ons with built-in update feature.
addonsWithUpdaters: list[str] = [
	"BrailleExtender",
	"TiendaNVDA",
	"Weather Plus",
]


def checkForAddonUpdates() -> Optional[list[AddonUpdateRecord]]:
	# Don't even think about update checks if secure mode flag is set.
	if globalVars.appArgs.secure:
		return None
	from . import addonUpdateProtocols
	# Build a list of preliminary update records based on installed add-ons.
	curAddons = []
	for addon in addonHandler.getAvailableAddons():
		# Skip add-ons that can update themselves.
		# Add-on Updater is included, but is an exception as it updates other add-ons, too.
		if addon.name in addonsWithUpdaters:
			continue
		manifest = addon.manifest
		name: str = addon.name
		if name in addonUtils.updateState["noUpdates"]:
			continue
		curVersion: str = manifest["version"]
		# Check different channels if appropriate.
		updateChannel: Optional[str] = manifest.get("updateChannel")
		if updateChannel == "None":
			updateChannel = None
		installedChannel = updateChannel
		if name in addonUtils.updateState["devUpdates"]:
			# For prerelease builds, dev channel is set as default.
			updateChannel = addonUtils.updateState["devUpdateChannels"].get(name, "dev")
		else:
			updateChannel = None
		# Mark disabled add-ons (flag passed in will be "isEnabled").
		isEnabled = not addon.isDisabled
		# Note that version (update) and installed version will be the same for now.
		curAddons.append(AddonUpdateRecord(
			name=name,
			summary=manifest["summary"],
			version=curVersion,
			installedVersion=curVersion,
			updateChannel=updateChannel,
			installedChannel=installedChannel,
			isEnabled=isEnabled
		))
	# Choos the appropriate add-on update protocol/source.
	updateProtocols: dict[str, str] = {
		protocol.key: protocol.protocol for protocol in addonUpdateProtocols.AvailableUpdateProtocols
	}
	updateChecker = getattr(addonUpdateProtocols, updateProtocols[addonUtils.updateState["updateSource"]])
	try:
		info = updateChecker().checkForAddonUpdates(installedAddons=curAddons)
	except:
		# Present an error dialog if manual add-on update check is in progress.
		raise RuntimeError("Cannot check for community add-on updates")
	return info


AddonDownloadNotifier = extensionPoints.Action()


def downloadAddonUpdate(url: str, destPath: Optional[str], fileHash: Optional[str]) -> None:
	if not destPath:
		import tempfile
		destPath = tempfile.mktemp(prefix="nvda_addonUpdate-", suffix=".nvda-addon")
	log.debug(f"nvda3208: dest path is {destPath}")
	# #2352: Some security scanners such as Eset NOD32 HTTP Scanner
	# cause huge read delays while downloading.
	# Therefore, set a higher timeout.
	try:
		remote = urlopen(url, timeout=120)
	except:
		log.debug("Could not access download URL")
		raise RuntimeError("Could not access download URL")
	if remote.code != 200:
		remote.close()
		raise RuntimeError("Download failed with code %d" % remote.code)
	size: int = int(remote.headers["content-length"])
	log.debug(f"nvda3208: remote size is {size} bytes")
	with open(destPath, "wb") as local:
		if fileHash:
			hasher = hashlib.sha256()
		read: int = 0
		AddonDownloadNotifier.notify(read=read, size=size)
		chunk: int = 8192
		while True:
			if size - read < chunk:
				chunk = size - read
			block = remote.read(chunk)
			if not block:
				break
			read += len(block)
			local.write(block)
			if fileHash:
				hasher.update(block)
			AddonDownloadNotifier.notify(read=read, size=size)
		remote.close()
		if read < size:
			raise RuntimeError("Content too short")
		if fileHash and hasher.hexdigest() != fileHash:
			raise RuntimeError("Content has incorrect file hash")
	log.debug("nvda3208: download complete")
	AddonDownloadNotifier.notify(read=read, size=size)


# Record install status.
class AddonInstallStatus(enum.IntEnum):
	AddonInstallSuccess = 0
	AddonInstallGenericError = 1
	AddonReadBundleFailed = 2
	AddonMinVersionNotMet = 3
	AddonNotTested = 4


def installAddonUpdate(destPath: str, addonName: str) -> int:
	try:
		bundle = addonHandler.AddonBundle(destPath)
	except:
		log.error(f"Error opening addon bundle from {destPath}", exc_info=True)
		return AddonInstallStatus.AddonReadBundleFailed
	# NVDA itself will check add-on compatibility range.
	# As such, the below fragment was borrowed from NVDA Core (credit: NV Access).
	from addonHandler import addonVersionCheck
	if not addonVersionCheck.hasAddonGotRequiredSupport(bundle):
		return AddonInstallStatus.AddonMinVersionNotMet
	elif not addonVersionCheck.isAddonTested(bundle):
		return AddonInstallStatus.AddonNotTested
	bundleName: str = bundle.manifest['name']
	# Optimization (future): it is better to remove would-be add-ons all at once
	# instead of doing it each time a bundle is opened.
	for addon in addonHandler.getAvailableAddons():
		if bundleName == addon.manifest['name']:
			if not addon.isPendingRemove:
				addon.requestRemove()
			break
	try:
		gui.ExecAndPump(addonHandler.installAddonBundle, bundle)
	except:
		log.error(f"Error installing  addon bundle from {destPath}", exc_info=True)
		return AddonInstallStatus.AddonInstallGenericError
	return AddonInstallStatus.AddonInstallSuccess
