Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3
'================================================================================================================================================================
'Const strConn = "DSN=dsn;UID=tmp;PWD=tmp;"
'Const strConn = "Driver={PostgreSQL UNICODE};Server=202.71.100.92;Port=5432;Database=telemetry;Uid=tmp;Pwd=tmp;"
'Const strConn = "Driver={SQL Native Client};Server=202.71.100.80;Database=telemetry;Uid=sa;Pwd=sa123;"
'Const strConn_2 = "Data Source=202.71.100.80,1433;Network Library=DBMSSOCN;Initial Catalog=telemetry;User ID=sa;Password=sa123;"
'================================================================================================================================================================
'---------- Connection ZERO
Const strConn_0 = "Driver={PostgreSQL UNICODE};Server=127.0.0.1;Port=5432;Database=telemetry;Uid=postgres;Pwd=postgres;"
'---------- Connection ZERO
'----------- Connection ONE
'Const strConn_1 = "DSN=abb;Initial Catalog=MeterData;User ID=sa;Password=sa;"
'Const strConn_1 = "DSN=nrw;Initial Catalog=SYAMeterData;User ID=sa;Password=sa;"
'Const strConn_1 = "user id=sa; password=sa; data source=abb; initial catalog=MeterData;"
'Const strConn_1 = "Driver={SQL Native Client};Server=ITAC-P023\LLM2;Database=LLMWEB;Uid=sa;Pwd=123qwe;"
Const strConn_1 = "Driver={Oracle in XE};dbq=192.168.8.117:1521/itac;Uid=isecurefgt;Pwd=isecurefgt;"
'----------- Connection ONE
'----------- Connection TWO
'Const strConn_2 = "Driver={PostgreSQL UNICODE};Server=127.0.0.1;Port=5432;Database=telemetry_twin;Uid=postgres;Pwd=postgres;"
'Const strConn_2 = "Driver={PostgreSQL UNICODE};Server=202.71.102.124;Port=5432;Database=telemetry;Uid=tmp;Pwd=tmp;"
'Const strConn_2 = "DSN=abb;Initial Catalog=MeterData;User ID=sa;Password=sa;"
'Const strConn_2 = "Driver={SQL Native Client};Server=ITAC-P023\LLM2;Database=Copy_LLMWEB;Uid=sa;Pwd=123qwe;"
Const strConn_2 = "Driver={Oracle in XE};dbq=192.168.8.112:1521/xe;Uid=idu;Pwd=idu;"
'----------- Connection TWO
'================================ Global Telemetics ================================================================================================================

'Wscript.Echo GetWaterLevel("R101",48)
'Wscript.Echo RTUStatusCheck("9003",2)
'Wscript.Echo GetSiteInfo("R101","nama")
'Wscript.Echo GetEquipTimestamp("R101")
'call main1
'call Load_Records
'call reconcile_TotalsData
Load_Records
'=============================== START OF RECONCILIATIONS CALL PART ================================
		' AUTO-NUMBERED FIELD SHOULD'NT BE INCLUDED!
		'call reconcile_test("SELECT [Counter_Type],[Date],[Count]  FROM [Counter_Log] ORDER  BY [Id],[Date]","[Id]","[Date]")
		'call reconcile_test(replace("SELECT  #LOG_ID#,#LOG_DATETIME#,#CLIENT_CODE#,#ZONE_CODE#,#STATUS#,#REF_POINT#,#EVENT_TYPE#,#SOURCE#,#EQUIP_CODE#,#DESCRIPTION#,#ARCHIVE_FLAG#,#INCIDENT_LOG#,#ASSIGNED_TO#,#LOCATION_CODE#,#STATE_CODE#  FROM MASTER_EVENT_LOG ORDER BY #ID#,#LOG_DATETIME#;","#",chr(34)), chr(34) & "ID" & chr(34), chr(34) & "LOG_DATETIME" & chr(34))
		
		'Wscript.Echo replace("SELECT  #LOG_ID#,#LOG_DATETIME#,#CLIENT_CODE#,#ZONE_CODE#,#STATUS#,#REF_POINT#,#EVENT_TYPE#,#SOURCE#,#EQUIP_CODE#,#DESCRIPTION#,#ARCHIVE_FLAG#,#INCIDENT_LOG#,#ASSIGNED_TO#,#LOCATION_CODE#,#STATE_CODE#  FROM MASTER_EVENT_LOG ORDER BY #ID#,#LOG_DATETIME#;","#",chr(34))
		
		'call reconcile_dispatch_list
		'**call reconcile_equipment_list ' column name problem
		'call reconcile_rule_list		
		'call reconcile_unit_list
		'call reconcile_site_list
		
		'call reconcile_append_unit_list
'=============================== END OF RECONCILIATIONS CALL PART ==================================

'======================================== THE FUNCTIONS ==============================================
Public sub main1()
On Error Resume Next


End sub
'=============================== BEGIN OF RECONCILIATIONS PART =====================================

Public Function reconcile_test(strSQL,firstCOMP,secondCOMP)
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	
	objRecordSet_1.Open strSQL, objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open strSQL, objConnection_2, adOpenStatic, adLockOptimistic	

		'for each x in objRecordset_1.Fields
		'	Wscript.Echo x.name & "-" & objRecordset_1.Fields.Item(x.name)
		'next	

		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					'cari = objRecordset_1.Fields.Item("versionid")
					objRecordset_2.Find firstCOMP & "='" & objRecordset_1.Fields.Item(firstCOMP) & "'" ' FIND
					if not objRecordset_2.EOF then
						'cari = objRecordset_1.Fields.Item("unitid")
						objRecordset_2.Find secondCOMP & "='" & objRecordset_1.Fields.Item(secondCOMP) & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields
								if isnull(objRecordset_1.Fields.Item(x.name)) then
									objRecordset_2.Fields.Item(x.name) = null
								else
									objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
								end if
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields
								if isnull(objRecordset_1.Fields.Item(x.name)) then
									objRecordset_2.Fields.Item(x.name) = null
								else
									objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
								end if
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields					
						if isnull(objRecordset_1.Fields.Item(x.name)) then
							objRecordset_2.Fields.Item(x.name) = null
						else
							objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
						end if
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields				
					if isnull(objRecordset_1.Fields.Item(x.name)) then
						objRecordset_2.Fields.Item(x.name) = null
					else
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					end if
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_unit_list()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM unit_list order by versionid,unitid", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM unit_list order by versionid,unitid", _
							objConnection_2, adOpenStatic, adLockOptimistic	

		'for each x in objRecordset_1.Fields
		'	Wscript.Echo x.name & "-" & objRecordset_1.Fields.Item(x.name)
		'next
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					'cari = objRecordset_1.Fields.Item("versionid")
					objRecordset_2.Find "versionid='" & objRecordset_1.Fields.Item("versionid") & "'" ' FIND
					if not objRecordset_2.EOF then
						'cari = objRecordset_1.Fields.Item("unitid")
						objRecordset_2.Find "unitid='" & objRecordset_1.Fields.Item("unitid") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_equipment_list()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM telemetry_equip_list_table order by siteid,position", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM telemetry_equip_list_table order by siteid,position", _
							objConnection_2, adOpenStatic, adLockOptimistic	
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst

					objRecordset_2.Find "siteid='" & objRecordset_1.Fields.Item("siteid") & "'" ' FIND
					if not objRecordset_2.EOF then

						objRecordset_2.Find "position='" & objRecordset_1.Fields.Item("position") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
					
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_site_list()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM telemetry_site_list_table order by siteid,unitid", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM telemetry_site_list_table order by siteid,unitid", _
							objConnection_2, adOpenStatic, adLockOptimistic	

		'for each x in objRecordset_1.Fields
		'	Wscript.Echo x.name & "-" & objRecordset_1.Fields.Item(x.name)
		'next
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					'cari = objRecordset_1.Fields.Item("versionid")
					objRecordset_2.Find "siteid='" & objRecordset_1.Fields.Item("siteid") & "'" ' FIND
					if not objRecordset_2.EOF then
						'cari = objRecordset_1.Fields.Item("unitid")
						objRecordset_2.Find "unitid='" & objRecordset_1.Fields.Item("unitid") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_rule_list()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM unit_list order by siteid, unitid, position, index, alarmtype", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM unit_list order by siteid, unitid,position,index, alarmtype", _
							objConnection_2, adOpenStatic, adLockOptimistic	

		'for each x in objRecordset_1.Fields
		'	Wscript.Echo x.name & "-" & objRecordset_1.Fields.Item(x.name)
		'next
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					
					objRecordset_2.Find "siteid='" & objRecordset_1.Fields.Item("siteid") & "'" ' FIND
					if not objRecordset_2.EOF then
						
						objRecordset_2.Find "unitid='" & objRecordset_1.Fields.Item("unitid") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_dispatch_list()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM telemetry_dispatch_list_table order by ruleid,priority", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM telemetry_dispatch_list_table order by ruleid,priority", _
							objConnection_2, adOpenStatic, adLockOptimistic	

		'for each x in objRecordset_1.Fields
		'	Wscript.Echo x.name & "-" & objRecordset_1.Fields.Item(x.name)
		'next
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					'cari = objRecordset_1.Fields.Item("versionid")
					objRecordset_2.Find "ruleid='" & objRecordset_1.Fields.Item("ruleid") & "'" ' FIND
					if not objRecordset_2.EOF then
						'cari = objRecordset_1.Fields.Item("unitid")
						objRecordset_2.Find "priority='" & objRecordset_1.Fields.Item("priority") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

'=============================== END OF RECONCILIATIONS PART ==================================

Public Function reconcile_append_unit_list()
	Set objConnection_0 = CreateObject("ADODB.Connection")
	Set objRecordSet_0 = CreateObject("ADODB.Recordset")
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_0.Open strConn_0
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	'objConnection_2.execute "Delete From unit_list"
	'Wscript.Quit
	objRecordSet_0.Open "SELECT * FROM unit_list order by versionid,unitid", _
						objConnection_0, adOpenStatic, adLockOptimistic

	if not objRecordset_0.EOF then ' First Recordset got Data
		objRecordSet_1.Open "SELECT * FROM unit_list order by versionid,unitid", _
							objConnection_1, adOpenStatic, adLockOptimistic
		objRecordSet_2.Open "SELECT * FROM unit_list order by versionid,unitid", _
							objConnection_2, adOpenStatic, adLockOptimistic

		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
		
		Do Until objRecordset_0.EOF ' RS1 : Moving Thru Records
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					
					objRecordset_2.Find "versionid='" & objRecordset_0.Fields.Item("versionid") & "'" ' FIND
					if not objRecordset_2.EOF then						
						objRecordset_2.Find "unitid='" & objRecordset_0.Fields.Item("unitid") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_0.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_0.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_0.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_0.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_0.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_0.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_0.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_0.Fields.Item(x.name)
				next
				objRecordset_2.Update

			end if
			objRecordset_0.MoveNext
		Loop
		
		objRecordset_2.Close
		objRecordSet_2.Open "SELECT * FROM unit_list order by versionid,unitid", _
					objConnection_2, adOpenStatic, adLockOptimistic
		
		Do Until objRecordset_1.EOF ' RS2 : Moving Thru Records
			
			objRecordset_2.MoveFirst
				
				objRecordset_2.Find "versionid='" & objRecordset_1.Fields.Item("versionid") & "'" ' FIND
				if not objRecordset_2.EOF then						
					objRecordset_2.Find "unitid='" & objRecordset_1.Fields.Item("unitid") & "'"
					if not objRecordset_2.EOF then
					
					' Proceed to UPDATE
					
						for each x in objRecordset_1.Fields								
							objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
						next
						objRecordset_2.Update
					
					else
					
					' Proceed to INSERT
						objRecordset_2.AddNew
						for each x in objRecordset_1.Fields								
							objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
						next
						objRecordset_2.Update					
					
					end if
				else
				
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				end if
			
			objRecordset_1.MoveNext
		Loop
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	objRecordSet_0.Close
	objConnection_0.Close
	objRecordSet_1.Close
	objConnection_1.Close
	objRecordSet_2.Close
	objConnection_2.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

'=================================================================================================
Public Sub memain()
	Set colSoundCards = GetObject("winmgmts:").ExecQuery _
	    ("Select * from Win32_SoundDevice")
	For Each objSoundCard in colSoundCards
	    'objRecordset.AddNew
	    Wscript.Echo objSoundCard.SystemName & vbNewLine & objSoundCard.Manufacturer & vbNewLine & objSoundCard.ProductName
	    'objRecordset.Update
	Next
End Sub

'    objRecordset("ComputerName") = objSoundCard.SystemName
'    objRecordset("Manufacturer") = objSoundCard.Manufacturer
'    objRecordset("ProductName") = objSoundCard.ProductName
'    objRecordset.Update

Public Function Load_Records()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
		
	timestamp1 = now
	'SQLstr = "SELECT count(*) FROM address_history"	
	'SQLstr = "SELECT  #LOG_ID#,#LOG_DATETIME#,#CLIENT_CODE#,#ZONE_CODE#,#STATUS#,#REF_POINT#,#EVENT_TYPE#,#SOURCE#,#EQUIP_CODE#,#DESCRIPTION#,#ARCHIVE_FLAG#,#INCIDENT_LOG#,#ASSIGNED_TO#,#LOCATION_CODE#,#STATE_CODE#  FROM MASTER_EVENT_LOG ORDER BY #ID#,#LOG_DATETIME#;"
	SQLstr = "SELECT * FROM EQUIP_JOB"
	'SQLstr = "select count from Counter_Log;"
	objConnection_1.Open strConn_1
	
	objRecordSet_1.Open Replace(SQLstr,"#",chr(34)), _
			objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then
		for each x in objRecordset_1.Fields
			if isnull(objRecordset_1.Fields.Item(x.name)) then
				Wscript.Echo "null"
			else
				Wscript.Echo objRecordset_1.Fields.Item(x.name)
			end if
		next		
	else
		Wscript.Echo "No records exist!"
		Wscript.Quit
	end if
	
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo "Processed in " & datediff("s",timestamp1,timestamp2) & "s, bro!"
End Function

Public Function Insert_Record()
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordset = CreateObject("ADODB.Recordset")
	
	objConnection.Open strConn_2	
	objRecordset.CursorLocation = adUseClient
	objRecordset.Open "SELECT * FROM unit_list" , objConnection, _
	    adOpenStatic, adLockOptimistic
	
	    objRecordset.AddNew
	    objRecordset("versionid") = "M5"
	    objRecordset("unitid") = "9999"
	    objRecordset("userid") = "1234"
		objRecordset("pwd") = "0123456789"
		objRecordset("simno") = "+60136232604"
	    objRecordset.Update
	
	objRecordset.Close
	objConnection.Close
	Wscript.Echo "Done!"
	
End Function

Public Function GetListOfSites()
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")

	objConnection.Open strConn
	'Get Districts
	objRecordSet.Open "SELECT control_district FROM telemetry_user_table WHERE username='AMRADMIN'", _
			objConnection, adOpenStatic, adLockOptimistic

	if not objRecordset.EOF then
		Control_District = objRecordset.Fields.Item("control_district") 'Need control Here		
		Control_District = Replace(Control_District,",","','")
	else
		Wscript.Echo "No registered districts exist!"
		Wscript.Quit
	end if    
	
	objRecordSet.Close
	
	'Get Site List
	objRecordSet.Open "SELECT siteid FROM telemetry_site_list_table WHERE sitedistrict IN ('" & Control_District & "') ORDER BY siteid", _
			objConnection, adOpenStatic, adLockOptimistic
		
	Do Until objRecordset.EOF
		Wscript.Echo objRecordset.Fields.Item("siteid")        
		objRecordset.MoveNext
	Loop
	objRecordSet.Close	
End Function

Public Function GetEquipTimestamp(siteid)
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
		
	objConnection.Open strConn
	objRecordSet.Open "select sequence from telemetry_equip_status_table where siteid='" & siteid & "' limit 1", _
			objConnection, adOpenStatic, adLockOptimistic

	if not objRecordset.EOF then
		GetEquipTimestamp = objRecordset.Fields.Item("sequence")		
	else
		GetEquipTimestamp = "NONE"
	end if
	objRecordSet.Close
	objConnection.Close	
End Function

Public Function GetSiteInfo(siteid,c)
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
		
	objConnection.Open strConn
	objRecordSet.Open "select * from site_info_table where siteid='" & siteid & "'", _
			objConnection, adOpenStatic, adLockOptimistic

	if not objRecordset.EOF then	
		select case c
			case "nama"
				GetSiteInfo = objRecordset.Fields.Item("sitename")
			case "no"
				GetSiteInfo = objRecordset.Fields.Item("siteno")
			case "alamat"
				GetSiteInfo = objRecordset.Fields.Item("address")
			case "id_phy"
				GetSiteInfo = objRecordset.Fields.Item("state_id_phy")
			case "id_poll"
				GetSiteInfo = objRecordset.Fields.Item("state_id_poll")
			case else
				GetSiteInfo = "OUT"
		end select
	else
		GetSiteInfo = "NONE"
	end if
	objRecordSet.Close
	objConnection.Close	
End Function

Public Function GetWaterLevel(siteid,position)
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
		
	objConnection.Open strConn
	objRecordSet.Open "select value from telemetry_equip_status_table where siteid='" & siteid & "' and position=" & position, _
			objConnection, adOpenStatic, adLockOptimistic

	objRecordSet.MoveFirst
	
	GetWaterLevel = objRecordset.Fields.Item("value")
	objRecordSet.Close
	objConnection.Close	
End Function

Public Function TimeOfPoll(siteid)
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
	objConnection.Open strConn
	objRecordSet.Open "select sequence from telemetry_equip_status_table where siteid='" & siteid & "' order by sequence desc limit 1", _
			objConnection, adOpenStatic, adLockOptimistic
	
	timestamp1 = ReFormatDate(MidnightTime(now))
	timestamp2 = objRecordset.Fields.Item("sequence")
	
	if datediff("H",timestamp1,timestamp2)< 0 then
		TimeOfPoll = 0
	else
		TimeOfPoll = datediff("s",timestamp1,timestamp2)
	end if
	
	objRecordSet.Close
	objConnection.Close	
End Function

Public Function RTUStatusCheck(siteid,position)
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
	objConnection.Open strConn
	objRecordSet.Open "select sequence from telemetry_equip_status_table where siteid='" & siteid & "' and position=" & position & " order by sequence desc limit 1", _
			objConnection, adOpenStatic, adLockOptimistic
	
	timestamp1 = objRecordset.Fields.Item("sequence")
	timestamp2 = ReFormatDate(now)
	
	if datediff("d",timestamp1,timestamp2)= 0 then
		'timestamp1 = datepart("H",timestamp1)
		'timestamp2 = datepart("H",timestamp2)
		'Wscript.Echo timestamp1 & "-" & datediff("H",timestamp1,timestamp2)
		if datediff("H",timestamp1,timestamp2) < 2 then
			RTUStatusCheck = 8
		else
			RTUStatusCheck = 0
		end if
	else
		RTUStatusCheck = 0
	end if
	
	objRecordSet.Close
	objConnection.Close	
End Function

Public Function MidnightTime(pick_a_date)
	d = datepart("yyyy",pick_a_date) & "-"
	select case len(datepart("m",pick_a_date))
		case 1
			d = d & "0" & datepart("m",pick_a_date)
		case 2
			d = d & datepart("m",pick_a_date)
		case else
			d = d & "00"
	end select	
	d = d & "-"
	select case len(datepart("d",pick_a_date))
		case 1
			d = d & "0" & datepart("d",pick_a_date)
		case 2
			d = d & datepart("d",pick_a_date)
		case else
			d = d & "00"
	end select
	MidnightTime = d & " 00:00:00"
End Function

Public Function ReFormatDate(pick_a_date)
	d = datepart("yyyy",pick_a_date) & "-"
	select case len(datepart("m",pick_a_date))
		case 1
			d = d & "0" & datepart("m",pick_a_date)
		case 2
			d = d & datepart("m",pick_a_date)
		case else
			d = d & "00"
	end select
	d = d & "-"
	select case len(datepart("d",pick_a_date))
		case 1
			d = d & "0" & datepart("d",pick_a_date)
		case 2
			d = d & datepart("d",pick_a_date)
		case else
			d = d & "00"
	end select
	d = d & " "
	d = d & datepart("H",pick_a_date) & ":" 
	select case len(datepart("n",pick_a_date))
		case 1
			d = d & "0" & datepart("n",pick_a_date)
		case 2
			d = d & datepart("n",pick_a_date)
		case else
			d = d & "00"
	end select
	d = d & ":00"	
	ReFormatDate = d
End Function

Public Function EmailDateFormat(pick_a_date)
	d = datepart("yyyy",pick_a_date)
	select case len(datepart("m",pick_a_date))
		case 1
			d = d & "0" & datepart("m",pick_a_date)
		case 2
			d = d & datepart("m",pick_a_date)
		case else
			d = d & "00"
	end select	
	select case len(datepart("d",pick_a_date))
		case 1
			d = d & "0" & datepart("d",pick_a_date)
		case 2
			d = d & datepart("d",pick_a_date)
		case else
			d = d & "00"
	end select
	EmailDateFormat = d	
End Function

Public Function EmailTimeFormat(pick_a_date)	
	select case len(datepart("H",pick_a_date))
		case 1
			d = "0" & datepart("H",pick_a_date)
		case 2
			d = datepart("H",pick_a_date)
		case else
			d = "00"
	end select	
	select case len(datepart("n",pick_a_date))
		case 1
			d = d & "0" & datepart("n",pick_a_date)
		case 2
			d = d & datepart("n",pick_a_date)
		case else
			d = d & "00"
	end select	
	EmailTimeFormat = d
End Function

' Gdev Reconciliation for NRW
Public Function reconcile_AbbSiteInfo()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM AbbSiteInfo order by meterid", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM AbbSiteInfo order by meterid", _
							objConnection_2, adOpenStatic, adLockOptimistic	
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
'====================================================================================
		'objRecordset_1.MoveFirst
		'objRecordset_1.Find "unitid='9056'"
'====================================================================================
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst
					'cari = objRecordset_1.Fields.Item("versionid")
					objRecordset_2.Find "meterid='" & objRecordset_1.Fields.Item("meterid") & "'" ' FIND
					if not objRecordset_2.EOF then
												
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
								
					
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
				
				'end if
			
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_AddressHistory()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM AddressHistory order by meterid,smsaddress", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM AddressHistory order by meterid,smsaddress", _
							objConnection_2, adOpenStatic, adLockOptimistic	
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst

					objRecordset_2.Find "meterid='" & objRecordset_1.Fields.Item("meterid") & "'" ' FIND
					if not objRecordset_2.EOF then

						objRecordset_2.Find "smsaddress='" & objRecordset_1.Fields.Item("smsaddress") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
					
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_Consumer_table()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	' AccountNo can be duplicate, but it should be by district, AccountNo
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM Consumer_Table order by serialno,accountno", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM Consumer_Table order by serialno,accountno", _
							objConnection_2, adOpenStatic, adLockOptimistic	
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst

					objRecordset_2.Find "accountno='" & objRecordset_1.Fields.Item("accountno") & "'" ' FIND
					if not objRecordset_2.EOF then

						objRecordset_2.Find "serialno='" & objRecordset_1.Fields.Item("serialno") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
					
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function

Public Function reconcile_TotalsData()
	Set objConnection_1 = CreateObject("ADODB.Connection")
	Set objRecordSet_1 = CreateObject("ADODB.Recordset")
	Set objConnection_2 = CreateObject("ADODB.Connection")
	Set objRecordSet_2 = CreateObject("ADODB.Recordset")
	' AccountNo can be duplicate, but it should be by district, AccountNo
	dim x,cari
	RS2_state = 0
	timestamp1 = now
	
	objConnection_1.Open strConn_1
	objConnection_2.Open strConn_2
	
	objRecordSet_1.Open "SELECT * FROM TotalsData order by meterid,totrectimestamp", _
						objConnection_1, adOpenStatic, adLockOptimistic

	if not objRecordset_1.EOF then ' First Recordset got Data
		objRecordSet_2.Open "SELECT * FROM TotalsData order by meterid,totrectimestamp", _
							objConnection_2, adOpenStatic, adLockOptimistic	
		
							
		if objRecordSet_2.EOF then
			RS2_state = 0
		else
			RS2_state = 1
		end if
		Do Until objRecordset_1.EOF ' Moving Thru Records		
			' Find in Recordset 2
			if RS2_state = 1 then
				objRecordset_2.MoveFirst

					objRecordset_2.Find "meterid='" & objRecordset_1.Fields.Item("meterid") & "'" ' FIND
					if not objRecordset_2.EOF then

						objRecordset_2.Find "totrectimestamp='" & objRecordset_1.Fields.Item("totrectimestamp") & "'"
						if not objRecordset_2.EOF then
						
						' Proceed to UPDATE
						
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						else
						
						' Proceed to INSERT
							objRecordset_2.AddNew
							for each x in objRecordset_1.Fields								
								objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
							next
							objRecordset_2.Update
						
						
						end if
					else
					
					' Proceed to INSERT
					objRecordset_2.AddNew
					for each x in objRecordset_1.Fields								
						objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
					next
					objRecordset_2.Update
					
					end if
			else ' RS2_state = 0
			
				' Proceed to INSERT
				objRecordset_2.AddNew
				for each x in objRecordset_1.Fields								
					objRecordset_2.Fields.Item(x.name) = objRecordset_1.Fields.Item(x.name)
				next
				objRecordset_2.Update
					
			end if
			objRecordset_1.MoveNext
		Loop
		
	else
		Wscript.Echo "No records exist in 1st Recordset!"
		Wscript.Quit
	end if	
	
	'Wscript.Echo objRecordSet_1.RecordCount
	objRecordSet_1.Close	
	objConnection_1.Close
	
	timestamp2 = now

	Wscript.Echo datediff("s",timestamp1,timestamp2) & " saat, bro!"
End Function