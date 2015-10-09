REM TMS Flux DB
REM TMS Flux Input Grid
REM TMS Flux Process Grid
REM TMS Flux Server Grid

option explicit

Dim strComputer,strServiceName
REM strComputer = "." ' Local Computer
REM strServiceName = "wuauserv" ' Windows Update Service
strComputer = "ITAC-P023" ' Local Computer
strServiceName = "ITAC Speed Demon" ' Windows Update Service

REM if isServiceRunning(strComputer,strServiceName) then
	REM wscript.echo "The '" & strServiceName & "' service is running on '" & strcomputer & "'"
REM else
	REM wscript.echo "The '" & strServiceName & "' service is NOT running on '" & strcomputer & "'"
REM end if

do while isServiceRunning(strComputer,strServiceName) = false
	WScript.Sleep 10000	
loop

dim WSshell
set WSshell = createobject("wscript.shell")
WSshell.run "c:\windows\notepad.exe",1

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