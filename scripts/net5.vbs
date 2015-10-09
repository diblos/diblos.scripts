set objShell = CreateObject("WScript.Shell")
objShell.Run "\\itacfilesvr\User Folders\bakhtiar"

wscript.sleep 5000 'milliseconds

strPassword = "12345"
objShell.sendkeys strPassword
objShell.sendkeys "{enter}"