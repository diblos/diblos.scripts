 ServerShare = "\\Resource\Desktop"
    ServerShare2 = "\\Resource\Documents and Settings\User\SendTo"

    Set NetworkObject = CreateObject("WScript.Network")
    Set FSO = CreateObject("Scripting.FileSystemObject")

    NetworkObject.MapNetworkDrive "", ServerShare, False, UserName, Password
    NetworkObject.MapNetworkDrive "", ServerShare2, False, UserName, Password

    Set Directory = FSO.GetFolder(ServerShare)
    For Each FileName In Directory.Files
        WScript.Echo "Files Copied: ", FileName.Name
    Next

    Set Directory = FSO.GetFolder(ServerShare2)
    For Each FileName In Directory.Files
        WScript.Echo "Files Copied2: ", FileName.Name
    Next

    Set FileName = Nothing
    Set Directory = Nothing
    Set FSO = Nothing

    NetworkObject.RemoveNetworkDrive ServerShare, True, False
    NetworkObject.RemoveNetworkDrive ServerShare2, True, False

    Set ShellObject = Nothing
    Set NetworkObject = Nothing

    Const DestinationFolder = "\\Resource\Desktop"
    Const DestinationFolder2 = "\\Resource\Documents and Settings\User\SendTo"
    Const SourceFolder = "C:\Documents and Settings\User.MACHINE\Desktop"
    Const SourceFolder2 = "C:\Documents and Settings\User.MACHINE\SendTo"

    Set fso = CreateObject("Scripting.FileSystemObject")
        'Check to see if the file already exists in the destination folder
        If fso.FolderExists(DestinationFolder) Then
            'Check to see if the file is read-only
            If Not fso.GetFolder(DestinationFolder).Attributes And 1 Then 
                'The file exists and is not read-only.  Safe to replace the file.
                fso.CopyFolder SourceFolder, "Resource\Desktop", True
            Else 
                        'The file exists and is read-only.
        'Remove the read-only attribute
                fso.GetFolder(DestinationFolder).Attributes = fso.GetFolder        (DestinationFolder).Attributes - 1
                'Replace the file
                fso.CopyFolder SourceFolder, "\\Resource\Desktop", True
                'Reapply the read-only attribute
                fso.GetFolder(DestinationFolder).Attributes = fso.GetFolder        (DestinationFolder).Attributes + 1
            End If
        Else
            'The file does not exist in the destination folder.  Safe to copy file to         this folder.
            fso.CopyFolder SourceFolder, "\\Resource\Desktop", True
        End If

        If fso.FolderExists(DestinationFolder2) Then
            'Check to see if the file is read-only
            If Not fso.GetFolder(DestinationFolder2).Attributes And 1 Then 
                'The file exists and is not read-only.  Safe to replace the file.
                fso.CopyFolder SourceFolder2, "Resource\Documents and Settings\User\SendTo", True
            Else 
                'The file exists and is read-only.
                'Remove the read-only attribute
                fso.GetFolder(DestinationFolder2).Attributes = fso.GetFolder        (DestinationFolder2).Attributes - 1
                'Replace the file
                fso.CopyFolder SourceFolder2, "Resource\Documents and Settings\User\SendTo", True
                'Reapply the read-only attribute
                fso.GetFolder(DestinationFolder2).Attributes = fso.GetFolder        (DestinationFolder2).Attributes + 1
            End If
        Else
            'The file does not exist in the destination folder.  Safe to copy file to         this folder.
            fso.CopyFolder SourceFolder2, "\\Resource\Documents and Settings\User\SendTo", True
        End If
    Set fso = Nothing