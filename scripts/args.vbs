Dim FormatName
FormatName = WScript.Arguments.Named("f")
Nama = WScript.Arguments.Named("n")
If FormatName = "" Then
Wscript.Quit
Else
WScript.Echo FormatName
WScript.Echo Nama
End If

'********************************************************************
'	cscript args.vbs /f:hukum
'	cscript args.vbs /f:sdsdsds /n:ahdkahdka
'********************************************************************