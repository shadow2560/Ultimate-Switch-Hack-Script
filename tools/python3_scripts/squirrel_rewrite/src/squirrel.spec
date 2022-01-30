# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['squirrel.py'],
             pathex=['E:\\dev\\dev_projects\\Ultimate-Switch-Hack-Script\\tools\\Saturn_emu_inject\\test\\ztools', '_bottle_websocket_', '_bottle_websocket_\\*.py', '_EEL_', '_EEL_\\*.py', 'lib', 'lib\\*.py', 'nutFs', 'nutFs\\*.py', 'Fs', 'Fs\\*.py', 'manager', 'manager\*.py', 'mtp', 'mtp\\*.py', 'Drive', 'Drive\\*.py'],
             binaries=[],
             datas=[],
             hiddenimports=[],
             hookspath=[],
             hooksconfig={},
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)

exe = EXE(pyz,
          a.scripts, 
          [],
          exclude_binaries=True,
          name='squirrel',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=True,
          disable_windowed_traceback=False,
          target_arch=None,
          codesign_identity=None,
          entitlements_file=None )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas, 
               strip=False,
               upx=True,
               upx_exclude=[],
               name='squirrel')
