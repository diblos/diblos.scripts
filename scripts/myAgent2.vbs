strAgentName = "Merlin"
strAgentPath = "C:\Windows\Msagent\Chars\" & strAgentName & ".acs"
Set objAgent = CreateObject("Agent.Control.2")

 objAgent.Connected = TRUE
 objAgent.Characters.Load strAgentName, strAgentPath
 Set objCharacter = objAgent.Characters.Character(strAgentName)

  objCharacter.Show
  Set objRequest = objCharacter.Play("DoMagic1")
  Set objRequest = objCharacter.Play("DoMagic2")

       Wscript.Sleep 100

        Set objRequest = objCharacter.Speak _
            ("Go Ahead Type in any date and I will tell you the day it will be")

                 Set objRequest = objCharacter.Play("Think")

                   Wscript.Sleep 10000

                    strAnswer = InputBox("Enter Your Date like This Month Day Year:", _
                        "intDay")
                        If strAnswer = "" Then
                            Wscript.Quit
                            Else
                                'Wscript.Echo strAnswer
                                End If

                                 intDay = DatePart("w", strAnswer)

                                  Set objRequest = objCharacter.Play("Search")
                                  Set objRequest = objCharacter.Play("Uncertain")

                                   Set objRequest = objCharacter.Speak _
                                       ("Like Staples says...That was Easy!!")

                                            Set objRequest = objCharacter.Play("Pleased")
                                            Set objRequest = objCharacter.Play("DontRecognize")

                                             Set objRequest = objCharacter.Speak _
                                                 ("Who's your Daddy??")
                                                 Set objRequest = objCharacter.Play("Idle3_1")
                                                 Set objRequest = objCharacter.Play("Idle3_2")

                                                  Wscript.Sleep 12000
                                                  Select Case intDay
                                                      Case 1
                                                              'Wscript.Echo "Sunday"
                                                                      strMessage = "Sunday"
                                                                              Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                  Case 2
                                                                                          'Wscript.Echo "Monday"
                                                                                                  strMessage = "Monday"
                                                                                                          Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                                              Case 3
                                                                                                                      'Wscript.Echo "Tuesday"
                                                                                                                              strMessage = "Tuesday"
                                                                                                                                      Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                                                                          Case 4
                                                                                                                                                  'Wscript.Echo "Wednesday"
                                                                                                                                                          strMessage = "Wednesday"
                                                                                                                                                                  Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                                                                                                      Case 5
                                                                                                                                                                              'Wscript.Echo "Thursday"
                                                                                                                                                                                      strMessage = "Thursday"
                                                                                                                                                                                              Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                                                                                                                                  Case 6
                                                                                                                                                                                                          'Wscript.Echo "Friday"
                                                                                                                                                                                                                  strMessage = "Friday"
                                                                                                                                                                                                                          Msgbox strMessage, 0, "Here's Your Special Day!!"
                                                                                                                                                                                                                              Case 7
                                                                                                                                                                                                                                      'Wscript.Echo "Saturday"
                                                                                                                                                                                                                                              strMessage = "Saturday"
                                                                                                                                                                                                                                                      Msgbox strMessage, 0, "Here's Your Special Day!!"

                                                                                                                                                                                                                                                                       Set objRequest = objCharacter.Speak _
                                                                                                                                                                                                                                                                           (intDay)

                                                                                                                                                                                                                                                                                   Wscript.Sleep 900





                                                                                                                                                                                                                                                                                            End Select 
