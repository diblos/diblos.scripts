Set IE = CreateObject("InternetExplorer.Application") 
set WshShell = WScript.CreateObject("WScript.Shell")  
IE.Navigate "http://imtwebsvr/imtpopr/"
IE.Visible = True 
Wscript.Sleep 4000
IE.Document.All.Item("ctl00$ContentPlaceHolder1$txtUsername").Value = "bakhtiar.ahmad" 
IE.Document.All.Item("ctl00$ContentPlaceHolder1$txtPassword").Value = "12345" 
IE.Document.All.Item("ctl00$ContentPlaceHolder1$ImageButton1").Click
'WshShell.AppActivate "IE"
'WshShell.SendKeys "{ENTER}"