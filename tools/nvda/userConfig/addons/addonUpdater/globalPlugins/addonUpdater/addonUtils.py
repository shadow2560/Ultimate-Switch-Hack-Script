# Add-on Updater
# Copyright 2018-2022 Joseph Lee, released under GPL.

import pickle
from urllib.request import urlopen
import ctypes
import ssl
import os
import globalVars

updateState = {}


def loadState():
	global updateState
	try:
		# Pickle wants to work with bytes.
		with open(os.path.join(globalVars.appArgs.configPath, "nvda3208.pickle"), "rb") as f:
			updateState = pickle.load(f)
	except (IOError, EOFError, NameError, ValueError, pickle.UnpicklingError):
		updateState["autoUpdate"] = True
		updateState["updateNotification"] = "toast"
		updateState["lastChecked"] = 0
		updateState["noUpdates"] = []
		updateState["devUpdates"] = []
		updateState["legacyAddonsFound"] = set()
	# Just to make sure...
	if "autoUpdate" not in updateState:
		updateState["autoUpdate"] = True
	if "updateNotification" not in updateState:
		updateState["updateNotification"] = "toast"
	if "lastChecked" not in updateState:
		updateState["lastChecked"] = 0
	if "noUpdates" not in updateState:
		updateState["noUpdates"] = []
	if "devUpdates" not in updateState:
		updateState["devUpdates"] = []
	if "legacyAddonsFound" not in updateState:
		updateState["legacyAddonsFound"] = set()


def saveState(keepStateOnline=False):
	global updateState
	try:
		with open(os.path.join(globalVars.appArgs.configPath, "nvda3208.pickle"), "wb") as f:
			pickle.dump(updateState, f, protocol=0)
	except IOError:
		pass
	if not keepStateOnline:
		updateState = None


# Load and save add-on state if asked by the user.
def reload(factoryDefaults=False):
	if not factoryDefaults:
		loadState()
	else:
		updateState.clear()
		updateState["autoUpdate"] = True
		updateState["updateNotification"] = "toast"
		updateState["lastChecked"] = 0
		updateState["noUpdates"] = []
		updateState["devUpdates"] = []


def save():
	saveState(keepStateOnline=True)


# Borrowed from NVDA Core (the only difference is the URL and where structures are coming from).
# Flake8: ignore this function altogether.
def _updateWindowsRootCertificates():
	import updateCheck
	crypt = ctypes.windll.crypt32
	# Get the server certificate.
	sslCont = ssl._create_unverified_context()
	u = urlopen("https://addons.nvda-project.org", context=sslCont)
	cert = u.fp._sock.getpeercert(True)
	u.close()
	# Convert to a form usable by Windows.
	certCont = crypt.CertCreateCertificateContext(
		0x00000001,  # X509_ASN_ENCODING
		cert,
		len(cert))
	# Ask Windows to build a certificate chain, thus triggering a root certificate update.
	chainCont = ctypes.c_void_p()
	crypt.CertGetCertificateChain(None, certCont, None, None,
		ctypes.byref(updateCheck.CERT_CHAIN_PARA(cbSize=ctypes.sizeof(updateCheck.CERT_CHAIN_PARA),
			RequestedUsage=updateCheck.CERT_USAGE_MATCH())),
		0, None,
		ctypes.byref(chainCont))
	crypt.CertFreeCertificateChain(chainCont)
	crypt.CertFreeCertificateContext(certCont)
