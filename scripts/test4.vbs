strComputer = "."

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
set colAdapters = objWMIService.Execquery("Select * from Win32_NetworkAdapter")
For Each Adapter in colAdapters
'if (Adapter.NetConnectionStatus = 7) Then
'Adapter.Disable()
'wscript.echo "V"
wscript.echo Adapter.Name
'end if
Next
