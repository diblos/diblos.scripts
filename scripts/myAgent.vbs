'
' MyAgent.vbs written by John Papproth
' Creates an instance of the default Microsoft Agent Character
' Demonstrates several methods of the control.
'
'
Dim myAgent
Dim myRequest
Dim myCharacter
Dim myActor

 myActor="MyCharacter!"

  set myAgent = CreateObject("Agent.Control.2")
  myAgent.Connected = true

   set myRequest = myAgent.Characters.Load(myActor)

    set myCharacter = myAgent.Characters(myActor)

     myCharacter.Show()
     myCharacter.Listen(true)
     myCharacter.MoveTo 350,350
     myCharacter.Speak("Hello!")

      Msgbox "Click ok to end!",vbOkOnly+vbInformation,"Speech input" ' : " & myCharacter.SpeechInput.Enabled 
