Set WshNetwork = WScript.CreateObject("WScript.Network")
Set oDrives = WshNetwork.EnumNetworkDrives

For i = 0 to oDrives.Count - 1 Step 2
   WScript.Echo "Drive " & oDrives.Item(i) & " = " & oDrives.Item(i+1)
Next