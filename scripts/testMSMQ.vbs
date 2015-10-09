Option Explicit 

Const MQ_RECEIVE_ACCESS = 1 
Const MQ_SEND_ACCESS = 2 
Const MQ_DENY_NONE = 0 
Const MQ_PEEK_ACCESS = 32 

Dim Transaction
 
Dim FormatName
FormatName = WScript.Arguments.Named("f")
If FormatName = "" Then
Help()
Wscript.Quit
End If
 
Dim MSMQQueueInfo 
Set MSMQQueueInfo = CreateObject("MSMQ.MSMQQueueInfo")
MSMQQueueInfo.FormatName = FormatName 

If MSMQQueueInfo.IsTransactional2 Then
Transaction = 3 'MQ_SINGLE_MESSAGE
Else
Transaction = 0 'MQ_NO_TRANSACTION
End If
 
Dim MSMQQueue
Set MSMQQueue = CreateObject("MSMQ.MSMQQueue")
 
Dim MSMQMessage
Set MSMQMessage = CreateObject("MSMQ.MSMQMessage")
 
Select Case WScript.Arguments(0)
 Case "/send"
  Set MSMQQueue = MSMQQueueInfo.Open(MQ_SEND_ACCESS, MQ_DENY_NONE)
  MSMQMessage.Body = "Testing Message Queue"
  MSMQMessage.Label = "SampleApp"
  MSMQMessage.Send MSMQQueue, Transaction 
  WScript.Echo "Message Sent"
 Case "/peek"
  Set MSMQQueue = MSMQQueueInfo.Open(MQ_PEEK_ACCESS, MQ_DENY_NONE)
  WScript.Echo "If queue is empty, the command will wait until a message comes into queue"
  WScript.Echo "Receiving Message....."
  Set MSMQMessage = MSMQQueue.Peek 
  WScript.Echo "Label: " & CStr (MSMQMessage.Label) 
  WScript.Echo "Body: " & CStr (MSMQMessage.Body) 
  WScript.Echo "Received Message"
 
 Case "/receive"
  Set MSMQQueue = MSMQQueueInfo.Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE)
  WScript.Echo "If queue is empty, the command will wait until a message comes into queue"
  WScript.Echo "Receiving Message....."
  Set MSMQMessage = MSMQQueue.Receive 
  WScript.Echo "Label: " & CStr (MSMQMessage.Label) 
  WScript.Echo "Body: " & CStr (MSMQMessage.Body) 
  WScript.Echo "Received Message"
 
 Case else
  Help()
End Select

Function Help()
  Wscript.Echo "Usage:" & vbCrLf & vbCrLf _
   & "msmq.vbs /send [ /f:DIRECT=OS:machine\private$\test]" & vbCrLf _
   & "msmq.vbs /peek [ /f:DIRECT=OS:machine\private$\test]" & vbCrLf _
   & "msmq.vbs /receive [ /f:DIRECT=OS:machine\private$\test]"
End Function