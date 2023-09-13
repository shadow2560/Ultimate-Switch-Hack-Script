
from io import StringIO
import os
import configobj
from configobj import validate
import globalVars
from . import socket_utils


CONFIG_FILE_NAME = 'teleNVDA.ini'

_config = None
configspec = StringIO("""
[connections]
	last_connected = list(default=list("remote.nvda.es"))
[controlserver]
	autoconnect = boolean(default=False)
	self_hosted = boolean(default=False)
	UPNP = boolean(default=False)
	connection_type = integer(default=0)
	host = string(default="remote.nvda.es")
	port = integer(default=6837)
	key = string(default="")

[seen_motds]
	__many__ = string(default="")

[trusted_certs]
	__many__ = string(default="")

[ui]
	play_sounds = boolean(default=True)
	allow_speech_commands = boolean(default=True)
	portcheck = string(default="https://nvda.es/portcheck.php?port={port}")
""")
def get_config():
	global _config
	if not _config:
		path = os.path.abspath(os.path.join(globalVars.appArgs.configPath, CONFIG_FILE_NAME))
		_config = configobj.ConfigObj(infile=path, configspec=configspec, default_encoding='utf8', create_empty=True)
		val = validate.Validator()
		_config.validate(val, copy=True)
	return _config

def write_connection_to_config(address):
	"""Writes an address to the last connected section of the config.
	If the address is already in the config, move it to the end."""
	conf = get_config()
	last_cons = conf['connections']['last_connected']
	address = socket_utils.hostport_to_address(address)
	if address in last_cons:
		conf['connections']['last_connected'].remove(address)
	conf['connections']['last_connected'].append(address)
	conf.write()
