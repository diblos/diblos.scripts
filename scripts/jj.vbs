Set WshShell = WScript.CreateObject("WScript.Shell")

WshShell.Run "%windir%\notepad.exe"
Wscript.Sleep 2000 'wait 2 seconds
WshShell.AppActivate "Notepad"

WshShell.SendKeys "v Hello World!"
WshShell.SendKeys "{ENTER}"
WshShell.SendKeys "abc"
WshShell.SendKeys "{CAPSLOCK}"
WshShell.SendKeys "def"