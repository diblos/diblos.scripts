Set WshShell = WScript.CreateObject("WScript.Shell")

'WshShell.Run "%windir%\notepad.exe"
Wscript.Sleep 2000 'wait 2 seconds
WshShell.AppActivate "Login"

WshShell.SendKeys "+A"
WshShell.SendKeys "dministrator"
WshShell.SendKeys "{TAB}"  'send Tab
WshShell.SendKeys "12345"
WshShell.SendKeys "{ENTER}"