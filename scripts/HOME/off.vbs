Dim x
Dim y

set oShell = createobject("wscript.shell")

    x = msgbox("Would you like to shutdown your PC after a period of time?",vbYesNo,"Automatic Shutdown")
        
        if x = 6 then
        y = InputBox("Enter time left for shutdown to occur automatically(time in minutes...):","Automatic Shutdown")
        oShell.Run "shutdown.exe -s -t " & (y * 60) & " -f -c ""System is now set for automatic shutdown!"""
        end if 
        if x = 7 then
        oShell.run "shutdown.exe -a"
        end if 
        
       
