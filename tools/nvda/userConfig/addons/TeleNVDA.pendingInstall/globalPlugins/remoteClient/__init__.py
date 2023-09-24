import addonHandler
import api
import configobj
import core
import braille
import ctypes
import ctypes.wintypes
import globalVars
import gui
from gui import NVDASettingsDialog
import IAccessibleHandler
import json
import logging
import os
import queueHandler
try:
	from winAPI.secureDesktop import post_secureDesktopStateChange
except:
	post_secureDesktopStateChange = None
import versionInfo
import shlobj
import speech
import socket
import ssl
import sys
import threading
import ui
import uuid
import wx
import base64
from config import conf as nvda_conf, isInstalledCopy
from globalPluginHandler import GlobalPlugin as _GlobalPlugin
from keyboardHandler import KeyboardInputGesture
from logHandler import log
from scriptHandler import script
from winUser import WM_QUIT

logger = logging.getLogger(__name__)

from . import bridge
from . import configuration
from . import cues
from . import dialogs
from . import keyboard_hook
from . import local_machine
from . import serializer
from . import server
from . import url_handler
from .socket_utils import SERVER_PORT, address_to_hostport, hostport_to_address
from .transport import RelayTransport, TransportEvents

from .session import MasterSession, SlaveSession
try:
	addonHandler.initTranslation()
except addonHandler.AddonError:
	log.warning(
		"Unable to initialise translations. This may be because the addon is running from NVDA scratchpad."
	)
logging.getLogger("keyboard_hook").addHandler(logging.StreamHandler(sys.stdout))

class GlobalPlugin(_GlobalPlugin):
	# Translators: script category for add-on gestures
	scriptCategory = _("TeleNVDA")

	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		for addon in addonHandler.getAvailableAddons(): 
			if addon.name == "remote" and not addon.isDisabled:
				raise RuntimeError("TeleNVDA cannot be used while NVDA Remote is running. Please, disable NVDA Remote and restart NVDA.")
		self.local_machine = local_machine.LocalMachine()
		self.slave_session = None
		self.master_session = None
		self.create_menu()
		NVDASettingsDialog.categoryClasses.append(dialogs.OptionsDialog)
		self.connecting = False
		self.url_handler_window = url_handler.URLHandlerWindow(callback=self.verify_connect)
		url_handler.register_url_handler()
		self.master_transport = None
		self.slave_transport = None
		self.server = None
		self.hook_thread = None
		self.sending_keys = False
		self.key_modifiers = set()
		self.hostPendingModifiers = set()
		self.ignoreGesture = False
		self.guestScripts = (self.script_sendKeys, self.script_ignoreNextGesture)
		self.sd_server = None
		self.sd_relay = None
		self.sd_bridge = None
		try:
			configuration.get_config()
		except configobj.ParseError:
			os.remove(os.path.abspath(os.path.join(globalVars.appArgs.configPath, configuration.CONFIG_FILE_NAME)))
			queueHandler.queueFunction(queueHandler.eventQueue, wx.CallAfter, wx.MessageBox, _("Your NVDA Remote configuration was corrupted and has been reset."), _("NVDA Remote Configuration Error"), wx.OK|wx.ICON_EXCLAMATION)
		if hasattr(shlobj, 'SHGetKnownFolderPath'):
			self.temp_location = os.path.join(shlobj.SHGetKnownFolderPath(shlobj.FolderId.PROGRAM_DATA), 'temp')
		else:
			self.temp_location = os.path.join(shlobj.SHGetFolderPath(0, shlobj.CSIDL_COMMON_APPDATA), 'temp')
		self.ipc_file = os.path.join(self.temp_location, 'remote.ipc')
		self.sd_focused = False
		if post_secureDesktopStateChange:
			post_secureDesktopStateChange.register(self.onSecureDesktopChange)
		if hasattr(globalVars, 'teleNVDA'):
			self.postStartupHandler()
		core.postNvdaStartup.register(self.postStartupHandler)
		globalVars.teleNVDA = None

	def postStartupHandler(self):
		cs = configuration.get_config()['controlserver']
		if globalVars.appArgs.secure:
			self.handle_secure_desktop()
		if cs['autoconnect'] and not self.master_session and not self.slave_session:
			wx.CallLater(50,self.perform_autoconnect)

	def perform_autoconnect(self):
		cs = configuration.get_config()['controlserver']
		channel = cs['key']
		if cs['self_hosted']:
			port = cs['port']
			address = ('localhost',port)
			UPNP = cs['UPNP']
			self.start_control_server(port, channel, UPNP)
		else:
			address = address_to_hostport(cs['host'])
		if cs['connection_type']==0:
			self.connect_as_slave(address, channel)
		else:
			self.connect_as_master(address, channel)

	def create_menu(self):
		self.menu = wx.Menu()
		tools_menu = gui.mainFrame.sysTrayIcon.toolsMenu
		# Translators: Item in TeleNVDA submenu to connect to a remote computer.
		self.connect_item = self.menu.Append(wx.ID_ANY, _("Connect..."), _("Remotely connect to another computer running NVDA Remote Access or TeleNVDA"))
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.do_connect, self.connect_item)
		# Translators: Item in TeleNVDA submenu to disconnect from a remote computer.
		self.disconnect_item = self.menu.Append(wx.ID_ANY, _("Disconnect"), _("Disconnect from another computer running NVDA Remote Access or TeleNVDA"))
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_disconnect_item, self.disconnect_item)
		self.menu.Remove(self.disconnect_item.Id)
		# Translators: Menu item in TeleNVDA submenu to mute speech and sounds from the remote computer.
		self.mute_item = self.menu.Append(wx.ID_ANY, _("Mute remote"), _("Mute speech and sounds from the remote computer"))
		self.mute_item.Enable(False)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_mute_item, self.mute_item)
		# Translators: Menu item in TeleNVDA submenu to push clipboard content to the remote computer.
		self.push_clipboard_item = self.menu.Append(wx.ID_ANY, _("&Push clipboard"), _("Push the clipboard to the other machine"))
		self.push_clipboard_item.Enable(False)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_push_clipboard_item, self.push_clipboard_item)
		# Translators: Menu item in TeleNVDA submenu to send a file to the remote computer.
		self.send_file_item = self.menu.Append(wx.ID_ANY, _("Send &file..."), _("Send a file to the other machine"))
		self.send_file_item.Enable(False)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_send_file_item, self.send_file_item)
		self.copyLinkMenu = wx.Menu()
		# Translators: Menu item in TeleNVDA submenu to copy a link to the current session compatible with NVDA Remote.
		self.copy_link_remote_item = self.copyLinkMenu .Append(wx.ID_ANY, _("NVDA &Remote protocol (recommended)"), _("Copy a link to the remote session compatible with both NVDA Remote and TeleNVDA"))
		self.copy_link_remote_item.Enable(False)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_copy_link_remote_item, self.copy_link_remote_item)
		# Translators: Menu item in TeleNVDA submenu to copy a link to the current session compatible with TeleNVDA.
		self.copy_link_tele_item = self.copyLinkMenu .Append(wx.ID_ANY, _("&TeleNVDA protocol"), _("Copy a link to the remote session compatible only with TeleNVDA"))
		self.copy_link_tele_item.Enable(False)
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_copy_link_tele_item, self.copy_link_tele_item)
		# Translators: Menu item in TeleNVDA submenu to copy a link to the current session.
		self.copy_link_item=self.menu.AppendSubMenu(self.copyLinkMenu, _("Copy &link"), _("Copy a link to the remote session"))
		# Translators: Menu item in TeleNVDA submenu to open add-on options.
		self.options_item = self.menu.Append(wx.ID_ANY, _("&Options..."), _("Options"))
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_options_item, self.options_item)
		# Translators: Menu item in TeleNVDA submenu to send Control+Alt+Delete to the remote computer.
		self.send_ctrl_alt_del_item = self.menu.Append(wx.ID_ANY, _("Send Ctrl+Alt+Del"), _("Send Ctrl+Alt+Del"))
		gui.mainFrame.sysTrayIcon.Bind(wx.EVT_MENU, self.on_send_ctrl_alt_del, self.send_ctrl_alt_del_item)
		self.send_ctrl_alt_del_item.Enable(False)

		# Translators: Label of menu in NVDA tools menu.
		self.remote_item=tools_menu.AppendSubMenu(self.menu, _("R&emote"), _("TeleNVDA"))

	def terminate(self):
		if post_secureDesktopStateChange:
			post_secureDesktopStateChange.unregister(self.onSecureDesktopChange)
		self.disconnect()
		self.local_machine.terminate()
		self.local_machine = None
		NVDASettingsDialog.categoryClasses.remove(dialogs.OptionsDialog)
		self.copyLinkMenu.Remove(self.copy_link_remote_item.Id)
		self.copy_link_remote_item.Destroy()
		self.copy_link_remote_item=None
		self.copyLinkMenu.Remove(self.copy_link_tele_item.Id)
		self.copy_link_tele_item.Destroy()
		self.copy_link_tele_item=None
		try:
			self.menu.Remove(self.connect_item.Id)
			self.menu.Remove(self.disconnect_item.Id)
		except:
			pass
		self.connect_item.Destroy()
		self.connect_item=None
		self.disconnect_item.Destroy()
		self.disconnect_item=None
		self.menu.Remove(self.mute_item.Id)
		self.mute_item.Destroy()
		self.mute_item=None
		self.menu.Remove(self.push_clipboard_item.Id)
		self.push_clipboard_item.Destroy()
		self.push_clipboard_item=None
		self.menu.Remove(self.send_file_item.Id)
		self.send_file_item.Destroy()
		self.send_file_item=None
		self.menu.Remove(self.copy_link_item.Id)
		self.copy_link_item.Destroy()
		self.copy_link_item = None
		self.menu.Remove(self.options_item.Id)
		self.options_item.Destroy()
		self.options_item=None
		self.menu.Remove(self.send_ctrl_alt_del_item.Id)
		self.send_ctrl_alt_del_item.Destroy()
		self.send_ctrl_alt_del_item=None
		tools_menu = gui.mainFrame.sysTrayIcon.toolsMenu
		tools_menu.Remove(self.remote_item.Id)
		self.remote_item.Destroy()
		self.remote_item=None
		try:
			self.menu.Destroy()
			self.copyLinkMenu.Destroy()
		except (RuntimeError, AttributeError):
			pass
		try:
			os.unlink(self.ipc_file)
		except:
			pass
		self.menu=None
		if not isInstalledCopy():
			url_handler.unregister_url_handler()
		self.url_handler_window.destroy()
		self.url_handler_window=None
		core.postNvdaStartup.unregister(self.postStartupHandler)

	def on_disconnect_item(self, evt):
		if evt:
			evt.Skip()
		def disconnect_as_slave_with_alert():
			if (self.slave_transport is not None
				and configuration.get_config()['ui']['alert_before_slave_disconnect']
				and not gui.message.isModalMessageBoxActive()):  # Check if a modal message box is open
				result = gui.messageBox(
					# Translators: question before disconnecting
					message=_("Are you sure you want to disconnect the controlled computer?"),
					# Translators: question title
					caption=_("Warning!"),
					style=wx.YES | wx.NO | wx.ICON_WARNING
				)
				if result == wx.YES:
					self.disconnect()
			elif (self.master_transport is not None
				  or (self.slave_transport is not None
					  and not configuration.get_config()['ui']['alert_before_slave_disconnect'])):
				self.disconnect()
		wx.CallAfter(disconnect_as_slave_with_alert)

	def on_mute_item(self, evt):
		if evt:
			evt.Skip()
		self.local_machine.is_muted = not self.local_machine.is_muted
		if self.local_machine.is_muted:
			# Translators: Menu item in TeleNVDA submenu to unmute speech and sounds from the remote computer.
			self.mute_item.SetItemLabel(_("Unmute remote"))
		else:
			# Translators: Menu item in TeleNVDA submenu to mute speech and sounds from the remote computer.
			self.mute_item.SetItemLabel(_("Mute remote"))

	def on_push_clipboard_item(self, evt):
		connector = self.slave_transport or self.master_transport
		try:
			connector.send(type='set_clipboard_text', text=api.getClipData())
			cues.clipboard_pushed()
		except TypeError:
			log.exception("Unable to push clipboard")


	def on_send_file_item(self, evt):
		connector = self.slave_transport or self.master_transport
		if not getattr(connector, 'connected', False):
			ui.message(_("Not connected."))
			return
		if globalVars.appArgs.secure:
			return
		# Check if a file dialog is already open
		if getattr(self, 'is_send_file_dialog_open', False):
			return
		# Set the flag to True, indicating that the file dialog is open
		setattr(self, 'is_send_file_dialog_open', True)
		fd = wx.FileDialog(gui.mainFrame,
			# Translators: message displayed in transfer file dialog when sending a file
			message=_("Choose the file you want to send to the remote computer"),
			# Translators: supported file types when sending or receiving files
			wildcard=_("All files (*.*)") + "|*.*",
			defaultDir=os.environ['userprofile'], style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST | wx.FD_PREVIEW)
		if fd.ShowModal() != wx.ID_OK:
			# Reset the flag to False after the file dialog is closed
			setattr(self, 'is_send_file_dialog_open', False)
			return
		# Reset the flag to False after the file dialog is closed
		setattr(self, 'is_send_file_dialog_open', False)
		filename = os.path.basename(fd.GetPath())
		try:
			f = open(fd.GetPath(), "rb")
			file_content = f.read()
			f.close()
		except:
			logger.exception("Unable to read the specified file")
		if len(file_content) > 10485760:
			gui.messageBox(
				# Translators: error message when a file is too big
				message=_("This file is too large. Only files smaller than 10 MB are supported."),
				# Translators: error message caption
				caption=_("Error"),
				style=wx.ICON_ERROR)
			return
		result = gui.messageBox(
			# Translators: question before sending a file
			message=_("The session will be blocked until the transfer is complete. Are you sure you want to continue?"),
			# Translators: question title
			caption=_("Warning!"),
			style=wx.YES | wx.NO | wx.ICON_WARNING)
		if result == wx.YES:
			file_content = base64.b64encode(file_content)
			connector.send(type='file_transfer', name=filename, content=file_content.decode("utf-8"))
			cues.clipboard_pushed()
			# Translators: message spoken when the file has been sent successfully
			ui.message(_("File sent"))

	@script(
		# Translators: send file gesture description
		_("Sends the specified file to the remote machine"),
		gesture="kb:control+shift+NVDA+f")
	def script_send_file(self, gesture):
		wx.CallAfter(self.on_send_file_item, None)

	@script(
		# Translators: push clipboard gesture description
		_("Sends the contents of the clipboard to the remote machine"),
		gesture="kb:control+shift+NVDA+c")
	def script_push_clipboard(self, gesture):
		connector = self.slave_transport or self.master_transport
		if not getattr(connector,'connected',False):
			ui.message(_("Not connected."))
			return
		try:
			connector.send(type='set_clipboard_text', text=api.getClipData())
			cues.clipboard_pushed()
			ui.message(_("Clipboard pushed"))
		except TypeError:
			ui.message(_("Unable to push clipboard"))

	def on_copy_link_remote_item(self, evt):
		session = self.master_session or self.slave_session
		url = session.get_connection_info().get_url_to_connect(0)
		api.copyToClip(str(url))

	def on_copy_link_tele_item(self, evt):
		session = self.master_session or self.slave_session
		url = session.get_connection_info().get_url_to_connect(1)
		api.copyToClip(str(url))

	def on_options_item(self, evt):
		wx.CallAfter(gui.mainFrame.popupSettingsDialog if hasattr(gui.mainFrame, "popupSettingsDialog") else gui.mainFrame._popupSettingsDialog, gui.NVDASettingsDialog, dialogs.OptionsDialog)
		evt.Skip()

	def on_send_ctrl_alt_del(self, evt):
		self.master_transport.send('send_SAS')

	def disconnect(self):
		if self.master_transport is None and self.slave_transport is None:
			return
		if self.server is not None:
			self.server.close()
			self.server = None
		if self.master_transport is not None:
			self.disconnect_as_master()
		if self.slave_transport is not None:
			self.disconnect_as_slave()
		# Translators: Presented when disconnected from the remote computer.
		ui.message(_("Disconnected!"))
		cues.disconnected()
		if self.menu.FindItemById(self.disconnect_item.Id):
			self.menu.Remove(self.disconnect_item.Id)
		if not self.menu.FindItemById(self.connect_item.Id):
			self.menu.Insert(0, self.connect_item)
		self.push_clipboard_item.Enable(False)
		self.send_file_item.Enable(False)
		self.copy_link_remote_item.Enable(False)
		self.copy_link_tele_item.Enable(False)

	def disconnect_as_master(self):
		self.master_transport.close()
		self.master_transport = None
		self.master_session = None

	def disconnecting_as_master(self):
		if self.menu:
			if not self.menu.FindItemById(self.connect_item.Id):
				self.menu.Insert(0, self.connect_item)
			if self.menu.FindItemById(self.disconnect_item.Id):
				self.menu.Remove(self.disconnect_item.Id)
			# Translators: Menu item in TeleNVDA submenu to mute speech and sounds from the remote computer.
			self.mute_item.SetItemLabel(_("Mute remote"))
			self.mute_item.Enable(False)
			self.push_clipboard_item.Enable(False)
			self.send_file_item.Enable(False)
			self.copy_link_remote_item.Enable(False)
			self.copy_link_tele_item.Enable(False)
			self.send_ctrl_alt_del_item.Enable(False)
		if self.local_machine:
			self.local_machine.is_muted = False
		self.sending_keys = False
		if self.hook_thread is not None:
			ctypes.windll.user32.PostThreadMessageW(self.hook_thread.ident, WM_QUIT, 0, 0)
			self.hook_thread.join()
			self.hook_thread = None
		self.key_modifiers = set()

	def disconnect_as_slave(self):
		self.slave_transport.close()
		self.slave_transport = None
		self.slave_session = None

	def on_connected_as_master_failed(self):
		if self.master_transport.successful_connects == 0:
			self.disconnect_as_master()
			# Translators: Title of the connection error dialog.
			gui.messageBox(parent=gui.mainFrame, caption=_("Error Connecting"),
			# Translators: Message shown when cannot connect to the remote computer.
			message=_("Unable to connect to the remote computer"), style=wx.OK | wx.ICON_WARNING)

	def do_connect(self, evt):
		if evt:
			evt.Skip()
		# Check if the connect dialog is already open
		if getattr(self, 'is_connect_dialog_open', False):
			return
		# Set the flag to True, indicating that the connect dialog is open
		setattr(self, 'is_connect_dialog_open', True)
		last_cons = configuration.get_config()['connections']['last_connected']
		# Translators: Title of the connect dialog.
		dlg = dialogs.DirectConnectDialog(parent=gui.mainFrame, id=wx.ID_ANY, title=_("Connect"))
		dlg.panel.host.SetItems(list(reversed(last_cons)))
		dlg.panel.host.SetSelection(0)
		def handle_dlg_complete(dlg_result):
			if dlg_result != wx.ID_OK:
				# Reset the flag to False when the dialog is closed
				setattr(self, 'is_connect_dialog_open', False)
				return
			if dlg.client_or_server.GetSelection() == 0: #client
				host = dlg.panel.host.GetValue()
				server_addr, port = address_to_hostport(host)
				channel = dlg.panel.key.GetValue()
				if dlg.connection_type.GetSelection() == 0:
					self.connect_as_master((server_addr, port), channel)
				else:
					self.connect_as_slave((server_addr, port), channel)
			else: #We want a server
				channel = dlg.panel.key.GetValue()
				self.start_control_server(int(dlg.panel.port.GetValue()), channel, useUPNP=bool(dlg.panel.useUPNP.GetValue()))
				if dlg.connection_type.GetSelection() == 0:
					self.connect_as_master(('127.0.0.1', int(dlg.panel.port.GetValue())), channel, insecure=True)
				else:
					self.connect_as_slave(('127.0.0.1', int(dlg.panel.port.GetValue())), channel, insecure=True)
			# Reset the flag to False when the dialog is closed
			setattr(self, 'is_connect_dialog_open', False)
		gui.runScriptModalDialog(dlg, callback=handle_dlg_complete)

	def on_connected_as_master(self):
		configuration.write_connection_to_config(self.master_transport.address)
		if not self.menu.FindItemById(self.disconnect_item.Id):
			self.menu.Insert(0, self.disconnect_item)
		if self.menu.FindItemById(self.connect_item.Id):
			self.menu.Remove(self.connect_item.Id)
		self.mute_item.Enable(True)
		self.push_clipboard_item.Enable(True)
		if not globalVars.appArgs.secure:
			self.send_file_item.Enable(True)
		self.copy_link_remote_item.Enable(True)
		self.copy_link_tele_item.Enable(True)
		self.send_ctrl_alt_del_item.Enable(True)
		# We might have already created a hook thread before if we're restoring an
		# interrupted connection. We must not create another.
		if not self.hook_thread:
			self.hook_thread = threading.Thread(target=self.hook)
			self.hook_thread.daemon = True
			self.hook_thread.start()
		# Translators: Presented when connected to the remote computer.
		ui.message(_("Connected!"))
		cues.connected()

	def on_disconnected_as_master(self):
		# Translators: Presented when connection to a remote computer was interupted.
		ui.message(_("Connection interrupted"))

	def connect_as_master(self, address, key, insecure=False):
		transport = RelayTransport(address=address, serializer=serializer.JSONSerializer(), channel=key, connection_type='master', insecure=insecure)
		self.master_session = MasterSession(transport=transport, local_machine=self.local_machine)
		transport.callback_manager.register_callback(TransportEvents.CERTIFICATE_AUTHENTICATION_FAILED, self.on_certificate_as_master_failed)
		transport.callback_manager.register_callback(TransportEvents.CONNECTED, self.on_connected_as_master)
		transport.callback_manager.register_callback(TransportEvents.CONNECTION_FAILED, self.on_connected_as_master_failed)
		transport.callback_manager.register_callback(TransportEvents.CLOSING, self.disconnecting_as_master)
		transport.callback_manager.register_callback(TransportEvents.DISCONNECTED, self.on_disconnected_as_master)
		self.master_transport = transport
		self.master_transport.reconnector_thread.start()

	def connect_as_slave(self, address, key, insecure=False):
		if not nvda_conf['keyboard']['handleInjectedKeys'] and gui.messageBox(
		# Translators: A message to warn the user that handle keys from other applications should be on.
		message=_("The option to handle keys from other applications is disabled in your NVDA keyboard settings. In order to allow the keyboard of this machine to be controlled, this option should be enabled. Would you like to do this now?"),
		# Translators: The title of the warning dialog displayed when handle keys from other applications is disabled.
		caption=_("Warning"),style=wx.YES|wx.NO|wx.ICON_WARNING)==wx.YES:
			nvda_conf['keyboard']['handleInjectedKeys']=True
		transport = RelayTransport(serializer=serializer.JSONSerializer(), address=address, channel=key, connection_type='slave', insecure=insecure)
		self.slave_session = SlaveSession(transport=transport, local_machine=self.local_machine)
		self.slave_transport = transport
		transport.callback_manager.register_callback(TransportEvents.CERTIFICATE_AUTHENTICATION_FAILED, self.on_certificate_as_slave_failed)
		self.slave_transport.callback_manager.register_callback(TransportEvents.CONNECTED, self.on_connected_as_slave)
		self.slave_transport.reconnector_thread.start()
		if not self.menu.FindItemById(self.disconnect_item.Id):
			self.menu.Insert(0, self.disconnect_item)
		if self.menu.FindItemById(self.connect_item.Id):
			self.menu.Remove(self.connect_item.Id)

	def handle_certificate_failed(self, transport):
		self.last_fail_address = transport.address
		self.last_fail_key = transport.channel
		self.disconnect()
		try:
			cert_hash = transport.last_fail_fingerprint
			wnd = dialogs.CertificateUnauthorizedDialog(None, fingerprint=cert_hash)
			a = wnd.ShowModal()
			if a == wx.ID_YES:
				config = configuration.get_config()
				config['trusted_certs'][hostport_to_address(self.last_fail_address)]=cert_hash
				config.write()
			if a == wx.ID_YES or a == wx.ID_NO: return True
		except Exception as ex:
			log.error(ex)
		return False

	def on_certificate_as_master_failed(self):
		if self.handle_certificate_failed(self.master_transport):
			self.connect_as_master(self.last_fail_address, self.last_fail_key, True)

	def on_certificate_as_slave_failed(self):
		if self.handle_certificate_failed(self.slave_transport):
			self.connect_as_slave(self.last_fail_address, self.last_fail_key, True)

	def on_connected_as_slave(self):
		log.info("Control connector connected")
		cues.control_server_connected()
		# Translators: Presented in direct (client to server) remote connection when the controlled computer is ready.
		speech.speakMessage(_("Connected to control server"))
		self.push_clipboard_item.Enable(True)
		if not globalVars.appArgs.secure:
			self.send_file_item.Enable(True)
		self.copy_link_remote_item.Enable(True)
		self.copy_link_tele_item.Enable(True)
		configuration.write_connection_to_config(self.slave_transport.address)

	def start_control_server(self, server_port, channel, useUPNP=False):
		self.server = server.Server(server_port, channel, UPNP=useUPNP)
		server_thread = threading.Thread(target=self.server.run)
		server_thread.daemon = True
		server_thread.start()

	def hook(self):
		log.debug("Hook thread start")
		keyhook = keyboard_hook.KeyboardHook()
		keyhook.register_callback(self.hook_callback)
		msg = ctypes.wintypes.MSG()
		while ctypes.windll.user32.GetMessageW(ctypes.byref(msg), None, 0, 0):
			pass
		log.debug("Hook thread end")
		keyhook.free()

	def hook_callback(self, **kwargs):
		#Prevent disabling sending keys if another key is held down
		if not self.sending_keys:
			return False
		keyCode = (kwargs['vk_code'], kwargs['extended'])
		if not kwargs['pressed'] and keyCode in self.hostPendingModifiers:
			self.hostPendingModifiers.discard(keyCode)
			return False
		gesture = KeyboardInputGesture(self.key_modifiers, keyCode[0], kwargs['scan_code'], keyCode[1])
		if gesture.isModifier:
			if kwargs['pressed']:
				self.key_modifiers.add(keyCode)
			else:
				self.key_modifiers.discard(keyCode)
		elif kwargs['pressed']:
			script = gesture.script
			if self.ignoreGesture:
				self.ignoreGesture = False
			elif script in self.guestScripts:
				wx.CallAfter(script, gesture)
				return True
		self.master_transport.send(type="key", **kwargs)
		return True #Don't pass it on

	def set_receiving_braille(self, state):
		if state and self.master_session.patch_callbacks_added and braille.handler.enabled:
			self.master_session.patcher.patch_braille_input()
			if versionInfo.version_year < 2023:
				braille.handler.enabled = False
				if braille.handler._cursorBlinkTimer:
					braille.handler._cursorBlinkTimer.Stop()
					braille.handler._cursorBlinkTimer=None
				if braille.handler.buffer is braille.handler.messageBuffer:
					braille.handler.buffer.clear()
					braille.handler.buffer = braille.handler.mainBuffer
					if braille.handler._messageCallLater:
						braille.handler._messageCallLater.Stop()
						braille.handler._messageCallLater = None
			self.local_machine.receiving_braille=True
		elif not state:
			self.master_session.patcher.unpatch_braille_input()
			if versionInfo.version_year < 2023:
				braille.handler.enabled = bool(braille.handler.displaySize)
			self.local_machine.receiving_braille=False

	def onSecureDesktopChange(self, isSecureDesktop: bool):
		'''
		@param isSecureDesktop: True if the new desktop is the secure desktop.
		'''
		if isSecureDesktop:
			self.enter_secure_desktop()
		else:
			self.leave_secure_desktop()

	def event_gainFocus(self, obj, nextHandler):
		if not hasattr(IAccessibleHandler, 'SecureDesktopNVDAObject'):
			nextHandler()
			return
		if isinstance(obj, IAccessibleHandler.SecureDesktopNVDAObject):
			self.sd_focused = True
			self.enter_secure_desktop()
		elif self.sd_focused and not isinstance(obj, IAccessibleHandler.SecureDesktopNVDAObject):
			#event_leaveFocus won't work for some reason
			self.sd_focused = False
			self.leave_secure_desktop()
		nextHandler()

	def enter_secure_desktop(self):
		"""function ran when entering a secure desktop."""
		if self.slave_transport is None:
			return
		if not os.path.exists(self.temp_location):
			os.makedirs(self.temp_location)
		channel = str(uuid.uuid4())
		self.sd_server = server.Server(port=0, password=channel, bind_host='127.0.0.1')
		port = self.sd_server.server_socket.getsockname()[1]
		server_thread = threading.Thread(target=self.sd_server.run)
		server_thread.daemon = True
		server_thread.start()
		self.sd_relay = RelayTransport(address=('127.0.0.1', port), serializer=serializer.JSONSerializer(), channel=channel, insecure=True)
		self.sd_relay.callback_manager.register_callback('msg_client_joined', self.on_master_display_change)
		self.slave_transport.callback_manager.register_callback('msg_set_braille_info', self.on_master_display_change)
		self.sd_bridge = bridge.BridgeTransport(self.slave_transport, self.sd_relay)
		relay_thread = threading.Thread(target=self.sd_relay.run)
		relay_thread.daemon = True
		relay_thread.start()
		data = [port, channel]
		with open(self.ipc_file, 'w') as fp:
			json.dump(data, fp)

	def leave_secure_desktop(self):
		if self.sd_server is None:
			return #Nothing to do
		self.sd_bridge.disconnect()
		self.sd_bridge = None
		self.sd_server.close()
		self.sd_server = None
		self.sd_relay.close()
		self.sd_relay = None
		self.slave_transport.callback_manager.unregister_callback('msg_set_braille_info', self.on_master_display_change)
		self.slave_session.set_display_size()

	def on_master_display_change(self, **kwargs):
		self.sd_relay.send(type='set_display_size', sizes=self.slave_session.master_display_sizes)

	SD_CONNECT_BLOCK_TIMEOUT = 1
	def handle_secure_desktop(self):
		try:
			with open(self.ipc_file) as fp:
				data = json.load(fp)
			os.unlink(self.ipc_file)
			port, channel = data
			test_socket=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			test_socket=ssl.wrap_socket(test_socket)
			test_socket.connect(('127.0.0.1', port))
			test_socket.close()
			self.connect_as_slave(('127.0.0.1', port), channel, insecure=True)
			# So we don't miss the first output when switching to a secure desktop,
			# block the main thread until the connection is established. We're
			# connecting to localhost, so this should be pretty fast. Use a short
			# timeout, though.
			self.slave_transport.connected_event.wait(self.SD_CONNECT_BLOCK_TIMEOUT)
		except:
			pass

	def verify_connect(self, con_info):
		if self.is_connected() or self.connecting:
			gui.messageBox(_("TeleNVDA is already connected. Disconnect before opening a new connection."), _("TeleNVDA Already Connected"), wx.OK|wx.ICON_WARNING)
			return
		self.connecting = True
		server_addr = con_info.get_address()
		key = con_info.key
		if con_info.mode == 'master':
			message = _("Do you wish to control the machine on server {server} with key {key}?").format(server=server_addr, key=key)
		elif con_info.mode == 'slave':
			message = _("Do you wish to allow this machine to be controlled on server {server} with key {key}?").format(server=server_addr, key=key)
		if gui.messageBox(message, _("TeleNVDA Connection Request"), wx.YES|wx.NO|wx.NO_DEFAULT|wx.ICON_WARNING) != wx.YES:
			self.connecting = False
			return
		if con_info.mode == 'master':
			self.connect_as_master((con_info.hostname, con_info.port), key=key)
		elif con_info.mode == 'slave':
			self.connect_as_slave((con_info.hostname, con_info.port), key=key)
		self.connecting = False

	def is_connected(self):
		connector = self.slave_transport or self.master_transport
		if connector is not None:
			return connector.connected
		return False

	@script(
		# Translators: Copy link compatible with NVDA Remote gesture description
		_("Copies a link to the remote session to the clipboard compatible with both NVDA Remote and TeleNVDA"))
	def script_copy_remote_link(self, gesture):
		connector = self.slave_transport or self.master_transport
		if not getattr(connector,'connected',False):
			ui.message(_("Not connected."))
			return
		self.on_copy_link_remote_item(None)
		ui.message(_("Copied link"))

	@script(
		# Translators: Copy link compatible with TeleNVDA gesture description
		_("Copies a link to the remote session to the clipboard compatible only with TeleNVDA"))
	def script_copy_tele_link(self, gesture):
		connector = self.slave_transport or self.master_transport
		if not getattr(connector,'connected',False):
			ui.message(_("Not connected."))
			return
		self.on_copy_link_tele_item(None)
		ui.message(_("Copied link"))

	@script(
		# Translators: description for the Connect gesture
		_("""Opens a dialog to start a remote session"""),
		gesture="kb:alt+NVDA+pageUp")
	def script_connect(self, gesture):
		if self.master_transport or self.slave_transport:
			ui.message(_("TeleNVDA Already Connected"))
			return
		self.do_connect(None)

	@script(
		# Translators: description for the Disconnect gesture
		_("""Disconnect a remote session"""),
		gesture="kb:alt+NVDA+pageDown")
	def script_disconnect(self, gesture):
		if self.master_transport is None and self.slave_transport is None:
			ui.message(_("Not connected."))
			return
		self.on_disconnect_item(None)

	@script(
		# Translators: gesture description for the ignoreNextGesture script
		_("""Set the host to ignore the next gesture completely, sending next gesture to the guest as is. Useful when you need to use the gesture asigned to toggle between guest and host, in the guest machine."""),
		gesture = "kb:control+f11")
	def script_ignoreNextGesture(self, gesture):
		if not self.master_transport or not self.sending_keys:
			return gesture.send()
		self.ignoreGesture = True
		# Translators: Report when the next gesture will be send to the guest ignoring everything else.
		ui.message(_("Send next gesture to the guest"))

	@script(
		# Translators: Documentation string for the script that toggles the control between guest and host machine.
		_("Toggles the control between guest and host machine"),
		gesture="kb:f11"
	)
	def script_sendKeys(self, gesture):
		if not self.master_transport:
			gesture.send()
			return
		self.sending_keys = not self.sending_keys
		self.set_receiving_braille(self.sending_keys)
		if self.sending_keys:
			self.hostPendingModifiers = gesture.modifiers
			# Translators: Presented when sending keyboard keys from the controlling computer to the controlled computer.
			ui.message(_("Controlling remote machine."))
		else:
			# release all pressed keys in the guest.
			for k in self.key_modifiers:
				self.master_transport.send(type="key", vk_code=k[0], extended=k[1], pressed=False)
			self.key_modifiers = set()
			# Translators: Presented when keyboard control is back to the controlling computer.
			ui.message(_("Controlling local machine."))

	@script(
		# Translators: gesture description for the toggle remote mute script
		_("""Mute or unmute the speech coming from the remote computer"""))
	def script_toggle_remote_mute(self, gesture):
		if not self.is_connected() or self.connecting: return
		self.on_mute_item(None)
		# Translators: Report when using gestures to mute or unmute the speech coming from the remote computer.
		status = _("Mute speech and sounds from the remote computer") if self.local_machine.is_muted else _("Unmute speech and sounds from the remote computer")
		ui.message(status)
