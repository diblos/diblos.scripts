dim paint

Set wshShell = CreateObject("Wscript.Shell")

set paint = wshShell.exec("mspaint")
do while paint.status = 0:loop
wshShell.appactivate("untitled-Paint")'this returns false
Wscript.sleep 500
WshShell.SendKeys "^v"
wscript.sleep 500
wshshell.sendkeys "^s"
wscript.sleep 500
wshshell.sendkeys "d:\test.png"
wscript.sleep 500
wshell.sendkeys "{Enter}"
Set wshshell = Nothing