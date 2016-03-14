/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Bus_Stop_ID]
      ,[Type_Of_Day]
      ,[AM_Peak_From]
      ,[AM_Peak_To]
      ,[Noon_Peak_From]
      ,[Noon_Peak_To]
      ,[PM_Peak_From]
      ,[PM_Peak_To]
      ,[Off_Peak_From]
      ,[Off_Peak_To]
      ,[Radius_Peak_Meter]
      ,[Radius_Off_Peak_Meter]
  FROM [ETA].[dbo].[Bus_Stop_ETA_Config]
  
  select min(id)[min],MAX(id)[max],COUNT(1)[count] FROM [ETA].[dbo].[Bus_Stop_ETA_Config]

--PROCEDURE START
USE ETA;
SELECT * INTO SAT FROM [ETA].[dbo].[Bus_Stop_ETA_Config]; 
TRUNCATE TABLE [ETA].[dbo].[Bus_Stop_ETA_Config];
INSERT INTO [ETA].[dbo].[Bus_Stop_ETA_Config](
	[Bus_Stop_ID]
      ,[Type_Of_Day]
      ,[AM_Peak_From]
      ,[AM_Peak_To]
      ,[Noon_Peak_From]
      ,[Noon_Peak_To]
      ,[PM_Peak_From]
      ,[PM_Peak_To]
      ,[Off_Peak_From]
      ,[Off_Peak_To]
      ,[Radius_Peak_Meter]
      ,[Radius_Off_Peak_Meter]
) 
SELECT [Bus_Stop_ID]
      ,[Type_Of_Day]
      ,[AM_Peak_From]
      ,[AM_Peak_To]
      ,[Noon_Peak_From]
      ,[Noon_Peak_To]
      ,[PM_Peak_From]
      ,[PM_Peak_To]
      ,[Off_Peak_From]
      ,[Off_Peak_To]
      ,[Radius_Peak_Meter]
      ,[Radius_Off_Peak_Meter]
FROM [ETA].[dbo].[SAT];
DROP TABLE [ETA].[dbo].[SAT];


--DELETE [BSDR].[dbo].[AVL] WHERE ID>=58185;
--PROCEDURE END