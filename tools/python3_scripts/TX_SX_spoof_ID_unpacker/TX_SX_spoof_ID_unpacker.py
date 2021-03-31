###############################################
# TX SX spoof ID unpacker - by Reacher17#
###############################################
from Crypto.Cipher import AES
from Crypto.Util import Counter
import os
import sys
import hashlib
from binascii import hexlify as _hexlify, unhexlify

#https://discord.com/channels/698952104940929054/
        
print("     #####################################################")
print("     #       TX SX spoof ID unpacker - by Reacher17      #")
print("     #                                                   #")
print("     #   Thanks :                                        #")
print("     #   Zoria - Linkynimes                              #")
print("     #   Shadow,Darkstorm                                #")
print("     #   B&nder                                          #")
print("     #   Heykyz                                          #")
print("     #   Chronoss                                        #")
print("     #   shadow256                                       #")
print("     #                                                   #")
print("     #  ModConsoles:                                     #")
print("     #  https://discord.gg/yhEKCzSMND                    #")
print("     #                                                   #")
print("     #####################################################")

def hexlify(b: (bytes, bytearray)) -> str:
    return _hexlify(b).decode("utf8")

def aes_ctr_dec(buf, key, iv):
    hex_val = (iv.hex())
    ctr = Counter.new(128, initial_value=int(hex_val, 16))
    return AES.new(key, AES.MODE_CTR, counter=ctr).encrypt(buf)

def help():
	print ('Usage:')
	print ()
	print ('TX_SX_spoof_ID_unpacker.py -i boot.dat_file_to_modify -f console_fingerprint_to_spoof')
	return 1

if (len(sys.argv) == 1):
	help()
	sys.exit(1)
for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-i'):
		boot = os.path.abspath(sys.argv[i+1])
	elif currArg.startswith('-f'):
		sxos_fingerprint = sys.argv[i+1]
	else:
		print('Error in arguments passed.\n')
		help()
		sys.exit(1)

fingerprint = unhexlify(sxos_fingerprint)

payload81_key = unhexlify("12280A64B7A487E99864CD2E22393C87")
payload81_ctr = unhexlify("C28124EAA147BEE8EF865E2AE8496834")
s2_key = unhexlify("47E6BFB05965ABCD00E2EE4DDF540261")
s2_ctr = unhexlify("8E4C7889CBAE4A3D64797DDA84BDB086")
s3_key = unhexlify("D548D48DBA299604CED1AE5B47D8429C")
s3_ctr = unhexlify("428DB51A85E4940D37648FEC66BA2C78")
fw_key = unhexlify("81F555CC58EF03CB41BD81C90A8E8F79")
fw_ctr = unhexlify("A4C122884E6C8979E3E3E0F07D116E52")
license = ("46726565204C6963656E636500")

patch_d = unhexlify("3B980014")
patch_spoof = unhexlify("0000014A8D2981520D40B072AE0D40390F008052DF010F6B01F8EC54010000140A208CD28A23B0F24B3140A90D2881D20D40B0F2AB3100A9B867FF17")
patch_license1 = unhexlify("000080D2C0035FD6")
patch_license2 = unhexlify("C0CC80D2C0035FD6")
patch_s2 = unhexlify("00008052C0035FD6")


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
print(sha256_pay81)

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
print(sha256_stage3)

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
print(sha256_stage2)

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
print(sha256_header)
bootout.seek(0x0)
bootout.write(bytes)
bootout.seek(0xE0)
bootout.write(unhexlify(sha256_header))

#------------------

#ROMMENU.bin
rom_in = open(rommenu, "wb")
rom_in.write(aes_ctr_dec(bootin[0x11EBA40:0x15c8080], fw_key, fw_ctr))
rom_in.seek(0x7CA0)
rom_in.write(patch_license1)
rom_in.seek(0x7D40)
rom_in.write(patch_license1)
rom_in.seek(0x14AE0)
rom_in.write(patch_license2)
rom_in.seek(0x13AAD0)
rom_in.write(unhexlify(license))
rom_in.seek(0x0)

with open(rommenu, 'rb') as f:
    bytes = f.read()
    sha256_rommenu = hashlib.sha256(bytes[0x610:0x1AD610]).hexdigest()
print(sha256_rommenu)

rom_in.seek(0x18)
rom_in.write(unhexlify(sha256_rommenu))
rom_in.seek(0x0)
rom_in = open(rommenu, "rb")
rom_in2 = rom_in.read()
bootout.seek(0x11EBA40)
bootout.write(aes_ctr_dec(rom_in2, fw_key, fw_ctr))
#------------------
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
