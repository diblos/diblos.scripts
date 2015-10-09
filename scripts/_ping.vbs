'PING-IP-to-Excel 
'IPtoHostname---or---HostnametoIP 
' 
'Inspiredby:TorgeirBakken(MVP) 
'http://groups.google.com/group/microsoft.public.scripting.vbscript/msg/a465907f8dc6e265?pli=1 
' 
'Author:AngelCruz,angelcruzpr@live.com 
'ScripttogetalistofhostnamesorIP'sfromatexfileandreturnanExcelWorksheetwith 
' 
'HOSTNAMEIPRESULTLATENCY 
'----------------------- 
' 
'UsingonlyPINGatthecommandprompt 
' 
'Version7.0Jan/16/2011 
' 
DimstrHostname,strIP,strPingResult,IntLatency 
 
intRow=2 
SetobjExcel=CreateObject("Excel.Application") 
 
With objExcel 
 
.Visible=True 
.Workbooks.Add 
 
.Cells(1,1).Value="XXXXXXXXXXXXXXXXXXXXXXXXXXX" 
.Cells(1,2).Value="XXXXXXXXXXXXXX" 
.Cells(1,3).Value="XXXXXXX" 
.Cells(1,4).Value="XXXXXXX" 
 
.Range("A1:D1").Select 
.Cells.EntireColumn.AutoFit 
 
.Cells(1,1).Value="Hostname" 
.Cells(1,2).Value="IP" 
.Cells(1,3).Value="Result" 
.Cells(1,4).Value="Latency" 
 
End With 
 
'---InputTextFilewitheitherHostamesorIP's--- 
SetFso=CreateObject("Scripting.FileSystemObject") 
SetInputFile=fso.OpenTextFile("c:\users\alcruz\desktop\MachineList.Txt") 
 
Do While Not(InputFile.atEndOfStream)
 
strHostname=InputFile.ReadLine 
 
SetWshShell=WScript.CreateObject("WScript.Shell") 
 
'CallPINGlookup(strHostname,strIP,strPingResult,intLatency) 
CallPINGlookup strHostname,strIP,strPingResult,intLatency
 
With objExcel 
.Cells(intRow,1).Value=strHostname 
.Cells(intRow,2).Value=strIP 
.Cells(intRow,3).Value=strPingResult 
.Cells(intRow,4).Value=intLatency 
End With 
 
intRow=intRow+1 
 
Loop 
 
With objExcel 
.Range("A1:D1").Select 
.Selection.Interior.ColorIndex=19 
.Selection.Font.ColorIndex=11 
.Selection.Font.Bold=True 
.Cells.EntireColumn.AutoFit 
End With 
 
 
'-------------SubrutinesandFunctions---------------- 
 
'SubPINGlookup(ByRefstrHostname,ByRefstrIP,ByRefstrPingResult,ByRefintLatency) 
SubPINGlookup ByRefstrHostname,ByRefstrIP,ByRefstrPingResult,ByRefintLatency 

'BothIPaddressandDNSnameisallowed 
'Functionwillreturntheopposite 
 
'CheckiftheHostnameisanIP 
SetoRE=NewRegExp 
oRE.Pattern="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" 
 
'SortoutifIPorHostname 
strMachine=strHostname 
bIsIP=oRE.Test(strMachine) 
If bIsIP Then 
strIP=strMachine 
strHostname="-------" 
Else 
strIP="-------" 
strHostname=strMachine 
End If 
 
 
'Getatempfilenameandopenit 
SetosShell=CreateObject("Wscript.Shell") 
SetoFS=CreateObject("Scripting.FileSystemObject") 
sTemp=osShell.ExpandEnvironmentStrings("%TEMP%") 
sTempFile=sTemp&"\"&oFS.GetTempName 
 
'PINGandcheckiftheIPexists 
intT1=Fix(Timer*1000) 
osShell.Run"%ComSpec%/cping-a"&strMachine&"-n1>"&sTempFile,0,True 
intT2=Fix(Timer*1000) 
intLatency=Fix(intT2-intT1)/1000 
 
 
'OpenthetempTextFileandReadouttheData 
SetoTF=oFS.OpenTextFile(sTempFile) 
 
'Parsethetemptextfile 
strPingResult="-------"'assumefailedunless... 
Do While Not oTF.AtEndoFStream 
 
strLine=Trim(oTF.Readline) 
If strLine="" Then 
strFirstWord="" 
Else 
arrStringLine=Split(strLine,"",-1,1) 
strFirstWord=arrStringLine(0) 
End If 
 
Select Case strFirstWord 
 
Case "Pinging" 
If arrStringLine(2)="with" Then 
strPingResult="-------" 
strHostname="-------" 
Else 
strHostname=arrStringLine(1) 
strIP=arrStringLine(2) 
strLen=Len(strIP)-2 
strIP=Mid(strIP,2,strLen) 
strPingResult="Ok" 
End If 
Exit Do 
'EndCase 
 
Case "Ping"'pingingnonexistenthostname 
strPingResult="------" 
Exit Do 
'EndCase 
 
End Select 
 
Loop 
 
'Closeit 
oTF.Close 
'DeleteIt 
oFS.DeleteFilesTempFile 
 
 
End Sub