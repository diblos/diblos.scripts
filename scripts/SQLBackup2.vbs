Option Explicit 

Const filePath = "C:\Documents and Settings\jmunn\My Documents\Visual Studio 2008\Logs\"
Const holdDays = 6

main 

Sub Main() 

ClearArchive 

End Sub 

Sub ClearArchive() 

Dim fso 'As Scripting.FileSystemObject 
Dim fld 'As Scripting.Folder 
Dim f 'As Scripting.File 
Dim delLogName, delLogOut, delCtr

Set fso = CreateObject("Scripting.FileSystemObject") 
Set fld = fso.GetFolder(filePath) 

delLogName = filePath & "Nightly Backup - Backup Logs Deleted" & ".txt"

Set delLogOut = fso.CreateTextFile(delLogName, True)

delLogOut.WriteLine(delLogName)
delLogOut.WriteLine("")
delLogOut.WriteLine("-- The following log files were deleted on " & DateValue(Now()) & " at " & TimeValue(Now()))
delLogOut.WriteLine("")

delCtr = 0

For Each f In fld.Files
	If Left(f.Name, 48) = "Nightly Backup - SQL Server Databases_Subplan_1_" And Right(LCase(f.Name), 4) = ".txt" Then 
		If DateDiff("d", f.DateCreated, Date()) > holdDays Then
			delLogOut.WriteLine(f.Name)
			fso.DeleteFile f, True
			delCtr = delCtr + 1
		End If 
	End If 
Next 

If delCtr = 0 Then
	delLogOut.WriteLine("No log files were deleted this run...")
End If

Set fld = Nothing 
Set fso = Nothing 

delLogOut.Close

End Sub

'If I put the script in its own file and run it from the command prompt, it runs just fine. If the script runs from the SQL Server Agent job, the for-loop will delete the files correctly, but the filenames do not get written to the deletion log file and the counter does not get incremented, so according to the job log, nothing was deleted. Why does the script run differently from each invocation? It can't be a permission thing, the service that logs in has full access to the directory and the files do get deleted. Any ideas out there?
'Between this and other outstanding issues, I'm quickly losing faith in SQL Server.  >=o(

'Thanks in advance for your thoughts!
'John

'Version Info:

'Microsoft SQL Server Management Studio      10.0.2531.0
'Microsoft Analysis Services Client Tools      10.0.1600.22
'Microsoft Data Access Components (MDAC)      3.85.1132
'Microsoft MSXML      2.6 3.0 4.0 5.0 6.0 
'Microsoft Internet Explorer      8.0.6001.18702
'Microsoft .NET Framework      2.0.50727.3603
'Operating System      5.1.2600