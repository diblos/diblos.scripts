Set Wshshell=CreateObject("Word.Basic")
WshShell.sendkeys"%{prtsc}"
WScript.Sleep 1500

set Wshshell = WScript.CreateObject("WScript.Shell")
Wshshell.Run "mspaint",1
WScript.Sleep 500

WshShell.AppActivate "Paint"
WScript.Sleep 500

WshShell.sendkeys "^(v)"
WScript.Sleep 500

wshshell.sendkeys "^(s)"
wscript.sleep 500

wshshell.sendkeys "d:\test.bmp"
wscript.sleep 500

'==========================
'wshshell.sendkeys "{ESC}"
'wshshell.sendkeys "%f"
'wshshell.sendkeys "x"
'wshshell.sendkeys "n"
'==========================
wshshell.sendkeys "%t"
wscript.sleep 500

wshshell.sendkeys "1"
wscript.sleep 500

wshshell.sendkeys "{ENTER}"
wscript.sleep 500

wshshell.sendkeys "y"
wshshell.sendkeys "%{F4}"

Set wshshell = Nothing

wscript.Quit