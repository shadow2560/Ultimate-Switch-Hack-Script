Const RETURNONLYFSDIRS = &H1   
Set oShell = CreateObject("Shell.Application") 
Set oFolder = oShell.BrowseForFolder(&H0&, Wscript.Arguments.Item(1), RETURNONLYFSDIRS)
If oFolder is Nothing Then  
	rep = ""
Else 
	Set oFolderItem = oFolder.Self 
	rep = oFolderItem.path 
End If 

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
objStream2.SaveToFile Wscript.Arguments.Item(0), 2
objStream.Close
objStream2.Close

'Const ForReading = 1, ForWriting = 2
'Set fso = CreateObject("Scripting.FileSystemObject")
'Set fichier = fso.OpenTextFile(Wscript.Arguments.Item(0), ForWriting,true)
'fichier.write("" &rep)
'fichier.close()
  
Set oFolderItem = Nothing 
Set oFolder = Nothing 
Set oShell = Nothing
WScript.Quit