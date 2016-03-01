/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Bus_ID]
      ,[Vehicle_Plate_No]
      ,[Vehicle_Type]
      ,[Vehicle_Model]
      ,[Vehicle_Status]
      ,[Tracker_ID]      
      ,[Tracker_Model]
      ,[Tracker_Brand]
      ,[Remark]
      ,[Depot_ID]
      ,[Total_Passenger]
      ,[Fuel_Consumption]
      ,[Enable_OKU]
      ,[IsRecoveryTeam]
      ,[IsEnforcementTeam]
      ,[IsMobilityTeam]
      ,[Tracker_Phone_No]
      ,[Tracker_Password]
      ,[Grounded]
      ,[Tracker_Phone_No2]
  FROM [FTS].[dbo].[Bus_Profile] with (nolock)
  where tracker_id not in ('NO_TRACKER')
  and Tracker_Model='4G_Zigbee'
  and substring([Tracker_ID],10,1)='0'
  order by Tracker_ID