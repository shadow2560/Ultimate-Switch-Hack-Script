# Getting your SSL Private Key and Certificate
# SocraticBliss and SimonMKWii (R)

from binascii import unhexlify as uhx, hexlify as hx
from pip._internal import main as pipmain
import hashlib
import sys

# Fill in the 32 Hex Digit keys here... (Hint: only replace the 32 F's)
rsa_private_kek_generation_source = uhx('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')
master_key_00 = uhx('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')
ssl_rsa_kek_source_x = uhx('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')
ssl_rsa_kek_source_y = uhx('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')

keys = [['rsa_private_kek_generation_source', rsa_private_kek_generation_source, 'F3A68FC81509A41372EC479FD79019FE719A6DA7804B5557432A78F27DD74E49'],
        ['master_key_00', master_key_00,                                         '0EE359BE3C864BB0782E1D70A718A0342C551EED28C369754F9C4F691BECF7CA'],
        ['ssl_rsa_kek_source_x', ssl_rsa_kek_source_x,                           '69A08E62E0AE507BB5DA0E65179AE3BE051FED3C49941DF4EF2956D36D30110C'],
        ['ssl_rsa_kek_source_y', ssl_rsa_kek_source_y,                           '1C86F363265417D499229EB1C4ADC7479B2A15F931261F31EE6776AEB4C76542']]

def install(packages):
    for package in packages:
        try:
            pipmain(['-q', 'install', '-I', package])
            print('%s successfully installed!' % package)

        except:
            print('\nError: unable to install %s!' % package)
            sys.exit(1)
    return

def decrypt(inputkey, iv):
    return AES.new(iv, AES.MODE_ECB).decrypt(inputkey)

def unwrap(wrappedkey, iv):
    return decrypt(wrappedkey, iv)

def b2ctr(x):
    return Counter.new(128, initial_value=int(hx(x), 16))

def read_at(fp, off, len):
    fp.seek(off)
    return fp.read(len)

def get_ssl_privk(cal0):   
    # Save the SSL Cert
    ssl_cert = read_at(cal0, 0x0AE0, 0x800)
    with open('clcert.der', 'wb') as cert:
        cert.write(ssl_cert)

    # Generate the SSL RSA Kek
    unwrapped_kek = unwrap(rsa_private_kek_generation_source, master_key_00)
    unwrapped_kekek = unwrap(ssl_rsa_kek_source_x, unwrapped_kek)
    ssl_rsa_kek = unwrap(ssl_rsa_kek_source_y, unwrapped_kekek)
    #print('ssl_rsa_kek = %s' % (hx(ssl_rsa_kek).upper()))

    # Decrypt the Encrypted SSL Key
    dec = AES.new(ssl_rsa_kek, AES.MODE_CTR, counter=b2ctr(read_at(cal0, 0x3AE0, 0x10))) \
             .decrypt(read_at(cal0, 0x3AF0, 0x120))
    privk = hx(dec[:0x100])
    with open('privk.bin', 'wb') as key:
        key.write(uhx(privk))
    return

def main():
    #Step 1) Decrypted SSL Cert Test
    try:
        with open('PRODINFO.bin', 'rb') as cal0:
            ssl_test = read_at(cal0, 0x0, 0x4)
            if ssl_test != 'CAL0':
                raise Exception
    except:
        print('\nError: Your PRODINFO.bin is still encrypted!\n')
        print('0) Get your BIS Keys (via biskeydump)')
        print('1) Save your SYSNAND backup (via hekate)')
        print('2) Decrypt your PRODINFO (via HacDiskMount) with BIS Key 0')
        print('3) Save to file -> PRODINFO.bin (to your working directory)')
        print('4) Run the CertNXtractionPack.cmd script again!')
        sys.exit(1)

    #Step 2) Check the key hashes
    incorrect_keys = 0
    print('Verifying keys...\n')
    for key in keys:    
        if hashlib.sha256(key[1]).hexdigest().upper() != key[2]:
            print('Error: %s is incorrect!' % key[0])
            incorrect_keys+=1
            
    if incorrect_keys > 0:
        print('\nError: Please insert the correct key(s) at the top of the CertNXtractionPack.py script and try again!')        
        sys.exit(1)

    #Step 3) Get your Private Key
    try:
        with open('PRODINFO.bin', 'rb') as cal0:
            get_ssl_privk(cal0)
    except:
        print('\nError: Unable to open PRODINFO.bin!')
        sys.exit(1)

    print('Script #1 Completed Successfully!')
    print('Saved clcert.der and privk.bin to your working directory.')
    sys.exit(0)

if __name__=='__main__':
    try:
        from Crypto.Cipher import AES
        from Crypto.Util import Counter

    except ImportError:
        dependencies = ['pycrypto']
        print('Checking Dependencies...')
        install(dependencies)

    main()