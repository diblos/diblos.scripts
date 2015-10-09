Option Explicit

Dim arrResult,currentDirectory,folder2zip,destFile,destFolder,getFormattedDate
'currentDirectory = left(WScript.ScriptFullName,(Len(WScript.ScriptFullName))-(len(WScript.ScriptName)))
currentDirectory = "D:\misc\2bcopied\fromDownload"
Dim Files
Files = Array()

destFolder = "D:\misc\2bcopied\fromDownload\Dropbox\exchange"
destFile = "C:\Documents and Settings\qwerty\My Documents\Downloads\exchange\test.zip"

'WScript.Echo PerfectPath(currentDirectory)
'WScript.Echo PerfectPath(destFolder)

CreateFolder(destFolder)
ProcessFolder(currentDirectory)
RemovedProcessed()
WScript.Quit

Sub ShowFolderList(folderspec)
    Dim fs, f, f1, fc, s
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFolder(folderspec)
    Set fc = f.SubFolders
    For Each f1 in fc
        s = s & f1.name 
        s = s &  vbCrLf
    Next
	WScript.Echo s
End Sub

Sub ProcessFolder(folderspec)
    Dim fs, f, f1, fc, s
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFolder(folderspec)
    Set fc = f.SubFolders
    For Each f1 in fc
		if left(f1.name,1)="D" And Len(f1.name)=10 then
			s = f1.name 
			
			WScript.Sleep(1000)
			arrResult = ZipFolder(PerfectPath(folderspec) & s, PerfectPath(destFolder) & s & ".zip")
						
			If arrResult(0) = 0 Then
				If arrResult(1) = 1 Then
					WScript.Echo "Done; 1 empty subfolder was skipped."
				Else
					WScript.Echo "Done; " & arrResult(1) & " empty subfolders were skipped."
					redim preserve Files(ubound(Files)+1)
					Files(ubound(Files))=PerfectPath(folderspec) & s
				End If
			Else
				WScript.Echo "ERROR " & Join( arrResult, vbCrLf )
			End If		
		
		
		End If
    Next
End Sub

Function ZipFolder( myFolder, myZipFile )
' This function recursively ZIPs an entire folder into a single ZIP file,
' using only Windows' built-in ("native") objects and methods.
'
' Last Modified:
' October 12, 2008
'
' Arguments:
' myFolder   [string]  the fully qualified path of the folder to be ZIPped
' myZipFile  [string]  the fully qualified path of the target ZIP file
'
' Return Code:
' An array with the error number at index 0, the source at index 1, and
' the description at index 2. If the error number equals 0, all went well
' and at index 1 the number of skipped empty subfolders can be found.
'
' Notes:
' [1] If the specified ZIP file exists, it will be overwritten
'     (NOT APPENDED) without notice!
' [2] Empty subfolders in the specified source folder will be skipped
'     without notice; lower level subfolders WILL be added, wether
'     empty or not.
'
' Based on a VBA script (http://www.rondebruin.nl/windowsxpzip.htm)
' by Ron de Bruin, http://www.rondebruin.nl
'
' (Re)written by Rob van der Woude
' http://www.robvanderwoude.com

    ' Standard housekeeping
    Dim intSkipped, intSrcItems
    Dim objApp, objFolder, objFSO, objItem, objTxt
    Dim strSkipped

    Const ForWriting = 2

    intSkipped = 0

    ' Make sure the path ends with a backslash
    If Right( myFolder, 1 ) <> "\" Then
        myFolder = myFolder & "\"
    End If

    ' Use custom error handling
    On Error Resume Next

    ' Create an empty ZIP file
    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
    Set objTxt = objFSO.OpenTextFile( myZipFile, ForWriting, True )
    objTxt.Write "PK" & Chr(5) & Chr(6) & String( 18, Chr(0) )
    objTxt.Close
    Set objTxt = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Err.Clear
        On Error Goto 0
        Exit Function
    
    ' Create a Shell object
    End If
    Set objApp = CreateObject( "Shell.Application" )

    ' Copy the files to the compressed folder
    For Each objItem in objApp.NameSpace( myFolder ).Items
        If objItem.IsFolder Then
            ' Check if the subfolder is empty, and if
            ' so, skip it to prevent an error message
            Set objFolder = objFSO.GetFolder( objItem.Path )
            If objFolder.Files.Count + objFolder.SubFolders.Count = 0 Then
                intSkipped = intSkipped + 1
            Else
                objApp.NameSpace( myZipFile ).CopyHere objItem
            End If
        Else
            objApp.NameSpace( myZipFile ).CopyHere objItem
        End If
    Next

    Set objFolder = Nothing
    Set objFSO    = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Set objApp = Nothing
        Err.Clear
        On Error Goto 0
        Exit Function
    End If

    ' Keep script waiting until compression is done
    intSrcItems = objApp.NameSpace( myFolder  ).Items.Count
    Do Until objApp.NameSpace( myZipFile ).Items.Count + intSkipped = intSrcItems
        WScript.Sleep 200
    Loop
    Set objApp = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Err.Clear
        On Error Goto 0
        Exit Function
    End If

    ' Restore default error handling
    On Error Goto 0

    ' Return message if empty subfolders were skipped
    If intSkipped = 0 Then
        strSkipped = ""
    Else
        strSkipped = "skipped empty subfolders"
    End If

    ' Return code 0 (no error occurred)
    ZipFolder = Array( 0, intSkipped, strSkipped )
End Function

Sub CreateFolder( strPath )
	dim FSO
	Set FSO = CreateObject("scripting.filesystemobject")
	On Error Resume Next
		If strPath <> "" Then 'Fixes endless recursion in some instances when at lowest directory
			If Not FSO.FolderExists( FSO.GetParentFolderName(strPath) ) then Call CreateFolder( FSO.GetParentFolderName(strPath) )
			FSO.CreateFolder( strPath )
		End If
	Set FSO = Nothing
End Sub

Function PerfectPath(dPath)
	if right(dPath,1)="\" then
		PerfectPath = dPath
	else
		PerfectPath = dPath & "\"
	end if
End Function

Function dePerfectPath(dPath)
	if right(dPath,1)="\" then
		dePerfectPath = left(dPath,len(dPath)-1)
	else
		dePerfectPath = dPath
	end if
End Function

Sub RemovedProcessed()
	dim filesys
	Set filesys = CreateObject("Scripting.FileSystemObject")
	
	dim x
	For Each x in Files
		WScript.Sleep(1000)
		If filesys.FolderExists(PerfectPath(x)) Then  
		   filesys.DeleteFolder dePerfectPath(x)
		   WScript.Echo("Folder deleted: " & x)
		End If
	Next

	Set filesys = Nothing
End Sub
