' script inspired by
' https://stackoverflow.com/questions/9346320/wmi-to-get-drive-letter-association-with-physical-drive-path-misses-cdroms
On Error resume next
Set fso = CreateObject("Scripting.FileSystemObject")
Set txt = fso.CreateTextFile("templogs\volumes_list.txt", True)
ComputerName = "."
Set wmiServices = GetObject _
    ("winmgmts:{impersonationLevel=Impersonate}!//" & ComputerName)
Set wmiDiskDrives = wmiServices.ExecQuery _
    ("SELECT DeviceID FROM Win32_DiskDrive")

For Each wmiDiskDrive In wmiDiskDrives
    strEscapedDeviceID = _
        Replace(wmiDiskDrive.DeviceID, "\", "\\", 1, -1, vbTextCompare)
    Set wmiDiskPartitions = wmiServices.ExecQuery _
        ("ASSOCIATORS OF {Win32_DiskDrive.DeviceID=""" & _
            strEscapedDeviceID & """} WHERE " & _
                "AssocClass = Win32_DiskDriveToDiskPartition")

    For Each wmiDiskPartition In wmiDiskPartitions
        Set wmiLogicalDisks = wmiServices.ExecQuery _
            ("ASSOCIATORS OF {Win32_DiskPartition.DeviceID=""" & _
                wmiDiskPartition.DeviceID & """} WHERE " & _
                    "AssocClass = Win32_LogicalDiskToPartition")

        For Each wmiLogicalDisk In wmiLogicalDisks
            txt.WriteLine  wmiLogicalDisk.DeviceID & " = " & wmiDiskDrive.DeviceID
        Next
    Next
Next
txt.Close
fso.Dispose
fso.Close
Set fso = Nothing
WScript.Quit(0)