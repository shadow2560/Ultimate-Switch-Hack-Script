#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	With thanks to https://switchbrew.org/wiki/Calibration
	This file is on GPL V3 licence
"""

from copy import deepcopy
import sys
import binascii
import subprocess
import os
import struct
import hashlib
# import time

# start_time = time.time()

if (sys.version_info[0] == 3):
	pass
else:
	print ('Python 3 est requis pour lancer ce script, pas Python ' + str(sys.version_info[0]) + '.')
	sys.exit(103)

prodinfo_magic_number = b'CAL0'
prodinfo_version = 0
prodinfo_body_size = 0
prodinfo_offset_stop = 0

# Get crc_16, function ported from the one on https://switchbrew.org/wiki/Calibration
crc_16_table = [0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401, 0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400]
def get_crc_16(p, n):
	crc = 0x55AA
	r = 0
	i = 0
	j = 0
	while (n > 0):
		j = i + 1
		r = crc_16_table[crc & 0xF]
		crc = (crc >> 4) & 0x0FFF
		crc = crc ^ r ^ crc_16_table[int.from_bytes(p[i:j], 'big') & 0xF]
		r = crc_16_table[crc & 0xF]
		crc = (crc >> 4) & 0x0FFF
		crc = crc ^ r ^ crc_16_table[(int.from_bytes(p[i:j], 'big') >> 4) & 0xF]
		i += 1
		n -= 1
	crc = crc.to_bytes(2, 'little')
	#print(int.from_bytes(crc, byteorder='little'))
	return(crc)

"""
	The folowing variable is a liste with the different values of the PRODINFO file, organized like this:
	data_type: Value are "data", "crc_16" or "sha256".
	Data values will be organized like this:
		data_offset_begin, data_datas_length, data_description, data_content
	Crc_16 values will be organized like this:
		crc_offset_begin, crc_datas_length, crc_description, crc_padding_size, crc_content, crc_expected
	Sha256 values will be organized like this:
		sha256_offset_begin, sha256_datas_length (always 0x20), sha256_description, sha256_content, sha256_expected
"""
prodinfo_datas = []

def data_getdatas(prodinfo_file_src, offset_start, datas_length, description):
	global prodinfo_datas
	prodinfo_file_src.seek(offset_start)
	temp_info = struct.pack(str(datas_length) + 's', prodinfo_file_src.read(datas_length))
	prodinfo_datas.append(['data', offset_start, datas_length, description, temp_info])
	return(0)

def crc_getdatas(prodinfo_file_src, offset_start, datas_length, padding_size, description, crc_source):
	global prodinfo_datas
	crc_16_padding = crc_source + (b'\0'*padding_size)
	temp_crc_16 = get_crc_16(crc_16_padding, len(crc_16_padding))
	temp_crc_16 = (b'\0'*padding_size) + bytes(temp_crc_16)
	temp_info = struct.pack(str(datas_length) + 's', prodinfo_file_src.read(datas_length))
	prodinfo_datas.append(['crc', offset_start, datas_length, description, padding_size, temp_info, temp_crc_16])
	return(0)

def sha256_getdatas(prodinfo_file_src, offset_start, datas_length, description, begin_sha256_data_offset, sha256_data_size):
	global prodinfo_datas
	prodinfo_file_src.seek(begin_sha256_data_offset)
	temp_info = prodinfo_file_src.read(sha256_data_size)
	temp_sha256 = hashlib.sha256(temp_info).digest()
	prodinfo_file_src.seek(offset_start)
	temp_info = struct.pack(str(datas_length) + 's', prodinfo_file_src.read(datas_length))
	prodinfo_datas.append(['sha256', offset_start, datas_length, description, temp_info, temp_sha256])
	return(0)

def read_prodinfo(prodinfo_file_src_path):
	global prodinfo_offset_stop
	global prodinfo_body_size
	try:
		with open(prodinfo_file_src_path, 'rb') as prodinfo_file_src:
			data_getdatas(prodinfo_file_src, 0x0, 0x4, 'MagicNumber, CAL0 header magic')
			if (prodinfo_datas[-1][4] != prodinfo_magic_number):
				print("Fichier PRODINFO source incorrect.")
				return 101
			prodinfo_begin_for_crc_16 = prodinfo_datas[-1][4]
			data_getdatas(prodinfo_file_src, 0x4, 0x4, 'Version')
			prodinfo_version = int.from_bytes(prodinfo_datas[-1][4], byteorder='little')
			prodinfo_begin_for_crc_16 = prodinfo_begin_for_crc_16 + prodinfo_datas[-1][4]
			data_getdatas(prodinfo_file_src, 0x8, 0x4, 'BodySize, total size of calibration data starting at offset 0x40')
			prodinfo_begin_for_crc_16 = prodinfo_begin_for_crc_16 + prodinfo_datas[-1][4]
			prodinfo_body_size = int.from_bytes(prodinfo_datas[-1][4], byteorder='little')
			prodinfo_offset_stop = prodinfo_body_size + 0x40
			data_getdatas(prodinfo_file_src, 0xc, 0x2, 'Model')
			prodinfo_begin_for_crc_16 = prodinfo_begin_for_crc_16 + prodinfo_datas[-1][4]
			data_getdatas(prodinfo_file_src, 0xe, 0x2, 'UpdateCount, increases each time calibration data is installed')
			prodinfo_begin_for_crc_16 = prodinfo_begin_for_crc_16 + prodinfo_datas[-1][4]
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'Begin file crc_16', prodinfo_begin_for_crc_16)
			sha256_getdatas(prodinfo_file_src, 0x20, 0x20, 'BodyHash, SHA256 hash calculated over calibration data', 0x40, prodinfo_body_size)
			data_getdatas(prodinfo_file_src, 0x40, 0x1e, 'ConfigurationId1, Configuration ID string')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'ConfigurationId1 crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x60, 0x20, 'Reserved, Empty')
			data_getdatas(prodinfo_file_src, 0x80, 0x4, 'WlanCountryCodesNum, Number of elements in the WlanCountryCodes array')
			prodinfo_country_code_for_crc_16 = prodinfo_datas[-1][4]
			data_getdatas(prodinfo_file_src, 0x84, 0x4, 'WlanCountryCodesLastIndex, Index of the last element in the WlanCountryCodes array')
			prodinfo_country_code_for_crc_16 = prodinfo_country_code_for_crc_16 + prodinfo_datas[-1][4]
			data_getdatas(prodinfo_file_src, 0x88, 0x180, 'WlanCountryCodes, Array of WLAN country code strings. Each element is 3 bytes (code + NULL terminator)')
			prodinfo_country_code_for_crc_16 = prodinfo_country_code_for_crc_16 + prodinfo_datas[-1][4]
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x8, 0x6, 'WlanCountryCodesNum+WlanCountryCodesLastIndex+WlanCountryCodes crc16', prodinfo_country_code_for_crc_16)
			data_getdatas(prodinfo_file_src, 0x210, 0x6, 'WlanMacAddress')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'WlanMacAddress crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x218, 0x8, 'Reserved, Empty')
			data_getdatas(prodinfo_file_src, 0x220, 0x6, 'BdAddress')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'BdAddress crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x228, 0x8, 'Reserved, Empty')
			data_getdatas(prodinfo_file_src, 0x230, 0x6, 'AccelerometerOffset')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'AccelerometerOffset crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x238, 0x6, 'AccelerometerScale')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'AccelerometerScale crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x240, 0x6, 'GyroscopeOffset')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'GyroscopeOffset crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x248, 0x6, 'GyroscopeScale')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x2, 0x0, 'GyroscopeScale crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x250, 0x18, 'SerialNumber')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x8, 0x6, 'SerialNumber crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x270, 0x30, 'EccP256DeviceKey, Device key (ECC-P256 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccP256DeviceKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x2b0, 0x180, 'EccP256DeviceCertificate, Device certificate (ECC-P256 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccP256DeviceCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x440, 0x30, 'EccB233DeviceKey, Device key (ECC-B233 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccB233DeviceKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x480, 0x180, 'EccB233DeviceCertificate, Device certificate (ECC-B233 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccB233DeviceCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x610, 0x30, 'EccP256ETicketKey, ETicket key (ECC-P256 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccP256ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x650, 0x180, 'EccP256ETicketCertificate, ETicket certificate (ECC-P256 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccP256ETicketCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x7e0, 0x30, 'EccB233ETicketKey, ETicket key (ECC-B233 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccB233ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x820, 0x180, 'EccB233ETicketCertificate, ETicket certificate (ECC-B233 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'EccB233ETicketCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x9b0, 0x110, 'SslKey, empty and unused')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'SslKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0xad0, 0x4, 'SslCertificateSize, Total size of the SSL certificate')
			prodinfo_ssl_certificate_size = int.from_bytes(prodinfo_datas[-1][4], byteorder='little')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'SslCertificateSize crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0xae0, 0x800, 'SslCertificate, Only SslCertificateSize bytes are used')
			sha256_getdatas(prodinfo_file_src, 0x12e0, 0x20, 'BodyHash, SHA256 hash calculated over calibration data', 0xae0, prodinfo_ssl_certificate_size)
			data_getdatas(prodinfo_file_src, 0x1300, 0x1000, 'RandomNumber, Random generated data')
			sha256_getdatas(prodinfo_file_src, 0x2300, 0x20, 'RandomNumberHash, SHA256 over the random data block', prodinfo_datas[-1][1], prodinfo_datas[-1][2])
			data_getdatas(prodinfo_file_src, 0x2320, 0x110, 'GameCardKey (empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'GameCardKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x2440, 0x400, 'GameCardCertificate')
			sha256_getdatas(prodinfo_file_src, 0x2840, 0x20, 'GameCardCertificateHash, SHA256 over the Gamecard certificate', prodinfo_datas[-1][1], prodinfo_datas[-1][2])
			data_getdatas(prodinfo_file_src, 0x2860, 0x220, 'Rsa2048ETicketKey, ETicket key (RSA-2048 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'Rsa2048ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x2a90, 0x240, 'Rsa2048ETicketCertificate, ETicket certificate (RSA-2048 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'Rsa2048ETicketCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x2ce0, 0x18, 'BatteryLot, Battery lot string ID')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x8, 0x6, 'BatteryLot crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x2d00, 0x800, 'SpeakerCalibrationValue, Speaker calibration values. Only 0x5A bytes are used')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'SpeakerCalibrationValue crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3510, 0x4, 'RegionCode, 0=JPN 1=USA 2=EUR 3=AUS 4=CHN 5=KOR 6=HKG')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'RegionCode crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3520, 0x50, 'AmiiboKey, Amiibo key (ECQV and ECDSA versions)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'AmiiboKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3580, 0x14, 'AmiiboEcqvCertificate, Amiibo certificate (ECQV version)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'AmiiboEcqvCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x35a0, 0x70, 'AmiiboEcdsaCertificate, Amiibo certificate (ECDSA version)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'AmiiboEcdsaCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3620, 0x40, 'AmiiboEcqvBlsKey, Amiibo key (ECQV-BLS version)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'AmiiboEcqvBlsKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3670, 0x20, 'AmiiboEcqvBlsCertificate, Amiibo certificate (ECQV-BLS version)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'AmiiboEcqvBlsCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x36a0, 0x90, 'AmiiboEcqvBlsRootCertificate, Amiibo root certificate (ECQV-BLS version)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'AmiiboEcqvBlsRootCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3740, 0x4, 'ProductModel, 0 = Invalid, 1 = Nx, 2 = Copper, 3 = Iowa, 4 = Hoag, 5 = Calcio, 6 = Aula')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'ProductModel crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3750, 0x6, 'HomeMenuSchemeMainColorVariation')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xa, 0x8, 'HomeMenuSchemeMainColorVariation crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3760, 0xc, 'LcdBacklightBrightnessMapping')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x4, 0x2, 'LcdBacklightBrightnessMapping crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3770, 0x50, 'ExtendedEccB233DeviceKey, Extended device key (ECC-B233 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedEccB233DeviceKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x37d0, 0x50, 'ExtendedEccP256ETicketKey, Extended ETicket key (ECC-P256 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedEccP256ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3830, 0x50, 'ExtendedEccB233ETicketKey, Extended ETicket key (ECC-B233 version; empty and unused)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedEccB233ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3890, 0x240, 'ExtendedRsa2048ETicketKey, Extended ETicket key (RSA-2048 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedRsa2048ETicketKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3ae0, 0x130, 'ExtendedSslKey, Extended SSL key (active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedSslKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3c20, 0x130, 'ExtendedGameCardKey, Extended Gamecard key (active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedGameCardKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3d60, 0x4, 'LcdVendorId')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'LcdVendorId crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3d70, 0x240, '[5.0.0+] ExtendedRsa2048DeviceKey, Extended device key (RSA-2048 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'ExtendedRsa2048DeviceKey crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x3fc0, 0x240, '[5.0.0+] Rsa2048DeviceCertificate, Device certificate (RSA-2048 version; active)')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x10, 0xe, 'Rsa2048DeviceCertificate crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4210, 0x1, '[5.0.0+] UsbTypeCPowerSourceCircuitVersion')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'UsbTypeCPowerSourceCircuitVersion crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4220, 0x4, '[9.0.0+] HomeMenuSchemeSubColor')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeSubColor crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4230, 0x4, '[9.0.0+] HomeMenuSchemeBezelColor')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeBezelColor crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4240, 0x4, '[9.0.0+] HomeMenuSchemeMainColor1')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeMainColor1 crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4250, 0x4, '[9.0.0+] HomeMenuSchemeMainColor2')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeMainColor2 crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4260, 0x4, '[9.0.0+] HomeMenuSchemeMainColor3')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeMainColor3 crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4270, 0x1, '[9.0.0+] AnalogStickModuleTypeL')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'AnalogStickModuleTypeL crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4280, 0x12, '[9.0.0+] AnalogStickModelParameterL')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xe, 'AnalogStickModelParameterL crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x42a0, 0x9, '[9.0.0+] AnalogStickFactoryCalibrationL')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x7, 0x5, 'AnalogStickFactoryCalibrationL crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x42b0, 0x1, '[9.0.0+] AnalogStickModuleTypeR')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'AnalogStickModuleTypeR crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x42c0, 0x12, '[9.0.0+] AnalogStickModelParameterR')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xe, 'AnalogStickModelParameterR crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x42e0, 0x9, '[9.0.0+] AnalogStickFactoryCalibrationR')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0x7, 0x5, 'AnalogStickFactoryCalibrationR crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x42f0, 0x1, '[9.0.0+] ConsoleSixAxisSensorModuleType')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'ConsoleSixAxisSensorModuleType crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4300, 0x6, '[9.0.0+] ConsoleSixAxisSensorHorizontalOffset')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xa, 0x8, 'ConsoleSixAxisSensorHorizontalOffset crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4310, 0x1, '[6.0.0+] BatteryVersion')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'BatteryVersion crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4320, 0x10, 'Reserved, Empty')
			data_getdatas(prodinfo_file_src, 0x4330, 0x4, '[9.0.0+] HomeMenuSchemeModel')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xc, 0xa, 'HomeMenuSchemeModel crc16', prodinfo_datas[-1][4])
			data_getdatas(prodinfo_file_src, 0x4340, 0x1, '[10.0.0+] ConsoleSixAxisSensorMountType')
			crc_getdatas(prodinfo_file_src, prodinfo_file_src.tell(), 0xf, 0xd, 'ConsoleSixAxisSensorMountType crc16', prodinfo_datas[-1][4])
			prodinfo_file_src.seek(0x4350)
			temp_info = prodinfo_file_src.read()
			prodinfo_datas.append(['data', 0x4350, 0x1, 'PRODINFO end', temp_info])
			prodinfo_file_src.close()
	except:
		print ('Le fichier "' + prodinfo_file_src_path + '" n\'existe pas.')
		raise
		return(101)
	return(0)

def get_prodinfo_infos(prodinfo_file_src_path, prodinfo_file_dest_path):
	try:
		with open(prodinfo_file_dest_path, 'w') as prodinfo_file_dest:
			for item in prodinfo_datas[0:-1]:
				if (item[0] == 'data'):
					prodinfo_file_dest.write(item[3] + " :\n")
					prodinfo_file_dest.write(str(binascii.hexlify(item[4]), 'utf-8') + "\n\n")
				elif (item[0] == 'crc'):
					prodinfo_file_dest.write(item[3] + " :\n")
					prodinfo_file_dest.write(str(binascii.hexlify(item[5]), 'utf-8') + "\n\n")
				elif (item[0] == 'sha256'):
					prodinfo_file_dest.write(item[3] + " :\n")
					prodinfo_file_dest.write(str(binascii.hexlify(item[4]), 'utf-8') + "\n\n")
			prodinfo_file_dest.close()
	except:
		print ('Le fichier "' + prodinfo_file_dest_path + '" n\'existe pas.')
		raise
		return(101)
	return(0)

def verif_prodinfo_hashes(prodinfo_file_src_path):
	hashes_errors = 0
	for item in prodinfo_datas[0:-1]:
		if (item[1] > prodinfo_offset_stop):
			continue
		if (prodinfo_version <= 0x7):
			if (item[1] >= 0x3d70):
				continue
		if (item[0] == 'crc'):
			if (item[5] != item[6]):
				hashes_errors += 1
			elif (item[0] == 'sha256'):
				if (item[4] != item[5]):
					hashes_errors += 1
			elif (item[0] == 'data'):
				continue
	if (hashes_errors != 0):
		print("Nombre d'erreurs de hashes trouvées: " + str(hashes_errors))
		return(1)
	else:
		print("Aucune erreur de hashes trouvée.")
		return(0)

def rewrite_prodinfo_hashes(prodinfo_file_src_path, prodinfo_file_dest_path):
	#verif_hashes = verif_prodinfo_hashes(prodinfo_file_src_path)
	#if (verif_hashes == 0):
		#return(200)
	try:
		with open(prodinfo_file_dest_path, 'wb+') as prodinfo_file_dest:
			filesize = 0x3fbc00
			prodinfo_file_dest.write(b'\0'*filesize)
			prodinfo_file_dest.seek(0)
			for item in prodinfo_datas[0:-1]:
				if (item[1] > prodinfo_offset_stop):
					continue
				if (prodinfo_version <= 0x7):
					if (item[1] >= 0x3d70):
						continue
				prodinfo_file_dest.seek(item[1])
				if (item[0] == 'data'):
					prodinfo_file_dest.write(item[4])
				elif (item[0] == 'crc'):
					prodinfo_file_dest.write(item[6])
				elif (item[0] == 'sha256'):
					prodinfo_file_dest.write(item[5])
			#prodinfo_file_dest.seek(0x4350)
			#prodinfo_file_dest.write(prodinfo_datas[-1][4])
			prodinfo_file_dest.seek(0x40)
			temp_info = prodinfo_file_dest.read(prodinfo_body_size)
			temp_sha256 = hashlib.sha256(temp_info).digest()
			prodinfo_file_dest.seek(0x20)
			prodinfo_file_dest.write(temp_sha256)
			prodinfo_file_dest.close()
	except:
		print ('Le fichier "' + prodinfo_file_dest_path + '" n\'existe pas.')
		raise
		return(101)
	return(0)

def help():
	print ('Utilisation:')
	print ()
	print ('prodinfo_rewrite.py -a Action -i chemin_fichier_source_PRODINFO -o chemin_fichier_destination_PRODINFO')
	print("\nAction peut être:")
	print("get_infos: Obtenir des infos détaillées sur un fichier PRODINFO dans un fichier texte.")
	print("rewrite_hashes: Réécrire les différents hashes (sha256 et crc_16) d'un fichier PRODINFO dans un nouveau fichier.")
	print("verif_hashes: Seulement vérifier les hashes du fichier source, le paramètre -o n'est donc pas requis.")
	return(0)

action = ''
if (len(sys.argv) == 1):
	help()
	sys.exit(0)
action_param = 0
input_param = 0
output_param = 0
for i in range(1,len(sys.argv), 2):
	currArg = sys.argv[i]
	if currArg.startswith('-h'):
		help()
		sys.exit(0)
	elif currArg.startswith('-a'):
		if (action_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		action = sys.argv[i+1]
		action_param = 1
		if (action == 'verif_hashes'):
			prodinfo_file_dest_path = ""
			output_param = 1
	elif currArg.startswith('-i'):
		if (input_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		prodinfo_file_src_path = os.path.abspath(sys.argv[i+1])
		input_param = 1
	elif currArg.startswith('-o'):
		if (output_param == 1):
			print('Erreur de saisie des arguments.\n')
			help()
			sys.exit(301)
		prodinfo_file_dest_path = os.path.abspath(sys.argv[i+1])
		output_param = 1
	else:
		print('Erreur de saisie des arguments.\n')
		help()
		sys.exit(301)
if (prodinfo_file_src_path == prodinfo_file_dest_path):
	print("Les chemins d'entrée et de sortie ne peuvent être les mêmes.\n")
	help()
	sys.exit(301)

read_prodinfo(prodinfo_file_src_path)
if (action == 'get_infos'):
	return_code = get_prodinfo_infos(prodinfo_file_src_path, prodinfo_file_dest_path)
elif (action == 'rewrite_hashes'):
	return_code = rewrite_prodinfo_hashes(prodinfo_file_src_path, prodinfo_file_dest_path)
elif (action == 'verif_hashes'):
	return_code = verif_prodinfo_hashes(prodinfo_file_src_path)
else:
	help()
	sys.exit(301)

# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
sys.exit(return_code)