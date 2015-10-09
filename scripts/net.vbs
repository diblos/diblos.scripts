ServerShare = "\\192.168.8.41\d$"
UserName = "192.168.8.41\administrator"
Password = "123@qwe"

Set NetworkObject = CreateObject("WScript.Network")
Set FSO = CreateObject("Scripting.FileSystemObject")

NetworkObject.MapNetworkDrive "", ServerShare, False, UserName, Password

Set Directory = FSO.GetFolder(ServerShare)
For Each FileName In Directory.Files
    WScript.Echo FileName.Name
Next

Set FileName = Nothing
Set Directory = Nothing
Set FSO = Nothing

NetworkObject.RemoveNetworkDrive ServerShare, True, False

Set ShellObject = Nothing
Set NetworkObject = Nothing