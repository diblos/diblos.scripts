set objShell = CreateObject("WScript.Shell")
objShell.Run "RunAs /noprofile /user:itac\bakhtiar ""z:"""

wscript.sleep 5000 'milliseconds

strPassword = "12345"
objShell.sendkeys strPassword
objShell.sendkeys "{enter}"