'' NewFolder.vbs
'' Free example VBScript to create a folder (Simple)
'' Author Guy Thomas http://computerperformance.co.uk/
'' Version 2.4 - September 2010
'' ------------------------------------------------'
'Option Explicit
'Dim objFSO, objFolder, strDirectory
'strDirectory = "c:\deleteme"
'' Create FileSystemObject. So we can apply .createFolder method
'Set objFSO = CreateObject("Scripting.FileSystemObject")

'' Here is the key line Create a Folder, using strDirectory
'Set objFolder = objFSO.CreateFolder(strDirectory)
'WScript.Echo "Just created " & strDirectory
'WScript.Quit
'' End of free example VBScript to create a folder

'===============================================================


'' NewFolderEC.vbs
'' Free example VBScript to create a folder with error-correcting Code.
'' Author Guy Thomas http://computerperformance.co.uk/
'' Version 2.6 - May 2010
'' ------------------------------------------------' 

'Option Explicit
'Dim objFSO, objFolder, objShell, strDirectory
'strDirectory = "c:\deleteme"

'' Create the File System Object
'Set objFSO = CreateObject("Scripting.FileSystemObject")

'' Note If..Exists. Then, Else ... End If construction
'If objFSO.FolderExists(strDirectory) Then
'   Set objFolder = objFSO.GetFolder(strDirectory)
'   WScript.Echo strDirectory & " already created "
'Else
'   Set objFolder = objFSO.CreateFolder(strDirectory)
'WScript.Echo "Just created " & strDirectory
'End If

'If err.number = vbEmpty then
'   Set objShell = CreateObject("WScript.Shell")
'   objShell.run ("Explorer" &" " & strDirectory & "\" )
'Else WScript.echo "VBScript Error: " & err.number
'End If

'WScript.Quit

'' End of Sample VBScript to create a folder with error-correcting Code

'===============================================================

Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim strDirectory
strDirectory = "c:\deleteme\me\me"
CreateFolder(strDirectory)

'Recursive folder create, will create directories and Sub
Sub CreateFolder( strPath )
On Error Resume Next
If strPath <> "" Then 'Fixes endless recursion in some instances when at lowest directory
If Not objFSO.FolderExists( objFSO.GetParentFolderName(strPath) ) then Call CreateFolder( objFSO.GetParentFolderName(strPath) )
objFSO.CreateFolder( strPath )
End If 
End Sub
'===============================================================