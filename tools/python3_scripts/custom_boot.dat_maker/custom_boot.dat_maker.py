#!/usr/bin/python
# -*- coding:Utf-8 -*-

###############################################
# TX SX Pro Custom Payload Packer - by CTCaer #
# Modified by shadow256 #
###############################################

import struct
import hashlib
from os import unlink
import sys
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 is required to launch tyhis script, not Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

"""
typedef struct boot_dat_hdr
{
	unsigned char ident[0x10];
	unsigned char sha2_s2[0x20];
	unsigned int s2_dst;
	unsigned int s2_size;
	unsigned int s2_enc;
	unsigned char pad[0x10];
	unsigned int s3_size;
	unsigned char pad2[0x90];
	unsigned char sha2_hdr[0x20];
} boot_dat_hdr_t;
"""

def sha256(data):
	sha256 = hashlib.new('sha256')
	sha256.update(data)
	return sha256.digest()

def help():
	print ('Usage:')
	print ()
	print ('custom_boot.dat_maker.py -i payload_to_pack_path -o boot.dat_folder_path')
	print('')
	print('Default path for the payload to pack is "payload.bin" and default boot.dat path is "boot.dat".')
	return(0)

boot_fn = 'boot.dat'
stage2_fn = 'payload.bin'
boot_fn_param = 0
stage2_fn_param = 0
for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-i'):
		if (stage2_fn_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		stage2_fn = os.path.abspath(sys.argv[i+1])
		stage2_fn_param = 1
	elif currArg.startswith('-o'):
		if (boot_fn_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		boot_fn = os.path.abspath(sys.argv[i+1])
		boot_fn = os.path.join(boot_fn, 'boot.dat')
		boot_fn_param = 1
	else:
		print('Erreur de saisie des arguments.\n')
		help()
		sys.exit(301)
if (stage2_fn == boot_fn):
	print("Les chemins d'entrée et de sortie ne peuvent être les mêmes.\n")
	help()
	sys.exit(301)

boot = open(boot_fn, 'wb')

with open(stage2_fn, 'rb') as fh:
	stage2 = bytearray(fh.read())
	stage2 = bytes(stage2)

# Re-create the header.
header = b''

# Magic ID.
header += b'\x43\x54\x43\x61\x65\x72\x20\x42\x4F\x4F\x54\x00'

# Version 2.5.
header += b'\x56\x32\x2E\x35'

# Set sha256 hash of stage2 payload.
header += sha256(stage2)

# Set stage2 payload destination to 0x40010000.
header += b'\x00\x00\x01\x40'

# Stage2 payload size.
header += struct.pack('I', len(stage2))

# Disable Stage2 encryption.
header += struct.pack('I', 0)

# Add padding. Stage3 size is 0.
header += b'\x00' * 0xA4

# Add header's sha256 hash.
sha256 = hashlib.new('sha256')
sha256.update(header)
header += sha256.digest()

# Write header and the plaintext custom payload.
boot.write(header)
boot.write(stage2)

boot.close()

# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
sys.exit(0)