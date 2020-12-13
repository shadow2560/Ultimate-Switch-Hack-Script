#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	This file is on GPL V3 licence
"""

from copy import deepcopy
import sys
import binascii
import subprocess
import os
import struct
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 est requis pour lancer ce script, pas Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

def create_linkle_keys_file(keys_file):
	linkle_keys_needed = ['encrypted_keyblob_00']
	linkle_keys_prefered = ['encrypted_keyblob_01', 'encrypted_keyblob_02', 'encrypted_keyblob_03', 'encrypted_keyblob_04', 'encrypted_keyblob_05']
	linkle_keys_to_find = linkle_keys_needed + linkle_keys_prefered
	linkle_list_prefered_usable = []
	try:
		with open(keys_file, 'r', encoding='utf-8') as keys_source_file:
			temp_keys_source_list = keys_source_file.readlines()
			keys_source_file.close()
	except:
		print ('Le fichier "' + keys_file + '" n\'existe pas.')
		return 0
	keys_source_list=[]
	i = 0
	for item in temp_keys_source_list:
		if (len(item) == 1):
			i +=1
			continue
		temp_keys_source_list[i] = item.split('=')
		temp_keys_source_list[i][0] = temp_keys_source_list[i][0].strip()
		temp_keys_source_list[i][1] = temp_keys_source_list[i][1][0:-1].strip()
		for item in linkle_keys_to_find:
			if (item == temp_keys_source_list[i][0]):
				keys_source_list.append(temp_keys_source_list[i])
		i +=1
	del temp_keys_source_list
	stop_keys_prefered_insertion = 0
	i = 0
	for keys_prefered in linkle_keys_prefered:
		j = 0
		for keys_source in keys_source_list:
			if (keys_source[0] == keys_prefered):
				linkle_list_prefered_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list)):
					stop_keys_prefered_insertion = 1
			j +=1
		if (stop_keys_prefered_insertion == 1):
			print('La dernière clé facultative trouvée est la clé "' + linkle_list_prefered_usable[-1][0] + '", vous ne pourrez restaurer un fichier BOOT0 n\'utilisant que les clés jusqu\'à celle-ci.')
			break
	linkle_list_needed_usable = []
	stop_keys_needed_insertion = 0
	for keys_needed in linkle_keys_needed:
		j = 0
		for keys_source in keys_source_list:
			if (keys_source[0] == keys_needed):
				linkle_list_needed_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list)):
					stop_keys_needed_insertion = 1
			j +=1
		if (stop_keys_needed_insertion == 1):
			print ('La clé "' + keys_needed + '" obligatoire ne se trouve pas dans le fichier de clé, le script ne peux pas continuer.')
			return 0
	return (keys_source_list)

def help():
	print ('Utilisation:')
	print ()
	print ('boot0_rewrite.py -k chemin_prod.keys -i chemin_fichier_source_BOOT0 -o chemin_fichier_destination_BOOT0')
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
		boot0_file_src_path = os.path.abspath(sys.argv[i+1])
	elif currArg.startswith('-o'):
		boot0_file_dest_path = os.path.abspath(sys.argv[i+1])
	else:
		print('Erreur de saisie des arguments.\n')
		help()
		sys.exit(301)

linkle_keys_path = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'Linkle_keys.txt')
linkle_program_path = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'Linkle.exe')
try:
	with open(linkle_keys_path, 'w') as linkle_keys_file:
		pipes = subprocess.Popen('\"' + linkle_program_path + '\" keygen -k \"' + prod_keys_path + '\"', stdout=linkle_keys_file, stderr=subprocess.PIPE)
		stdout, std_err = pipes.communicate()
		linkle_keys_file.close()
except:
	print('Erreur de création du fichier de clés via Linkle.')
	sys.exit(100)
if pipes.returncode != 0:
	err_msg = "%s. Code: %s" % (std_err.strip(), pipes.returncode)
	raise Exception(err_msg)
	sys.exit(100)

keys_source_list = create_linkle_keys_file(linkle_keys_path)
os.remove(linkle_keys_path)
if (len(keys_source_list) == 0):
	print("Aucune key_blob trouvé.")
	sys.exit(201)
else:
	i = 0
	for item in keys_source_list:
		keys_source_list[i][1] = struct.pack('512s', binascii.unhexlify(item[1]))
		i += 1
boot0_bct_index = [[0, 0], [0, 0], [0, 0], [0, 0]]
try:
	with open(boot0_file_src_path, 'rb') as boot0_file_src:
		boot0_begin = boot0_file_src.read(0x180000)
		boot0_file_src.seek(0x2330)
		boot0_bct_index[0][0] = int.from_bytes(struct.pack('1s', boot0_file_src.read(0x1)), 'big')
		boot0_file_src.seek(0x6330)
		boot0_bct_index[1][0] = int.from_bytes(struct.pack('1s', boot0_file_src.read(0x1)), 'big')
		boot0_file_src.seek(0xa330)
		boot0_bct_index[2][0] = int.from_bytes(struct.pack('1s', boot0_file_src.read(0x1)), 'big')
		boot0_file_src.seek(0xe330)
		boot0_bct_index[3][0] = int.from_bytes(struct.pack('1s', boot0_file_src.read(0x1)), 'big')
		boot0_file_src.close()
except:
	print ('Le fichier "' + boot0_file_src_path + '" n\'existe pas.')
	raise
	sys.exit(101)
i = 0
for item2 in boot0_bct_index:
	boot0_bct_index[i][0] -= 1
	if boot0_bct_index[i][0] >5:
		boot0_bct_index[i][0] = 5
	for item in keys_source_list:
		if (item[0] == "encrypted_keyblob_0" + str(item2[0])):
			boot0_bct_index[i][1] = 1
			break
	i += 1
for item in boot0_bct_index:
	if (item[1] == 0):
		print("Une keyblob manquante est requise par un index d'un des BCT, impossible de reconstruire le fichier BOOT0.")
		sys.exit(110)

try:
	with open(boot0_file_dest_path, 'wb') as boot0_file:
		filesize = 0x400000
		boot0_file.write(b'\0'*filesize)
		# boot0_file.seek(0x400000 - 1)
		# boot0_file.write(b'\0')
		boot0_file.seek(0)
		boot0_file.write(boot0_begin)
		boot0_file.seek(0x180000)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_00"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180200)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_01"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180000)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_00"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180400)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_02"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180600)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_03"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180800)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_04"):
				boot0_file.write(item[1])
		boot0_file.seek(0x180a00)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_05"):
				boot0_file.write(item[1])
		boot0_file.seek(0x450)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_0" + str(boot0_bct_index[0][0])):
				boot0_file.write(item[1][0:0xb0])
		boot0_file.seek(0x4450)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_0" + str(boot0_bct_index[1][0])):
				boot0_file.write(item[1][0:0xb0])
		boot0_file.seek(0x8450)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_0" + str(boot0_bct_index[2][0])):
				boot0_file.write(item[1][0:0xb0])
		boot0_file.seek(0xc450)
		for item in keys_source_list:
			if (item[0] == "encrypted_keyblob_0" + str(boot0_bct_index[3][0])):
				boot0_file.write(item[1][0:0xb0])
		boot0_file.close()
except:
	print ('Le fichier "' + boot0_file_dest_path + ' n\'a pas pu être créé.')
	raise
	sys.exit(102)
print('Fichier BOOT0 modifié avec succès.')

# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
sys.exit(0)