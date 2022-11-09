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

hactool = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactool.exe')
keyset = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'prod.keys')
FIRMWARE_DIR = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'firmware')
if len(sys.argv) < 2:
    print("You didn't type any arguements, trying default firmware folder and prod.keys\n")
    if Path(FIRMWARE_DIR).exists() and Path(keyset).exists() and Path(hactool).exists():
        pass
    else:
        print('\nError in default paths\nUsage Example: python FS-AutoIPS.py "firmware" "prod.keys" "output"')
        sys.exit(1)
else:
    FIRMWARE_DIR = sys.argv[1]
    keyset = sys.argv[2]

if Path(FIRMWARE_DIR).exists() and Path(keyset).exists():
    pass
else:
    print('Something is wrong with your paths: \nUsage Example: python FS-AutoIPS.py "firmware" "prod.keys" "output"')
    sys.exit(1)    

start = time.time()
if len(sys.argv) < 4:
    root_dir = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'output/')
else:
    root_dir = sys.argv[3] + "/".replace("\\", "/")
find = ""
compkip = "temp/FS.kip1"
kipname = "temp/FS-dec.kip1"
pattern = '0x1e42b91fc14271'
pattern2 = '0x0194081C00121F05007181000054' #added for extra patch....
pattern3 = '0x0294081C00121F05007181000054' #test added for extra patch....
pattern4 = '0x1C00121F0500714101' # find patch for firmware 15.0.0 and up
pattern5 = '0x0036883E' # also FW 15.0.0 and up
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
            if (getsize > 3000000 and getsize < 3500000):
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
        global findnew
        findnew = s.find(pattern2)
        global findnew_alt
        findnew_alt = s.find(pattern3)
        global find_15
        find_15 = s.find(pattern4)
        global findnew_15
        findnew_15 = s.find(pattern5)

    except OSError as e:
        print("Error: %s : %s" % ("Search: ", e.strerror))    
    
def makepatches():
    try:
        if find:
            if findnew:
                res = int(''.join(map(str, findnew)))
                newval =  res / 8
                addpos = int(2) #byte position in find hex
                addpos2 = int(256)
                newfinal =  int(newval - addpos)
                newfinal2 =  int(newfinal - addpos2)
            else:
                print("Unable to find pattern2 - trying pattern3")
                if findnew_alt:
                    res = int(''.join(map(str, findnew_alt)))
                    newval =  res / 8
                    addpos = int(2) #byte position in find hex
                    addpos2 = int(256)
                    newfinal =  int(newval - addpos)
                    newfinal2 =  int(newfinal - addpos2)
                else:
                    print("Unable to find pattern3 - quitting to avoid a crash")
                    sys.exit(1)
            res = int(''.join(map(str, find)))
            newval =  res / 8
            addpos = int(5) #byte position in find hex
            addpos2 = int(256)
            final =  int(newval - addpos)
            final2 =  int(final - addpos2)
            # print("IPS Offset patch address: 0x%X" % final)
        else:
            print("Unable to find pattern - trying pattern4")
        if find_15:
            if findnew_15:
                res = int(''.join(map(str, findnew_15)))
                newval =  res / 8
                addpos = int(2) #byte position in find hex
                addpos2 = int(256)
                newfinal =  int(newval - addpos)
                newfinal2 =  int(newfinal - addpos2)
            else:
                print("Unable to find pattern5 - quitting to avoid a crash")
                sys.exit(1)
            res = int(''.join(map(str, find_15)))
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
                    hexstring =  xxx.hex().upper()
                    #print (hexstring)
                    #new patch
                    filekip.seek(newfinal, 0)
                    yyy =  filekip.read(4)
                    newhexstring =  yyy.hex().upper() #CAD10194
                    #
                    filekip.close()
                    
                    outputdirs() # Create some directories so we can store our files...
                    if not os.path.exists(os.path.join(root_dir, "bootloader")):
                        os.makedirs(os.path.join(root_dir, "bootloader"))
                    if not os.path.exists(os.path.join(root_dir, "bootloader/patches.ini")):
                            loader = ("#" + fatver + "\n" + "[FS:" + info[:-48] + "]")
                    else:
                            loader = ("\n\n" + "#" + fatver + "\n" + "[FS:" + info[:-48] + "]")
                    
                    print("Patch for file: %s" % file)
                    patchnfo = (".nosigchk=0:0x%X" % final2 + ":0x4:" + hexstring + ",1F2003D5" + "\n.nosigchk=0:0x%X" % newfinal2 + ":0x4:" + newhexstring + ",E0031F2A")
                    print("Adding to Patches.ini")
                    print ((loader + "\n" + patchnfo).replace("\n\n", ""))
                    print("")
                    # txt = open(info + ".txt", "w")
                    txt = open(os.path.join(root_dir, "bootloader/patches.ini"), "a")
                    txt.write(loader + "\n" + patchnfo)
                    txt.close()
            
            # write ips patch
            text_file = open(rootloc + info + ".ips", "wb")
            hexval = ('0x{0:0{1}X}'.format(final, 6))
            hexval2 = ('0x{0:0{1}X}'.format(newfinal, 6)) #change int back to hex (make sure we also print leading zero and limit address size)
            shorthex =  hexval.replace("0x", "")
            newpatchloc =  hexval2.replace("0x", "")
            longstr = ("5041544348" + shorthex + "0004" + "1F2003D5" + newpatchloc + "0004" + "E0031F2A" + "454F46")
            #print(longstr)
            y = bytes.fromhex(longstr) #written ips patch
            text_file.write(y)
            text_file.close()
        
        else:
            cantfind()
    
    except OSError as e:
        print("Error: %s : %s" % ("Making the patches: ", e.strerror))     

def cantfind():
    print ("Can't find the byte pattern, unable to create an ips file :-(")
    sys.exit(1)

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
                #extract hdr file and check the size is equal to 3072 bytes
                subprocess.run(['hactool.exe', '--keyset=' + keyset, '--disablekeywarns', '-t', 'nca', '--header=temp/hdr.bin', '--romfsdir=temp/', FIRMWARE_DIR + '/' + file], stdout=subprocess.DEVNULL)
                x = os.path.getsize("temp/hdr.bin")
                if x == 3072:
                    #print ("File size is correct: " + str(x) + " Bytes")
                    with open ("temp/hdr.bin","rb") as z:
                        z.seek(528) # start search offset 0x210
                        address = struct.unpack('>I',z.read(4))[0]
                        z.close
                        global fatver
                        if address == 453509120: # if hex equals 0x1B080000 at 0x210 file hdr is for exfat
                            print("Exfat firmware file found")
                            fatver = "Exfat"
                        if address == 419954688: # if hex equals 0x19080000 at 0x210 file hdr is for fat
                            print("Fat firmware file found")
                            fatver = "Fat"
                else:
                    run()
                # outlines = subprocess.run([hactool, '-k', keyset, '--disablekeywarns', '-t', 'nca', '--romfsdir', 'temp/', FIRMWARE_DIR + '/' + file], capture_output=True)
                if os.path.isfile('temp/nx/package2'):
                    subprocess.run([hactool, '-k', keyset, '--disablekeywarns', '-t', 'pk21', 'temp/nx/package2', '--outdir', 'temp/'], stdout=subprocess.DEVNULL)
                    subprocess.run([hactool, '-k', keyset, '--disablekeywarns', '-t', 'ini1', 'temp/INI1.bin', '--outdir', 'temp/'], stdout=subprocess.DEVNULL)
                    subprocess.run([hactool, '--disablekeywarns', '-t', 'kip1', '--uncompressed', 'temp/FS-dec.kip1', 'temp/FS.kip1'], stdout=subprocess.DEVNULL)
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
print("Time taken to extract firmware and make FS patches: %s seconds\n" % seconds)