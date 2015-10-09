Set objSW=CreateObject("Shell.Application")
  Set objSW=objSW.Windows

  for i=1 to objSW.Count-1
    If objSW(i).LocationURL="http://www.google.com" then
      Set myBrowser=objSW(1)
    End If
  next

  If IsObject(myBrowser) Then
   wscript.echo "Google found"
  Else
   wscript.echo "Google not found"
  End If