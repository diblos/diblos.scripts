/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Bus_ID]
      ,[Driver_ID]
      ,[Route_ID]
      ,[Segment_ID]
      ,[Direction]
      ,[Alarm_Type]
      ,[Trigger_Datetime]
      ,[Acknowledged_By]
      ,[Acknowledged_Datetime]
      ,[Resolved_By]
      ,[Resolved_Datetime]
      ,[Status]
      ,[Remarks]
      ,[Off_Route_Time]
      ,[Speed]
      ,[Tracker_ID]
  FROM [FTS].[dbo].[Bus_Alarm_Hist] with (nolock)
  where Alarm_Type='idle'
  --and Trigger_Datetime between '2016-03-01 00:00:00' and '2016-03-01 23:59:59'

and Trigger_Datetime between '2016-01-01 00:00:00' and '2016-01-01 23:59:59'

  --and Trigger_Datetime between '2016-01-01 00:00:00' and '2016-01-01 23:59:59'

--and Trigger_Datetime between '2015-12-01 00:00:00' and '2015-12-01 23:59:59'

--and Trigger_Datetime between '2015-11-01 00:00:00' and '2015-11-01 23:59:59'

--and Trigger_Datetime between '2015-09-01 00:00:00' and '2015-09-01 23:59:59'

  --and Trigger_Datetime between '2015-05-01 00:00:00' and '2015-05-01 23:59:59'
  
  --and Trigger_Datetime between '2015-01-01 00:00:00' and '2015-01-01 23:59:59'
  --order by Off_Route_Time