'********************************************************************
'* File:        services.vbs
'* Purpose:     display service information on a computer using WMI 
'* Requires:    WMI to be installed on server specified
'* Revisions:   Initial development - 01/08/01, tonymu
'* Disclaimer:  This code is to be used for sample purposes only
'*              Microsoft does not guarantee its functionality
'********************************************************************
'Known Issues:
'   The following error will be returned if WMI is not installed
'        <path-to>\services.vbs(23, 1) Microsoft VBScript runtime error: ActiveX component can't create object: 'GetObject'

REM Dim oArgs, strServerName, oServiceSet, oWshNetwork
REM Dim counter

REM Set oArgs = WScript.Arguments
REM If oArgs.Count > 0 Then
   REM strServerName = trim(oArgs(0))
REM Else
   REM 'strServerName = "LocalHost"
   REM strServerName = "itac-p023"
REM End If
REM Set oServiceSet = GetObject("winmgmts:{impersonationLevel=impersonate}!//" & strServerName & "/root/cimv2").InstancesOf("Win32_Service")
REM If strServerName = "LocalHost" Then
   REM Set oWshNetwork = WScript.CreateObject("WScript.Network")
   REM WScript.Echo "Service Information retrieved from " & oWshNetwork.ComputerName
   REM Set oWshNetwork = Nothing
REM Else
   REM WScript.Echo "Service Information retrieved from " & strServerName
REM End If
REM WScript.Echo String(75, "_")
REM For each Service in oServiceSet
	REM WScript.Echo
	REM WScript.Echo "   " & Service.Description
	REM WScript.Echo "      Short Name:    " & Service.Name 
	REM WScript.Echo "      Current State: " & Service.State
	REM counter=counter+1
REM Next
REM WScript.Echo String(75, "_")
REM WScript.Echo counter
REM Set oServiceSet = Nothing

option explicit

Dim strComputer,strServiceName
strComputer = "." ' Local Computer
REM strServiceName = "wuauserv" ' Windows Update Service
REM strComputer = "POLRI-DBASVR" ' Local Computer
strServiceName = "Itac.BE.LDD" ' Windows Update Service

if isServiceRunning(strComputer,strServiceName) then
	wscript.echo "The '" & strServiceName & "' service is running on '" & strcomputer & "'"
else
	wscript.echo "The '" & strServiceName & "' service is NOT running on '" & strcomputer & "'"
end if

' Function to check if a service is running on a given computer
function isServiceRunning(strComputer,strServiceName)
	Dim objWMIService, strWMIQuery

	strWMIQuery = "Select * from Win32_Service Where Name = '" & strServiceName & "' and state='Running'"

	Set objWMIService = GetObject("winmgmts:" _
		& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

	if objWMIService.ExecQuery(strWMIQuery).Count > 0 then
		isServiceRunning = true
	else
		isServiceRunning = false
	end if

end function