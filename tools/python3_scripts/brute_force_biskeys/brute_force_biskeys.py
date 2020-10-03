#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	This file is on GPL V3 licence
"""

import sys
import os
import subprocess

def runcommand (cmd):
	proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, universal_newlines=True)
	std_out, std_err = proc.communicate()
	return proc.returncode, std_out, std_err

if sys.argv[1] == "PRODINFO":
	bis_key = "bis_key_00"
if sys.argv[1] == "SAFE":
	bis_key = "bis_key_01"
if sys.argv[1] == "SYSTEM":
	bis_key = "bis_key_02"
if sys.argv[1] == "USER":
	bis_key = "bis_key_03"
input_file = sys.argv[2]
output_file = sys.argv[3]
temp_biskey_file = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'temp_biskey.txt')
a=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
for i in range(a, 0, -1):
	temp_keys_file = open(temp_biskey_file, 'w+', encoding='utf-8')
	temp_key = hex(i).split("x")
	b=len(hex(i))-2
	if b < 64:
		c = 64-b
		temp_key[1] = "0"*c + temp_key[1]
	temp_keys_file.write(bis_key + ' = ' + temp_key[1])
	temp_keys_file.close()
	code, out, err = runcommand("tools\\NxNandManager\\NxNandManager_old.exe --info -i \"" + input_file + "\" -keyset \"" + temp_biskey_file + "\"")
	if code == 0:
		break
os.remove(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'temp_biskey.txt'))
keys_file = open(output_file, 'w+', encoding='utf-8')
keys_file.write(bis_key + ' = ' + temp_key[1])
keys_file.close()