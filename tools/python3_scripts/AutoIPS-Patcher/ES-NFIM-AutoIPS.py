""""
Use Python 3
Patch Script made by MrDude
Modified by shadow256
Thanks to Crckd/DarkMatterCore and the others that helped @GbaTemp
https://gbatemp.net/threads/info-on-sha-256-hashes-on-fs-patches.581550/
Branching & bit shifting- https://gbatemp.net/threads/info-on-sha-256-hashes-on-fs-patches.581550/page-7#post-9352950
https://armconverter.com/
"""
import os
import subprocess
import shutil
import os.path
from pathlib import Path
import sys
import struct
import time
import re
import binascii

hactool = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactool.exe')
hactoolnet = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactoolnet.exe')
keyset = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'prod.keys')
FIRMWARE_DIR = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'firmware')
if len(sys.argv) < 2:
    print("You didn't type any arguements, trying default firmware folder and prod.keys\n")
    if Path(FIRMWARE_DIR).exists() and Path(keyset).exists() and Path(hactoolnet).exists() and Path(hactool).exists():
        pass
    else:
        print('\nError in default paths\nUsage Example: python ES-NFIM-AutoIPS.py "firmware" "prod.keys" "output"')
        sys.exit(1)
else:
    FIRMWARE_DIR = sys.argv[1]
    keyset = sys.argv[2]

if Path(FIRMWARE_DIR).exists() and Path(keyset).exists():
    pass
else:
    print('Something is wrong with your paths: Usage Example: python ES-NFIM-AutoIPS.py "firmware" "prod.keys" "output"')
    sys.exit(1)    

start = time.time()
if len(sys.argv) < 4:
    root_dir = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'output/')
else:
    root_dir = sys.argv[3] + "/".replace("\\", "/")
ES_NCA = ""
shortlist = []
filename = "dumped/main_dec"
rootloc = root_dir + "atmosphere/exefs_patches/nfim_ctest/"
sdk = "sdk.txt"
buildid =  ""
header = "5041544348"
footer = "454F46"
Patch = 0xE0031FAA
Patch2 = 0xC0035FD6
final = 0
ips_file = ""
    
def List_files():
    directory = FIRMWARE_DIR
    files = os.listdir(directory)
    for filelist in files:
        getsize = os.stat(directory + '/' + filelist).st_size
        if (262144 < getsize < 687265): #set size limit to make the search faster.
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
    for filename in shortlist:
        if filename.endswith(".nca"):

            outlines = subprocess.check_output([hactoolnet,'-k', keyset, '--disablekeywarns', FIRMWARE_DIR + '/' + filename])

            for line in outlines.splitlines():
                # line = line.decode('ascii').replace(" ","")
                line = line.decode('utf-8').replace(" ","")
                # print(line)
                if line.startswith("TitleID:010000000000000F") and not filename.endswith("*.nca"):
                    for line in outlines.splitlines():
                        # line = line.decode('ascii').replace(" ","")
                        line = line.decode('utf-8').replace(" ","")
                        if line.startswith("TitleName:nifm") and not filename.endswith("*.nca"):
                            print("Found NCA: " + filename)				
                            global ES_NCA
                            ES_NCA = filename
                            #getsize = os.stat(FIRMWARE_DIR + '/' + filename).st_size #587264
                            #print(getsize)
                    break
            
            if ES_NCA:
                print("Using hactoolnet to extract exefsdir")
                subprocess.run([hactoolnet, '-k', keyset, '--disablekeywarns', '-t', 'nca', '--exefsdir', '.', FIRMWARE_DIR + '/' + filename], stdout=subprocess.DEVNULL)
                if os.path.exists("main"):
                    print("Using hactool to decompress main")
                    outlines = subprocess.check_output(['hactool','--keyset=' + keyset, '--disablekeywarns', '--intype=nso','--disablekeywarns','--uncompressed=main_dec','main'])
                    cleanup()
                    makedumped()
                    movefiles()

                outlines = subprocess.check_output([hactoolnet,'-k', keyset, '--disablekeywarns', FIRMWARE_DIR + '/' + ES_NCA])
                for line in outlines.splitlines():
                    # line = line.decode('ascii').replace(" ","")
                    line = line.decode('utf-8').replace(" ","")
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
    
    global buildid
    global final
    global f1
    value = int(data)
    build_id() # run this first so we can get our IPS name.
    if value < 12300 or value == 82990:
        with open('dumped/main_dec', 'rb') as file:
            f1 = re.search(b'\xF5\x0F\x1D\xF8\xF4\x4F\x01\xA9\xFD\x7B\x02\xA9\xFD\x83\x00\x91\xF5\x03\x01\xAA\xF4\x03\x00\xAA..\xFF\x97\xF3\x03\x14\xAA\xE0\x03\x14\xAA\x9F', file.read()) #(fw < 10.0.4)
            if f1:
                doit()
            else:
                print ("Hex match not found")
    
    elif value >= 12300 and value < 15300:
        with open('dumped/main_dec', 'rb') as file:
            f1 = re.search(b'\xFD\x7B\xBD\xA9\xF5\x0B\x00\xF9\xFD\x03\x00\x91\xF4\x4F\x02\xA9\xF5\x03\x01\xAA\xF4\x03\x00\xAA.\xFB\xFF\x97\xF3\x03\x14\xAA\xE0\x03\x14\xAA\x9F', file.read()) #(fw >12.x.x)
            if f1:
                doit()
            else:
                print ("Hex match not found")        
    elif value >= 15300:
        with open('dumped/main_dec', 'rb') as file:
            f1 = re.search(b'\xFD...........................\xF3\x03\x14\xAA\xE0\x03\x14\xAA\x9F', file.read()) #(fw >15.x.x)
            if f1:
                doit()
            else:
                print ("Hex match not found")        

def doit():
    global f1
    global final
    hexfound = binascii.hexlify(f1.group())
    test = hexfound.decode('utf-8').upper()               
    print ("Found Hex: " + test)
    final = (f1.start()+0)
    hexval = '0x{0:0{1}X}'.format(final, 6) #change int back to uppercase hex (make sure we also print leading zero)
    print ("Probable Patch Offset:", hexval)   
           
def clean_sdk():
    if Path(sdk).exists():
        os.remove(sdk)

def makedirs():
    list_ = ['atmosphere\\', 'atmosphere\\exefs_patches\\', 'atmosphere\\exefs_patches\\nfim_ctest']
    for folder in list_:
        if not os.path.exists((root_dir + folder).replace("\\", "/")):
            os.makedirs(root_dir + folder)	

def build_id():
    global buildid
    with open(filename,"rb") as f:
        f.seek(0x40)
        raw_buildid = f.read(0x14)
        buildid = raw_buildid.hex().upper()
        f.close
    print("Build ID:", buildid)
    
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
    
def patch():
    #write patch
    y = bytearray(struct.pack('>IHII',final,8,Patch,Patch2)) #https://docs.python.org/3/library/struct.html
    del y[0] # IPS uses 24-bit offsets
    #print(y)
    ips_file.write(y)
        
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
write_header() # write the first part of the ips file, leave file open until patches are completed.
patch()
write_footer() # write the last part of the ips file.
ips_file.close() # we wrote the header,all the patches and the footer so we can close this file now.
clean_dumped() # clean up dumped folder, this is not required now.
end = time.time()
timetaken = (end - start)
seconds = ("{:.2f}".format(round(timetaken, 2)))
print("Time taken to extract firmware and make ES patch: %s seconds\n" % seconds)