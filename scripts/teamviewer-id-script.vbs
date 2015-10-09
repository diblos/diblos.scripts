Const strFolderName = "\\fileserver\share\folder\"
' set this to where you want the files stored, make sure there is permission from clients to this no matter what user they are logged on with!
Const ShowInfoOutput = True
' Set to true/false for writing to console

Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const HKEY_CURRENT_USER = &H80000001
Const HKEY_LOCAL_MACHINE = &H80000002

strComputer = "."
 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
    strComputer & "\root\default:StdRegProv")
 
strKeyPath = "SOFTWARE\Wow6432Node\TeamViewer\Version5"
strValueName = "ClientID"
oReg.GetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwTVID

' client ID is placed in more than one place depending on version
' in case we dont get it first, try a second place (add more of theese "if sections" if other versions are used)
If dwTVID = 0 Then
	strKeyPath = "SOFTWARE\Wow6432Node\TeamViewer\Version5.1"
	oReg.GetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwTVID
End If
Set oReg = Nothing

' Get information about this machine
Set WshNetwork = WScript.CreateObject("WScript.Network") ' used for Networking object control
UserName = UCase(WshNetwork.UserName)
ComputerName = UCase(WshNetwork.ComputerName)
EnvDomainName = UCase( WshNetwork.UserDomain )
Set WshNetwork = Nothing

If ShowInfoOutput Then
	WScript.Echo "User:         " & EnvDomainName & "\" & UserName
	WScript.Echo "Computer:     " & ComputerName
	WScript.Echo "TeamViewerID: " & dwTVID
End If

If Not dwTVID = 0 Then
	' only save if we did get a TeamViewer ID
	' Save to userdomain, computername, username, teamviewerid to a text file with same name
	strFileName = strFolderName & EnvDomainName & "_" & ComputerName & "_" & UserName & "_" & dwTVID & ".txt"
	Set objFSO = CreateObject("Scripting.FileSystemObject") ' used for file operations
	Set objTextFile = objFSO.OpenTextFile (strFileName, ForWriting, True)
	objTextFile.WriteLine EnvDomainName & vbCrLf & ComputerName & vbCrLF & UserName & vbCrLF & dwTVID
	objTextFile.Close
End If
