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
      ,[Deviation]
      ,[Received_Datetime]
      ,[Segment_ID_Original]
      ,[Trip_On_Status]
      ,[Bus_Plate_No]
      ,[Travel_Time]
      ,[Segment_Ascending]
      ,[Trip_No]
      ,[Distance_Travelled]
      ,[Segment_ID_Original2]
      ,[BSDRTripNo]
      ,[Bus_Stop_ID]
      ,[Bus_ID]
      ,[Driver_ID]
      ,[Vehicle_Type]
      ,[Vehicle_Model]
      ,[EngineOff_With_Speed]
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
  FROM [FTS].[dbo].[AVL_Data_Daily] with (nolock)
  where 
  --tracker_id='NR09G20020'
  tracker_id in (SELECT [Tracker_ID]            
  FROM [FTS].[dbo].[Bus_Profile] with (nolock)
  where tracker_id not in ('NO_TRACKER')
  and Tracker_Model='4G_Zigbee'
  and substring([Tracker_ID],10,1)='0')
  --and gps_datetime between '2016-02-23 00:00:00' and '2016-02-23 01:00:00'
  --and gps_datetime between '2016-02-23 03:00:00' and '2016-02-23 04:00:00'
  --and gps_datetime between '2016-02-23 04:00:00' and '2016-02-23 05:00:00'
  and gps_datetime between '2016-02-23 12:00:00' and '2016-02-23 20:00:00'
  order by GPS_Datetime