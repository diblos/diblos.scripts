' Map network drive script 
Set objNetwork = CreateObject("WScript.Network") 
objNetwork.MapNetworkDrive "Z:" , "\\itacfilesvr\User Folders\bakhtiar",True, "itac\bakhtiar", "itramas"
'objNetwork.RemoveNetworkDrive "Z:"