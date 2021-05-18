Dim objShell,oExec
Const ForReading = 1, ForWriting = 2

sPath = Wscript.ScriptFullName
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(sPath)
sIniDir = objFSO.GetParentFolderName(objFile)

sNandInput = Wscript.Arguments.Item(0)
sKeysFile = Wscript.Arguments.Item(1)
sLetter = Wscript.Arguments.Item(2)
sPartition = Wscript.Arguments.Item(3)
Set objShell = wscript.createobject("wscript.shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set fichier = fso.OpenTextFile(Wscript.Arguments.Item(5), ForWriting,true)
oExec = objShell.Run(sIniDir & "\NxNandManager.exe -i """ & sNandInput & """ -keyset """ & sKeysFile & """ --mount -driveLetter=" & sLetter & " -part=" & sPartition & " -stdout_redirect """ & Wscript.Arguments.Item(4) & """ FORCE", 0, True)
'Set oExec = objShell.Exec(sIniDir & "\NxNandManager.exe -i """ & sNandInput & """ -keyset """ & sKeysFile & """ --mount -driveLetter=" & sLetter & " -part=" & sPartition & " -stdout_redirect """ & Wscript.Arguments.Item(4) & """ FORCE")

'fichier.WriteLine oExec.ProcessID
'Do While Not oExec.Stdout.atEndOfStream
	'fichier.WriteLine oExec.StdOut.ReadLine()
	'WScript.Sleep 10
'Loop 
'Do While oExec.Status = 0
	'fichier.WriteLine oExec.StdOut.ReadLine()
	'WScript.Sleep 100
'Loop
fichier.close()
fso.DeleteFile Wscript.Arguments.Item(4)
fso.DeleteFile Wscript.Arguments.Item(5)
WScript.Quit