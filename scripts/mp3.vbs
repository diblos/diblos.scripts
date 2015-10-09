   Const ForReading = 1, ForWriting = 2, ForAppending = 8
    dim chk,fname,f,ts

     Set FSO = CreateObject("Scripting.FileSystemObject")
      Set folder = fso.GetFolder(".")
        fname = "Playlist"
                 fso.CreateTextFile (fname + ".txt")
                     Set f = fso.GetFile(fname + ".txt")
                       Set ts = f.OpenAsTextStream(ForWriting, 0 )
                       Set Fns = folder.files
                        For each f1 in Fns
                          chk = "mp3"
                             obj = right(f1.name, 3)
                                 comparevalue=StrComp(obj,chk, 1 )

                                     if comparevalue = 0 then ts.writeline  folder + "\" + f1.name + vbNewLine
                                     next
                                     ts.close

                                        Set SHELL = CreateObject("wscript.shell")
                                        Set readfile = FSO.OpenTextFile(fname + ".txt" , 1,0)
                                          Do while readfile.AtEndOfStream <> true
                                             contents = Trim(readfile.Readline)
                                                 If contents <> "" Then
                                                      Shell.Run "MPLAY32 /PLAY /CLOSE " & contents,3,True
                                                          End if
                                                            Loop 
