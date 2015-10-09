Set IE = CreateObject("InternetExplorer.Application") 
set WshShell = WScript.CreateObject("WScript.Shell")  
IE.Navigate "http://192.168.8.254/TimeTracker/desktopdefault.aspx?ReturnUrl=/timetracker/default.aspx"
IE.Visible = True 
Wscript.Sleep 3000
IE.Document.All.Item("Btnsignin:email").Value = "bakhtiar.ahmad@itramas.com"
IE.Document.All.Item("Btnsignin:password").Value = "12345" 
IE.Document.All.Item("Btnsignin:Btnsignin").Click
'WshShell.AppActivate "IE"
'WshShell.SendKeys "{ENTER}"