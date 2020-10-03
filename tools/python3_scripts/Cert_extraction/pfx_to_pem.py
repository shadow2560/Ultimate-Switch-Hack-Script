import os, sys
import contextlib
import tempfile
import OpenSSL

def pfx_to_pem(pfxPath, pfxPassword):
    with open(os.path.join(os.path.dirname(__file__), '%s.pem'%os.path.basename(pfxPath).split('.')[0]), 'wb') as pem:
        pfx = open(pfxPath, 'rb').read()
        p12 = OpenSSL.crypto.load_pkcs12(pfx, pfxPassword)
        pem.write(OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, p12.get_privatekey()))
        pem.write(OpenSSL.crypto.dump_certificate(OpenSSL.crypto.FILETYPE_PEM, p12.get_certificate()))
        pem.close()
        print('Converted to %s!' % pem.name)
        return 0
    
if __name__ == '__main__':
    if len(sys.argv) > 2:
        print('Usage is %s path/to/pfx!' % sys.argv[0])
        sys.exit(1)
    sys.exit(pfx_to_pem(sys.argv[1], 'switch'))