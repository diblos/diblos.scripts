' http://www.rondebruin.nl/folder.htm

'Copy, Move and Delete files and folders
'Ron de Bruin (last update 18 Aug-2007)
'Go back to the Excel tips page

'On this page you can find example code to copy, move and delete files and folders.
'There are three sections on this page :

'1) Copy and Move files and folders
'2) Delete files and folders
'3) Special Folders
'4) VBS script to clear the Temp folder



'Copy and Move files and folders 
'Below are a few examples to copy and move files and folders.

'For one file you can use the VBA Name and FileCopy function
'and for entire folders or a lot of files use the other macro example's

Sub Copy_One_File()
    FileCopy "C:\Users\Ron\SourceFolder\Test.xls", "C:\Users\Ron\DestFolder\Test.xls"
End Sub

Sub Move_Rename_One_File()
'You can change the path and file name
    Name "C:\Users\Ron\SourceFolder\Test.xls" As "C:\Users\Ron\DestFolder\TestNew.xls"
End Sub

'Filesystemobject example code's

Sub Copy_Folder()
'This example copy all files and subfolders from FromPath to ToPath.
'Note: If ToPath already exist it will overwrite existing files in this folder
'if ToPath not exist it will be made for you.
    Dim FSO As Object
    Dim FromPath As String
    Dim ToPath As String

    FromPath = "C:\Users\Ron\Data"  '<< Change
    ToPath = "C:\Users\Ron\Test"    '<< Change

    'If you want to create a backup of your folder every time you run this macro
    'you can create a unique folder with a Date/Time stamp.
    'ToPath = "C:\Users\Ron\" & Format(Now, "yyyy-mm-dd h-mm-ss")

    If Right(FromPath, 1) = "\" Then
        FromPath = Left(FromPath, Len(FromPath) - 1)
    End If

    If Right(ToPath, 1) = "\" Then
        ToPath = Left(ToPath, Len(ToPath) - 1)
    End If

    Set FSO = CreateObject("scripting.filesystemobject")

    If FSO.FolderExists(FromPath) = False Then
        MsgBox FromPath & " doesn't exist"
        Exit Sub
    End If

    FSO.CopyFolder Source:=FromPath, Destination:=ToPath
    MsgBox "You can find the files and subfolders from " & FromPath & " in " & ToPath

End Sub


Sub Move_Rename_Folder()
'This example move the folder from FromPath to ToPath.
    Dim FSO As Object
    Dim FromPath As String
    Dim ToPath As String

    FromPath = "C:\Users\Ron\Data"  '<< Change
    ToPath = "C:\Users\Ron\Test"    '<< Change
    'Note: It is not possible to use a folder that exist in ToPath

    If Right(FromPath, 1) = "\" Then
        FromPath = Left(FromPath, Len(FromPath) - 1)
    End If

    If Right(ToPath, 1) = "\" Then
        ToPath = Left(ToPath, Len(ToPath) - 1)
    End If

    Set FSO = CreateObject("scripting.filesystemobject")

    If FSO.FolderExists(FromPath) = False Then
        MsgBox FromPath & " doesn't exist"
        Exit Sub
    End If

    If FSO.FolderExists(ToPath) = True Then
        MsgBox ToPath & " exist, not possible to move to a existing folder"
        Exit Sub
    End If

    FSO.MoveFolder Source:=FromPath, Destination:=ToPath
    MsgBox "The folder is moved from " & FromPath & " to " & ToPath

End Sub


Sub Copy_Files_Dates()
'This example copy all files between certain dates from FromPath to ToPath.
'You can also use this to copy the files from the last ? days
'If Fdate >= Date - 30 Then
'Note: If the files in ToPath already exist it will overwrite
'existing files in this folder
    Dim FSO As Object
    Dim FromPath As String
    Dim ToPath As String
    Dim Fdate As Date
    Dim FileInFromFolder As Object

    FromPath = "C:\Users\Ron\Data"  '<< Change
    ToPath = "C:\Users\Ron\Test"    '<< Change

    If Right(FromPath, 1) <> "\" Then
        FromPath = FromPath & "\"
    End If

    If Right(ToPath, 1) <> "\" Then
        ToPath = ToPath & "\"
    End If

    Set FSO = CreateObject("scripting.filesystemobject")

    If FSO.FolderExists(FromPath) = False Then
        MsgBox FromPath & " doesn't exist"
        Exit Sub
    End If

    If FSO.FolderExists(ToPath) = False Then
        MsgBox ToPath & " doesn't exist"
        Exit Sub
    End If

    For Each FileInFromFolder In FSO.getfolder(FromPath).Files
        Fdate = Int(FileInFromFolder.DateLastModified)
        'Copy files from 1-Oct-2006 to 1-Nov-2006
        If Fdate >= DateSerial(2006, 10, 1) And Fdate <= DateSerial(2006, 11, 1) Then
            FileInFromFolder.Copy ToPath
        End If
    Next FileInFromFolder

    MsgBox "You can find the files from " & FromPath & " in " & ToPath

End Sub


Sub Copy_Certain_Files_In_Folder()
'This example copy all Excel files from FromPath to ToPath.
'Note: If the files in ToPath already exist it will overwrite
'existing files in this folder
    Dim FSO As Object
    Dim FromPath As String
    Dim ToPath As String
    Dim FileExt As String

    FromPath = "C:\Users\Ron\Data"  '<< Change
    ToPath = "C:\Users\Ron\Test"    '<< Change

    FileExt = "*.xl*"  '<< Change
    'You can use *.* for all files or *.doc for word files

    If Right(FromPath, 1) <> "\" Then
        FromPath = FromPath & "\"
    End If

    Set FSO = CreateObject("scripting.filesystemobject")

    If FSO.FolderExists(FromPath) = False Then
        MsgBox FromPath & " doesn't exist"
        Exit Sub
    End If

    If FSO.FolderExists(ToPath) = False Then
        MsgBox ToPath & " doesn't exist"
        Exit Sub
    End If

    FSO.CopyFile Source:=FromPath & FileExt, Destination:=ToPath
    MsgBox "You can find the files from " & FromPath & " in " & ToPath

End Sub


Sub Move_Certain_Files_To_New_Folder()
'This example move all Excel files from FromPath to ToPath.
'Note: It will create the folder ToPath for you with a date-time stamp
    Dim FSO As Object
    Dim FromPath As String
    Dim ToPath As String
    Dim FileExt As String
    Dim FNames As String

    FromPath = "C:\Users\Ron\Data"  '<< Change
    ToPath = "C:\Users\Ron\" & Format(Now, "yyyy-mm-dd h-mm-ss") _
           & " Excel Files" & "\"    '<< Change only the destination folder

    FileExt = "*.xl*"   '<< Change
    'You can use *.* for all files or *.doc for word files

    If Right(FromPath, 1) <> "\" Then
        FromPath = FromPath & "\"
    End If

    FNames = Dir(FromPath & FileExt)
    If Len(FNames) = 0 Then
        MsgBox "No files in " & FromPath
        Exit Sub
    End If

    Set FSO = CreateObject("scripting.filesystemobject")

    FSO.CreateFolder (ToPath)

    FSO.MoveFile Source:=FromPath & FileExt, Destination:=ToPath
    MsgBox "You can find the files from " & FromPath & " in " & ToPath

End Sub


'Delete files and folders 

I'mportant !
'Read this page from Chip Pearson first
'http://www.cpearson.com/excel/Recycle.htm

'From Chip's site :
'You need to remember, though, that Kill permanently deletes the file. 
'There is no way to "undo" the delete. The file is not sent to the Windows Recycle Bin
'( Same for the macro's that use the filesystemobject )

Sub DeleteExample1()
'You can use this to delete all the files in the folder Test
    On Error Resume Next
    Kill "C:\Users\Ron\Test\*.*"
    On Error GoTo 0
End Sub

Sub DeleteExample2()
'You can use this to delete all xl? files in the folder Test
    On Error Resume Next
    Kill "C:\Users\Ron\Test\*.xl*"
    On Error GoTo 0
End Sub

Sub DeleteExample3()
'You can use this to delete one xls file in the folder Test
    On Error Resume Next
    Kill "C:\Users\Ron\Test\ron.xls"
    On Error GoTo 0
End Sub

Sub DeleteExample4()
'You can use this to delete the whole folder
'Note: RmDir delete only a empty folder
    On Error Resume Next
    Kill "C:\Users\Ron\Test\*.*"    ' delete all files in the folder
    RmDir "C:\Users\Ron\Test\"  ' delete folder
    On Error GoTo 0
End Sub

Sub Delete_Whole_Folder()
'Delete whole folder without removing the files first like in DeleteExample4
    Dim FSO As Object
    Dim MyPath As String

    Set FSO = CreateObject("scripting.filesystemobject")

    MyPath = "C:\Users\Ron\Test"  '<< Change

    If Right(MyPath, 1) = "\" Then
        MyPath = Left(MyPath, Len(MyPath) - 1)
    End If

    If FSO.FolderExists(MyPath) = False Then
        MsgBox MyPath & " doesn't exist"
        Exit Sub
    End If

    FSO.deletefolder MyPath

End Sub

Sub Clear_All_Files_And_SubFolders_In_Folder()
'Delete all files and subfolders
'Be sure that no file is open in the folder
    Dim FSO As Object
    Dim MyPath As String

    Set FSO = CreateObject("scripting.filesystemobject")

    MyPath = "C:\Users\Ron\Test"  '<< Change

    If Right(MyPath, 1) = "\" Then
        MyPath = Left(MyPath, Len(MyPath) - 1)
    End If

    If FSO.FolderExists(MyPath) = False Then
        MsgBox MyPath & " doesn't exist"
        Exit Sub
    End If

    On Error Resume Next
    'Delete files
    FSO.deletefile MyPath & "\*.*", True
    'Delete subfolders
    FSO.deletefolder MyPath & "\*.*", True
    On Error GoTo 0

End Sub

'SpecialFolders 

'How do I get the path of a special folder and open the folder ?

Sub GetSpecialFolder()
'Special folders are : AllUsersDesktop, AllUsersStartMenu
'AllUsersPrograms, AllUsersStartup, Desktop, Favorites
'Fonts, MyDocuments, NetHood, PrintHood, Programs, Recent
'SendTo, StartMenu, Startup, Templates
 
'Get Favorites folder and open it
    Dim WshShell As Object
    Dim SpecialPath As String

    Set WshShell = CreateObject("WScript.Shell")
    SpecialPath = WshShell.SpecialFolders("Favorites")
    MsgBox SpecialPath
    'Open folder in Explorer
    Shell "explorer.exe " & SpecialPath, vbNormalFocus
End Sub


Sub VBA_GetSpecialFolder_functions()
'Here are a few VBA path functions
    MsgBox Application.Path
    MsgBox Application.DefaultFilePath
    MsgBox Application.TemplatesPath
    MsgBox Application.StartupPath
    MsgBox Application.UserLibraryPath
    MsgBox Application.LibraryPath
End Sub

'Temp folder

'Without code you can do this to open the temp folder

'Start>Run
'Enter %temp%
'OK

'Or use one of the two code examples
Sub GetTempFolder_1()
    MsgBox Environ("Temp")
    'Open folder in Explorer
    Shell "explorer.exe " & Environ("Temp"), vbNormalFocus
End Sub

Sub GetTempFolder_2()
    Dim FSO As Object, TmpFolder As Object
    Set FSO = CreateObject("scripting.filesystemobject")
    Set TmpFolder = FSO.GetSpecialFolder(2)
    MsgBox TmpFolder
    'Open folder in Explorer
    Shell "explorer.exe " & TmpFolder, vbNormalFocus
End Sub
'0 = The Windows folder contains files installed by the Windows operating sys
'1 = The System folder contains libraries, fonts, and device drivers



'VBS script to clear the Temp folder 

'It is smart to delete all files and folders in your temp folder at least once a week to avoid problems.
'Important: Do this always after you reboot your system.

'Manual you can use this to open the folder and then delete all files and folders in the Temp folder.

'Start>Run
'Enter %temp%
'OK

'But it is easier to use a vbs file on your desktop to do this.
'A vbs file is a text file with script in it with a vbs extension.

'You simply double click on the file then on your desktop and it will do all the work for you.

'MVP Michael Harris posted a great script in the newsgroup
'http://groups.google.com/groups?threadm=%23bXVsIHnAHA.920%40tkmsftngp02

'1) Open Notepad
'2) Copy/Paste the script in Notepad
'3) Save the file as DeleteTempFiles.txt
'4) Change the extension from txt to vbs

'Or download the vbs file in a zip file
'DeleteTempFiles.zip