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
  FROM [FTS].[dbo].[AVLDATA_DAILY20121008]
  
 select top 2 [GPS_Datetime] FROM [FTS].[dbo].[AVLDATA_DAILY20121008]
 select top 2 dateadd("s",1,[GPS_Datetime]) FROM [FTS].[dbo].[AVLDATA_DAILY20121008]
 
 
 update [FTS].[dbo].[AVLDATA_DAILY20121008] set [GPS_Datetime]=dateadd("s",1,[GPS_Datetime])
 update [FTS].[dbo].[AVLDATA_DAILY20121010] set [GPS_Datetime]=dateadd("s",1,[GPS_Datetime])
 update [FTS].[dbo].[AVLDATA_DAILY20130129] set [GPS_Datetime]=dateadd("s",1,[GPS_Datetime])
 update [FTS].[dbo].[AVLDATA_DAILY20130227] set [GPS_Datetime]=dateadd("s",1,[GPS_Datetime])
 update [FTS].[dbo].[AVLDATA_DAILY20130228] set [GPS_Datetime]=dateadd("s",1,[GPS_Datetime])