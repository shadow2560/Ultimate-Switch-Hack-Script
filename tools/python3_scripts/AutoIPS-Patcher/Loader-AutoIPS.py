# Loader Dumper/Extractor & IPS Patcher - MrDude
# Modified by shadow256

import os
import hashlib
from pathlib import Path
from bitstring import ConstBitStream
import struct
import subprocess
import sys
import time

if Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'fusee-secondary.bin')).exists():
    filename = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'fusee-secondary.bin')
elif Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'package3')).exists():
    filename = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'package3')
else:
    filename = 'no default file founded'
hactool = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactoolnet.exe')
if len(sys.argv) < 2:
        print("You didn't type any arguements, trying the default files: " + '"fusee-secondary.bin" or "package3"')
        if Path(filename).exists() and Path(hactool).exists():
                pass
        else:
                print('\nError: Default file not founded\nUsage Example: python Loader-AutoIPS.py "package3"')
                sys.exit(1)
else:
        filename = sys.argv[1]

if Path(filename).exists():
        pass
else:
        print('Something is wrong with your paths: \nUsage Example: python Loader-AutoIPS.py "package3"')
        sys.exit(1)   

loaderkip = "loader.kip"
startloc = 0
size = 0
end = 0
loader = ConstBitStream(filename=filename)
findloader = loader.find('0xCCCCCCCC4C6F61646572')
if len(sys.argv) < 3:
    workingdir = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'output')
else:
    workingdir = sys.argv[2]
Path(workingdir).mkdir(parents=True, exist_ok=True)
if Path(workingdir).exists():
        pass
else:
        print('Something is wrong with your paths: Usage Example: python Loader-AutoIPS.py "package3" "output"')
        sys.exit(1)
info = ""
kipname = workingdir + "/Loader-dec.kip"
find = ""
find2 = ""
start = time.time()

def makedirs():
        try:
                atmos = 'atmosphere\\'
                list_ = ['kip_patches\\', 'kip_patches\\loader_patches']
                for folder in list_:
                        if not os.path.exists((workingdir + "\\" + atmos + folder).replace("\\", "/")):
                                os.makedirs(workingdir + "\\" + atmos + folder)
                                
        except OSError as e:
                print("Unable to create the patches folders: %s" % e)
                
def find_loader():
        if(len(findloader) == 0):
                print("Loader not found in %s - exiting script!" % filename)
                sys.exit(1)
        else:
                res = int(''.join(map(str, findloader)))
                newval =  res / 8
                start = int(-12)
                global startloc
                global size
                startloc =  int(newval + start)
                size =  int(startloc + 4)

def sha256():
        sha256_hash = hashlib.sha256()
        with open(loaderkip,"rb") as file:
                for byte_block in iter(lambda: file.read(4096),b""):
                        sha256_hash.update(byte_block)
                global info
                info = sha256_hash.hexdigest().upper()
                sha = "\nLoader Sha256: " + info
                print(sha)
                file.close()

def decrypt_loader():
        if Path(hactool).is_file():
                subprocess.run([hactool, '-t', 'kip1', '--uncompressed', kipname, loaderkip], stdout=subprocess.DEVNULL)
        else:
                print("Hactoolnet wasn't found in this script directory, you need that to decrypt %s - quitting now!" % loaderkip)
                cleanup()
                sys.exit(1)

def cleanup():
        try:
                os.remove(loaderkip)
        
        except OSError as e:
                print("Unable to clean up files for this reason! %s" % e)

def dump_loader():
        find_loader()
        with open(filename,"rb") as f:
                f.seek(startloc)
                Loader_address = struct.unpack('<I',f.read(4))[0]
                f.seek(size)
                Loader_size = struct.unpack('<I',f.read(4))[0]
                end = int(Loader_address + Loader_size)
                print("Dumping Loader from %s" % filename)
                print("Loader start address: 0x%X" % Loader_address)
                print("Loader end address: 0x%X" % end)
                print("Loader size: %d (bytes)" % Loader_size)
                
                # Extract the file
                print("Trying to extract the loader and decrypt it now....!")
                f.seek(Loader_address)
                content = f.read(Loader_size)
                f.close()
                           
                global loaderkip
                loaderkip = (workingdir + '/' + loaderkip)
                file = open((loaderkip), "wb")
                file.write(content)
                file.close()
                
                #Decrypt the loader
                decrypt_loader()               
                
                #Get the Sha256 value of Loader.kip for the ips filename
                sha256()
                
#Let's try to dump the loader now, get it decrypted and find the sha256 value
dump_loader()

#Remove the extracted loader now as we only need the decrypted version
cleanup() 

#--let's make the patches now if we managed to get a decrypted loader
if not Path(kipname).exists():
        print("ERROR " + kipname + " does not exist.")
        sys.exit(1)

def search():
        try:
                s = ConstBitStream(filename=kipname)
                global find
                global find2
                find = s.find('0x003C00121F280071') # Atmosphere 11 and 12 (set for 1 byte patch)
                find2 = s.find('0x01c0be121f00016b') # Atmosphere 13 > Current (set for 1 byte patch)
        except OSError as e:
                print("Unable to search files for this reason! %s" % e)    

def makeips():
        res = int(''.join(map(str, find)))
        newval =  res / 8
        addpos = int(6) #byte position in find hex
        addpos2 =  int(256)
        final =  int(newval + addpos)
        final2 =  int(final - addpos2)
        xxx = '0x{0:0{1}X}'.format(final, 8) #change int back to uppercase hex (make sure we also print leading zero)
        print("Offset patch address for ips file: %s" % xxx)

        if not os.path.exists(os.path.join(workingdir, "bootloader")):
            os.makedirs(os.path.join(workingdir, "bootloader"))
        if not os.path.exists(os.path.join(workingdir, "bootloader/patches.ini")):
                loader = ("[Loader:" + info[:-48] + "]")
        else:
                loader = ("\n\n[Loader:" + info[:-48] + "]")         
        
        patchnfo = (".nosigchk=0:0x%X" % final2 + ":0x1:01,00")
        # print("\nAdd to Patches.ini")
        # print (loader)
        # print(patchnfo)
        txt = open(os.path.join(workingdir, "bootloader/patches.ini"), "a")
        txt.write(loader + "\n" + patchnfo)
        txt.close()

        # write ips patch
        makedirs() # make sure we make the dirs first though, of we will be trying to put a file in somewhere that doesn't exist.
        rootloc = "/atmosphere/kip_patches/loader_patches/"
        text_file = open(workingdir + rootloc + info + ".ips", "wb")
        hexval = hex(final)
        shorthex =  hexval.replace("0x", "")
        y = bytes.fromhex(str("504154434800" + shorthex + "000100454F46")) #written ips patch
        text_file.write(y)
        text_file.close()

def patterncheck():
        try:
                search()
                global find
                global find2
                if find:
                        makeips()
                elif find2:
                        find = find2
                        makeips()
                else:
                        print ("Can't find the byte pattern, unable to create the ips file :-(\nCheck GBATemp for an update")
                        sys.exit(1)
        
        except OSError as e:
                print("Somethings gone wrong in the pattern check! %s" % e)                

patterncheck()
os.remove(kipname)
end = time.time()
timetaken = (end - start)
seconds = ("{:.2f}".format(round(timetaken, 2)))
print("Time taken to extract the loader and make an ips patch: %s seconds\n" % seconds)