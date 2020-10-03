#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	This file is on GPL V3 licence
"""

from copy import deepcopy
import sys
import binascii
import hashlib
import os
import fleep
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 est requis pour lancer ce script, pas Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

def file_is_text(fname):
	try:
		with open(fname, "rb") as file:
			info = fleep.get(file.read(128))
			file.close()
	except:
		print ('Le fichier "' + fname + '" n\'existe pas.')
		return 0
	# print(info.type)
	# print(info.extension)
	# print(info.mime)
	if (len(info.type) == 0):
		return 1
	else:
		print ('Erreur: Le fichier ne semble pas être un fichier texte.')
		return 0

def create_sha256_file(keys_file):
	try:
		with open(keys_file, 'r', encoding='utf-8') as keys_source_file:
			temp_keys_source_list = keys_source_file.readlines()
			keys_source_file.close()
	except:
		print('Le fichier de clés "' + keys_file + '" est inexistant')
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
		keys_source_list.append(temp_keys_source_list[i])
		i +=1
	del temp_keys_source_list
	i = 0
	sha256_list = deepcopy(keys_source_list)
	try:
		with open(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'sha256_sources.txt'), 'w', encoding='utf-8') as sha256_output_file:
			for item in keys_source_list:
				sha256_list[i][1] = hashlib.sha256(binascii.a2b_hex(item[1].lower().encode('utf-8'))).hexdigest()
				sha256_output_file.write(sha256_list[i][0] + ' = ' + sha256_list[i][1] + '\n')
				i +=1
			sha256_output_file.close()
	except:
		print('Impossible de créé le fichier sha256.')
		return 0
	return 1

def test_keys_file(keys_file):
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
		keys_source_list.append(temp_keys_source_list[i])
		i +=1
	del temp_keys_source_list
	i = 0
	sha256_list = deepcopy(keys_source_list)
	for item in keys_source_list:
		sha256_list[i][1] = hashlib.sha256(binascii.a2b_hex(item[1].lower().encode('utf-8'))).hexdigest()
		i += 1
	try:
		with open(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'sha256_sources.txt'), 'r', encoding='utf-8') as sha256_source_file:
			temp_sha256_source_list = sha256_source_file.readlines()
			sha256_source_file.close()
	except:
		print ('Le fichier "sha256_sources.txt" devant se trouver à côté de ce script est manquant, cette fonction ne peut pas continuer.')
		print ('Pour corriger ce problème, veuillez créer un fichier avec le paramètre "create_sha256_file" ou télécharger le fichier "sha256_sources.txt" sur le Github du projet et le mettre à côté de ce script.')
		return 0
	sha256_source_list=[]
	i = 0
	for item in temp_sha256_source_list:
		if (item == ''):
			i +=1
			continue
		temp_sha256_source_list[i] = item.split('=')
		temp_sha256_source_list[i][0] = temp_sha256_source_list[i][0].strip()
		temp_sha256_source_list[i][1] = temp_sha256_source_list[i][1][0:-1].strip()
		sha256_source_list.append(temp_sha256_source_list[i])
		i +=1
	del temp_sha256_source_list
	keys_not_verified = []
	keys_incorrect =[]
	for keys_source in sha256_list:
		i = 0
		for keys_verified in sha256_source_list:
			if (keys_source[0] == keys_verified[0]):
				if (keys_source[1] != keys_verified[1]):
					keys_incorrect.append(keys_source[0])
				break
			else:
				if (i+1 == len(sha256_source_list)):
					keys_not_verified.append(keys_source[0])
					
			i += 1
	for key_name in keys_not_verified:
		j = 0
		for keys in keys_source_list:
			if (key_name == keys[0]):
				del(keys_source_list[j])
				del(sha256_list[j])
				break
			j += 1
	keys_not_present =[]
	for sha256_source in sha256_source_list:
		j = 0
		for keys in keys_source_list:
			if (keys[0] == sha256_source[0]):
				break
			else:
				if (j+1 == len(keys_source_list)):
					keys_not_present.append(sha256_source[0])
			j +=1
	for key_name in keys_incorrect:
		j = 0
		for keys in keys_source_list:
			if (key_name == keys[0]):
				del(keys_source_list[j])
				del(sha256_list[j])
				break
			j += 1
	correct_keys_list = []
	if (len(keys_source_list) != 0):
		for keys in keys_source_list:
			correct_keys_list.append(keys[0])

	print ('nombre de clés possibles à analyser: ' + str(len(sha256_source_list)))
	if (len(correct_keys_list) == 0):
		print('Aucune clés vérifiable trouvée.')
	elif (len(correct_keys_list) == 1):
		print('Clé vérifiable trouvée: . + correct_keys_list[0]')
	else:
		print (str(len(correct_keys_list)) + ' Clés vérifiable trouvées: ' + ', '.join(correct_keys_list))
	if (len(keys_not_verified) == 0):
		print ('Aucune clé inconnue ou unique à la console trouvée')
	elif (len(keys_not_verified) == 1):
		print ('clé inconnue ou unique à la console trouvée: ' + keys_not_verified[0])
	else:
		print (str(len(keys_not_verified)) + ' clés inconnues ou uniques à la console trouvées: ' + ', '.join(keys_not_verified))
	if (len(keys_not_present) == 0):
		print ('Aucune clé manquante vérifiable trouvée.')
	elif (len(keys_not_present) == 1):
		print ('Clés manquante vérifiable trouvée: ' + keys_not_present[0])
	else:
		print (str(len(keys_not_present)) + ' clés manquantes vérifiables trouvées: ' + ', '.join(keys_not_present))
	if (len(keys_incorrect) == 0):
		print ('Aucune clé incorrecte trouvée.')
	elif (len(keys_incorrect) == 1):
		print ('Clé incorrecte trouvée: ' + keys_incorrect[0])
	else:
		print (str(len(keys_incorrect)) + ' clés incorrectes trouvées: ' + ', '.join(keys_incorrect))
	return(keys_source_list, keys_not_verified, keys_not_present, keys_incorrect)

def create_choidujour_keys_file(keys_file):
	keys_source_list = test_keys_file(keys_file)
	if (keys_source_list == 0):
		return 0
	choidujour_keys_needed = ['master_key_source', 'master_key_00', 'master_key_01', 'header_key', 'aes_kek_generation_source', 'aes_key_generation_source', 'key_area_key_application_source', 'key_area_key_ocean_source', 'key_area_key_system_source', 'package2_key_source']
	choidujour_keys_prefered = ['master_key_02', 'master_key_03', 'master_key_04', 'master_key_05', 'master_key_06', 'master_key_07']
	choidujour_list_prefered_usable = []
	stop_keys_prefered_insertion = 0
	for keys_prefered in choidujour_keys_prefered:
		j = 0
		for keys_source in keys_source_list[0]:
			if (keys_source[0] == keys_prefered):
				choidujour_list_prefered_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list[0])):
					stop_keys_prefered_insertion = 1
			j +=1
		if (stop_keys_prefered_insertion == 1):
			break
	choidujour_list_needed_usable = []
	stop_keys_needed_insertion = 0
	for keys_needed in choidujour_keys_needed:
		j = 0
		for keys_source in keys_source_list[0]:
			if (keys_source[0] == keys_needed):
				choidujour_list_needed_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list[0])):
					stop_keys_needed_insertion = 1
			j +=1
		if (stop_keys_needed_insertion == 1):
			print ('La clé "' + keys_needed + '" obligatoire ne se trouve pas dans le fichier de clé, le script ne peux pas continuer.')
			return 0
	if (len(choidujour_list_prefered_usable) != len(choidujour_keys_prefered)):
		print('La dernière clé facultative trouvée est la clé "' + choidujour_list_prefered_usable[-1][0] + '", vous ne pourrez générer que des packages de mise à jour jusqu\'au firmware n\'utilisant que les clés jusqu\'à celle-ci.')
	try:
		with open('ChoiDuJour_keys.txt', 'w', encoding='utf-8') as choidujour_keys_file:
			choidujour_keys_file.write(choidujour_list_needed_usable[0][0] + ' = ' + choidujour_list_needed_usable[0][1] + '\n')
			choidujour_keys_file.write(choidujour_list_needed_usable[1][0] + ' = ' + choidujour_list_needed_usable[1][1] + '\n')
			choidujour_keys_file.write(choidujour_list_needed_usable[2][0] + ' = ' + choidujour_list_needed_usable[2][1] + '\n')
			del(choidujour_list_needed_usable[0])
			del(choidujour_list_needed_usable[0])
			del(choidujour_list_needed_usable[0])
			for keys_source in choidujour_list_prefered_usable:
				choidujour_keys_file.write(keys_source[0] + ' = ' + keys_source[1] + '\n')
			for keys_source in choidujour_list_needed_usable:
				choidujour_keys_file.write(keys_source[0] + ' = ' + keys_source[1] + '\n')
			choidujour_keys_file.close()
			print ('Création du fichier "ChoiDuJour_keys.txt" effectuée avec succès.')
			return 1
	except:
		print ('Le fichier "ChoiDuJour_keys.txt" n\'a pas pu être créé ou une erreur d\'écriture s\'est produite.')
		return 0

def help():
	print ('Utilisation:')
	print ()
	print ('keys_management.py Action Fichier_de_clés')
	print ()
	print ('Le paramètre "Action" peut avoir les valeurs suivantes:')
	print ('create_sha256_file : Cré le fichier sha256 servant ensuite à la vérification des clés. La fonction analyse le fichier de clés et cré un fichier contenant le nom de chaque clé associé au sha256 de celle-ci. Attention car aucune vérification n\'est faite sur les clés uniques pour chaque console ou pour des erreurs éventuelles donc soyez certain de se que vous faites si vous utilisez cette fonction car l\'ancien fichier de vérification sera supprimé.')
	print ('test_keys_file : Test un fichier de clés en le comparant au fichier contenant les sha256 des clés connues et affiche le nombre de clés analysées, les clés inconnues ou uniques à la console trouvées ainsi que les clés incorrectes trouvées.')
	print ('create_choidujour_keys_file : Permet de créé un fichier de clés ne contenant que les clés nécessaire à ChoiDuJour pour créer un package de mise à jour. Le fichier sera nommé "ChoiDuJour_keys.txt" et se trouvera dans le dossier à partir duquel le script a été exécuté.')
	print ('test_file : Test seulement si le fichier passé en argument est un fichier texte. Si c\'est le cas, le script se terminera sans rien afficher.')
	return 1

if (len(sys.argv) != 3):
	print ('Nombre d\'arguments incorrect.')
	help()
	sys.exit(102)
if (sys.argv[1] == 'test_file'):
	if not (file_is_text(sys.argv[2])):
		sys.exit(101)
if not (file_is_text(sys.argv[2])):
	sys.exit(101)
if (sys.argv[1] == 'create_sha256_file'):
	create_sha256_file(sys.argv[2])
	sys.exit(0)
elif (sys.argv[1] == 'test_keys_file'):
	test_keys_file(sys.argv[2])
	# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
	sys.exit(0)
elif (sys.argv[1] == 'create_choidujour_keys_file'):
	create_choidujour_keys_file(sys.argv[2])
	sys.exit(0)
elif (sys.argv[1] == 'test_file'):
	pass
else:
	print ('Premier argument incorrect')
	help()
	sys.exit(100)