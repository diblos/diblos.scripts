 Dim oCS     : oCS       = "Driver={SQLite3 ODBC Driver};Database=@FSPEC@;StepAPI=;Timeout="
    Dim oCNCT   : Set oCNCT = CreateObject( "ADODB.Connection" )
  
    oCS = Replace( oCS, "@FSPEC@", sCurDir + sFina )
    oCNCT.Open oCS
    WScript.Echo "connected to", sFina
  
    Dim sSQL, oRS, nRec, oFld
  
    sSQL = "DROP TABLE tblEasy"
    On Error Resume Next
    oCNCT.Execute sSQL
    If 0 <> Err.Number Then WScript.Echo "'" + sSQL + "' failed; ok if first time"
    On Error GoTo 0
  
    sSQL = Array(   "CREATE TABLE tblEasy ("     _
                  , "   ID INTEGER PRIMARY KEY"  _
                  , " , NAME VARCHAR( 40 )"      _
                  , ")"                          _
                )
    sSQL = Join( sSQL, " " )
    oCNCT.Execute sSQL
    WScript.Echo "table tblEasy created"
  
    For nRec = 1 To nMxRec
        sSQL = "INSERT INTO tblEasy VALUES( " & nRec & ", 'Name" & nRec & "' )"
        oCNCT.Execute sSQL
    Next
    WScript.Echo nMxRec, "records added (in an ineffient way)"
  
    sSQL    = "SELECT * FROM tblEasy"
    Set oRS = oCNCT.Execute( sSQL )
    For nRec = 1 To (nMxRec / 10 ) + 1
        WScript.Echo "----------", nRec
        For Each oFld In oRS.Fields
            WScript.Echo oFld.Name, oFld.Value
        Next
        oRS.MoveNext
    Next
  
    oCNCT.Close
    Set oCNCT = Nothing