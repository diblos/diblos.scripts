const HKEY_LOCAL_MACHINE = &H80000002
strChr = string(2,chr(10))
Dim strIndex
Set objGetService = GetObject("winmgmts:\\" & "." & "\root\cimv2")
set objArray = objGetService.ExecQuery _
("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")

For Each objItem in objArray
strCurrentMAC = objItem.MACAddress
strCaption = objItem.Description
strIndex = objItem.Index
strSelectNIC = MsgBox("Is this the NIC you want to select? " & strChr & strCaption,36,"Mac Assasin")
wscript.sleep 500

if strSelectNIC = 6 then
Exit For
End if
Next
 

Set colItems = objGetService.ExecQuery _
("Select * From Win32_NetworkAdapter Where Index =" & strIndex & "")

For Each objItem in colItems

strNetID = objItem.NetConnectionID

Next

strMac = Replace(strCurrentMAC,":","")
strInput = InputBox(strCaption & strChr & "Curent MAC Address: " &_
strMac & strChr & "Enter New MAC Address:","MAC Assasin", strMac)

if strInput <> "" Then

Set objGetReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &_
"." & "\root\default:StdRegProv")

strKeyPath = "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"

objGetReg.SetStringValue HKEY_LOCAL_MACHINE,strKeyPath & "\00" & strIndex,"NetworkAddress",strInput

RebootNIC()

if RebootNIC = "En&able" then

RebootNIC()

End if
End if

Function RebootNIC ()

set objShell = CreateObject("Shell.Application")
set objFolder = objShell.Namespace(3)

For Each objFolderItem in objFolder.items
if objFolderItem.name = "Network Connections" then
set objfolderNC = objFolderItem.getfolder
Exit For
End if
Next

For Each objFolderItem in objfolderNC.items
If Instr(objFolderItem.name,strNetID) Then
set objfolLAC = objFolderItem

Exit For
End if
Next

For Each objVerb in objfolLAC.verbs
if objVerb.name = "Disa&ble" then
objVerb.DoIt
RebootNIC = "En&able"
Exit for
End if

if objVerb.name = "En&able" then
objVerb.DoIt
Exit for
End if
Next

wscript.sleep 2000

End Function
