' Map network drive script 
Set objNetwork = CreateObject("WScript.Network") 
objNetwork.MapNetworkDrive "i:" , "\\imtwebsvr\d$\WebApps",True, "itac\administrator", "se@cureimt6897"
'objNetwork.RemoveNetworkDrive "i:"