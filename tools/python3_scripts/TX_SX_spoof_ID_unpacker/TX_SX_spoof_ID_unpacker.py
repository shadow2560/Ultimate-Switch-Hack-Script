###############################################
# TX SX spoof ID unpacker - by Reacher17 #
# Thanks to the following: 
# Inaki - license.dat
# Zoria - Linkynimes
# Shadow, Darkstorm, B&ender, Heykyz, mrdude
# shadow256
###############################################
from Crypto.Cipher import AES
from Crypto.Util import Counter
import os
import hashlib
import struct
from binascii import hexlify as _hexlify, unhexlify
import subprocess
import sys
import pip

# reqs = subprocess.check_output([sys.executable, '-m', 'pip', 'freeze'])
# installed_packages = [r.decode().split('==')[0] for r in reqs.split()]

#print(installed_packages, "\n")

def install():
    try:
        if not ('pycryptodome' in installed_packages):
            pip.main(['install', "pycryptodome"])
            #subprocess.run(['pip', 'install', 'pycryptodome'])
        if not ('pycryptodomex' in installed_packages):
            pip.main(['install', "pycryptodome"])
            #subprocess.run(['pip', 'install', 'pycryptodomex'])
    
    except OSError as e:
        print("Error: %s %s" % ("during package install,", e.strerror))

# install()

def help():
	print ('Usage:')
	print ()
	print ('TX_SX_spoof_ID_unpacker.py [-i boot.dat_file_to_modify] [-f console_fingerprint_to_spoof] [-l fingerprint_file_path')
	print("\nNote that you could not use \"-f\" and \"-l\" together")
	return 1

boot = 'boot.dat'
fpfile = "fingerprint.txt"
sxos_fingerprint = ""

for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-i'):
		boot = os.path.abspath(sys.argv[i+1])
	elif currArg.startswith('-f'):
		sxos_fingerprint = sys.argv[i+1]
		fpfile = ""
	elif currArg.startswith('-l'):
		fpfile = sys.argv[i+1]
		sxos_fingerprint = ""
	else:
		print('Error in arguments passed.\n')
		help()
		sys.exit(1)

if not os.path.isfile(boot):
    print(boot, "not found - exiting script")
    sys.exit(1)

def get_ver_int(boot_ver):
    if (boot_ver[1] == 0x302E) and (boot_ver[0] == 0x312E3356) and (sha256 == "f05c9c9f1a862ff7ac6ae44fe5bf0bb4749db0b2dc6565f6f0f2acdbe81bb06b"):       # TX BOOT V3.1.0
        return 310
    else:
        print("Wrong", boot, "- please use a clean unpatched SXOS 3.10", boot, "file")

f = open(boot, "rb")
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

def staticlic():
    validlic = open("license.dat", "wb")
    validlic.write(unhexlify(goodlic))
    validlic.close()    

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

payload81_key = unhexlify("12280A64B7A487E99864CD2E22393C87")
payload81_ctr = unhexlify("C28124EAA147BEE8EF865E2AE8496834")
s2_key = unhexlify("47E6BFB05965ABCD00E2EE4DDF540261")
s2_ctr = unhexlify("8E4C7889CBAE4A3D64797DDA84BDB086")
s3_key = unhexlify("D548D48DBA299604CED1AE5B47D8429C")
s3_ctr = unhexlify("428DB51A85E4940D37648FEC66BA2C78")
fw_key = unhexlify("81F555CC58EF03CB41BD81C90A8E8F79")
fw_ctr = unhexlify("A4C122884E6C8979E3E3E0F07D116E52")

patch_d = unhexlify("3B980014")
patch_spoof = unhexlify("0000014A8D2981520D40B072AE0D40390F008052DF010F6B01F8EC54010000140A208CD28A23B0F24B3140A90D2881D20D40B0F2AB3100A9B867FF17")
patch_s2 = unhexlify("00008052C0035FD6")
NOP = unhexlify("1F2003D5")

header = 'header.bin'
bootbin = 'boot.bin'
stage2 = 'stage2_40008100.bin'
stage3 = 'stage3_40020000.bin'
payload81 = 'payload_81000000.bin'
rommenu = 'rommenu.bin'

f = open(boot, "rb")
bootin = f.read()

bootout = open(bootbin, "wb")
bootout.write(bootin)

#payload80000000.bin
pay81 = open(payload81, "wb")
pay81.write(aes_ctr_dec(bootin[0x201E0:0x1F6DE0], payload81_key, payload81_ctr))
pay81.seek(0x19FF14)
pay81.write(patch_d)
pay81.seek(0x1C6000)
pay81.write(patch_spoof)
pay81.seek(0x1C6100)
pay81.write(fingerprint)
pay81.seek(0x0)

with open(payload81, 'rb') as f:
    bytes = f.read()
    sha256_pay81 = hashlib.sha256(bytes).hexdigest()  
print("payload 81 hash:", sha256_pay81)

bootout.seek(0x201E0)
bootout.write(aes_ctr_dec(bytes, payload81_key, payload81_ctr))
#------------------

#stage3 40020000.bin
stage3_in = open(stage3, "wb")
stage3_in.write(aes_ctr_dec(bootin[0x11500:0x1BB70], s3_key, s3_ctr))
stage3_in.seek(0xA620)
stage3_in.write(unhexlify(sha256_pay81))
stage3_in.seek(0x0)

with open(stage3, 'rb') as f:
    bytes = f.read()
    sha256_stage3 = hashlib.sha256(bytes).hexdigest()
print("stage3 hash:", sha256_stage3)

bootout.seek(0x11500)
bootout.write(aes_ctr_dec(bytes, s3_key, s3_ctr))
#------------------

#stage2 40008100.bin
stage2_in = open(stage2, "wb")
stage2_in.write(aes_ctr_dec(bootin[0x100:0x110D0], s2_key, s2_ctr))
stage2_in.seek(0x45C0)
stage2_in.write(patch_s2)
stage2_in.seek(0x0)

with open(stage2, 'rb') as f:
    bytes = f.read()
    sha256_stage2 = hashlib.sha256(bytes).hexdigest()
print("stage2 hash:", sha256_stage2)

bootout.seek(0x100)
bootout.write(aes_ctr_dec(bytes, s2_key, s2_ctr))
#-------------------

#header.bin
header_m = open(header, "wb")
header_m.write(bootin[0x0:0xE0])
header_m.seek(0x10)
header_m.write(unhexlify(sha256_stage2))
header_m.seek(0x0)

with open(header, 'rb') as f:
    bytes = f.read()
    sha256_header = hashlib.sha256(bytes).hexdigest()
print("header hash:", sha256_header)
bootout.seek(0x0)
bootout.write(bytes)
bootout.seek(0xE0)
bootout.write(unhexlify(sha256_header))
#------------------

#ROMMENU.bin
rom_in = open(rommenu, "wb")
rom_in.write(aes_ctr_dec(bootin[0x11EBA40:0x15c8080], fw_key, fw_ctr))
#rom_in.seek(0x12A58) # reads console fingerprint - set's to all 00's (12448)
#rom_in.write(NOP)

rom_in.seek(0x12A5C) # make license check valid. (0x1244c + 0x160)
rom_in.write(NOP)

cheat = unhexlify("1F2003D5")
rom_in.seek(0x14B18) # fix cheat menu
rom_in.write(cheat)

license = ("4861636B656420537769746368")
rom_in.seek(0x13AAD0)
rom_in.write(unhexlify(license)) # not needed just a visual text patch
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
#------------------

f = open(bootbin, "rb")
bootin = f.read()
bootout = open(boot, "wb")
bootout.write(bootin)

f.close()
pay81.close()
stage2_in.close()
stage3_in.close()
header_m.close()
bootout.close()
rom_in.close()

os.remove("boot.bin")
os.remove("header.bin")
os.remove("payload_81000000.bin")
os.remove("stage2_40008100.bin")
os.remove("stage3_40020000.bin")
os.remove("rommenu.bin")

print("Done!")
