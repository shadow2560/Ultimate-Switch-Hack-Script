'''
Use Python 3.x
Script By MrDude, modified by shadow256
Manually extract example:
hactool --keyset=keys.dat --intype=nca --exefsdir=. --disablekeywarns firmware/f8a5837382d57047b51f9d0375b59845.nca
hactool --keyset=keys.dat --intype=nso --disablekeywarns --uncompressed=main_dec main
'''
import os
import subprocess
import shutil
import os.path
from pathlib import Path
import sys
import time

hactool = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactool.exe')
hactoolnet = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'hactoolnet.exe')
keyset = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'prod.keys')
FIRMWARE_DIR = os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'firmware')
if len(sys.argv) < 2:
    print("You didn't type any arguements, trying default firmware folder and prod.keys\n")
    if Path(FIRMWARE_DIR).exists() and Path(keyset).exists() and Path(hactoolnet).exists() and Path(hactool).exists():
        pass
    else:
        print('\nError in default paths\nUsage Example: python NCA-Info.py.py "firmware" "prod.keys"')
        sys.exit(1)
else:
    FIRMWARE_DIR = sys.argv[1]
    keyset = sys.argv[2]

if Path(FIRMWARE_DIR).exists() and Path(keyset).exists():
    pass
else:
    print('Something is wrong with your paths: Usage Example: python NCA-Info.py "firmware" "keys.dat"')
    sys.exit(1)    

start = time.time()
ES_NCA = ""
shortlist = []
filename = "dumped/main_dec"
buildid =  ""
final = 0
ips_file = ""
    
def List_files():
    directory = FIRMWARE_DIR
    files = os.listdir(directory)
    for filelist in files:
        getsize = os.stat(directory + '/' + filelist).st_size
        if (getsize > 5632): #skip small files
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
    #List_files() # create short list of files to process
    print("Checking files in " + FIRMWARE_DIR + " folder.")
    for filename in shortlist:
        try: 
            if filename.endswith(".nca"):
    
                outlines = subprocess.check_output([hactoolnet,'-k', keyset, '--disablekeywarns', FIRMWARE_DIR + '/' + filename])
    
                for line in outlines.splitlines():
                    # line = line.decode('ascii').replace(" ","")
                    line = line.decode('utf-8').replace(" ","")
                    if line.startswith("TitleID:"):
                        print((line).replace("TitleID:", "\nTitleID: ").replace(".", ""))
                
                for line in outlines.splitlines():
                    # line = line.decode('ascii').replace(" ","")
                    line = line.decode('utf-8').replace(" ","")
                    if line.startswith("TitleName:"):
                        print((line).replace("TitleName:", "TitleName: ").replace(".", ""))
                
                for line in outlines.splitlines():
                    # line = line.decode('ascii').replace(" ","")
                    line = line.decode('utf-8').replace(" ","")
                    if line.startswith("ContentType:"):
                        if "Data" in line:
                            line = line.replace("Data", "Data")                        
                            print((line).replace("ContentType:", "ContentType: ").replace(".", ""))
                        else:
                            print((line).replace("ContentType:", "ContentType: ").replace(".", ""))
                
                for line in outlines.splitlines():
                    # line = line.decode('ascii').replace(" ","")
                    line = line.decode('utf-8').replace(" ","")
                    if line.startswith("TitleID:") and not filename.endswith("*.nca"):
                        for line in outlines.splitlines():
                            # line = line.decode('ascii').replace(" ","")
                            line = line.decode('utf-8').replace(" ","")
                            if line.startswith("ContentType:") and not filename.endswith("*.nca"):
                                print("NCA: " + filename)
                                global ES_NCA
                                ES_NCA = filename
                        break
                
                if ES_NCA:
                    subprocess.run([hactoolnet, '-k', keyset, '--disablekeywarns', '-t', 'nca', '--exefsdir', '.', FIRMWARE_DIR + '/' + filename], stdout=subprocess.DEVNULL)
                    if os.path.exists("main"):
                        outlines = subprocess.check_output(['hactool','--keyset=' + keyset,'--intype=nso','--disablekeywarns','--uncompressed=main_dec','main'])
                        cleanup()
                        makedumped()
                        movefiles()
                        build_id()
    
                    #break
                
                if not shortlist:
                    shortlist.pop(0)
                    extract()
        except:
            print("Failed to decompile %s:\n" % filename)

def clean_faied():
    if Path("sdk").exists():
        os.remove("sdk")   
    if Path("rtld").exists():
        os.remove("rtld")
    if Path("subsdk0").exists():
        os.remove("subsdk0") 
    if Path("subsdk1").exists():
        os.remove("subsdk1")
    if Path("subsdk2").exists():
        os.remove("subsdk2")    
        
def build_id():
    global buildid
    with open(filename,"rb") as f:
        f.seek(0x40)
        raw_buildid = f.read(0x14)
        buildid = raw_buildid.hex().upper()
        f.close
    print("Build ID:", buildid)
        
def clean_dumped():
    try:
        os.remove(filename)
        os.rmdir("dumped")
    except OSError as e:
        print("Error: %s : %s" % ("dumped", e.strerror))

#========================================================
#-----main extraction and decrypt is done from here------
#========================================================
List_files() # create short list of files to process
extract() # Extract main and then decrypt it
clean_dumped() # clean up dumped folder, this is not required now.
clean_faied()
end = time.time()
timetaken = (end - start)
seconds = ("{:.2f}".format(round(timetaken, 2)))
print("\nTime taken %s seconds\n" % seconds)