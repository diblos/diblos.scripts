Dim oFS     : Set oFS = CreateObject( "Scripting.FileSystemObject" )
    Dim sCurDir : sCurDir = oFS.GetAbsolutePathName( ".\" ) + "\"
    Dim sFina   : sFina   = "demo.SqLite2X"
    Dim nMxRec  : nMxRec  = 10
  
    Dim oCNCT   : Set oCNCT = CreateObject( "SqLite2X.SqLiteConnection" )
    oCNCT.ConnectToDb( sCurDir + sFina )
    WScript.Echo "connected to", sFina
    WScript.Echo "using .SqLite2X/SQLite Vers.", oCNCT.GetSqLiteDllVersionString()
  
    Dim sSQL, oRS, nRec, oFld, nFld
  
    sSQL = "DROP TABLE tblEasy"
    On Error Resume Next
    oCNCT.ExecSqlStatement sSQL
    If 0 <> Err.Number Then WScript.Echo "'" + sSQL + "' failed; ok if first time"
    On Error GoTo 0
  
    sSQL = Array(   "CREATE TABLE tblEasy ("     _
                  , "   ID INTEGER PRIMARY KEY"  _
                  , " , NAME VARCHAR( 40 )"      _
                  , ")"                          _
                )
    sSQL = Join( sSQL, " " )
    oCNCT.ExecSqlStatement sSQL
    WScript.Echo "table tblEasy created"
  
    For nRec = 1 To nMxRec
        sSQL = "INSERT INTO tblEasy VALUES( " & nRec & ", 'Name" & nRec & "' )"
        oCNCT.ExecSqlStatement sSQL
    Next
    WScript.Echo nMxRec, "records added (in an ineffient way)"
  
    sSQL    = "SELECT * FROM tblEasy"
    Set oRS = oCNCT.ExecSqlQuery( sSQL )
  If False Then
    For nRec = 1 To (nMxRec / 10 ) + 1
        WScript.Echo "----------", nRec
        For Each oFld In oRS.Fields
            WScript.Echo oFld.Name, oFld.Value
        Next
        oRS.MoveNext
    Next
    oCNCT.Close
  Else
    For nRec = 1 To oRS.GetRowCount - 1
        WScript.Echo "----------", nRec
        For nFld = 0 To oRS.GetColCount - 1
            WScript.Echo oRS.GetColName( nFld ), oRS.GetAsString( nFld, nRec )
        Next
    Next
  End If
  
    Set oCNCT = Nothing
  
