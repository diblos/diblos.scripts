''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Oracle automated full backup
'' Written by: Andrew Levine   March, 2009
'' 
'' This script performs the following steps:
'' 
'' 1. Creates .par file for use by oracle export (expdp.exe)
'' 2. Cleans up old export files (deletes -old file, renames current backup to -old)
'' 3. Performs oracle export
'' 4. Compresses oracle export (.dmp file) to .zip file
'' 5. Sends .zip file to specified FTP server
'' 6. Deletes .zip file if FTP upload was successful
'' 7. Appends results to .log file, emails results to specified addresses
''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Set oShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set WshNetwork = WScript.CreateObject("WScript.Network")
Const ForReading = 1, ForWriting = 2, ForAppending = 8,  FailIfNotExist = 0, OpenAsDefault = -2
Const NonFatalError = 0, FatalError = 1
Dim overallErrorState
Dim logOutput
Dim actionData
Dim workingDir
Dim errors

overallErrorState = 0

serverName = WshNetwork.ComputerName

Function fixNum (x)
    If Len(x) = 1 Then
        x = "0" & x
    End If
    fixNum = x
End Function

Function getFormattedDate
    getFormattedDate = Year(Date) & "-" & fixNum (Month(Date)) & "-"& fixNum (Day(Date))
End Function

Function getLogHeader 
    logTime = FormatDateTime(Now(),3) 
    If Len(logTime) < 11 Then 
        logTime = " " & logTime
    End If
    getLogHeader = vbCrLf  &  " " & getFormattedDate & " " & logTime & "   "
End Function

Function checkForErrors (action, actionData, errorState, isFatal)
    If errorState = 0 Then
        logOutput = logOutput & getLogHeader & action & actionData & " successful."
    ElseIf errorState = 1 Then
            If isFatal = 1 Then
                logOutput = logOutput & getLogHeader & "FATAL ERROR: " & action & actionData  & " failed! SCRIPT ABORTING!!!"
                overallErrorState = 2
                writeLog
            Else
                overallErrorState = 1
                logOutput = logOutput & getLogHeader & "WARNING: " & action & actionData  & " failed!"
            End If
    End If
    errors = 0
End Function


Function writeLog
        'Write Log file
        logOutput = logOutput &  vbCrLf  & String (115, "=")
        Set objTextFile = objFSO.OpenTextFile (logDir & serverName & "_vbs_backup.log", ForAppending, True)
            objTextFile.WriteLine(logOutput)
        objTextFile.Close
        Set objTextFile = Nothing

        'send Email Notification
        REM emailAddress = "email1@mycompany.com,email2@mycompany.com"
        REM smtpServer = "192.168.1.11"

        REM If overallErrorState = 0 Then 
            REM subjectLine = serverName & " Oracle backup completed successfully."
        REM ElseIf overallErrorState = 1 Then
            REM subjectLine = serverName & " Oracle backup completed with warnings. Please review logfile."
        REM Else 
            REM subjectLine = serverName & " Oracle backup aborted with a fatal error! Please review logfile."
        REM End If

        REM Set objEmail = CreateObject("CDO.Message")
        REM objEmail.From = serverName & "_Oracle_Export"
        REM objEmail.To = emailAddress
        REM objEmail.Subject = subjectLine
        REM objEmail.Textbody = logOutput & vbCrLf & vbCrLf & "This script (" & Wscript.ScriptFullName & ") was run on " & serverName & "." & vbCrLf & vbCrLf & "To view or modify this job, go to Control Panel-->Scheduled Tasks."
        REM objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
        REM objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
        REM objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
        REM objEmail.Configuration.Fields.Update
        REM objEmail.Send
        
        'clean up memory
        Set oShell = Nothing
        Set objFSO = Nothing
        Set WshNetwork = Nothing
        Set objEmail = Nothing
        
        WScript.quit
End Function

logOutput = logOutput &  vbCrLf  & String (115, "=")
logOutput = logOutput & getLogHeader & Wscript.ScriptFullName & " started on " & serverName & "."

workingDir = "D:\misc\test_ora\nightlybckp\"'"H:\ora-dba\NightlyBackup\"
parfileDir = "D:\misc\test_ora\parfile\"'"H:\ora-dba\parfiles\"
exportDir = "D:\misc\test_ora\exp\"'"H:\ora-dba\exports\"
logDir = "D:\misc\test_ora\logs\"'"H:\ora-dba\logs\"

shortDate = Year(Date) & fixNum (Month(Date)) & fixNum (Day(Date))

'create par file
parFilename = serverName & "_expfull.par"
dumpFilePrefix = serverName & "_FULLEXPORT"
dumpFileSuffix = ".DMP"
parDateTime = getFormattedDate & "_" & Int(Timer)
'parOutput = "Directory=data_pump_dir" & vbCrLf & "dumpfile=" & dumpFilePrefix & dumpFileSuffix & vbCrLf & "Logfile=log_file_dir:" & dumpFilePrefix & ".log" & vbCrLf & "Job_name=" & serverName & "_" & parDateTime & "_auto_full_export" & vbCrLf & "Full=y" & vbCrLf & "PARALLEL=3"
'''
parOutput = "Directory=data_pump_dir" & vbCrLf & "dumpfile=" & dumpFilePrefix & dumpFileSuffix & vbCrLf & "Logfile=log_file_dir:" & dumpFilePrefix & ".log" & vbCrLf & "Job_name=" & serverName & "_" & parDateTime & "_auto_partial_export" & vbCrLf & "SCHEMAS=vjf01" & vbCrLf & "PARALLEL=3"
Set objTextFile = objFSO.OpenTextFile (parfileDir & parFilename, ForWriting, True)
errors = objTextFile.WriteLine(parOutput)
objTextFile.Close
Set objTextFile = Nothing
checkForErrors "Creation of ", parfileDir & parFilename, errors, FatalError

'clean up old export files
On Error Resume Next
    objFSO.DeleteFile(exportDir & dumpFilePrefix & "-OLD" & dumpFileSuffix)
On Error GoTo 0
If objFSO.FileExists(exportDir & dumpFilePrefix & "-OLD" & dumpFileSuffix) Then
        errors = 1
End If
checkForErrors "Delete of oldest dump file ", dumpFilePrefix & "-OLD" & dumpFileSuffix, errors, NonFatalError

If objFSO.FileExists(exportDir & dumpFilePrefix & dumpFileSuffix) Then
    On Error Resume Next    
        objFSO.MoveFile exportDir & dumpFilePrefix & dumpFileSuffix, exportDir & dumpFilePrefix & "-OLD" & dumpFileSuffix
    On Error GoTo 0
End If
If Not objFSO.FileExists(exportDir & dumpFilePrefix & "-OLD" & dumpFileSuffix) Then
    errors = 1
End If
checkForErrors "Rename of previous dump file to '-old'",null,errors, NonFatalError

If objFSO.FileExists(exportDir & dumpFilePrefix & dumpFileSuffix) Then
    errors = 1
    checkForErrors dumpFilePrefix & dumpFileSuffix & " exists. Cannot perform Oracle Export.", null,errors, FatalError
End If    

'perform oracle export
'exportCmd = "C:\oracle\product\10.2.0\db_1\bin\expdp.exe user/password@server parfile=" & parfileDir & parFilename
exportCmd = "C:\oraclexe\app\oracle\product\10.2.0\server\BIN\expdp.exe test/test@xe parfile=" & parfileDir & parFilename
logOutput = logOutput & getLogHeader & "About to start Oracle export."
errors = oShell.Run (exportCmd, 0, 1)
checkForErrors "Oracle export",null,errors, FatalError

'Zip oracle export file
REM zippath = ".\izarc\IZARCC.exe"
REM fileToZip =  dumpFilePrefix & dumpFileSuffix
REM zipFileName = dumpFilePrefix & "_" & shortdate &".zip"
REM zipCmd = zipPath & " -a -cx -$"& exportDir & " " & exportDir & zipFileName & " " & exportDir & fileToZip
REM logOutput = logOutput & getLogHeader & "About to compress export to: " & zipFileName & "."
REM errors = oShell.Run (zipCmd, 0, 1)
REM checkForErrors "Creation of ",zipFileName, errors, FatalError

'Create text file instructions for ftp upload
REM ftpServer = "192.168.1.5"
REM ftpFilename = workingDir & ftpServer & "_ftp.txt"
REM ftpUser = "username"
REM ftpPassword = "password"
REM ftpFolder = "oracle_dmp"
REM ftpLogFile = logDir & servername & "_" & ftpServer & "_ftp.log"
REM ftpFileOutput = "open " & ftpServer & vbCrLf & ftpUser & vbCrLf & ftpPassword & vbCrLf & "cd " & ftpFolder  & vbCrLf & "put " & exportDir & zipFileName & vbCrlf & "quit"
REM Set objTextFile = objFSO.OpenTextFile (ftpFilename, ForWriting, True)
REM errors = objTextFile.WriteLine(ftpFileOutput)
REM objTextFile.Close
REM Set objTextFile = Nothing
REM checkForErrors "Creation of FTP instructions ",ftpFilename,errors, FatalError

'Send file via ftp and export results to ftp log file
REM ftpCmd = "%comspec% /c ftp.exe -s:" & ftpFilename & " > " & ftpLogFile
REM logOutput = logOutput & getLogHeader & "Starting FTP Upload to " & ftpServer & "."
REM errors = oShell.Run (ftpCmd, 0, 1)
REM 'check to see if FTP.exe terminated properly
REM If errors <> 0 Then
    REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP.exe errored out attempting to upload " & zipFileName & " to " & ftpServer & ". SCRIPT ABORTING!!!"
    REM overallErrorState = 1
    REM writeLog
REM Else
    REM 'Parse FTP log for error/success messages
    REM Set objTextFile = objFSO.OpenTextFile (ftpLogFile, ForReading, FailIfNotExist, OpenAsDefault)
    REM ftpResult = objTextFile.ReadAll
    REM objTextFile.close
    REM Set objTextFile = Nothing
    
    REM If InStr(ftpResult, "226 Transfer complete.") > 0 Then
        REM logOutput = logOutput & getLogHeader & "Uploaded " & zipFileName & " to " & ftpServer & "."
        REM logOutput = logOutput & getLogHeader & "About to delete " & zipFileName & "."
        REM On Error Resume Next
            REM objFSO.DeleteFile(exportDir & zipFileName)
        REM On Error GoTo 0
      REM ElseIf InStr(ftpResult, "File not found") > 0 Then
           REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP Error: File Not Found. SCRIPT ABORTING!!!"
           REM overallErrorState = 2
           REM writeLog
    REM ElseIf InStr(ftpResult, "cannot log in.") > 0 Then
        REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP Error: Login Failed. SCRIPT ABORTING!!!"
        REM overallErrorState = 2
        REM writeLog
    REM ElseIf InStr(ftpResult, "Access is denied.") > 0 Then
        REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP Error: Access is denied. SCRIPT ABORTING!!!"
        REM overallErrorState = 2
        REM writeLog
    REM ElseIf InStr(ftpResult, "Unknown host") > 0 Then
        REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP Error: Unknown host. (Could not see FTP server.) SCRIPT ABORTING!!!"
        REM overallErrorState = 2
        REM writeLog
    REM Else
        REM logOutput = logOutput & getLogHeader & "Fatal Error! FTP Error: Unknown. SCRIPT ABORTING!!!"
        REM overallErrorState = 1
        REM writeLog
    REM End If
REM End If
 
If objFSO.FileExists(zipFileName) Then
        logOutput = logOutput & getLogHeader & zipFileName & " not deleted from " & serverName & "."
        overallErrorState = 1
Else
        logOutput = logOutput & getLogHeader & "Successfully deleted " & zipFileName & " from " & serverName & "."
End If

If overallErrorState = 0 Then 
    logOutput = logOutput & getLogHeader & "Script completed successfully!"
ElseIf overallErrorState = 1 Then
    logOutput = logOutput & getLogHeader & "Script completed WITH WARNINGS."
End If

writeLog