Function GetFileDlgEx(sIniDir,sFilter,sTitle) 
	Set oDlg = CreateObject("WScript.Shell").Exec("mshta.exe ""about:<object id=d classid=clsid:3050f4e1-98b5-11cf-bb82-00aa00bdce0b></object><script>moveTo(0,-9999);eval(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0).Read("&Len(sIniDir)+Len(sFilter)+Len(sTitle)+41&"));function window.onload(){var p=/[^\0]*/;new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(p.exec(d.object.openfiledlg(iniDir,null,filter,title)));close();}</script><hta:application showintaskbar=no />""") 
	oDlg.StdIn.Write "var iniDir='" & sIniDir & "';var filter='" & sFilter & "';var title='" & sTitle & "';" 
	GetFileDlgEx = oDlg.StdOut.ReadAll 
End Function

sIniDir = Wscript.Arguments.Item(0)
sFilter = Wscript.Arguments.Item(1)
sTitle = Wscript.Arguments.Item(2)
rep = GetFileDlgEx(Replace(sIniDir,"\","\\"),sFilter,sTitle) 
'MsgBox rep & vbcrlf & Len(rep)

Set objStream = CreateObject("ADODB.Stream" )
objStream.Open
objStream.Type = 2
objStream.Position = 0
objStream.Charset = "UTF-8"
objStream.WriteText rep
objStream.Position = 3
Set objStream2 = CreateObject("ADODB.Stream" )
objStream2.Open
objStream2.Type = 1
objStream.CopyTo objStream2
objStream2.SaveToFile Wscript.Arguments.Item(3), 2
objStream.Close
objStream2.Close

'Const ForReading = 1, ForWriting = 2
'Set fso = CreateObject("Scripting.FileSystemObject")
'Set fichier = fso.OpenTextFile(Wscript.Arguments.Item(3), ForWriting,true)
'fichier.write("" &rep)
'fichier.close()
WScript.Quit