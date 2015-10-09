Set fso = CreateObject("Scripting.FileSystemObject")
Set aFile = fso.GetFile(".\output.dat")
aFile.Delete
