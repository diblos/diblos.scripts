''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Copyright (c) 2008, Dr Alexander J. Turner
' All rights reserved.
'
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
'     ' Redistributions of source code must retain the above copyright
'       notice, this list of conditions and the following disclaimer.
'     ' Redistributions in binary form must reproduce the above copyright
'       notice, this list of conditions and the following disclaimer in the
'       documentation and/or other materials provided with the distribution.
'     ' Neither the name of the  nor the
'       names of its contributors may be used to endorse or promote products
'       derived from this software without specific prior written permission.
'
' THIS SOFTWARE IS PROVIDED BY  ``AS IS'' AND ANY
' EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL  BE LIABLE FOR ANY
' DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
' (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
' ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Option Explicit

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Configure this script then run from CMD using cscript
'
' Use the constants below to configure the script
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' Database server name 
Const server     = "localhost"
' Use trusted (windows authenitcation) or standard (SQL Server authentication)
Const trusted    = FALSE
' Database user name - not needed for trusted connection
Const userId     = "deployview"
' Database password  - not needed for trusted connection
Const password   = "deployview"
' Database
Const dataBase   = "dv"
' Set to true to create a unicode SQL File (safest)
' and false for an asci one (asci will loose data if you have
' unicode fields in the db)
Const useUnicode = TRUE
' Set the name of the created file
Const fileName   = "Data.sql"

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' DO NOT EDIT BELOW THIS LINE UNLESS YOU WANT TO ENCHANCE/CHANGE  
' THE FUNCTIONALLITY OF THE SCRIPT
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' Variables used in the script
Dim db,i,connectString,fields,rs

' Userful ADODB constants
Const adOpenStatic      = 3
Const adLockReadOnly    = 1
Const adCmdText         = 1
Const adUseClient       = 3
Const adLockBatchOptimistic = 4 

' SQL that is used to get important info
Const GetTriggers = "SELECT spus.name + '.' + sp.name, s.name FROM sysobjects s inner join sysobjects sp on s.parent_obj = sp.id inner join sysusers spus on sp.uid = spus.uid WHERE s.xtype='TR' AND OBJECTPROPERTY(s.[id], 'ExecIsTriggerDisabled')=0"
Const GetUserTables_SQLServer = "SELECT usrs.name + '.' + obs.name 'Full Name' FROM  sysobjects obs, sysusers usrs WHERE obs.xtype = 'U' AND obs.uid = usrs.uid "
Const GetKeyOrder = "SELECT usrs1.name + '.' + o.name , usrs2.name + '.' + oo.name FROM sysobjects o, sysforeignkeys f ,sysobjects oo,sysusers usrs1,sysusers usrs2 WHERE o.id = f.rkeyid AND oo.id = f.fkeyid AND usrs1.uid=o.uid AND usrs2.uid=oo.uid"

' Connect to the db 
If trusted Then
    connectString="Provider=SQLNCLI;Server=" & server & ";Database=" & dataBase & ";Trusted_Connection=yes;"     
Else
    connectString="Provider=SQLNCLI;Server=" & server & ";Database=" & dataBase & ";Uid=" & userId & ";Pwd=" & password & ";"
End If
     
Set db = CreateObject("ADODB.Connection")
db.Open connectString
db.Execute "USE " + dataBase

DumpDBDataToFile db,fileName,GetUserTables(db),dataBase,useUnicode
WScript.Echo "All done"
WScript.Quit

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Pass in a connection and an array of table names
' and it will sort the tables names into dependency order.
' IE if table B depends on table A then A will be earlier in
' the list than B.  Again, if B m->1 A, then A comes first 
' in the list.
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Sub SortDepOrder(ado,tables)
    Dim recset
    Set recset = GetDisconRS(ado,GetKeyOrder)
    Dim inpa 
    Dim rc
    Dim i
    i = 0
    rc = recset.RecordCount
    Dim pc()
    ReDim pc(rc, 2)
    recset.MoveFirst
    While Not recset.EOF
        pc(i, 0) = recset.fields(0)
        pc(i, 1) = recset.fields(1)
        recset.MoveNext
        i = i + 1
    Wend
    recset.Close
    Dim cnt
    cnt = True
    ' Keep sorting until no changes are made
    While cnt
        cnt = False
        Dim cfind
        ' scan over all elements
        For cfind = 0 To ubound(tables)
            Dim child
            child = tables(cfind)
            ' see if the current element is a reference child
            For i = 0 To rc
                ' if we find a child find the parent
                If pc(i, 1) = child Then
                    ' found child
                    ' so get parent
                    Dim prnt
                    prnt = pc(i, 0)
                    Dim pfind 
                    ' loop over the whole input looking for the parent
                    For pfind = 0 To ubound(tables)
                        ' if we find it
                        If tables(pfind) = prnt Then
                            ' and it is after the child, swap
                            If pfind > cfind Then
                                ' parent lower than child swap
                                Dim tmp 
                                tmp = tables(pfind)
                                tables(pfind) = tables(cfind)
                                tables(cfind) = tmp
                                WScript.Echo tables(pfind) & " X " & tables(cfind)
                                cnt = True
                            End If
                        End If
                    Next 
                End If
            Next 
        Next 
    Wend
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Pass an database connection and get an array of all the user
' tables
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetUserTables(ado)
    Dim tabs(),ntab

    ado.Execute "BEGIN TRANSACTION"
    Dim recset
    Set recset = GetDisconRS(ado,GetUserTables_SQLServer)
    recset.MoveFirst
    ntab=0
    While Not recset.EOF
        ntab=ntab+1
        recset.MoveNext
    Wend
    recset.MoveFirst
    redim tabs(ntab-1)
    ntab=0
    While Not recset.EOF
        tabs(ntab)= recset.fields(0).value
        recset.MoveNext
        ntab=ntab+1
    Wend
    recset.Close
    ado.Execute "COMMIT"
    GetUserTables = tabs
    Exit Function
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Pass an database connection and get an array of all the enabled user
' table triggers as TABLE,TRIGGER strings
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetUserTriggers(ado)
    Dim trigs(),ntrig

    ado.Execute "BEGIN TRANSACTION"
    Dim recset
    Set recset = GetDisconRS(ado,GetTriggers)
    recset.MoveFirst
    ntrig=0
    While Not recset.EOF
        ntrig=ntrig+1
        recset.MoveNext
    Wend
    recset.MoveFirst
    redim trigs(ntrig-1)
    ntrig=0
    While Not recset.EOF
        trigs(ntrig)= recset.fields(0).value & "," & recset.fields(1)
        recset.MoveNext
        ntrig=ntrig+1
    Wend
    recset.Close
    ado.Execute "COMMIT"
    GetUserTriggers = trigs
    Exit Function
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' This function writes SQL to restore all the data into a set of tables 
' without changing the structure - IE a data only backup of the tables
' in pure SQL (ie loads of delete and insert statements).
'
' Parameters:
' ado         - a ADODB database connection objects
' fileName    - the file to which to write the SQL
' tabs        - a list of tables owner.name (like dbo.mytab)
' dataBase    - the name of the database the tables are in
' userUnicode - is the file to be unicode (recommended)
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Sub DumpDBDataToFile(ado, fileName, tabs,dataBase,useUnicode)
    Dim trc
    trc=0
    Dim fs
    ' Open the output file and select the chosen format
    Set fs = CreateObject("Scripting.FileSystemObject")
    Dim ts 
    If useUnicode Then
        Set ts = fs.OpenTextFile(fileName, 2, True,-1)
    Else
        Set ts = fs.OpenTextFile(fileName, 2, True)
    End If
    
    Dim t,tt 
    Dim rec
    Dim c
    Dim trigs
    
    ' Putting no count in the output script makes it run faster
    ts.WriteLine "SET NOCOUNT ON"
    ts.WriteLine "GO"
    ts.WriteLine "USE " & dataBase
    ts.WriteLine "GO"
    ' I had trouble with transactions, though under some conditions
    ' running with transactions was faster, often the transactions are
    ' so large that SQL Server 'jams up' and takes ages (even hours) to
    ' recover - this way is safer!
    ts.WriteLine "SET IMPLICIT_TRANSACTIONS OFF"
    ts.WriteLine "GO"

    ' It is important to turn off all enabled triggers else the db will
    ' be updating as it is loading and so all sorts of problems will ensue
    trigs=GetUserTriggers(ado)
    For Each t In trigs
        t=Split(t,",")
        For Each tt In tabs
            If UCase(Trim(tt))= UCase(Trim(t(0))) Then 
                WScript.Echo "Disabling trigger: " & t(1) & " on " & t(0)
                ts.WriteLine "ALTER TABLE " & t(0) & " DISABLE TRIGGER " & t(1)
                ts.WriteLine "GO"
                Exit For
            End If
        Next
    Next

    ' sort the dependency order so that deletes and inserts will fit
    ' with FK restraints. There might be a way of turning off the restraints
    ' but this works as well.
    WScript.Echo "Sorting table order"
    SortDepOrder ado, tabs
    For c = ubound(tabs) To 0 Step -1
        ts.WriteLine "DELETE FROM " & tabs(c) & " WITH (TABLOCKX) "
        ts.WriteLine "GO"
    Next
    
    ' Now we write out the inserts to restore the data. The tables are
    ' loaded in the opposite order to that in which they are deleted from
    For Each t In tabs
        ado.Execute "BEGIN TRANSACTION"
        ' This allows insertion into identity columns
        ts.WriteLine _
            "IF OBJECTPROPERTY ( object_id('" & t & "'),'TableHasIdentity') = 1 " + _
                "SET IDENTITY_INSERT " & t & " ON "
        ts.WriteLine "GO"
        Set rec = GetDisconRS(ado,"SELECT * FROM " & t)
        Dim sql
        Dim sql1
        Dim first
        first = True
        If Not rec.EOF Then
        rec.MoveFirst
        While Not rec.EOF
            Dim i
            If first Then
                sql1 = "INSERT INTO " & t & " ("
                For i = 0 To rec.fields.count - 1
                    If i > 0 Then sql1 = sql1 + ","
                    sql1 = sql1 + rec.fields(i).name
                Next
                sql1 = sql1 + ") VALUES ("
                first = False
                WScript.Echo "Dumping " & t
            End If
            sql = sql1
            Dim vt 
            Dim f 
            ' Use the returning data type to work out how to escape the SQL
            ' this is far from perfect, I am sure that some translations
            ' will not work properly, but for now it seems to work on the DBs
            ' I am working with
            For i = 0 To rec.fields.count - 1
                f = rec.fields(i).value
                vt = varType(f)
                If vt = 1 Then
                    f = "Null"
                ElseIf vt = 2 Or vt = 3 Or vt = 4 Or vt = 5 Or vt = 6 Or vt = 14 Then
                    f = DBEscapeNumber(CStr(f))
                ElseIf vt = 11 Then
                    If vt Then
                        f = "1"
                    Else
                        f = "0"
                    End If
                ElseIf vt = 8 Then
                    f = DBEscapeString(CStr(f))
                ElseIf vt = 7 Then
                    f = DBEscapeDate(CStr(f))
                ElseIf vt = 17 Then
                    f = "0x" + Right( "0" & Hex(f),2)
                ElseIf vt = 8209 Then
                    f = "0x" + BinToHex(f)
                Else
                    WScript.Echo "Could not reformat", "Table=" & t & " Col=" & rec.fields(i).name & " vt=" & vt
                    WScript.Quit
                End If
                If i > 0 Then sql = sql + ","
                sql = sql + f
            Next
            sql = sql + ")"
            ts.WriteLine sql
            ts.WriteLine "GO"
            trc=trc+1
            ' I like to see some record of what is going on
            if trc mod 1000 = 0 Then
                WScript.Echo "Total row count=" & trc
            End If
            rec.MoveNext
        Wend
        
        End If
        rec.Close
        ' Turn back on normal identity rules
        ' It would be better to check if identity insert was on before we 
        ' turned it off - this way we might turn it off when it is supposed to 
        ' on for the DBs normal function. I should fix this some time soon
        ts.WriteLine _
            "IF OBJECTPROPERTY ( object_id('" & t & "'),'TableHasIdentity') = 1 " + _
                "SET IDENTITY_INSERT " & t & " OFF "
        ts.WriteLine "GO"
    Next
    
    ' Turn back on triggers
    For Each t In trigs
        t=Split(t,",")
        For Each tt In tabs
            If UCase(Trim(tt))= UCase(Trim(t(0))) Then 
                WScript.Echo "Enabling trigger: " & t(1) & " on " & t(0)
                ts.WriteLine "ALTER TABLE " & t(0) & " ENABLE TRIGGER " & t(1)
                ts.WriteLine "GO"
                Exit For
            End If
        Next
    Next
    ts.Close
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' This function returns a disconnected RS
' given a connection to the db and some SQL
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GetDisconRS(ado,sql)
    Dim recset
    Set recset = CreateObject("ADODB.Recordset")
    recset.CursorLocation = adUseClient
    recset.CursorType = adOpenStatic
    recset.LockType = adLockBatchOptimistic 
    recset.Open sql, ado, , , adCmdText
    Set recset.ActiveConnection = Nothing
    Set GetDisconRS = recset
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Given a variable of type Date returns  a variable of type String in
' long date format in English.  For example a Date 01/01/2008 will
' become "1 January 2008".  If that passed variable is a String, not
' a Date, then the results will still be a long date if VBScript can
' parse the passed String as a Date.  However, the Date created  will
' be dependent upon the local in which VBScript is running.
'
' Author: Alexander J Turner - 12 Feb 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function DateLong(myDate)
   Dim months
   months=Split("january,february,march,april,may,june,july,august,september,october,november,december",",")
   DateLong= _
       DatePart("D",mydate)      & " " & _
       months(    DatePart("M",myDate)-1) & " " & _
       DatePart("YYYY",mydate)
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Given any variable, will return a String which is safe for direct
' inclusion in an SQL Server SQL Statement. E.g. 01/01/2008 will
' result in '1 January 2008'. Note that the ' marks are included imn
' the returned String.
'
' Author: Alexander J Turner - 12 Feb 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function DBEscapeDate(myDate)
   ' The full String escape should never be required but it is here
   ' to ensure that a malevalent injection cannot cause
   ' commands to be passed via a Date field
   DBEscapeDate=DBEscapeString(DateLong(myDate))
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Given any variable, will return a String which is safe for direct
' inclusion in an SQL Server SQL Statement.
' Note that the ' marks are included in the returned String.
'
' Author: Alexander J Turner - 12 Feb 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function DBEscapeString(myString)
   DBEscapeString="'" & Replace(myString,"'","''") & "'"
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Given any variable, will return a Number which is safe for direct
' inclusion in an SQL Server SQL Statement. Note than non numeric
' values will be converted to 0.
'
' Author: Alexander J Turner - 12 Feb 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function DBEscapeNumber(myNumber)
   If NOT IsNumeric(myNumber) Then myNumber=0
   myNumber=myNumber*1.0
   DBEscapeNumber=Replace(myNumber & "","'","''")
End Function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Pass in an array of numbers (byte or between 0 and 255)
' and get out a string of hex representing the same numbers
'
' Author: Alexander J Turner - 1 May 2008
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function BinToHex(data)
    Dim ret
    Dim l
    Dim i
    Dim lb
    Dim h
    Dim d
    Dim o
    lb = LBound(data) - 1
    l = UBound(data) - LBound(data) + 1
    ret = String(l * 2, "0")
    Redim o(l-1)

    ' Use arrays and join as just adding to the end of a
    ' string scales badly as the length of the string increases
    For i = 1 To l
        d = 255 and ascb(midb(data,i,1))
        If d > 15 Then
            o(i-1) = Hex(d)
        Else
            o(i-1) = "0" + Hex(d)
        End If
    Next
    BinToHex = Join(o,"")
End Function
