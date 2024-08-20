import os
import wx
from . import input
from . import cues
from . import configuration
import api
import nvwave
import tones
import speech
import ctypes
import braille
import inputCore

try:
	from systemUtils import hasUiAccess
except ModuleNotFoundError:
	from config import hasUiAccess
import ui
import versionInfo
import logging
import addonHandler
import globalVars
import base64
import gui
logger = logging.getLogger('local_machine')
from logHandler import log
try:
	addonHandler.initTranslation()
except addonHandler.AddonError:
	log.warning(
		"Unable to initialise translations. This may be because the addon is running from NVDA scratchpad."
	)


def setSpeechCancelledToFalse():
	"""
	This function updates the state of speech so that it is aware that future
	speech should not be cancelled. In the long term this is a fragile solution
	as NVDA does not support modifying the internal state of speech.
	"""
	if versionInfo.version_year >= 2021:
		# workaround as beenCanceled is readonly as of NVDA#12395
		speech.speech._speechState.beenCanceled = False
	else:
		speech.beenCanceled = False


class LocalMachine:

	def __init__(self):
		self.is_muted = False
		self.receiving_braille=False
		self._cached_sizes = None
		if versionInfo.version_year >= 2023:
			braille.decide_enabled.register(self.handle_decide_enabled)

	def terminate(self):
		if versionInfo.version_year >= 2023:
			braille.decide_enabled.unregister(self.handle_decide_enabled)

	def play_wave(self, fileName):
		"""Instructed by remote machine to play a wave file."""
		if self.is_muted:
			return
		if os.path.exists(fileName):
			# ignore async / asynchronous from kwargs:
			# playWaveFile should play asynchronously from TeleNVDA.
			nvwave.playWaveFile(fileName=fileName, asynchronous=True)

	def beep(self, hz, length, left, right, **kwargs):
		if self.is_muted:
			return
		tones.beep(hz, length, left, right)

	def cancel_speech(self, **kwargs):
		if self.is_muted:
			return
		wx.CallAfter(speech._manager.cancel)

	def pause_speech(self, switch, **kwargs):
		if self.is_muted:
			return
		wx.CallAfter(speech.pauseSpeech, switch)

	def speak(
			self,
			sequence,
			priority=speech.priorities.Spri.NORMAL,
			**kwargs
	):
		if self.is_muted:
			return
		setSpeechCancelledToFalse()
		if not configuration.get_config()['ui']['allow_speech_commands']:
			sequence = [s for s in sequence if isinstance(s, str)]
		wx.CallAfter(speech._manager.speak, sequence, priority)

	def display(self, cells, **kwargs):
		if self.receiving_braille and braille.handler.displaySize > 0 and len(cells) <= braille.handler.displaySize:
			# We use braille.handler._writeCells since this respects thread safe displays and automatically falls back to noBraille if desired
			cells = cells + [0] * (braille.handler.displaySize - len(cells))
			wx.CallAfter(braille.handler._writeCells, cells)

	def braille_input(self, **kwargs):
		try:
			inputCore.manager.executeGesture(input.BrailleInputGesture(**kwargs))
		except inputCore.NoInputGestureAction:
			pass

	def set_braille_display_size(self, sizes, **kwargs):
		if versionInfo.version_year >= 2023:
			self._cached_sizes = sizes
			return
		sizes.append(braille.handler.display.numCells)
		try:
			size=min(i for i in sizes if i>0)
		except ValueError:
			size = braille.handler.display.numCells
		braille.handler.displaySize = size
		braille.handler.enabled = bool(size)

	def handle_filter_displaySize(self, value):
		if not self._cached_sizes:
			return value
		sizes = self._cached_sizes + [value]
		try:
			return min(i for i in sizes if i>0)
		except ValueError:
			return value

	def handle_decide_enabled(self):
		return not self.receiving_braille

	def send_key(self, vk_code=None, extended=None, pressed=None, **kwargs):
		wx.CallAfter(input.send_key, vk_code, None, extended, pressed)

	def set_clipboard_text(self, text, **kwargs):
		cues.clipboard_received()
		ui.message(_("Clipboard updated"))
		api.copyToClip(text=text)

	def send_SAS(self, **kwargs):
		"""
		This function simulates as "a secure attention sequence" such as CTRL+ALT+DEL.
		SendSAS requires UI Access, so we provide a warning when this fails.
		This warning will only be read by the remote NVDA if it is currently connected to the machine.
		"""
		if hasUiAccess():
			ctypes.windll.sas.SendSAS(0)
		else:
			# Translators: Sent when a user fails to send CTRL+ALT+DEL from a remote NVDA instance
			ui.message(_("No permission on device to trigger CTRL+ALT+DEL from remote"))
			logger.warning("UI Access is disabled on this machine so cannot trigger CTRL+ALT+DEL")

	def file_transfer(self, name, content, **kwargs):
		if globalVars.appArgs.secure:
			return
		fd = wx.FileDialog(gui.mainFrame,
		# Translators: message displayed in transfer file dialog when receiving a file
		message=_("Choose where to save the received file"),
		defaultDir=os.environ['userprofile'], defaultFile=name,
		# Translators: supported file types when sending or receiving files
		wildcard=_("All files (*.*)")+"|*.*",
		style=wx.FD_SAVE | wx.FD_OVERWRITE_PROMPT)
		if fd.ShowModal() == wx.ID_OK:
			try:
				f = open(fd.GetPath(), "wb")
				file_content = base64.b64decode(content.encode("utf-8"))
				f.write(file_content)
				f.close()
				cues.clipboard_received()
				# Translators: message spoken when the file has been received successfully
				ui.message(_("File received"))
			except:
				logger.exception("Unable to save received file to disk")
