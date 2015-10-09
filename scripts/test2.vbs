Option Explicit
Const FOF_SIMPLEPROGRESS = 256
Dim MySource, MyTarget, MyHex, MyBinary, i
Dim oShell, oCTF
Dim oFileSys
dim winShell
MySource = "d:\test\VPortSDKPLUS_ActiveX.exe"
MyTarget = "d:\test\FullFile.zip"
MyHex = Array(80, 75, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
For i = 0 To UBound(MyHex)
MyBinary = MyBinary & Chr(MyHex(i))
Next
Set oShell = CreateObject("WScript.Shell")
Set oFileSys = CreateObject("Scripting.FileSystemObject")
'Create the basis of a zip file.
   Set oCTF = oFileSys.CreateTextFile(MyTarget, True)
      oCTF.Write MyBinary
         oCTF.Close
            Set oCTF = Nothing
            'Add File to zip
               set winShell = createObject("shell.application")
                  winShell.namespace(MyTarget).CopyHere MySource
                  wScript.Sleep(5000) 
