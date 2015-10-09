' Map network drive script 
Set objNetwork = CreateObject("WScript.Network") 
objNetwork.MapNetworkDrive "X:" , "\\192.168.8.39\D$\ItacSystem",True, "pb2x-coresvr\administrator", "123@qwe"
'objNetwork.RemoveNetworkDrive "X:"