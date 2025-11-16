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

Dim outFile, title, initDir, cmd, exec, out
outFile = WScript.Arguments.Item(0)
title   = WScript.Arguments.Item(1)

initDir = GetArgOrDefault(2, "")
' If WScript.Arguments.Count > 2 Then
    ' initDir = WScript.Arguments.Item(2)
' Else
    ' initDir = ""
' End If

cmd = Chr(34) & exePath & Chr(34) & " folder " & _
      Chr(34) & initDir & Chr(34) & " " & _
      Chr(34) & title & Chr(34)

Set exec = shell.Exec(cmd)
out = exec.StdOut.ReadAll
out = Trim(out)

' Write UTF-8
Dim s1, s2
Set s1 = CreateObject("ADODB.Stream")
s1.Type = 2
s1.Charset = "UTF-8"
s1.Open
s1.WriteText out

Set s2 = CreateObject("ADODB.Stream")
s2.Type = 1
s2.Open
s1.Position = 0
s1.CopyTo s2
s2.SaveToFile outFile, 2
s1.Close
s2.Close

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

Function GetArgOrDefault(idx, defaultVal)
    If WScript.Arguments.Count > idx Then
        GetArgOrDefault = WScript.Arguments.Item(idx)
    Else
        GetArgOrDefault = defaultVal
    End If
End Function
