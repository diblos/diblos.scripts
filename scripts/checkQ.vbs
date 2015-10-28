' ///////////////////////////////////////////////////////////////////////////////
' // ActiveXperts Network Monitor  - VBScript based checks
' // � ActiveXperts Software B.V.
' //
' // For more information about ActiveXperts Network Monitor and VBScript, please
' // visit the online ActiveXperts Network Monitor VBScript Guidelines at:
' //    http://www.activexperts.com/support/network-monitor/online/vbscript/
' // 
' ///////////////////////////////////////////////////////////////////////////////
'  

Option Explicit
Const  retvalUnknown = 1
Dim    SYSDATA, SYSEXPLANATION  ' Used by Network Monitor, don't change the names


' ///////////////////////////////////////////////////////////////////////////////

' // To test a function outside Network Monitor (e.g. using CSCRIPT from the
' // command line), remove the comment character (') in the following 5 lines:
' Dim bResult
' bResult =  CheckQueueLength( "localhost", "", "private$\admin_queue$", 10 )
' WScript.Echo "Return value: [" & bResult & "]"
' WScript.Echo "SYSDATA: [" & SYSDATA & "]"
' WScript.Echo "SYSEXPLANATION: [" & SYSEXPLANATION & "]"

 Dim bResult
 bResult =  CheckQueueLength( "imt-p013", "", "private$\drsqueue", 10 )
 WScript.Echo "Return value: [" & bResult & "]"
 WScript.Echo "SYSDATA: [" & SYSDATA & "]"
 WScript.Echo "SYSEXPLANATION: [" & SYSEXPLANATION & "]"

' //////////////////////////////////////////////////////////////////////////////
   

' //////////////////////////////////////////////////////////////////////////////

Function CheckQueueLength ( strComputer, strCredentials, strQueue, nMaxLength ) 

' Description: 
'     Checks Ms Queue length on a (remote) computer. 
' Parameters:
'     1) strComputer As String  - Hostname or IP address of the computer you want to monitor
'     2) strCredentials As String - Specify an empty string to use Network Monitor service credentials.
'         To use alternate credentials, enter a server that is defined in Server Credentials table.
'         (To define Server Credentials, choose Tools->Options->Server Credentials)
'     3) strQueue As String - Queue that you want to monitor. Syntax: private$\queuename
'     4) nMaxLength As Number - Maximum allowed items in queue
' Usage:
'     CheckQueueLength( "", "", "", Max_Queue_Length )
' Sample:
'     CheckQueueLength( "localhost", "", "private$\admin_queue$", 10 )

    Dim   objWMIService

    CheckQueueLength    = retvalUnknown  ' Default return value
    SYSDATA             = ""             ' Will hold the actual CPU percentage value when the function returns
    SYSEXPLANATION      = ""             ' Set initial value

    If( Not getWMIObject( strComputer, strCredentials, objWMIService, SYSEXPLANATION ) ) Then
        Exit Function
    End If

    CheckQueueLength    = checkQueueLengthWMI ( objWMIService, strComputer, strQueue, nMaxLength, SYSDATA, SYSEXPLANATION )

End Function


' //////////////////////////////////////////////////////////////////////////////
' //
' // Private Functions
' //   NOTE: Private functions are used by the above functions, and will not
' //         be called directly by the ActiveXperts Network Monitor Service.
' //         Private function names start with a lower case character and will
' //         not be listed in the Network Monitor's function browser.
' //
' //////////////////////////////////////////////////////////////////////////////

Function checkQueueLengthWMI( objWMIService, strComputer, strQueue, nMaxLength, BYREF strSysData, BYREF strSysExplanation )

    Dim objQueue, collQueues, nQueueLength, nQueueBytes, nPos, strQueueName

    checkQueueLengthWMI            = retvalUnknown  ' Default return value

On Error Resume Next

    set collQueues          = objWMIService.ExecQuery( "select * from Win32_PerfRawData_MSMQ_MSMQQueue" ) 
    If( Err.Number <> 0 ) Then
        strSysData         = ""
        strSysExplanation  = "Unable to query Win32_PerfRawData_MSMQ_MSMQQueue on computer [" & strComputer & "]"
        Exit Function
    End If
    If( collQueues.Count <= 0  ) Then
        strSysData         = ""
        strSysExplanation  = "Win32_PerfRawData_MSMQ_MSMQQueue class does not exist on computer [" & strComputer & "]"
        Exit Function
    End If

On Error Goto 0

    For Each objQueue in collQueues
        If( Err.Number <> 0 ) Then
            checkQueueLengthWMI= retvalUnknown
            strSysExplanation  = "Unable to list queues on computer [" & strComputer & "]"
            Exit Function 
        End If

        ' NOTE: objQueue.Name is formatted like this: Server01\Private$\AdminQueue$
        ' However, we cannot use Server01 because hte user may have specified localhost, or 192.168.1.1 as computername
        ' So now, filter the queuename by stripping the 
        nPos = Instr( objQueue.Name, "\" )
        strQueueName = Mid( objQueue.Name, nPos + 1 )

	If( UCase( strQueueName ) = UCase( strQueue ) ) Then

            nQueueLength       = objQueue.MessagesInQueue
            nQueueBytes        = objQueue.BytesInQueue

            strSysData         = nQueueLength
            strSysExplanation  = "Queue length=[" & nQueueLength & "], maximum allowed=[" & nMaxLength & "]"

            If( nQueueLength > nMaxLength ) Then
              CheckQueueLengthWMI = False 
            Else
              CheckQueueLengthWMI = True 
            End If  
          
            Exit Function
        End If
    Next

    CheckQueueLengthWMI        = False
    strSysExplanation          = "Queue [" & strQueue & "] is not found on computer [" & strComputer & "]"

End Function


' //////////////////////////////////////////////////////////////////////////////

Function getWMIObject( strComputer, strCredentials, BYREF objWMIService, BYREF strSysExplanation )	

On Error Resume Next

    Dim objNMServerCredentials, objSWbemLocator, colItems
    Dim strUsername, strPassword

    getWMIObject              = False

    Set objWMIService         = Nothing
    
    If( strCredentials = "" ) Then	
        ' Connect to remote host on same domain using same security context
        Set objWMIService     = GetObject( "winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer &"\root\cimv2" )
    Else
        Set objNMServerCredentials = CreateObject( "ActiveXperts.NMServerCredentials" )

        strUsername           = objNMServerCredentials.GetLogin( strCredentials )
        strPassword           = objNMServerCredentials.GetPassword( strCredentials )

        If( strUsername = "" ) Then
            getWMIObject      = False
            strSysExplanation = "No alternate credentials defined for [" & strCredentials & "]. In the Manager application, select 'Options' from the 'Tools' menu and select the 'Server Credentials' tab to enter alternate credentials"
            Exit Function
        End If
	
        ' Connect to remote host using different security context and/or different domain 
        Set objSWbemLocator   = CreateObject( "WbemScripting.SWbemLocator" )
        Set objWMIService     = objSWbemLocator.ConnectServer( strComputer, "root\cimv2", strUsername, strPassword )

        If( Err.Number <> 0 ) Then
            objWMIService     = Nothing
            getWMIObject      = False
            strSysExplanation = "Unable to access [" & strComputer & "]. Possible reasons: WMI not running on the remote server, Windows firewall is blocking WMI calls, insufficient rights, or remote server down"
            Exit Function
        End If

        objWMIService.Security_.ImpersonationLevel = 3

    End If
	
    If( Err.Number <> 0 ) Then
        objWMIService         = Nothing
        getWMIObject          = False
        strSysExplanation     = "Unable to access '" & strComputer & "'. Possible reasons: no WMI installed on the remote server, no rights to access remote WMI service, or remote server down"
        Exit Function
    End If    

    getWMIObject              = True 

End Function

' //////////////////////////////////////////////////////////////////////////////
