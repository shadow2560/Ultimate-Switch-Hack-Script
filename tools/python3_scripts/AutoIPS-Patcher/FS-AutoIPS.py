# FS IPS patch maker - MrDude
# Modified by shadow256
import os
import subprocess
import shutil
import hashlib
import os.path
from pathlib import Path
import sys
import time
import struct
hactool = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactool.exe'))
keyset = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'prod_keys'))
FIRMWARE_DIR = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'firmware'))
if len(sys.argv) < 2:
    print("You didn't type any arguements, trying default firmware folder and prod.keys\n")
    if Path(FIRMWARE_DIR).exists() and Path(keyset).exists() and Path(hactool).exists():
        pass
    else:
        print('Usage Example: python FS-AutoIPS.py "firmware" "prod.keys" "output"')
        sys.exit(1)
    
else:
    FIRMWARE_DIR = sys.argv[1]
    keyset = sys.argv[2]

if Path(FIRMWARE_DIR).exists() and Path(keyset).exists():
    pass
else:
    print('Something is wrong with your paths: Usage Example: python FS-AutoIPS.py "firmware" "prod.keys" "output"')
    sys.exit(1)    

start = time.time()
if sys.argv[3] == "":
    root_dir = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'output')
else:
    root_dir = sys.argv[3] + "/".replace("\\", "/")
find = ""
compkip = "temp/FS.kip1"
kipname = "temp/FS-dec.kip1"
pattern = '0x1e42b91fc14271'
rootloc = root_dir + "atmosphere/kip_patches/fs_patches/"
file = ""
shortlist = []

def Makedirs():
    if not os.path.exists('temp'):
        os.makedirs('temp')

def outputdirs():
    try:
        list_ = ['atmosphere\\', 'atmosphere\\kip_patches\\', 'atmosphere\\kip_patches\\fs_patches']
        for folder in list_:
            if not os.path.exists((root_dir + folder).replace("\\", "/")):
                os.makedirs(root_dir + folder)        
    
    except OSError as e:
        print("Error: %s : %s" % ("Can't make output directories: ", e.strerror)) 
    
def List_files():
    try:
        directory = FIRMWARE_DIR
        files = os.listdir(directory)
        for filelist in files:
            getsize = os.stat(directory + '/' + filelist).st_size
            if (3145728 < getsize < 3500000):
                shortlist.append(filelist)
    except OSError as e:
        print("Error: %s : %s" % ("Listing files: ", e.strerror))

def run():
    if len(shortlist) >= 1:
        extract()
    else:
        print("Extraction Complete!")

def search():
    try:
        from bitstring import ConstBitStream
        s = ConstBitStream(filename=kipname)
        global find
        find = s.find(pattern)
    
    except OSError as e:
        print("Error: %s : %s" % ("Search: ", e.strerror))    
    
def makepatches():
    try:
        if find:
            res = int(''.join(map(str, find)))
            newval =  res / 8
            addpos = int(5) #byte position in find hex
            addpos2 = int(256)
            final =  int(newval - addpos)
            final2 =  int(final - addpos2)
            # print("IPS Offset patch address: 0x%X" % final)
        
            deckip = (compkip)
            if os.path.isfile(deckip): 
                sha256_hash = hashlib.sha256()
                with open(deckip,"rb") as f:
                    # Read and update hash string value in blocks of 4K
                    for byte_block in iter(lambda: f.read(4096),b""):
                        sha256_hash.update(byte_block)
                    info = sha256_hash.hexdigest()
                    info = info.upper()
                    
                    filekip = open(kipname, 'rb')
                    filekip.seek(final, 1)
                    xxx =  filekip.read(4)
                    hexstring =  xxx.hex()
                    # print (hexstring)
                    filekip.close()
                    
                    outputdirs() # Create some directories so we can store our files...
                    if not os.path.exists(os.path.join(root_dir, "bootloader")):
                        os.makedirs(os.path.join(root_dir, "bootloader"))
                    if not os.path.exists(os.path.join(root_dir, "bootloader/patches.ini")):
                            loader = ("[FS:" + info[:-48] + "]")
                    else:
                            loader = ("\n\n[FS:" + info[:-48] + "]")
                    
                    print("Patch for file: %s" % file)
                    patchnfo = (".nosigchk=0:0x%X" % final2 + ":0x4:" + hexstring + ",1F2003D5")
                    print("Adding to Patches.ini")
                    print ((loader + "\n" + patchnfo).replace("\n\n", ""))
                    print("")
                    # txt = open(info + ".txt", "w")
                    txt = open(os.path.join(root_dir, "bootloader/patches.ini"), "a")
                    txt.write(loader + "\n" + patchnfo)
                    txt.close()
            
            # write ips patch
            text_file = open(rootloc + info + ".ips", "wb")
            hexval = hex(final)
            shorthex =  hexval.replace("0x", "")
            y = bytes.fromhex(str("50415443480" + shorthex + "00041F2003D5454F46")) #written ips patch
            text_file.write(y)
            text_file.close()
        
        else:
            cantfind()
    
    except OSError as e:
        print("Error: %s : %s" % ("Making the patches: ", e.strerror))     

def cantfind():
    print ("Can't find the byte pattern, unable to create an ips file :-(")
    sys.exit()

def extract():
    try:
        global file
        file = shortlist[0]
        del shortlist[0]
        
        with open(FIRMWARE_DIR + '/' + file,"rb") as x:
            x.seek(256) # start search offset 0x100
            address = struct.unpack('>I',x.read(4))[0]
            x.close()
            if address == 2573934072: # if hex equals 0x996B1DF8
                outlines = subprocess.run([hactool.name, '-k', keyset, '-t', 'nca', '--romfsdir', 'temp/', FIRMWARE_DIR + '/' + file], capture_output=True)
                if B"Invalid NCA header!" in outlines.stderr:
                    print("Error, verify your keys file.")
                    sys.exit(1)
                if os.path.isfile('temp/nx/package2'):
                    subprocess.run([hactool.name, '-k', keyset, '-t', 'pk21', 'temp/nx/package2', '--outdir', 'temp/'], stdout=subprocess.DEVNULL)
                    subprocess.run([hactool.name, '-k', keyset, '-t', 'ini1', 'temp/INI1.bin', '--outdir', 'temp/'], stdout=subprocess.DEVNULL)
                    subprocess.run([hactool.name, '-t', 'kip1', '--uncompressed', 'temp/FS-dec.kip1', 'temp/FS.kip1'], stdout=subprocess.DEVNULL)
                    os.remove("temp/nx/package2")
                    search()
                    makepatches()
                    run()
                else:
                    run()
            else:
                run()
    
    except OSError as e:
        print("Error: %s : %s" % ("Extract: ", e.strerror))    

def clean_dirs():
    shutil.rmtree("temp")

Makedirs()       
List_files()
# print(shortlist) #Debug - look at the files we need to extract.
run()
clean_dirs()
end = time.time()
timetaken = (end - start)
seconds = ("{:.2f}".format(round(timetaken, 2)))
print("Time taken to extract firmware and make FS patches: %s seconds" % seconds)