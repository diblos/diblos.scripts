On Error Resume Next 
 
'strComputer = "."
strComputer = "ITAC-P023"
 
'Set objWMIService = GetObject("winmgmts:" _
'    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
 
Dim sDBUser
Dim sDBPwd
Dim sDBServer
Dim sDBName
 
sDBUser = "sa"
sDBPwd = "123qwe"
sDBServer = ".\llm2"
sDBName = "LLMWEB"
'backupPath = "C:\Test\"
backupPath = "D:\misc\"
 
Set oSQLServer = CreateObject("SQLDMO.SQLServer")
Set oBackup = CreateObject("SQLDMO.Backup")
 
oSQLServer.LoginTimeout = 30
oSQLServer.LoginSecure = True
'oSQLServer.Connect sDBServer
oSQLServer.Connect sDBServer, sDBUser, sDBPwd
 
oBackUp.Initialize = "TRUE" ' Means overwrite existing .bak file. 
oBackup.Database = sDBName
oBackup.Action = SQLDMOBackup_Database
oBackup.Files = backupPath & sDBName & ".bak"
oBackup.SQLBackup oSQLServer
 
oSQLServer.Close()

'====================
'oRestore.Files = “C:\Temp\dbname.bak”
'oRestore.Database = sDBName
'oRestore.Action = SQLDMORestore_Database
'oRestore.ReplaceDatabase = True
'oRestore.SQLRestore sql