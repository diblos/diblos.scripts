' copy
Set fso = CreateObject("Scripting.FileSystemObject")
Set aFile = fso.CreateTextFile(".\output.dat", True)
aFile.WriteLine("1234")
Set aFile = fso.GetFile(".\output.dat")
aFile.Copy("./output.bak")

' alternate
fso.CopyFile "c:\mydir\*.*", "d:\backup\",TRUE

' copy folder
fso.CopyFolder "c:\mydir\*", "D:\backup\mydir\",TRUE
