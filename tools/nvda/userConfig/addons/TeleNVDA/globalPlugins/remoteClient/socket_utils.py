import urllib.parse
import ssl

SERVER_PORT = 6837

def address_to_hostport(addr):
	"""Converts an address such as google.com:80 into an address adn port tuple.
	If no port is given, use SERVER_PORT."""
	addr = urllib.parse.urlparse('//'+addr)
	port = addr.port or SERVER_PORT
	return (addr.hostname, port)

def hostport_to_address(hostport):
	host, port = hostport
	if ':' in host:
		host = '[' + host + ']'
	if port != SERVER_PORT:
		return host+':'+str(port)
	return host

def wrap_socket(sock, keyfile=None, certfile=None, server_side=False, cert_reqs=ssl.CERT_NONE, ssl_version=ssl.PROTOCOL_TLS_SERVER, ca_certs=None, do_handshake_on_connect=True, suppress_ragged_eofs=True, ciphers=None):
	if server_side and not certfile:
		raise ValueError("certfile must be specified for server-side operations")
	if keyfile and not certfile:
		raise ValueError("certfile must be specified")
	context = ssl.SSLContext(ssl_version)
	context.minimum_version = ssl.TLSVersion.TLSv1_2
	if cert_reqs == ssl.CERT_NONE and ssl_version == ssl.PROTOCOL_TLS_CLIENT:
		context.check_hostname = False
	context.verify_mode = cert_reqs
	if ca_certs:
		context.load_verify_locations(ca_certs)
	if certfile:
		context.load_cert_chain(certfile, keyfile)
	if ciphers:
		context.set_ciphers(ciphers)
	return context.wrap_socket(sock=sock, server_side=server_side, do_handshake_on_connect=do_handshake_on_connect, suppress_ragged_eofs=suppress_ragged_eofs)
