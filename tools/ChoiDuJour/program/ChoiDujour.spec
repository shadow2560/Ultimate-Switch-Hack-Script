# -*- mode: python -*-

block_cipher = None

binaries_added_files = [
	('*.dll', '.'),
	('*.exe', '.')
]

a = Analysis(['ChoiDujour.py'],
             pathex=['F:\\0\\dev_projects\\Ultimate-Switch-Hack-Script\\tools\\ChoiDuJour\\program'],
             binaries=binaries_added_files,
             datas=[],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='ChoiDujour',
          debug=False,
          strip=False,
          upx=True,
          runtime_tmpdir=None,
          console=True , manifest='ChoiDujour.exe.manifest')
