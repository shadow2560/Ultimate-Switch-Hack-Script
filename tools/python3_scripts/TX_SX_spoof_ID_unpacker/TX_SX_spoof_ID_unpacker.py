#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been modified by shadow256 
"""

###############################################
# SX License Hack and Spoof - by Reacher17 #
# Thanks to the following: 
# B&nder, mrdude for the script
# Inaki - Fingerprint and license.dat
# Deejay87 for the tests
# Zoria - Linkynimes, Chronoss
# Heykyz for the unpacker.py
# a big thank you to Shadow256 and Darkstorm
# And all the others that i haven't mentioned.
###############################################
from Crypto.PublicKey import RSA
from Crypto.Cipher import AES
from Crypto.Util import Counter
import os
import hashlib
import struct
import binascii
from binascii import hexlify as _hexlify, unhexlify
import subprocess
import sys

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 is required to launch this script, not Python ' + str(sys.version_info[0]) + '.')
	sys.exit(1)

#-----------------------------------------------------

def help():
	print ('Usage:')
	print ()
	print ('TX_SX_spoof_ID_unpacker.py [-i boot.dat_3.1.0_file_path] [-f console_fingerprint_or_text_file_path_containing_fingerprint_to_spoof] [-l licence_request.dat_file_path] [-o output_folder_path]')
	return 1

bootori = ''
Request = ''
sxos_fingerprint = ''
output_folder_path = ''
for i in range(1,len(sys.argv), 2):
    currArg = sys.argv[i]
    if currArg.startswith('-h'):
        help()
        sys.exit(0)
    elif currArg.startswith('-i'):
        bootori = os.path.abspath(sys.argv[i+1])
    elif currArg.startswith('-f'):
        sxos_fingerprint = sys.argv[i+1]
    elif currArg.startswith('-l'):
        Request = os.path.abspath(sys.argv[i+1])
    elif currArg.startswith('-o'):
        output_folder_path = os.path.abspath(sys.argv[i+1])
    else:
        print('Error in arguments passed.\n')
        help()
        sys.exit(1)

if bootori == "":
    bootori = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'boot_ori.dat')
if Request == "":
    Request = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'license-request.dat')
if sxos_fingerprint == "":
    fpfile = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'fingerprint.txt')
elif os.path.isfile(os.path.abspath(sxos_fingerprint)):
    fpfile = os.path.abspath(sxos_fingerprint)
    sxos_fingerprint = ''
else:
    if len(sxos_fingerprint) != 32:
        print("Fingerprint must be 32 characters long, exiting script.")
        sys.exit(1)
if output_folder_path != '':
    if not os.path.isdir(output_folder_path):
        print("Output dirrectory doesn't exist, exiting script.")
        sys.exit(1)
    boot = os.path.join(output_folder_path, 'boot.dat')
    Licence = os.path.join(output_folder_path, 'license.dat')
else:
    boot = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'boot.dat')
    Licence = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'license.dat')
if bootori == boot:
    print('"' + bootori + '" and "' + boot + '" paths can\'t be the same, exiting script.')
    sys.exit(1)

padding = ("0001ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000")
pub_key =      ('ef5d659c147718b4ff06aa9e04e9fb324f163f1f66d58cc0f904138e365cefc7462fbc907947c7208c75b87e75274f9b5ffe62b5c5269c9ab272ec5f949827dcd1a243ed87d4bdd4a747033f79eb54d6a1256377b4ba0fc7b1f1edcc4380ebe22338969542c6a06df1349a4d26794a3b4657ccef35abf54b11d8bc574a5ff7b0f8bc51eab6d143de2b98c5f8939e8a32c6076c55e7f3c43f5b27cc34fdeaff9293f7e841d6e18f081bd7620cab651f5bca1afca4d1479435fada06df81591abcbe0629ba6df3a46320d44d40fe5a40678063c1c6452b65132a0326ac8e118ef0e084f65a7f888070e522a9f63eaf862436255a7f8f9c4b3009033860c7fb637b')
pub_exponent = int('10001', 16)
priv_key =     int('cca180cb552797c4ac3d2bc1599c1a76a0ebf8dcc4920df9af28cffb04f8a0b8308580e3d5fb09fe0676615a22978fd3d9d5e4d7568b32d881740425962819f40a777930e8ad73f807658b1e4a01688ef046c16945e4c6b6c6a677cfe769a0bebbb395f0569cedebef8833dd7ee5b4134688ab17593fffbcc4ae101d63e4f51efbd207299630a760b1fb55e5170def77d1a729a5211de352dfbcf8dda39f09b5e5cfca53dd03c74ec792e382c17c2132af8b6632bb801c9a3de9a541414cfd5065323983cf6bfd69abce7505165e6184a8c57eba35f37db39f080489f662c005263c4cabc3948bb5852c8454cff7388ab47023b3dbe8dc0536d07df404d58591', 16)

def reverse(a,z) :
    s = ""
    for x in range(-1, -len(a), -2) :
        s += a[x-1] + a[x]
    if (z == 512) :
       if (len(s) != 512) :
           s = '0'+ s
           if (len(s) != 512) :
               s = '0'+ s
               if (len(s) != 512) :
                   s = '0'+ s
    if (z == 64) :
       if (len(s) != 64) :
           s = '0'+ s
           if (len(s) != 64) :
               s = '0'+ s
               if (len(s) != 64) :
                   s = '0'+ s
    print(s)
    return s


def sig_RSA(sig):
    print("\n")
    print("encrypt signature")
    signature = hex(pow(int(binascii.hexlify(sig),16), priv_key, int(pub_key,16)))[2:]
    if (len(signature) != 512) :
        signature = '0'+ signature
        if (len(signature) != 512) :
            signature = '0'+ signature
            if (len(signature) != 512) :
                signature = '0'+ signature
    print(signature)
    return signature

#-----------------------------------

if not os.path.isfile(bootori):
    print(bootori, "not found - exiting script")
    sys.exit(1)

def get_ver_int(boot_ver):
    if (boot_ver[1] == 0x302E) and (boot_ver[0] == 0x312E3356) and (sha256 == "f05c9c9f1a862ff7ac6ae44fe5bf0bb4749db0b2dc6565f6f0f2acdbe81bb06b"):       # TX BOOT V3.1.0
        return 310
    else:
        print("Wrong", bootori, "- please use a clean unpatched SXOS 3.10", bootori, "file")

f = open(bootori, "rb")
b = f.read()
sha256 = hashlib.sha256(b).hexdigest()
f.close()

version = get_ver_int(struct.unpack("II", b[0x08:0x10]))

if version != 310:
    print("Exiting script")
    sys.exit(1)

def hexlify(b: (bytes, bytearray)) -> str:
    return _hexlify(b).decode("utf8")

def aes_ctr_dec(buf, key, iv):
    hex_val = (iv.hex())
    ctr = Counter.new(128, initial_value=int(hex_val, 16))
    return AES.new(key, AES.MODE_CTR, counter=ctr).encrypt(buf)

def hexxor (a, b):
    s =  ''.join(["%x" % (int(a,16) ^ int(b,16))])
    if (len(s) != 64) :
        s = '0'+ s
        if (len(s) != 64) :
            s = '0'+ s
            if (len(s) != 64) :
                s = '0'+ s
    return s

#--------------Spoof------------------

def staticlic():
    validlic = open(Licence, "wb")
    validlic.write(unhexlify(goodlic))
    validlic.close()    

if not os.path.isfile(Request):
    if sxos_fingerprint == "":
        if os.path.isfile(fpfile):
            f = open(fpfile, "r")
            sxos_fingerprint = f.read(32)
            f.close
        else:
            sxos_fingerprint = ("5602D40FA505523444544A4200011500") #Inaki
            goodlic = ("B2ECDB5F517EDB111D906C8D153AEFFCE6D17282E9955116600EBBAE4770FA21A33A78CB5FCB7A9431D6D9CE20B02879E84D899310F2F59ABD716143A5381A53D55944E37EECFE166AEA6FA334469CDDF868F99509C6D95CCFC0B9DB63F8377DD6E833E8989F7C20FFED34F4F0AF054D60C28455E6933C5158F4F72E8C44C9F695E5EFAD756FF3A8D3CCF1633AC72AFB5E53CFE3ECBE25E31FA49FD6397D75E5DF38EC61DC897E02D1A44613B8A4359FB0292D95173BDF96B5AE5D8EEF821B1CFB6AEFA759E0A51EBD083C3CD751B5E2EA20201EAC2A19AE37712036DF4E7A05A1DE757FA5F5B440BA303A477063D9D2957EE71FA370217532684BA1E55C097D")
            staticlic()
    fingerprint = unhexlify(sxos_fingerprint)
    print("Using fingerprint:", sxos_fingerprint)

patch_d = unhexlify("3B980014")
patch_spoof = unhexlify("0000014A8D2981520D40B072AE0D40390F008052DF010F6B01F8EC54010000140A208CD28A23B0F24B3140A90D2881D20D40B0F2AB3100A9B867FF17")
#-------------------

payload81_key = unhexlify("12280A64B7A487E99864CD2E22393C87")
payload81_ctr = unhexlify("C28124EAA147BEE8EF865E2AE8496834")
s2_key = unhexlify("47E6BFB05965ABCD00E2EE4DDF540261")
s2_ctr = unhexlify("8E4C7889CBAE4A3D64797DDA84BDB086")
s3_key = unhexlify("D548D48DBA299604CED1AE5B47D8429C")
s3_ctr = unhexlify("428DB51A85E4940D37648FEC66BA2C78")
fw_key = unhexlify("81F555CC58EF03CB41BD81C90A8E8F79")
fw_ctr = unhexlify("A4C122884E6C8979E3E3E0F07D116E52")
payloadA0_key = unhexlify("043AB07482B9A8B55EA9041C74CD92EB")
payloadA0_ctr = unhexlify("AAF5295AEC233F953B408EE27F892CF8")
payload90_key = unhexlify("95F4D1F3C1EC6E5A54AC70F49AE315F5")
payload90_ctr = unhexlify("DCD96167060A7A9E1F2BC8C1C2A611B4")
payload98_key = unhexlify("DEE47F27900D540AFE04C4063638CE0F")
payload98_ctr = unhexlify("467E7F219FDCAFA5E6187262755D4DFC")
bootloader_key = unhexlify("FB61357AB9DEE1C9D4C49F6488349EF0")
bootloader_ctr = unhexlify("5BCF60493E61BCB930FD44C7FAC0EE09")
assets_key = unhexlify("EF48639FC925C8D0364B2DA7614EB038")
assets_ctr = unhexlify("7298408E70FBE048DCC6E594B0C272B6")
fb_key = unhexlify("4599F62BF51E62B6AC05AAA7E7B03DE3")
fb_ctr = unhexlify("39B0F6E0846C53DCE0457F285797AE99")
KEYXOR = ("FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE")
RET0 = unhexlify("00008052C0035FD6")
NOP = unhexlify("1F2003D5")
END = unhexlify("00")

bootbin = 'boot.bin'
header = 'header.bin'
header_s3 = 'header_s3.bin'
stage2 = 'stage2_40008100.bin'
stage3 = 'stage3_40020000.bin'
payload81 = 'payload_81000000.bin'
payload90 = 'payload_90000000.bin'
payload98 = 'payload_98000000.bin'
payloadA0 = 'payload_A0000000.bin'
payloadA0_dec = 'payload_A0000000_dec.bin'
payloadA0_dec2 = 'payload_A0000000(dec2).bin'
payloadA0_enc = 'payload_A0000000_enc.bin'
rommenu = 'rommenu.bin'
bootloader = 'bootloader_88000000.bin'
assets = 'assets_8804A000.bin'
fb = 'fb_F0000000.bin'
icone_holder = 0

f = open(bootori, "rb")
bootin = f.read()
f.close()

bootout = open(bootbin, "wb")
bootout.write(bootin)

#assets_8804A000.bin
assets_tmp = open(assets, "wb")
assets_tmp.write(aes_ctr_dec(bootin[0x600DE0:0x600DE0+0x4DC400], assets_key, assets_ctr))
if os.path.isfile('out/menu_bg.bin'):
 tmp = open('out/menu_bg.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x400)
 assets_tmp.write(GFX)
if os.path.isfile('out/options.bin'):
 tmp = open('out/options.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x400400)
 assets_tmp.write(GFX)
if os.path.isfile('out/holder.bin'):
 tmp = open('out/holder.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x3C0400)
 assets_tmp.write(GFX)
 icone_holder = 1
if os.path.isfile('out/bootcfw.bin'):
 tmp = open('out/bootcfw.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x440400)
 assets_tmp.write(GFX)
if os.path.isfile('out/bootofw.bin'):
 tmp = open('out/bootofw.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x480400)
 assets_tmp.write(GFX)
if os.path.isfile('out/launch.bin'):
 tmp = open('out/launch.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4C0400)
 assets_tmp.write(GFX)
if os.path.isfile('out/poweroff.bin'):
 tmp = open('out/poweroff.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4C4400)
 assets_tmp.write(GFX)
if os.path.isfile('out/repair.bin'):
 tmp = open('out/repair.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4C8400)
 assets_tmp.write(GFX)
if os.path.isfile('out/autorcm.bin'):
 tmp = open('out/autorcm.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4CC400)
 assets_tmp.write(GFX)
if os.path.isfile('out/emunand.bin'):
 tmp = open('out/emunand.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4D0400)
 assets_tmp.write(GFX)
if os.path.isfile('out/nand.bin'):
 tmp = open('out/nand.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4D4400)
 assets_tmp.write(GFX)
if os.path.isfile('out/core.bin'):
 tmp = open('out/core.bin', "rb")
 GFX = tmp.read()
 tmp.close()
 assets_tmp.seek(0x4D8400)
 assets_tmp.write(GFX)

assets_tmp.seek(0x0)
with open(assets, 'rb') as f:
 bytes = f.read()
 sha256_assets = hashlib.sha256(bytes).hexdigest()
print("assets hash:", sha256_assets)

bootout.seek(0x600DE0)
bootout.write(aes_ctr_dec(bytes, assets_key, assets_ctr))
assets_tmp.close()
os.remove(assets)
#------------------
#------------------

#bootloader_88000000.bin
BL = open(bootloader, "wb")
BL.write(aes_ctr_dec(bootin[0x5B6DE0:0x5B6DE0+0x4A000], bootloader_key, bootloader_ctr))
#supprime le chiffrement de la memoire
BL.seek(0x4E0)
BL.write(RET0)

#no boot auto
if os.path.isfile('out/holder.bin'):
    boot_auto = unhexlify("80000034")
    BL.seek(0x682C)
    BL.write(boot_auto)
"""
#no button emunand
BL.seek(0x18CC)
BL.write(RET0)

#menu sxcore
sxcore = unhexlify("000f0035")
BL.seek(0x8C2C)
BL.write(sxcore)
sxcore_M = unhexlify("D5020035")
BL.seek(0x7500)
BL.write(sxcore_M)
sxcore_M2 = unhexlify("60020034")
BL.seek(0x14bc4)
BL.write(sxcore_M2)


#fw.bin sxcore
fw = open('fw.bin', "rb")
fw_tmp = fw.read()
fw.close()
BL.seek(0x2EEF0)
BL.write(fw_tmp)
"""

#menu 4 icones
if icone_holder:

#Boot Director
 BL.seek(0x49F20)
 BL.write(b'atmosphere/fusee-primary.bin')
#nom holder boutton
 BL.seek(0x49f80)
 BL.write(b'Atmosphere'+END)
#name button (Boot custom FW) 
 BL.seek(0x3F550)
 BL.write(b'SXOS'+END)
#name button (Boot custom OFW) 
 BL.seek(0x3F567)
 BL.write(b'Nintendo'+END)
 
#buton emunand
 buton_emu = unhexlify("01028052")#10
 BL.seek(0x6d08)#left right
 BL.write(buton_emu)
 BL.seek(0x6d14)#up down
 BL.write(buton_emu)
#rediretion retour boot atmo
 menu_d = unhexlify("01B52154")
 BL.seek(0x68d0)
 BL.write(menu_d)
#rediredtion menu lancement
 menu = unhexlify("1F3400714148DE541A00009440F2FE17")
 BL.seek(0x49f70)
 BL.write(menu)
#menu lancement fonction boot.bin comparaison
 menu = unhexlify("1F3400714148DE541A00009440F2FE17")
 BL.seek(0x49f70)
 BL.write(menu)
#fonction de lancement du boot.bin
 payload_F = unhexlify("0000009000803C915DFDFE97")
 BL.seek(0x49FE0)
 BL.write(payload_F)
#nom d'icone 
 icone = unhexlify("484F4C444552")
 BL.seek(0x49f90)
 BL.write(icone)
#taille pour 4 icone
 payload_L_icone = unhexlify("01A08052")
 BL.seek(0x6c30)
 BL.write(payload_L_icone)
#centrer les icones
 centre_icone = unhexlify("010A8052")
 BL.seek(0x6c04)
 BL.write(centre_icone)
#redirection d'ajout icone
 payload_D_icone = unhexlify("CD0C0114")
 BL.seek(0x6c6c)
 BL.write(payload_D_icone)
#ajout d'icone
 payload_icone = unhexlify("E00313AA030000900200009063003C9142003E910100009021403E917BF2FE97E00313AA2BF3FE17")
 BL.seek(0x49FA0)
 BL.write(payload_icone)
#retour boot atmo
 menu_r_boot = unhexlify("801C00B0A101805201600AB920008052C0035FD6")
 BL.seek(0x49f00)
 BL.write(menu_r_boot)


BL.seek(0x47E40)
BL.write(unhexlify(sha256_assets))
BL.seek(0x0)
with open(bootloader, 'rb') as f:
 bytes = f.read()
 sha256_bl = hashlib.sha256(bytes).hexdigest()
print("bootloader hash:", sha256_bl)

bootout.seek(0x5B6DE0)
bootout.write(aes_ctr_dec(bytes, bootloader_key, bootloader_ctr))
BL.close()
os.remove(bootloader)
#------------------
#Payload_A0000000.bin
payA0_dec = open(payloadA0, "wb")
payA0_dec.write(aes_ctr_dec(bootin[0xF3D820:0xF3D820+0x2AE220], payloadA0_key, payloadA0_ctr))
payA0_dec.seek(0x0)
payA0_2 = open(payloadA0, "rb")
payA0_2_tmp = payA0_2.read()
payA0_dec.write(aes_ctr_dec(payA0_2_tmp, fw_key, fw_ctr))
payA0_2.close()
#license key
if os.path.isfile(Request):
    KEY1 = unhexlify("ef5d659c14077718b4ff06aa9e0400e9fb324f163f1f6600d58cc0f904138e36005cefc7462fbc90790047c7208c75b87e7500274f9b5ffe62b5c500269c9ab272ec5f94009827dcd1a243ed8700d4bdd4a747033f7900eb54d6a1256377b400ba0fc7b1f1edcc430080ebe2233896954200c6a06df1349a4d2600794a3b4657ccef3500abf54b11d8bc574a005ff7b0f8bc51eab600d143de2b98c5f893009e8a32c6076c55e700f3c43f5b27cc34fd00eaff9293f7e841d600e18f081bd7620cab00651f5bca1afca4d100479435fada06df8100591abcbe0629ba6d00f3a46320d44d40fe005a40678063c1c645002b65132a0326ac8e00118ef0e084f65a7f00888070e522a9f63e00af862436255a7f8f009c4b3009033860c700fb637b")
    payA0_dec.seek(0x22D861)
    payA0_dec.write(KEY1)
    KEY2 = unhexlify("ef5d21659c147718b4ff0600aa9e04e9fb324f16003f1f66d58cc0f90400138e365cefc7462f00bc907947c7208c7500b87e75274f9b5ffe0062b5c5269c9ab27200ec5f949827dcd1a20043ed87d4bdd4a74700033f79eb54d6a125006377b4ba0fc7b1f100edcc4380ebe2233800969542c6a06df134009a4d26794a3b465700ccef35abf54b11d800bc574a5ff7b0f8bc0051eab6d143de2b9800c5f8939e8a32c607006c55e7f3c43f5b2700cc34fdeaff9293f700e841d6e18f081bd700620cab651f5bca1a00fca4d1479435fada0006df81591abcbe060029ba6df3a46320d4004d40fe5a4067806300c1c6452b65132a030026ac8e118ef0e08400f65a7f888070e52200a9f63eaf86243625005a7f8f9c4b300903003860c7fb63aa")
    payA0_dec.seek(0x237B72)
    payA0_dec.write(KEY2)

pub_key_reboot = unhexlify("7b63fbc76038030900304b9c8f7f5a2536002486af3ef6a922e5007080887f5af684e000f08e118eac26032a0013652b45c6c163800067405afe404dd4200063a4f36dba2906be00bc1a5981df06dafa00359447d1a4fc1aca005b1f65ab0c62d71b00088fe1d641e8f7930092ffeafd34cc275b003fc4f3e7556c07c600328a9e93f8c5982b00de43d1b6ea51bcf800b0f75f4a57bcd811004bf5ab35efcc5746003b4a79264d9a34f1006da0c6429596382300e2eb8043ccedf1b100c70fbab4776325a100d654eb793f0347a700d4bdd487ed43a2d100dc2798945fec72b2009a9c26c5b562fe5f009b4f27757eb8758c0020c7477990bc2f4600c7ef5c368e1304f900c08cd5661f3f164f0032fbe9049eaa06ff00b41877149c655def")
payA0_dec.seek(0x29A4C2)
payA0_dec.write(pub_key_reboot)
payA0_dec.seek(0x0)

with open(payloadA0, 'rb') as f:
    bytes = f.read()
    sha256_patcher_1 = hashlib.sha256(bytes[0x400:0x1E3E40]).hexdigest() 
    sha256_patcher_2 = hashlib.sha256(bytes[0x1E3E40:0x1E6800]).hexdigest() 
    sha256_patcher_3 = hashlib.sha256(bytes[0x1E6800:0x1EFA60]).hexdigest() 
    sha256_patcher_4 = hashlib.sha256(bytes[0x1EFA60:0x2AE214]).hexdigest()  
print("patcher_1 hash:", sha256_patcher_1)
print("patcher_2 hash:", sha256_patcher_2)
print("patcher_3 hash:", sha256_patcher_3)
print("patcher_4 hash:", sha256_patcher_4)
payA0_dec.seek(0x10)
payA0_dec.write(unhexlify(sha256_patcher_1))
payA0_dec.seek(0x40)
payA0_dec.write(unhexlify(sha256_patcher_2))
payA0_dec.seek(0x70)
payA0_dec.write(unhexlify(sha256_patcher_3))
payA0_dec.seek(0xA0)
payA0_dec.write(unhexlify(sha256_patcher_4))
payA0_dec.close()

with open(payloadA0, 'rb') as f:
    bytes = f.read()
    sha256_header_patcher = hashlib.sha256(bytes[0x0:0x3E0]).hexdigest()  
print("sha256_header_patcher hash:", sha256_header_patcher) 

payA0_dec = open(payloadA0_dec2, "wb")
payA0_dec.write(bytes)
payA0_dec.seek(0x3E0)
payA0_dec.write(unhexlify(sha256_header_patcher))
payA0_dec.close()

payA0_dec = open(payloadA0_dec2, "rb")
payA0 = payA0_dec.read()
payA0_dec.close()

payA0_enc = open(payloadA0_enc, "wb")
payA0_enc.write(aes_ctr_dec(payA0, fw_key, fw_ctr))
payA0_enc.close()

with open(payloadA0_enc, 'rb') as f:
    bytes = f.read()
    sha256_payA0_enc = hashlib.sha256(bytes).hexdigest()  
print("payload A0_enc hash:", sha256_payA0_enc)

bootout.seek(0xF3D820)
bootout.write(aes_ctr_dec(bytes, payloadA0_key, payloadA0_ctr))
os.remove("payload_A0000000.bin")
#os.remove("payload_A0000000_dec.bin")
os.remove("payload_A0000000_enc.bin")
os.remove("payload_A0000000(dec2).bin")
#----------------------------------------
"""
#payload98000000.bin

pay98 = open(payload98, "wb")
pay98.write(aes_ctr_dec(bootin[0xDBA410:0xF3D820], payload98_key, payload98_ctr))

pay98.seek(0x0)

with open(payload98, 'rb') as f:
    bytes = f.read()
    sha256_pay98 = hashlib.sha256(bytes).hexdigest()  
print("payload 98_enc hash:", sha256_pay98)

bootout.seek(0xDBA410)
bootout.write(aes_ctr_dec(bytes, payload98_key, payload98_ctr))
pay98.close()
"""
#----------------------------------------

#payload90000000.bin

pay90 = open(payload90, "wb")
pay90.write(aes_ctr_dec(bootin[0xC958D0:0xDBA410], payload90_key, payload90_ctr))
"""
#sha256 payload98
pay90.seek(0x11F000)
pay90.write(unhexlify(sha256_pay98))
"""
#sha256 payloadA0
pay90.seek(0x11F050)
pay90.write(unhexlify(sha256_payA0_enc))
pay90.close()

with open(payload90, 'rb') as f:
    bytes = f.read()
    sha256_pay90 = hashlib.sha256(bytes).hexdigest()  
print("payload 90 hash:", sha256_pay90)
sha256_pay90_xor = hexxor(KEYXOR,sha256_pay90)
print("payload 90_enc_xor hash:", sha256_pay90_xor)
bootout.seek(0xC958D0)
bootout.write(aes_ctr_dec(bytes, payload90_key, payload90_ctr))
pay90.close()
os.remove("payload_90000000.bin")
#----------------------------------------
#payload80000000.bin
pay81 = open(payload81, "wb")
pay81.write(aes_ctr_dec(bootin[0x201E0:0x1F6DE0], payload81_key, payload81_ctr))
#sha256 booloader
pay81.seek(0x1C9FE8)
pay81.write(unhexlify(sha256_bl))

if os.path.isfile(Request):
    pay81.seek(0x17BDA0)
    pay81.write(unhexlify("A4BD1781"))
    pay81.seek(0x8258)
    pay81.write(unhexlify(pub_key))
else:
    pay81.seek(0x19FF14)
    pay81.write(patch_d)
    pay81.seek(0x1C6000)
    pay81.write(patch_spoof)
    pay81.seek(0x1C6100)
    pay81.write(fingerprint)

pay81.seek(0x1D2A14)
pay81.write(unhexlify(sha256_pay90_xor))
pay81.seek(0x0)

pay81.close()

with open(payload81, 'rb') as f:
    bytes = f.read()
    sha256_pay81 = hashlib.sha256(bytes).hexdigest()  
print("payload 81 hash:", sha256_pay81)

bootout.seek(0x201E0)
bootout.write(aes_ctr_dec(bytes, payload81_key, payload81_ctr))


os.remove("payload_81000000.bin")
#------------------

#fb F0000000.bin

if os.path.isfile('out/splash.bin'):
 fb_in = open(fb, "wb")
 fb_in.write(aes_ctr_dec(bootin[0x1F6DE0:0x1F6DE0+0x3C0000], fb_key, fb_ctr))
 
 tmp = open('out/splash.bin', "rb")
 FB_splash = tmp.read()
 tmp.close()
 
 fb_in.seek(0x0)
 fb_in.write(FB_splash)
 fb_in.seek(0x0)

 with open(fb, 'rb') as f:
     bytes = f.read()
     sha256_fb = hashlib.sha256(bytes).hexdigest()
 print("fb hash:", sha256_fb)

 bootout.seek(0x1F6DE0)
 bootout.write(aes_ctr_dec(bytes, fb_key, fb_ctr))
 fb_in.close()
 os.remove("fb_F0000000.bin")
#------------------

#stage3 40020000.bin
stage3_in = open(stage3, "wb")
stage3_in.write(aes_ctr_dec(bootin[0x11500:0x1BB70], s3_key, s3_ctr))
if os.path.isfile('out/splash.bin'):
 stage3_in.seek(0xA5D0)
 stage3_in.write(unhexlify(sha256_fb))
stage3_in.seek(0xA620)
stage3_in.write(unhexlify(sha256_pay81))
stage3_in.seek(0x0)

with open(stage3, 'rb') as f:
    bytes = f.read()
    sha256_stage3 = hashlib.sha256(bytes).hexdigest()
print("stage3 hash:", sha256_stage3)

bootout.seek(0x11500)
bootout.write(aes_ctr_dec(bytes, s3_key, s3_ctr))
stage3_in.close()
os.remove("stage3_40020000.bin")
#------------------

#stage2 40008100.bin
stage2_in = open(stage2, "wb")
stage2_in.write(aes_ctr_dec(bootin[0x100:0x110D0], s2_key, s2_ctr))

#Key Signature

print("\n")
print("Reverse Key signature")
key_reverse = reverse(pub_key,512)
stage2_in.seek(0x53A3)
stage2_in.write(unhexlify(key_reverse))

#stage2_in.seek(0x45C0)
#stage2_in.write(patch_s2)
stage2_in.seek(0x0)

with open(stage2, 'rb') as f:
    bytes = f.read()
    sha256_stage2 = hashlib.sha256(bytes).hexdigest()
print("stage2 hash:", sha256_stage2)

bootout.seek(0x100)
bootout.write(aes_ctr_dec(bytes, s2_key, s2_ctr))
stage2_in.close()
os.remove("stage2_40008100.bin")
#-------------------

#header.bin
header_m = open(header, "wb")
header_m.write(bootin[0x0:0xE0])
header_m.seek(0x10)
header_m.write(unhexlify(sha256_stage2))
header_m.seek(0x0)
header_m.close()

with open(header, 'rb') as f:
    bytes = f.read()
    sha256_header = hashlib.sha256(bytes).hexdigest()
print("header hash:", sha256_header)
bootout.seek(0x0)
bootout.write(bytes)
header_m.close()
os.remove(header)
#-------------------

#header.bin stage3
header_m_s3 = open(header_s3, "wb")
header_m_s3.write(bootin[0x11300:0x113E0])
header_m_s3.seek(0x20)
header_m_s3.write(unhexlify(sha256_stage3))
header_m_s3.seek(0x0)


with open(header_s3, 'rb') as f:
    bytes = f.read()
    sha256_header_sig_s3 = hashlib.sha256(bytes).hexdigest()
print("sha256_header_sig_s3 hash:", sha256_header_sig_s3)
bootout.seek(0x11300)
bootout.write(bytes)
header_m_s3.close()
os.remove(header_s3)
#------------------

#ROMMENU.bin
rom_in = open(rommenu, "wb")
rom_in.write(aes_ctr_dec(bootin[0x11EBA40:0x15c8080], fw_key, fw_ctr))

rom_in.seek(0x126d4+0x610)
rom_in.write(unhexlify("C3FFFF17"))
rom_in.seek(0x124FC+0x610)
rom_in.write(unhexlify("01248052"))
rom_in.seek(0x125e0+0x610)
rom_in.write(unhexlify("A30C00F00600805263C00B91"))

rom_in.seek(0x13AAD0)
rom_in.write(b'License Free By'+END)
rom_in.seek(0x1A92F0+0x610)
rom_in.write(b'Reacher17'+END)

if os.path.isfile('out/rommenu.jpg'):
 tmp = open('out/rommenu.jpg', "rb")
 GFX_rommenu = tmp.read()
 tmp.close()
 rom_in.seek(0xF9018+0x610)
 rom_in.write(GFX_rommenu)
 
if not os.path.isfile(Request):
    rom_in.seek(0x12A5C) # make license check valid. (0x1244c + 0x160)
    rom_in.write(NOP)
    rom_in.seek(0x14B18) # fix cheat menu
    rom_in.write(NOP)


rom_in.seek(0x0)

with open(rommenu, 'rb') as f:
    bytes = f.read()
    sha256_rommenu = hashlib.sha256(bytes[0x610:0x1AC610]).hexdigest()
print("rommenu hash:", sha256_rommenu)

rom_in.seek(0x18)
rom_in.write(unhexlify(sha256_rommenu))
rom_in.seek(0x0)
rom_in = open(rommenu, "rb")
rom_in2 = rom_in.read()
bootout.seek(0x11EBA40)
bootout.write(aes_ctr_dec(rom_in2, fw_key, fw_ctr))
rom_in.close()
os.remove("rommenu.bin")
#------------------

f = open(bootbin, "rb")
bootin = f.read()
bootout = open(boot, "wb")
bootout.write(bootin)
bootout.seek(0xE0)
bootout.write(unhexlify(sha256_header))
bootout.seek(0x113E0)
bootout.write(unhexlify(sha256_header_sig_s3))
f.close()

#Header Signature
tmp_header = reverse(sha256_header,64)

with open("header_sig.bin", "wb") as sig_header:
    sig_header.write(unhexlify(padding))
    sig_header.seek(0xE0)
    sig_header.write(unhexlify(tmp_header))

with open("header_sig.bin", "rb") as sig_header_tmp:
    sig_header = sig_header_tmp.read()

signature = sig_RSA(sig_header)
print("\n")
print("Reverse signature header")
sig_header_reverse = reverse(signature,512)
bootout.seek(0x11200)
bootout.write(unhexlify(sig_header_reverse))
os.remove("header_sig.bin")

#---------------------
#Header Signature s3
tmp_header = reverse(sha256_header_sig_s3,64)

with open("header_sig.bin", "wb") as sig_header:
    sig_header.write(unhexlify(padding))
    sig_header.seek(0xE0)
    sig_header.write(unhexlify(tmp_header))

with open("header_sig.bin", "rb") as sig_header_tmp:
    sig_header = sig_header_tmp.read()

signature = sig_RSA(sig_header)
print("\n")
print("Reverse signature header s3")
sig_header_reverse = reverse(signature,512)
bootout.seek(0x11400)
bootout.write(unhexlify(sig_header_reverse))
os.remove("header_sig.bin")

#---------------------

bootout.close()
os.remove("boot.bin")

#License Generator
if os.path.isfile(Request):
    tmp = open(Request, "rb")
    Request_tmp = tmp.read()
    tmp.close()

    with open(Licence, "wb") as Licence_tmp:
        Licence_tmp.write(unhexlify(padding))
        Licence_tmp.seek(0xE0)
        Licence_tmp.write(Request_tmp[0x0:0x20])

    with open(Licence, "rb") as tmp:
        Licence_sig = tmp.read()
    print("\n")
    print("License Encryption")
    signature = sig_RSA(Licence_sig)

    with open(Licence, "wb") as Licence_tmp:
        Licence_tmp.write(unhexlify(signature))
        print("\n")
        print("successful license creation !!!")
#------------------------

print("Done!")
