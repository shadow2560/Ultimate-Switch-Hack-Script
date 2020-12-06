import sys
from struct import pack as pk, unpack as up

def u32(x):
    return x & 0xFFFFFFFF

def tea_update_custom_mac(mac, v, k):
    v0, v1 = v[0], v[1]
    cur_sum = 0xC6EF3720
    k0, k1, k2, k3 = k[0], k[1], k[2], k[3]
    mac[3] = u32(mac[3] - (u32((v0 << 4) + k1) ^ u32(mac[2] + cur_sum) ^ u32((v1 >> 5) + k2)))
    mac[2] = u32(mac[2] - (u32((v1 << 4) + k3) ^ u32(mac[3] + cur_sum) ^ u32((v0 >> 5) + k0)))
    mac[1] = u32(mac[1] - (u32((v0 << 4) + k2) ^ u32(mac[0] + cur_sum) ^ u32((v0 >> 5) + k3)))
    mac[0] = u32(mac[0] - (u32((v1 << 4) + k0) ^ u32(mac[1] + cur_sum) ^ u32((v1 >> 5) + k1)))

def tea_decrypt(v, k):
    # Taken with love from Wikipedia
    v0, v1 = v[0], v[1]
    cur_sum = 0xC6EF3720
    delta = 0x9E3779B9
    k0, k1, k2, k3 = k[0], k[1], k[2], k[3]
    for i in xrange(0, 32):
        v1 = u32(v1 - (u32((v0 << 4) + k2) ^ u32(v0 + cur_sum) ^ u32((v0 >> 5) + k3)))
        v0 = u32(v0 - (u32((v1 << 4) + k0) ^ u32(v1 + cur_sum) ^ u32((v1 >> 5) + k1)))
        cur_sum = u32(cur_sum - delta)
    return [v0, v1]

def tea_encrypt(v, k):
    # Taken with love from Wikipedia
    v0, v1 = v[0], v[1]
    cur_sum = 0
    delta = 0x9E3779B9
    k0, k1, k2, k3 = k[0], k[1], k[2], k[3]
    for i in xrange(0, 32):
        cur_sum = u32(cur_sum + delta)
        v0 = u32(v0 + (u32((v1 << 4) + k0) ^ u32(v1 + cur_sum) ^ u32((v1 >> 5) + k1)))
        v1 = u32(v1 + (u32((v0 << 4) + k2) ^ u32(v0 + cur_sum) ^ u32((v0 >> 5) + k3)))
    return [v0, v1]

def get_key(offset):
    return [u32(0x73707048 + offset), u32(0xE8AD34FB + offset), u32(0xA4A8ACE6 + offset), u32(0x7B648B68 + offset)]

def encrypt_firmware(data, do_print = True):
    # Parse header.
    # Checks from validate_firmware_header (sub_08000CA8)
    # Note that several of these checks are redundant, and header + 0xC is not used but is set....
    assert len(data) >= 0x10
    offset, size, version, _C = up('<IIII', data[:0x10])
    assert size < 0x20000
    assert (offset & 0x3FF) == 0
    assert (size & 0x3FF) == 0
    assert offset == 0
    assert size < 0x1CC00
    if do_print:
        print 'Encrypting Update version %d.%d, size = 0x%X' % (version >> 8, version & 0xFF, size)

    # Encrypt data.
    assert len(data) == 0x10 + size
    calc_mac = [0, 0, 0, 0]
    dec = data[0x10:]
    enc = ''
    for i in xrange(0, size, 8):
        cur_key = get_key(i)
        cur_dec = up('<II', dec[i:i+8])
        cur_enc = tea_encrypt(cur_dec, cur_key)
        tea_update_custom_mac(calc_mac, cur_dec, cur_key)
        enc += pk('<II', *cur_enc)
    calc_mac = pk('<IIII', *calc_mac)
    return data[:0x10] + calc_mac + enc

def decrypt_firmware(data, do_print = True):
    # Parse header.
    # Checks from validate_firmware_header (sub_08000CA8)
    # Note that several of these checks are redundant, and header + 0xC is not used but is set....
    assert len(data) >= 0x20
    offset, size, version, _C = up('<IIII', data[:0x10])
    mac = data[0x10:0x20]
    assert size < 0x20000
    assert (offset & 0x3FF) == 0
    assert (size & 0x3FF) == 0
    assert offset == 0
    assert size < 0x1CC00
    if do_print:
        print 'Decrypting Update version %d.%d, size = 0x%X' % (version >> 8, version & 0xFF, size)

    # Decrypt data.
    assert len(data) == 0x20 + size
    calc_mac = [0, 0, 0, 0]
    enc = data[0x20:]
    dec = ''
    for i in xrange(0, size, 8):
        cur_key = get_key(i)
        cur_enc = up('<II', enc[i:i+8])
        cur_dec = tea_decrypt(cur_enc, cur_key)
        tea_update_custom_mac(calc_mac, cur_dec, cur_key)
        dec += pk('<II', *cur_dec)

    calc_mac = pk('<IIII', *calc_mac)
    if calc_mac != mac and do_print:
        print '[WARN] Calculated MAC (%s) != Expected MAC (%s)' % (calc_mac.encode('hex'), mac.encode('hex'))
    return data[:0x10] + dec

def main(argc, argv):
    if argc != 4 or argv[1] not in ('-d', '-e'):
        print 'Usage: %s {-d|-e} in out' % argv[0]
        return 1
    with open(argv[2], 'rb') as f:
        data = f.read()
    with open(argv[3], 'wb') as f:
        if argv[1] == '-d':
            f.write(decrypt_firmware(data))
        else:
            assert argv[1] == '-e'
            enc = encrypt_firmware(data)
            assert data == decrypt_firmware(enc, False)
            f.write(enc)
    return 0

if __name__ == '__main__':
    sys.exit(main(len(sys.argv), sys.argv))