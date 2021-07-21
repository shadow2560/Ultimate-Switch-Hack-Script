""""
Use Python 3
Patch Script made by MrDude
Modified by shadow256
Thanks to Crckd/DarkMatterCore and the others that helped @GbaTemp
https://gbatemp.net/threads/info-on-sha-256-hashes-on-fs-patches.581550/
https://armconverter.com/
"""
import os
import subprocess
import shutil
import os.path
from pathlib import Path
from bitstring import ConstBitStream
import sys
import struct
import time

hactool = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactool.exe'))
hactoolnet = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactoolnet.exe'))
keyset = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'prod_keys'))
FIRMWARE_DIR = Path(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'firmware'))
if len(sys.argv) < 2:
    print("You didn't type any arguements, trying default firmware folder and prod.keys\n")
    if Path(FIRMWARE_DIR).exists() and Path(keyset).exists() and Path(hactoolnet).exists() and Path(hactool).exists():
        pass
    else:
        print('Usage Example: python ES-MakeIPS.py "firmware" "prod.keys" "output"')
        sys.exit(1)
else:
    FIRMWARE_DIR = sys.argv[1]
    keyset = sys.argv[2]

if Path(FIRMWARE_DIR).exists() and Path(keyset).exists():
    pass
else:
    print('Something is wrong with your paths: Usage Example: python ES-MakeIPS.py "firmware" "prod.keys" "output"')
    sys.exit(1)    

start = time.time()
if sys.argv[3] == "":
    root_dir = "output/"
else:
    root_dir = sys.argv[3] + "/".replace("\\", "/")
ES_NCA = ""
shortlist = []
filename = "dumped/main_dec"
rootloc = root_dir + "atmosphere/exefs_patches/es_patches/"
sdk = "sdk.txt"
buildid =  ""
header = "5041544348"
footer = "454F46"
NOP_Patch = 0x1F2003D5
text_offset = 0
text_size = 0
final = 0
idx = 0
hexval = 0x0
patchloc = 0
ips_file = ""
patterns = 0
value = 0

patterns1 = ['0x1f90013128928052', '0xc07240f9e1930091', '0xf3031faa02000014']
patterns2 = ['0x1f90013128928052', '0xc0fdff35a8c35838', '0xe023009145eeff97']
    #patterns3 = ['0x1f90013128928052', '0xc0fdff35a8c35c38', '0xe023009168edff97']
patterns3 = ['0x1f90013128928052', '0xc0fdff35a8c3', '0xe023009168edff97'] #firmware 12.0.3
patterns4 = ['0x1f90013128928052', '0xc0fdff35a8c3', '0xe023009140edff97'] #firmware 12.1.0

def List_files():
    directory = FIRMWARE_DIR
    files = os.listdir(directory)
    for filelist in files:
        getsize = os.stat(directory + '/' + filelist).st_size
        if (262144 < getsize < 524288):
            shortlist.append(filelist)

def cleanup():
    main = "main"
    npdm = "main.npdm"
    if Path(main).exists():
        os.remove(main)
    if Path(npdm).exists():
        os.remove(npdm)

def makedumped():
    if not os.path.exists('dumped'):
        os.makedirs('dumped')

def movefiles():
    maindec = "dumped/main_dec"
    if Path(maindec).exists():
        os.remove(maindec)
    shutil.move("main_dec", maindec)

def extract():
    List_files() # create short list of files to process
    print("Checking files in " + FIRMWARE_DIR + " folder.")
    print(shortlist)
    for filename in shortlist:
        if filename.endswith(".nca"):

            outlines = subprocess.check_output([hactoolnet.name,'-k', keyset, FIRMWARE_DIR + '/' + filename])

            for line in outlines.splitlines():
                line = line.decode('ascii').replace(" ","")
                if line.startswith("TitleID:0100000000000033") and not filename.endswith("*.nca"):
                    for line in outlines.splitlines():
                        line = line.decode('ascii').replace(" ","")
                        if line.startswith("ContentType:Program") and not filename.endswith("*.nca"):
                            print("Found! Filename : " + filename)				
                            global ES_NCA
                            ES_NCA = filename
                    break
            
            if ES_NCA:
                print("Using hactoolnet to extract exefsdir")
                subprocess.run([hactoolnet.name, '-k', keyset, '-t', 'nca', '--exefsdir', '.', FIRMWARE_DIR + '/' + filename], stdout=subprocess.DEVNULL)
                if os.path.exists("main"):
                    print("Using hactool to decompress main")
                    outlines = subprocess.check_output([hactool.name, '-k', keyset, '-t', 'nso', '--uncompressed', 'main_dec', 'main'])
                    cleanup()
                    makedumped()
                    movefiles()

                outlines = subprocess.check_output([hactoolnet.name,'-k', keyset, FIRMWARE_DIR + '/' + ES_NCA])
                for line in outlines.splitlines():
                    line = line.decode('ascii').replace(" ","")
                    if line.startswith("SDKVersion:"):
                        f = open("sdk.txt", "w")
                        f.write((line).replace("SDKVersion:", "").replace(".", ""))
                        print((line).replace("SDKVersion:", "SDKVersion: ").replace(".", ""))
                        f.close()
                break
    
def checkfiles():
    if not Path(sdk).exists() or not os.path.isfile(sdk):
        print("ERROR " + sdk + " does not exist, dump the firmware first!")
        sys.exit(1)
    
    if not Path(filename).exists() or not os.path.isfile(filename):
        print("ERROR " + filename + " does not exist, dump the firmware first!")
        sys.exit(1)
    
    f = open(sdk, "r")
    data = f.read()
    f.close()
    
    global value
    global patterns
    global buildid
    value = int(data)
    build_id() # run this first so we can get our IPS name.
    if value < 11400:
        patterns = patterns1 # sdk for firmware under 11.0.0
    elif value < 12300:
        patterns = patterns2 # sdk for firmware 11.0.0 or 11.0.1 under 12.0.0
    elif value == 12300:
        if buildid == "1114E9102F1EBCD1B0EAF19C927362CFCB8B5D2C": #id for firmware 12.1.0
            patterns = patterns4 # for firmware 12.1.0
        else:
            patterns = patterns3 # for firmware under 12.1.0
    else:
        patterns = patterns4

def clean_sdk():
    if Path(sdk).exists():
        os.remove(sdk)

def makedirs():
    list_ = ['atmosphere\\', 'atmosphere\\exefs_patches\\', 'atmosphere\\exefs_patches\\es_patches']
    for folder in list_:
        if not os.path.exists((root_dir + folder).replace("\\", "/")):
            os.makedirs(root_dir + folder)	

def build_id():
    global text_offset
    global text_size
    global buildid
    # Get build ID and .text segment offset + size
    with open(filename,"rb") as f:
        f.seek(0x10)
        text_offset = struct.unpack('<I',f.read(4))[0]
        f.seek(0x18)
        text_size = struct.unpack('<I',f.read(4))[0]
        f.seek(0x40)
        raw_buildid = f.read(0x14)
        buildid = raw_buildid.hex().upper()
        f.close
    print("Build ID:", buildid)
    # Update .text segment offset + size for bitstream
    text_offset *= 8
    text_size *= 8
    
def write_header():
    # Open output IPS patch and write its header
    global ips_file
    ips_file = open(rootloc + buildid + ".ips", "wb")
    x = bytes.fromhex(str(header))
    ips_file.write(x)
    # ips_file.close #Leave this open so we can write the patches

def write_footer():
    # Write IPS patch footer
    x = bytes.fromhex(str(footer))
    ips_file.write(x)
    
def find_offsets():
    s = ConstBitStream(filename=filename)
    global patterns
    pattern = patterns[patchloc]
    find = list(s.findall(pattern, text_offset, text_offset + text_size, bytealigned=True)) # Only search within the .text segment
    for off in find:
        # Fix offset
        off_fix = int(off / 8)

        if off_fix < 0x20000 or off_fix > 0x2FFFC: # Limit range
            continue

        # Calculate instruction offset
        global final
        global hexval
        final = off_fix - 4
        hexval = '0x{0:0{1}X}'.format(final, 6) #change int back to uppercase hex (make sure we also print leading zero)

def patch_address():
    global patchloc
    global idx
    for idx in range(len(patterns)):
        patchloc = idx
        find_offsets()
        print("Probable patch address "+ str(idx+1) + " " + str(hexval) + " (Decimal:" + str(final) + ")") #show offset...debug
    pass

def patch1():
    global patchloc
    patchloc = 0    
    idx = 0
    find_offsets()
    # Get instruction to patch
    with open(filename,"rb") as f:
        f.seek(final)
        inst = struct.unpack('<I',f.read(4))[0]
        f.close
        # print (inst)

    if idx == 0:
        # Make sure we're dealing with a CBZ instruction
        cbz = (inst << 24)
        if cbz != 0x34 and cbz != 0xB4:
            # Generate B instruction
            patch = int((0x14 << 24) | ((inst >> 5) & 0x7FFFF))
            inst = struct.unpack("<I", struct.pack(">I", inst))[0]
            # Byteswap patched instruction
            patch = struct.unpack("<I", struct.pack(">I", patch))[0]
            y = bytearray(struct.pack('>IHI',final,4,patch))
            xxx = '0x{0:0{1}X}'.format(patch, 8) #change int back to uppercase hex (make sure we also print leading zero)
            print("CBZ instruction found 0x%X, writing patch 1 (%s) to ips file" %(inst, xxx))
            # print(y)
            del y[0] # IPS uses 24-bit offsets
            ips_file.write(y)
        
        else:
            print("No CBZ instruction found")
    else:
        print("Wrong patch address for patch 1")
        
def patch2():
    global patchloc
    patchloc = 1
    find_offsets()
    # Get instruction to patch
    with open(filename,"rb") as f:
        f.seek(final)
        inst = struct.unpack('>I',f.read(4))[0]
        f.close
        # print (inst)

    if patchloc == 1:
        if value >= 11400:
            # Make sure we are dealing with a MOV instruction
            if ((inst << 24) & 0x7F) != 0x52:
                patch = NOP_Patch
                y = bytearray(struct.pack('>IHI',final,4,patch))
                del y[0] # IPS uses 24-bit offsets
                ips_file.write(y)
                xxx = '0x{0:0{1}X}'.format(patch, 8) #change int back to uppercase hex (make sure we also print leading zero)
                print("MOV instruction found 0x%X, writing patch 2 (%s) to ips file" %(inst, xxx))               
            else:
                print("No MOV instruction found")            
        else:
            # Make sure we are dealing with a TBZ instruction
            if ((inst << 24) & 0x7F) != 0x36:
                patch = NOP_Patch
                y = bytearray(struct.pack('>IHI',final,4,patch))
                del y[0] # IPS uses 24-bit offsets
                ips_file.write(y)                
                print("TBZ instruction found 0x%X, writing patch 2 (0x%X) to ips file" %(inst, patch))
            else:
                print("No TBZ instruction found")       
    else:
        print("Wrong patch address for patch 2")
        
def patch3():
    global patchloc
    patchloc = 2
    find_offsets()
    # Get instruction to patch
    with open(filename,"rb") as f:
        f.seek(final)
        inst = struct.unpack('<I',f.read(4))[0]
        f.close
        # print (inst)
    
    if patchloc == 2:
        if value >= 11400: # (firmware sdk greater than 11.0.0)
            # Make sure we are dealing with a CBZ instruction
            cbz = (inst << 24)
            if cbz != 0x34 and cbz != 0xB4:
                # Generate B instruction
                patch = int((0x14 << 24) | ((inst >> 5) & 0x7FFFF))
                inst = struct.unpack("<I", struct.pack(">I", inst))[0]
                # Byteswap patched instruction
                patch = struct.unpack("<I", struct.pack(">I", patch))[0]
                y = bytearray(struct.pack('>IHI',final,4,patch))
                xxx = '0x{0:0{1}X}'.format(patch, 8) #change int back to uppercase hex (make sure we also print leading zero)
                print("CBZ instruction found 0x%X, writing patch 3 (%s) to ips file" %(inst, xxx))
                # print(y)
                del y[0] # IPS uses 24-bit offsets
                ips_file.write(y)                        
        else: # (firmware sdk lower than 11.0.0)
            # Check if we're dealing with a B.NE instruction
            if (inst << 24) != 0x54 or (inst & 0x10) != 0:
                patch = NOP_Patch
                y = bytearray(struct.pack('>IHI',final,4,patch))
                del y[0] # IPS uses 24-bit offsets
                ips_file.write(y)
                inst = struct.unpack("<I", struct.pack(">I", inst))[0]
                print("B.NE instruction found 0x%X, writing patch 3 (0x%X) to ips file" %(inst, patch))            
            else:
                print("No B.NE instruction found")       
    else:
        print("Wrong patch address for patch 3")
        
def clean_dumped():
    try:
        os.remove(filename)
        os.rmdir("dumped")
    except OSError as e:
        print("Error: %s : %s" % ("dumped", e.strerror))

#========================================================
#-----main extraction and decrypt is done from here------
#========================================================
extract() # Extract main and then decrypt it
checkfiles() # Make sure main was decrypted and we were able to read the sdk version
#========================================================
#------------Patch creation is done from here------------
#========================================================
clean_sdk() # We already have the value so this can be removed now.
makedirs() # create directories to store the ips patch.
build_id() # run this first so we can get our IPS name.
write_header() # write the first part of the ips file, leave file open until patches are completed.
patch1() # try and find pattern 0 so we can write patch 1 to our ips file
patch2() # try and find pattern 1 so we can write patch 2 to our ips file
patch3() # try and find pattern 2 so we can write patch 3 to our ips file
write_footer() # write the last part of the ips file.
ips_file.close() # we wrote the header,all the patches and the footer so we can close this file now.
patch_address() # show probable address patch adressess.
clean_dumped() # clean up dumped folder, this is not required now.
end = time.time()
timetaken = (end - start)
seconds = ("{:.2f}".format(round(timetaken, 2)))
print("Time taken to extract firmware and make ES patches: %s seconds\n" % seconds)