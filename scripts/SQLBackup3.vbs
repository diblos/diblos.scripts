'Here is a scaled down version of a script I use to back up all of the databases on the server and zip up the back up files. 
'I've taken out the zip and ftp code since you likely have your own components for this purpose. 

Function ZipAllSites() 

dim sZipPath 
dim sDBName 
dim sDBUser 
dim sDBPwd 

'sZipPath = "C:\TEMP" 
sZipPath = "D:\misc" 
'sDBName = "NORTHWIND" 
sDBName = "LLMWEB" 
sDBUser ="sa" 
sDBPwd = "123qwe" 

REM ZipDBFiles sDBUser,sDBPwd,sDBName, sZipPath '& "\my back up folder for this DB\" 
ZipDBFiles sDBUser,sDBPwd,sDBName, sZipPath
end function 


Function ZipDBFiles(sDBUser,sDBPwd,sDBName,sZipFilePath) 

Dim oSQLServer 
Dim oSQLBackUp 
Dim oFS 
Dim sDate 
Dim sFileName 


on error resume next 

sDate = "Day" & cstr(day(date)) 

sFileName = sZipFilePath & "Site" & sDate & sDBNAME & ".zip" 

Set oSQLServer = CreateObject("SQLDMO.SQLServer") 
Set oSQLBackUp = CreateObject("SQLDMO.BackUp") 

oSQLServer.Connect "(local)", sDBUser, sDBPwd 
oSQLBackUp.BackupSetName = "BackUp " & sDBName 
oSQLBackUp.Database = sDBName 
oSQLBackUp.Action = "0" 
oSQLBackUp.BackupSetDescription = "BackUp " & sDBName 
oSQLBackUp.Files = sZipFilePath & sDBNAME & ".bak" 
oSQLBackUp.TruncateLog = "3" 
oSQLBackUp.Initialize = "TRUE" ' Means overwrite existing .bak file. 
oSQLBackUp.SQLBackup oSQLServer 
oSQLServer.Disconnect 

Set oSQLBackUp = nothing 
Set oSQLServer = nothing 

' Zip component code goes here and use the variable 
' sFileName to name your zip file. 


Set oFS = CreateObject("Scripting.FileSystemObject") 

' Remove the temporary back up file after zip has complete. 

'oFS.DeleteFile sZipFilePath & sDBNAME & ".bak" ,true 

Set oFS = nothing 

ZipDBFiles = 1 

end function 

Call ZipAllSites()