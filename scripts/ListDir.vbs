' Test program for the ListDir function.
' Lists file names using wildcards.
'
' Author:  Christian d'Heureuse (www.source-code.biz)
' License: GNU/LGPL (http://www.gnu.org/licenses/lgpl.html)
'
' Changes:
' 2006-01-19 Extended to handle the special case of filter masks
'            ending with a ".". Thanks to Dave Casey for the hint.

Option Explicit

Main

Sub Main
   Dim Path
   Select Case WScript.Arguments.Count
      Case 0: Path = "*.*"             ' list current directory
      Case 1: Path = WScript.Arguments(0)
      Case Else: WScript.Echo "Invalid number of arguments.": Exit Sub
      End Select
   Dim a: a = ListDir(Path)
   If UBound(a) = -1 then
      WScript.Echo "No files found."
      Exit Sub
      End If
   Dim FileName
   For Each FileName In a
      WScript.Echo FileName
      Next
   End Sub

' Returns an array with the file names that match Path.
' The Path string may contain the wildcard characters "*"
' and "?" in the file name component. The same rules apply
' as with the MSDOS DIR command.
' If Path is a directory, the contents of this directory is listed.
' If Path is empty, the current directory is listed.
' Author: Christian d'Heureuse (www.source-code.biz)
Public Function ListDir (ByVal Path)
   Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
   If Path = "" then Path = "*.*"
   Dim Parent, Filter
   if fso.FolderExists(Path) then      ' Path is a directory
      Parent = Path
      Filter = "*"
     Else
      Parent = fso.GetParentFolderName(Path)
      If Parent = "" Then If Right(Path,1) = ":" Then Parent = Path: Else Parent = "."
      Filter = fso.GetFileName(Path)
      If Filter = "" Then Filter = "*"
      End If
   ReDim a(10)
   Dim n: n = 0
   Dim Folder: Set Folder = fso.GetFolder(Parent)
   Dim Files: Set Files = Folder.Files
   Dim File
   For Each File In Files
      If CompareFileName(File.Name,Filter) Then
         If n > UBound(a) Then ReDim Preserve a(n*2)
         a(n) = File.Path
         n = n + 1
         End If
      Next
   ReDim Preserve a(n-1)
   ListDir = a
   End Function

Private Function CompareFileName (ByVal Name, ByVal Filter) ' (recursive)
   CompareFileName = False
   Dim np, fp: np = 1: fp = 1
   Do
      If fp > Len(Filter) Then CompareFileName = np > len(name): Exit Function
      If Mid(Filter,fp) = ".*" Then    ' special case: ".*" at end of filter
         If np > Len(Name) Then CompareFileName = True: Exit Function
         End If
      If Mid(Filter,fp) = "." Then     ' special case: "." at end of filter
         CompareFileName = np > Len(Name): Exit Function
         End If
      Dim fc: fc = Mid(Filter,fp,1): fp = fp + 1
      Select Case fc
         Case "*"
            CompareFileName = CompareFileName2(name,np,filter,fp)
            Exit Function
         Case "?"
            If np <= Len(Name) And Mid(Name,np,1) <> "." Then np = np + 1
         Case Else
            If np > Len(Name) Then Exit Function
            Dim nc: nc = Mid(Name,np,1): np = np + 1
            If Strcomp(fc,nc,vbTextCompare)<>0 Then Exit Function
         End Select
      Loop
   End Function

Private Function CompareFileName2 (ByVal Name, ByVal np0, ByVal Filter, ByVal fp0)
   Dim fp: fp = fp0
   Dim fc2
   Do                                  ' skip over "*" and "?" characters in filter
      If fp > Len(Filter) Then CompareFileName2 = True: Exit Function
      fc2 = Mid(Filter,fp,1): fp = fp + 1
      If fc2 <> "*" And fc2 <> "?" Then Exit Do
      Loop
   If fc2 = "." Then
      If Mid(Filter,fp) = "*" Then     ' special case: ".*" at end of filter
         CompareFileName2 = True: Exit Function
         End If
      If fp > Len(Filter) Then         ' special case: "." at end of filter
         CompareFileName2 = InStr(np0,Name,".") = 0: Exit Function
         End If
      End If
   Dim np
   For np = np0 To Len(Name)
      Dim nc: nc = Mid(Name,np,1)
      If StrComp(fc2,nc,vbTextCompare)=0 Then
         If CompareFileName(Mid(Name,np+1),Mid(Filter,fp)) Then
            CompareFileName2 = True: Exit Function
            End If
         End If
      Next
   CompareFileName2 = False
   End Function
