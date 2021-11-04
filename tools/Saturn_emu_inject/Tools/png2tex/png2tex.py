#!/usr/bin/python
# -*- coding:Utf-8 -*-

# Coded by botik of Gbatemp forum, see https://gbatemp.net/threads/saturn-emulation-using-cotton-guardian-force-testing-and-debug.600756/post-9635281 for original source
# Modified by shadow256

import sys
import os
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 is required to launch this script, not Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

def write_files(src, dest):
	head=b'\x00\x40\x00\x00\x01\x00\x10\x08'
	if os.path.isfile(src):
		png_is_already_tex = 0
		try:
			with open(src,'rb') as f:
				temp=f.read()
				lg=len(temp)
				f.seek(0)
				test = f.read(len(head))
				if test == head:
					png_is_already_tex = 1
				f.close()
		except:
			raise
			return(101)
		try:
			with open(dest,'wb') as f:
				if png_is_already_tex == 1:
					f.write(temp)
				else:
					f.write(head)
					f.write(lg.to_bytes(4,'little'))
					f.write(int.from_bytes(temp[0x12:0x14],'big').to_bytes(2,'little'))
					f.write(int.from_bytes(temp[0x16:0x18],'big').to_bytes(2,'little'))
					f.write(temp)
				f.close()
		except:
			raise
			return(102)
	else:
		if not os.path.exists(dest):
			os.makedirs(dest)
		elif os.path.isfile(dest):
			print('A file exist for destination witch need to create a directory with this name.')
			return(103)
		i = 0
		j = len(src) + 1
		for root, dirs, files in os.walk(src):
			for name in files:
				png_is_already_tex = 0
				temp_file = os.path.join(root, name)
				if temp_file[-3:].lower() == 'png':
					if i > 0 and not os.path.exists(os.path.join(dest, root[j:])):
						os.makedirs(os.path.join(dest, root[j:]))
					try:
						with open(temp_file,'rb') as f:
							temp=f.read()
							lg=len(temp)
							f.seek(0)
							test = f.read(len(head))
							if test == head:
								png_is_already_tex = 1
							f.close()
					except:
						raise
						return(101)
					try:
						with open(os.path.join(dest, root[j:], name[0:-3] + 'tex'),'wb') as f:
							if png_is_already_tex == 1:
								f.write(temp)
							else:
								f.write(head)
								f.write(lg.to_bytes(4,'little'))
								f.write(int.from_bytes(temp[0x12:0x14],'big').to_bytes(2,'little'))
								f.write(int.from_bytes(temp[0x16:0x18],'big').to_bytes(2,'little'))
								f.write(temp)
							f.close()
					except:
						raise
						return(102)
			i = 1
	return(0)

def help():
	print ('usage:')
	print ()
	print ('png2tex.py png_file_source_or_folder [tex_dest]')
	print ()
	print ('If tex_dest is not specified, path will be the same as png_file_or_folder_source except the extension of the file witch be ".tex" if the param is a file.')
	print("If png_file_source_or_folder is a folder, all sub-folders will be analysed and replicated in the dest path if a png is found.")
	print("If png_file_source_or_folder is a file, the output will be a file and if it's a folder it will be a folder witch will be created if necessary and converted files will be named as the png but with the .tex extension replacing the png extension.")
	print ()
	return(0)

if (len(sys.argv) < 2):
	help()
	sys.exit(301)
if len(sys.argv) >= 3:
	if  os.path.isfile(sys.argv[1]) and sys.argv[1].lower() == sys.argv[2].lower():
		print("png_file_source_or_folder and tex_dest could not be the same.\n")
		help()
		sys.exit(301)
if sys.argv[1].lower() == '-h' or sys.argv[1].lower() == '--help':
	help()
	sys.exit(301)
if os.path.exists(sys.argv[1]):
	png = os.path.abspath(sys.argv[1])
else:
	print('The png file or folder does not exist.')
	sys.exit(301)
tex = ''
if len(sys.argv) >= 3:
	if os.path.isfile(png) and os.path.isdir(sys.argv[2]):
		print('A directory exist with this name, file could not be created.')
		sys.exit(301)
	tex = sys.argv[2]
else:
	if os.path.isfile(png):
		print("the tex file destination param has not been specified, it will be initialized with the value of the png source except for the png extension witch is replaced by the tex extension.")
		if png[-3:].lower() == 'png':
			tex = png[0:-3] + 'tex'
	elif os.path.isdir(png):
		print("the tex  folder destination param has not been specified, it will be initialized with the value of the source folder.")
		tex = png
return_code=write_files(png, tex)

# print("Execution time : %s secondes ---" % (time.time() - start_time))

sys.exit(return_code)