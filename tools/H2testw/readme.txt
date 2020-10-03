H2testw -- by Harald Bögeholz / c't Magazin für Computertechnik
Data integrity test for USB sticks and other media
Version 1.4, Copyright (C) 2008 Heise Zeitschriften Verlag GmbH & Co. KG
========================================================================

H2testw was developed to test USB sticks for various kinds of errors.
It can also be used for any other storage media like memory cards,
internal and external hard drives and even network volumes.

The executable file H2testw.exe needs no installation and can be
directly run. It was developed for Windows XP and Vista. It should
also work under Windows 2000 but was only tested on XP and Vista.
Windows 9x/ME is not supported. You can use the older command line
program H2test under these operating systems.

The function of H2testw is quite simple: It fills the chosen target
directory with test data and then reads it back and verifies it.

H2testw does not overwrite or erase any existing data. It doesn't
do any low-level tricks so administrator privileges are not required.
If your hardware is working properly H2testw will not harm any
existing data.

BUT: _If_ the hardware is defective then H2testw is designed to find
that defect and might as a side effect damage existing files.
Therefore: IF YOU SUSPECT A USB STICK OR OTHER STORAGE MEDIA TO BE
DEFECTIVE, EMPTY IT AND TEST IT COMPLETELY WITH H2TESTW. Only empty
media can be fully tested with H2testw. In order to be able to
reproduce the results we recommend to format the media (quick format
will do) and then test it.

H2testw writes files of up to 1 GByte to the chosen destination and
names them 1.h2w, 2.h2w, 3.h2w and so on. If the target directory
alread contains such a set of files H2testw will offer to verify them.
If there are any other files named *.h2w it will refuse to work. In
that case please erase all files *.h2w and hit the Refresh button.

After it is done the software leaves its test files on the medium.
You can erase them if you like or verify them again -- if it's a USB
stick for instance with another PC.

The check box "endless verify" does just that: It puts the verify
routine in an endless loop that stops only if an error is found. This
is meant to be used as a long-time test to find sporadic data transfer
errors.

A remark on the estimated time remaining: For intact flash memory the
estimate should be pretty exact since it has a constant data rate.
With defective media we have seen massive drops in the transfer rate
resulting in the estimate increasing instead of decreasing. Hard
drives are slower on the inner tracks than on the outer tracks so when
testing a hard drive the estimate is never precise.

If you have any questions or suggestions for H2testw please send an
email to Harald Bögeholz <hwb@heise.de> (in German or English).


What to do in case of errors
----------------------------

If H2benchw finds errors while verifying the data it means that the
media has not returned all data exactly as it was written. It is
likely that the media is defective, but there are other possible
causes for data corruption. In case of error you should therefore
repeat the test and

* Format the media immediately before testing

* Don't use USB extension cords

* If testing USB or FireWire devices, try a different port (sometimes
  USB ports at the back of the PC are better than those at the front)

* For exteral drives try another cable if possible


Error messages
--------------

When the verifying process detects any errors it outputs some
statistics differentiating the various error types:

* sectors that have been overwritten by others due to addressing
  errors (see above)

* sectors that have been altered only slightly (less than 8 differing
  bits per sector)

* completely corrupted sectors.

In the case of overwritten sectors H2testw tries to find out how much
real memory exists in the overwritten area and outputs that amount as
"aliased memory" (no guarantee here).

Finally it outputs the offset of the first error with regard to the
total amount of test data along with the expected and found value at
that offset.

Hint: You can copy&paste the error message, for instance to send it in
an email.


Typical errors
--------------

The test data of H2testw is made up so as to be able to discern
certain typical errors. There are three types:

* Addressing errors: When writing a sector its contents are not
  written to the correct address but overwrite another sector. We have
  seen this error on certain manipulated USB sticks. It also happens
  if you use a hard drive larger than 128 GByte on a machine whose
  BIOS or OS doesn't know about 48-bit addressing. In this case all
  addresses are taken modulo 128 GByte. When crossing the 128 GByte
  boundary you overwrite data at the beginning of the drive.

* Data is not saved at all. We have encountered this with defective
  USB sticks. Instead of the data written to it a sector returns only
  ones or zeroes when reading it. This is typical when accessing
  nonexisting memory.

* Only few bits of data are changed. That might happen if the
  connection between the PC and the storage media is faulty.


Technical details about the test data
-------------------------------------

H2testw writes data in chunks of 1 megabyte. So even if you choose to
completely fill the media you will end up with up to 1 megabyte of
free space. Although technically not correct H2testw uses the
Windows convention that 1 MByte equals 1024 KByte or 1,048,576 Byte.
In order to avoid problems with the 4 GByte limitation of the FAT file
system, H2testw begins a new data file after each gigabyte (1024
MByte).

Inside a data file each 512-byte sector begins with a 64-bit word (8
byte) containing the offset with regard to the whole data set. It is
stored in little-endian format, least significant byte first.

So the file 1.h2w begins with 

00 00 00 00 00 00 00 00,

the next sector with

00 02 00 00 00 00 00 00,

the next with

00 04 00 00 00 00 00 00

and so on. The file 2.h2w begins with

00 00 00 40 00 00 00 00

(offset 1 GByte = 0x40000000).

The rest of each sector is filled with a pseudo random number
sequence using the offset word as a seed.
