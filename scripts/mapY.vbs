' Map network drive script 
Set objNetwork = CreateObject("WScript.Network") 
objNetwork.MapNetworkDrive "y:" , "\\192.168.8.105\d$\ItacFE_SPB",True, "administrator", "12345"
'objNetwork.RemoveNetworkDrive "y:"