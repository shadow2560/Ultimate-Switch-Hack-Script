#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	With thanks to https://switchbrew.org/wiki/NPDM and https://switchbrew.org/wiki/NACP
	This file is on GPL V3 licence
"""

import sys
import os
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 est requis pour lancer ce script, pas Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

meta_magic = b'META'
acid_magic = b'ACID'
aci0_magic = b'ACI0'

def test_src_file(file_src_path):
	file_type = 'nacp'
	nacp_size = 16384
	try:
		with open(file_src_path, 'rb') as file_src:
			test_meta_magic = file_src.read(0x4)
			file_src.seek(0x70)
			aci0_start = file_src.read(0x4)
			aci0_start = int.from_bytes(aci0_start, 'little')
			# print(aci0_start)
			file_src.seek(0x280)
			test_acid_magic = file_src.read(0x4)
			file_src.seek(aci0_start)
			test_aci0_magic = file_src.read(0x4)
			if (test_meta_magic == meta_magic and test_acid_magic == acid_magic and test_aci0_magic == aci0_magic):
				file_type = 'npdm'
			if file_type != 'npdm':
				file_src.seek(0, os.SEEK_END)
				if (file_src.tell() != nacp_size):
					print("Le fichier ne semble pas être de type NPDM ou NACP.")
					return(1)
			file_src.seek(0)
			file_datas=file_src.read()
			file_src.close()
	except:
		print ('Le fichier "' + file_src_path + '" n\'existe pas ou une erreur s\'est produite durant sa lecture.')
		raise
		sys.exit(101)
	result = [file_type, file_datas]
	return(result)

def rewrite_npdm_file(file_src_path, file_dest_path, title_id):
	global src_file_infos
	if (file_src_path != file_dest_path):
		write_mode = 'wb+'
	else:
		write_mode = 'rb+'
	try:
		with open(file_dest_path, write_mode) as file_dest:
			if (write_mode == 'wb+'):
				file_dest.write(src_file_infos[1])
			file_dest.seek(0x70)
			aci0_start = file_dest.read(0x4)
			aci0_start = int.from_bytes(aci0_start, 'little')
			# file_dest.seek(0x80+0x210)
			# file_dest.write(title_id.to_bytes(8, 'little'))
			# file_dest.write(title_id.to_bytes(8, 'little'))
			file_dest.seek(aci0_start+0x10)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little'))
			file_dest.close()
	except:
		print ('Le fichier "' + file_dest_path + '" n\'existe pas.')
		raise
		return(101)
	print("Traitement effectué avec succès.")
	return(0)

def rewrite_nacp_file(file_src_path, file_dest_path, title_id, game_name, game_author, game_version, program_index):
	global src_file_infos
	if (file_src_path != file_dest_path):
		write_mode = 'wb+'
	else:
		write_mode = 'rb+'
	try:
		with open(file_dest_path, write_mode) as file_dest:
			if (write_mode == 'wb+'):
				file_dest.write(src_file_infos[1])
			file_dest.seek(0)
			file_dest.write(b'\0'*0x3000)
			file_dest.seek(0)
			for i in range(0x1, 0x11, 0x1):
				if (game_name != ''):
					file_dest.write(bytes(game_name, 'utf-8'))
				file_dest.seek(i*0x300-0x100)
				if (game_author != ''):
					file_dest.write(bytes(game_author, 'utf-8'))
				file_dest.seek(i*0x300)
			if (game_version != ''):
				file_dest.seek(0x3060)
				file_dest.write(b'\0'*0x10)
				file_dest.seek(0x3060)
				file_dest.write(bytes(game_version, 'utf-8'))
			# Title id work
			file_dest.seek(0x3038)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little'))
			file_dest.seek(0x3070)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little'))
			file_dest.seek(0x3078)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little'))		
			file_dest.seek(0x30B0)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little')*0x8)
			file_dest.seek(0x30F8)
			file_dest.write(int(title_id, base=16).to_bytes(8, 'little'))
			# Program index work
			file_dest.seek(0x3212)
			file_dest.write(int(str(program_index), base=16).to_bytes(1, 'little'))
			file_dest.close()
	except:
		print ('Le fichier "' + file_dest_path + '" n\'existe pas.')
		raise
		return(101)
	print("Traitement effectué avec succès.")
	return(0)

def help():
	print ('Utilisation:')
	print ()
	print ('npdm_and_nacp_rewrite.py -t Type_de_fichier -d Title_ID -n nom_du_jeu -a auteur_du_jeu -v Version_du_jeu -p ProgramIndex -i Chemin_fichier_source -o Chemin_fichier_destination')
	print("\nType_de_fichier peut être:")
	print("npdm: Traiter un fichier npdm (les paramètres Nom_du_jeu, Auteur_du_jeu et Version_du_jeu ne seront pas pris en compte).")
	print("nacp: Traiter un fichier nacp.")
	print("\nLe Title_ID doit faire 16 caractères hexadécimaux et commencer à partir de 01, le paramètre Nom_du_jeu peut faire jusqu'à " + str(int(0x200/4)) + " caractères, le paramètre Auteur_du_jeu peut faire jusqu'à " + str(int(0x100/4)) + " caractères, le paramètre Version_du_jeu peut faire jusqu'à " + str(int(0x10/4)) + " caractères et le paramètre ProgramIndex doit être un entier allant de 0 à 9 inclus (ce paramètre est défini à 0 par défaut).")
	return(0)

file_type = ''
title_id = ''
game_name = ''
game_author= ''
game_version = ''
program_index = 0
file_src_path = ''
file_dest_path = ''
if (len(sys.argv) == 1):
	help()
	sys.exit(0)
file_type_param = 0
title_id_param = 0
game_name_param = 0
game_author_param = 0
game_version_param = 0
program_index_param = 0
input_param = 0
output_param = 0
for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-t'):
		if (file_type_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		file_type = sys.argv[i+1]
		file_type_param = 1
	elif currArg.startswith('-d'):
		if (title_id_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		title_id = sys.argv[i+1]
		title_id_param = 1
	elif currArg.startswith('-n'):
		if (game_name_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		game_name = sys.argv[i+1]
		game_name_param = 1
	elif currArg.startswith('-a'):
		if (game_author_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		game_author = sys.argv[i+1]
		game_author_param = 1
	elif currArg.startswith('-v'):
		if (game_version_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		game_version = sys.argv[i+1]
		game_version_param = 1
	elif currArg.startswith('-p'):
		if (program_index_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		program_index = int(sys.argv[i+1])
		program_index_param = 1
	elif currArg.startswith('-i'):
		if (input_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		file_src_path = os.path.abspath(sys.argv[i+1])
		input_param = 1
	elif currArg.startswith('-o'):
		if (output_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		file_dest_path = os.path.abspath(sys.argv[i+1])
		output_param = 1
	else:
		print('Erreur de saisie des arguments.\n')
		help()
		sys.exit(301)
if (file_src_path == file_dest_path):
	print("Les chemins d'entrée et de sortie ne peuvent être les mêmes.\n")
	help()
	sys.exit(301)
src_file_infos = test_src_file(file_src_path)
if (src_file_infos == 1):
	help()
	sys.exit(301)
if (file_type != '' and file_type != src_file_infos[0]):
	print("Il semble que le type de fichier indiqué ne corresponde pas avec le type de fichier vérifié, le script ne va pas continuer par mesure de sécurité.")
	help()
	sys.exit(301)
file_type = src_file_infos[0]
if (file_type == 'npdm'):
	if (title_id == ''):
		print("Le paramètre Title_id est requis pour modifier  le type de fichier npdm.")
		help()
		sys.exit(301)
	if title_id.startswith('00'):
		print("Le paramètre Title_id ne peut commencer qu'à partir de 01.")
		help()
		sys.exit(301)
	if (len(title_id) != 16):
		print("Le paramètre Title_id doit faire 16 caractères hexadécimaux pour modifier  le type de fichier npdm.")
		help()
		sys.exit(301)
elif (file_type == 'nacp'):
	if (title_id == ''):
		print("Le paramètre Title_id est requis pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	if title_id.startswith('00'):
		print("Le paramètre Title_id ne peut commencer qu'à partir de 01.")
		help()
		sys.exit(301)
	if (len(title_id) != 16):
		print("Le paramètre Title_id doit faire 16 caractères hexadécimaux pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	if (game_name == '' and game_author == '' and game_version == ''):
		print("Les paramètres Nom_du_jeu, Auteur_du_jeu ou/et Version_du_jeu sont requis pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	if (len(game_name) > int(0x200/4)):
		print("Le paramètre Nom_du_jeu  ne doit pas faire plus de " + str(int(0x200/4)) + " caractères pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	if (len(game_author) > int(0x100/4)):
		print("Le paramètre Auteur_du_jeu  ne doit pas faire plus de " + str(int(0x100/4)) + " caractères pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	if (len(game_version) > int(0x10/4)):
		print("Le paramètre Version_du_jeu  ne doit pas faire plus de " + str(int(0x10/4)) + " caractères pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
	
	if program_index > 9 or program_index < 0:
		print("Le paramètre ProgramIndex doit être compris entre 0 et 9 pour modifier  le type de fichier nacp.")
		help()
		sys.exit(301)
else:
	print("Le paramètre Type_de_fichier  doit être \"nacp\" ou \"npdm\".")
	help()
	sys.exit(301)
if (file_src_path == ''):
	print("Le paramètre Chemin_fichier_source est requis.")
	help()
	sys.exit(301)
if (file_dest_path == ''):
	print("Le paramètre Chemin_fichier_destination n'a pas été renseigné, le fichier source sera modifié directement.")
	file_dest_path = file_src_path

if (file_type == 'npdm'):
	return_code = rewrite_npdm_file(file_src_path, file_dest_path, title_id)
elif (file_type == 'nacp'):
	return_code = rewrite_nacp_file(file_src_path, file_dest_path, title_id, game_name, game_author, game_version, program_index)
else:
	help()
	sys.exit(301)

# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
sys.exit(return_code)