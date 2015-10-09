' move or rename
Set fso = CreateObject("Scripting.FileSystemObject")
Set aFile = fso.CreateTextFile(".\output.dat", True)
aFile.WriteLine("1234")
Set aFile = fso.GetFile(".\output.dat")
aFile.Move ".\output.ok"
