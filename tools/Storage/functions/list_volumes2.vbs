On Error resume next
Set fso = CreateObject("Scripting.FileSystemObject")
Set txt = fso.CreateTextFile("templogs\volumes_list.txt", True)
For Each drv in fso.Drives
		If drv.IsReady Then
			txt.WriteLine "Lettre volume=" & drv.DriveLetter & ";  Nom=" & drv.VolumeName & ";  System=" & drv.FileSystem & ";  Taille=" & drv.Totalsize/1024/1024 & " MO; type=" & drv.DriveType 
		End If
Next
txt.Close
fso.Dispose
fso.Close
Set fso = Nothing
WScript.Quit(0)