/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Tracker_ID]
      ,[Latitude]
      ,[Longitude]
      ,[Speed]
      ,[GPS_Datetime]
      ,[Route_ID]
      ,[Segment_ID]
      ,[Direction]
      ,[Heading]
      ,[Main_Power_Status]
      ,[Engine_OnOff_Status]
      ,[Panic_Button_Status]
      ,[Bus_Stop_ID]
      ,[Travel_Time]
      ,[Bus_ID]
      ,[Bus_Registration_No]
      ,[Driver_ID]
      ,[Trip_No]
      ,[Deviation]
      ,[Distance_Travelled]
      ,[Vehicle_Type]
      ,[Vehicle_Model]
      ,[Segment_ID_Original]
      ,[EngineOff_With_Speed]
      ,[Trip_On_Status]
      ,[Received_Datetime]
      ,[Segment_Ascending]
      ,[Area_Name]
      ,[Bandar]
      ,[Negeri]
      ,[Distance_From_Point]
      ,[Location_Description]
      ,[BSDRTripNo]
      ,[Segment_ID_Original2]
      ,[Bus_Stop_Sequence]
      ,[Trip_Type]
      ,[ZigBee_Bus_Status]
      ,[ZigBee_PID_Status]
      ,[Cover_Status]
      ,[ETM_Status]
      ,[GPS_Status]
      ,[Celluar_Signal]
      ,[Sim_Card]
      ,[Tracker_OnOff_Status]
  FROM [REPORT].[dbo].[AVL_Data_Hist_08]
  
  use FTS
  SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_TYPE='BASE TABLE'
  AND NOT (TABLE_NAME LIKE 'sys%' OR TABLE_NAME LIKE 'temp%' OR TABLE_NAME LIKE '%_2014%')
  ORDER BY TABLE_NAME
  
  SELECT * FROM sysobjects WHERE xtype='U' 

SELECT sobjects.name
FROM sysobjects sobjects
WHERE sobjects.xtype = 'U'

select * from ARCHIVE_PURGE_CONFIG