Set fso = CreateObject("Scripting.FileSystemObject")
Set txt = fso.CreateTextFile("templogs\volume_free_space.txt", True)
Folder_Path = Wscript.Arguments.Item(0)
GetDriveInfo = fso.GetDriveName(Folder_Path)
get_drive_free_space = FSO.GetDrive(GetDriveInfo).FreeSpace
txt.WriteLine get_drive_free_space
txt.Close
Set fso = Nothing
WScript.Quit(0)