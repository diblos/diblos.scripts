set objShell = CreateObject("WScript.Shell")objShell.Run "RunAs /noprofile /user:domain\username ""cscript.exe \""C:\Development\VBS\monitor.vbs\"""""

wscript.sleep 1000 'milliseconds

strPassword = "something"
objShell.sendkeys strPassword
objShell.sendkeys "{enter}"