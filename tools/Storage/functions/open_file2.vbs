Option Explicit
Dim fso, shell, exePath
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

exePath = fso.GetParentFolderName(WScript.ScriptFullName) & "\openhelper.exe"
Dim BASE64_EXE
If Not fso.FileExists(exePath) Then
    BASE64_EXE = CleanBase64(ReadFileToString(fso.GetParentFolderName(WScript.ScriptFullName) & "\openhelper.b64"))
End If

If Not fso.FileExists(exePath) Then
    If Len(BASE64_EXE) = 0 Then
        WScript.Echo "vbs_openhelper.exe not found and no embedded EXE."
        WScript.Quit 1
    Else
        DecodeBase64ToFile BASE64_EXE, exePath
    End If
End If

Dim sIniDir, sFilter, sTitle, outFile, cmd, exec, out
sIniDir = WScript.Arguments.Item(0)
sFilter = WScript.Arguments.Item(1)
sTitle  = WScript.Arguments.Item(2)
outFile = WScript.Arguments.Item(3)

cmd = Chr(34) & exePath & Chr(34) & " file " & _
      Chr(34) & sIniDir & Chr(34) & " " & _
      Chr(34) & sFilter & Chr(34) & " " & _
      Chr(34) & sTitle & Chr(34)

Set exec = shell.Exec(cmd)
out = exec.StdOut.ReadAll
out = Trim(out)

' Write in windows-1252 (ANSI) directly
Dim f, ts
Set f = CreateObject("Scripting.FileSystemObject")
Set ts = f.CreateTextFile(outFile, True, False) ' False => ASCII (system ANSI)
ts.Write out
ts.Close
WScript.Quit 0

Sub DecodeBase64ToFile(b64, target)
    Dim xml, node
    Set xml = CreateObject("Msxml2.DOMDocument.6.0")
    Set node = xml.createElement("b64")
    node.dataType = "bin.base64"
    node.text = b64
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write node.nodeTypedValue
    stream.SaveToFile target, 2
    stream.Close
End Sub

Function CleanBase64(s)
    Dim re
    Set re = New RegExp
    re.Pattern = "[^A-Za-z0-9+/=]"
    re.Global = True
    CleanBase64 = re.Replace(s, "")
End Function

Function ReadFileToString(filename)
    Dim fso, f
    Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FileExists(filename) Then
        ReadFileToString = ""
        Exit Function
    End If
    Set f = fso.OpenTextFile(filename, 1, False) ' ForReading
    ReadFileToString = f.ReadAll
    f.Close
End Function
