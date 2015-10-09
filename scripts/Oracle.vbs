'#####================================================================================
'## Title: QueryOracleDatabase.vbs
'## Author: Eric Payne (Berbee Information Networks)
'## Date: 3/6/2007
'##
'## Purpose: Querys Oracle database to verify records can be returned (Poor Mans monitoring).
'##         If records are returned from a simple SQL query then the database is considered
'##         up and running.
'##
'## Prerequisites:
'##         1. Oracle System DSN to Oracle database
'##         2. Permission to query Oracle database
'##
'## Requirements:
'##         1. Parameter: /Query: A SQL Query to perform on database to return records
'##         2. Parameter: /DSN: A Oracle System DSN to database
'##         3. Parameter: /UserID: UserID for DSN
'##         4. Parameter: /Password: Password for DSN
'##
'## Execution:
'##     cscript //nologo QueryOracleDatabase.vbs /Query:"Select * from Table_Name;"
'##    /DSN:Oracle_DSN /UserID:XXXX /Password:XXXX
'##
'## Basic Logic:
'##         1. Read in Parameters
'##         2. Attempts to open strDSN
'##         3. Attempts to run strQuery
'##         4. Outputs results
'#####================================================================================

 Option Explicit
 On Error Resume Next

  'Arguments

   Dim objArgs: Set objArgs = WScript.Arguments
   if objArgs.Named.Exists("Query") Then
         Dim strSQLQuery: strSQLQuery = objARgs.Named("Query")
         Else
               WScript.Echo "Missing /Query parameter"
                     WScript.Quit
                     End if

                      if objArgs.Named.Exists("DSN") Then
                            Dim strDSN: strDSN = objArgs.Named("DSN")
                            Else
                                  WScript.Echo "Missing /DSN parameter"
                                        WScript.Quit
                                        End if

                                         if objArgs.Named.Exists("UserID") Then
                                               Dim strUserID: strUserID = objArgs.Named("UserID")
                                               Else
                                                     WScript.Echo "Missing /UserID parameter"
                                                           WScript.Quit
                                                           End if

                                                            if objArgs.Named.Exists("Password") Then
                                                                  Dim strPassword: strPassword = objArgs.Named("Password")
                                                                  Else
                                                                        WScript.Echo "Missing /password parameter"
                                                                              WScript.Quit
                                                                              End if

                                                                               'Query

                                                                                WScript.Echo vbnewline & "QUERYING ORACLE DATABASE"
                                                                                if QueryOracleDatabase(strSQLQuery,strDSN, strUserID, strPassword) Then
                                                                                      WScript.Echo "  - " & strSQLQuery & " returned records"
                                                                                      Else
                                                                                            Wscript.Echo "  - " & strSQLQuery & " returned 0 records"
                                                                                            End if


                                                                                              Function QueryOracleDatabase(strSQLQuery, strDSN, strUserID, strPassword)
                                                                                                    'Desc: Query database to see if it responds
                                                                                                          On Error Resume Next

                                                                                                                 Dim ADODBConnection: Set ADODBConnection = CreateObject("ADODB.Connection")
                                                                                                                       Const adUseClient = 3
                                                                                                                             ADODBConnection.CursorLocation = adUseClient
                                                                                                                                   ADODBConnection.ConnectionTimeout = 300

                                                                                                                                          Dim strConnection: strConnection = "Provider=OraOLEDB.Oracle;Data Source=" & strDSN & _
                                                                                                                                                    ";User ID=" & strUserID & ";Password=" & strPassword & ";"

                                                                                                                                                           ADODBConnection.Open strConnection
                                                                                                                                                                 if err <> 0 then
                                                                                                                                                                             WScript.Echo "An error occurred trying to open Oracle System DSN: " & strDSN & " " & _
                                                                                                                                                                                             err.number & " " & err.description & " " & err.Source
                                                                                                                                                                                                         WScript.Quit
                                                                                                                                                                                                               End if


                                                                                                                                                                                                                       Dim ADODBRecordSet: Set ADODBRecordSet = ADODBConnection.Execute(strSQLQuery)
                                                                                                                                                                                                                             if err <> 0 then
                                                                                                                                                                                                                                         WScript.Echo "An error occurred trying to execute query: " & strSQLQuery & _
                                                                                                                                                                                                                                                         " on Oracle System DSN: " & strDSN & " " & err.number & " " & err.description & " " & err.Source
                                                                                                                                                                                                                                                                     WScript.Quit
                                                                                                                                                                                                                                                                           End if


                                                                                                                                                                                                                                                                                   Dim bolRecordsReturned: bolRecordsReturned = vbFalse
                                                                                                                                                                                                                                                                                         if ADODBRecordSet.RecordCount > 0 Then
                                                                                                                                                                                                                                                                                                     QueryOracleDatabase = vbTrue
                                                                                                                                                                                                                                                                                                           Else
                                                                                                                                                                                                                                                                                                                       QueryOracleDatabase = vbFalse
                                                                                                                                                                                                                                                                                                                             End if

                                                                                                                                                                                                                                                                                                                                    ADODBConnection.Close
                                                                                                                                                                                                                                                                                                                                          Set ADODBRecordSet = Nothing
                                                                                                                                                                                                                                                                                                                                                Set ADODBConnection = Nothing

                                                                                                                                                                                                                                                                                                                                                 End Function 
