Set IE = CreateObject("InternetExplorer.Application") 
set WshShell = WScript.CreateObject("WScript.Shell")  
IE.Navigate "http://mail.itramas.com/Login.aspx"
IE.Visible = True 
Wscript.Sleep 3000
IE.Document.All.Item("ctl00$MPH$txtUserName").Value = "bakhtiar.ahmad@itramas.com"
IE.Document.All.Item("ctl00$MPH$txtPassword").Value = "++asdf8ASDF" 
IE.Document.All.Item("ctl00$MPH$btnEnterClick").Click
'WshShell.AppActivate "IE"
'WshShell.SendKeys "{ENTER}"