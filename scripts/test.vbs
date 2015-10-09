FolderToZip = "D:\logs" 
zipFile = "D:\some.zip" 
set sa = CreateObject("Shell.Application") 
Set zip= sa.NameSpace(zipFile) 
Set Fol=sa.NameSpace(FolderToZip) 
zip.CopyHere(Fol.Items) 
WScript.Sleep 2000 