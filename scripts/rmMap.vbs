   Dim objNetwork
   Set objNetwork = CreateObject("WScript.Network")
   objNetwork.MapNetworkDrive "I:", "\\print_server\hp_01","True","jdoe","jdoepassword"
   objNetwork.RemoveNetworkDrive "I:"