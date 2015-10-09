api_key = "qmoe3ahh8kd7qpuyin8sukf3k6c5v3qq"
BoxNetUserName = "diblos@gmail.com"
BoxNetPwd = "100nokiss"

UploadFileBoxNet("d:\test\try.bmp") 

Function UploadFileBoxNet(filePath)

 'Print filepath
 wscript.echo filepath

     Set WinHttpReq = CreateObject("Msxml2.ServerXMLHTTP")

 '**********Requesting Ticket
  strURL = "https://www.box.net/api/1.0/rest?action=get_ticket&api_key=" & api_key
  temp = WinHttpReq.Open("POST", strURL, false)
  WinHttpReq.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  WinHttpReq.Send()
  getTicket = WinHttpReq.ResponseText
  'Print strURL
  'Print getTicket
  wscript.echo strURL
  wscript.echo getTicket
    
 '**********Extracting Ticket from XML Response********
  getTicket = Left(getTicket,Len(getTicket)-20)
  getTicket = Right(getTicket,Len(getTicket) - Instr(getTicket,"t>")-1)
  'Print getTicket
  wscript.echo getTicket

 '****Opening Authentication Window for Box.net********
  'Systemutil.Run "iexplore", "https://www.box.net/api/1.0/auth/" & getTicket  
  Set WshShell = WScript.CreateObject("WScript.Shell")
  WshShell.Run "iexplore " & "https://www.box.net/api/1.0/auth/" & getTicket,1,True
  Browser("name:=Box.net.*").WebEdit("name:=login").Set BoxNetUserName
  Browser("name:=Box.net.*").WebEdit("name:=password").Set BoxNetPwd
  Browser("name:=Box.net.*").WebElement("name:=Login","height:=25").Click
  Browser("name:=Box.net.*").Sync
  Browser("name:=Box.net.*").Close

 '*****Requesting Auth_Token
  strUrl = "https://www.box.net/api/1.0/rest?action=get_auth_token&api_key=" & api_key & "&ticket=" & getTicket
  temp = WinHttpReq.Open("POST", strURL, false)
  WinHttpReq.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  WinHttpReq.Send()
  Auth_Token = WinHttpReq.ResponseText
  'Print strURL
  wscript.echo strURL

 '******Parsing Auth Token from XML Response
  Set xmlObj = XMLUtil.CreateXML()
  xmlObj.Load Auth_Token
  'Print xmlObj.ToString()
  'Print " ========================================================================= "
  wscript.echo xmlObj.ToString()
  wscript.echo " ========================================================================= "
  Set myToken = xmlObj.ChildElementsByPath("/response/auth_token")
  'Print myToken.Count
  wscript.echo myToken.Count
  For i = 1 to myToken.Count
     Auth_Token = myToken.Item(i).Value()
     'Print Auth_Token
     'Print " "
	 wscript.echo Auth_Token
	 wscript.echo " "
  Next

  strURL = "https://upload.box.net/api/1.0/upload/" & Auth_Token & "/0"

 '*****Calling the Upload File method of the .Net Class System.Net.WebClient
  Set wcl = DotNetFactory.CreateInstance ("System.Net.WebClient")
  strResult = wcl.UploadFile(strURL, filepath)

End Function