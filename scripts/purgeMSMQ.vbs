Option Explicit
'==================== Declarations
const MQ_RECEIVE_ACCESS = 1
const MQ_DENY_NONE = 0

const MQ_NO_TRANSACTION = 0
const MQ_MTS_TRANSACTION = 1
const MQ_SINGLE_MESSAGE = 3

const ForReading = 1
const TristateTrue = -1
const TristateFalse = 0

const g_receiveTimeout = 1000
'==================== Declarations
dim queueName, isTransactional
'dim args
'Set args = WScript.Arguments

'arg1 = args.Item(0)

'arg2 = args.Item(1)

queueName = "itacmanager"'"idsqueue"
isTransactional = false

'=====================================
'PurgeQueue queueName, isTransactional

PurgeQueue "alarmqueue", isTransactional
PurgeQueue "etqueue", isTransactional
'PurgeQueue "itac_avl_raw0", isTransactional
PurgeQueue "vdsqueue", isTransactional
PurgeQueue "vmsqueue", isTransactional

'WScript.Echo ubound(args)
'=====================================
public sub PurgeQueue(queueName, isTransactional)
	WScript.Echo "Purging queue: queueName=" & queueName


	dim messageCount
	dim queueInfo
	dim queue
	dim transactionLevel

	transactionLevel = MQ_NO_TRANSACTION

	if isTransactional then transactionLevel = MQ_SINGLE_MESSAGE

	messageCount = 0

	set queueInfo = CreateObject("MSMQ.MSMQQueueInfo")
	queueInfo.PathName = ".\private$\" & queueName

	set queue = queueInfo.Open (MQ_RECEIVE_ACCESS, MQ_DENY_NONE)

	do while true

		dim msg 
		set msg = queue.Receive(transactionLevel, False, False, g_receiveTimeout, False)

		if msg is nothing then
			WScript.Echo "Removed " & messageCount & " messages. No more messages."
			queue.Close
			exit sub
		end if

		messageCount = messageCount + 1

	loop



end sub