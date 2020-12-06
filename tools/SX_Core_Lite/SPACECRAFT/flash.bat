@BootloaderUpdater.exe bootloader.bin
@timeout /t 15 /nobreak > NUL
@FirmwareUpdater.exe firmware.bin
@pause