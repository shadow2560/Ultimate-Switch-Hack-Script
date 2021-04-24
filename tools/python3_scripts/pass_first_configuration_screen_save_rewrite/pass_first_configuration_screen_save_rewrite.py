#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	This file is on GPL V3 licence
"""

# from copy import deepcopy
import sys
import binascii
import subprocess
import os
import struct
# import hashlib
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 est requis pour lancer ce script, pas Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

def help():
	print ('Utilisation:')
	print ()
	print ('pass_first_configuration_screen_save_rewrite.py -k chemin_prod.keys_de_la_console -i chemin_fichier_sauvegarde_à_modifier')
	print ()
	print ('Attention, ce programme peut modifier n\'importe quel sauvegarde, veuillez bien choisir le fichier "8000000000000050" de votre dossier "save" de la partition SYSTEM.')
	return 1

if (len(sys.argv) == 1):
	help()
	sys.exit(0)
for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-k'):
		prod_keys_path = os.path.abspath(sys.argv[i+1])
	elif currArg.startswith('-i'):
		save_file_path = os.path.abspath(sys.argv[i+1])
	else:
		print('Erreur de saisie des arguments.\n')
		help()
		sys.exit(301)

hactoolnet_program_path = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactoolnet.exe')
extracted_file_path = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'file')
pipes = subprocess.Popen('\"' + hactoolnet_program_path + '\" -t save -k \"' + prod_keys_path + '\" \"' + save_file_path + '\" --outdir \"' + os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))) + '\"', stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
stdout, std_err = pipes.communicate()
if pipes.returncode != 0:
	err_msg = "%s. Code: %s" % (std_err.strip(), pipes.returncode)
	raise Exception(err_msg)
	sys.exit(100)

try:
	with open(extracted_file_path, 'rb+') as extracted_file:
		extracted_file.seek(0x29484)
		extracted_file.write(struct.pack('2s', binascii.unhexlify('01')))
		extracted_file.close()
except:
	print ('Le fichier "' + extracted_file_path + ' n\'a pas pu être créé.')
	raise
	sys.exit(102)

pipes = subprocess.Popen('\"' + hactoolnet_program_path + '\" -t save -k \"' + prod_keys_path + '\" \"' + save_file_path + '\" --replacefile file \"' + extracted_file_path + '\"', stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
stdout, std_err = pipes.communicate()
if pipes.returncode != 0:
	err_msg = "%s. Code: %s" % (std_err.strip(), pipes.returncode)
	raise Exception(err_msg)
	sys.exit(100)
	os.remove(extracted_file_path)
print('Fichier de la sauvegarde modifié avec succès.')

# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
sys.exit(0)