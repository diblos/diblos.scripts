/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Trx_Datetime]
      ,[Route_ID]
      ,[Stop_ID]
      ,[Stop_Segment_ID]
      ,[Bus_ID]
      ,[Bus_Segment_ID]
      ,[Destination]
      ,[Seq_No]
      ,[Bus_ETA_Min]
      ,[Bus_ETD_Time]
      ,[Created_Datetime]
      ,[Direction]
      ,[ETA_Source]
      ,[GPS_Datetime]
  FROM [ETA].[dbo].[ETA_Trx]
  
select min(id)[min],MAX(id)[max],COUNT(1)[count] FROM [ETA].[dbo].[ETA_Trx]

--PROCEDURE START
USE ETA;
--dbcc checkident ('ETA_Trx',reseed,0);
SELECT * INTO SAT FROM [ETA].[dbo].[ETA_Trx]; 
--DELETE FROM [ETA].[dbo].[ETA_Trx];
TRUNCATE TABLE [ETA].[dbo].[ETA_Trx];
INSERT INTO [ETA].[dbo].[ETA_Trx](
	[Trx_Datetime]
      ,[Route_ID]
      ,[Stop_ID]
      ,[Stop_Segment_ID]
      ,[Bus_ID]
      ,[Bus_Segment_ID]
      ,[Destination]
      ,[Seq_No]
      ,[Bus_ETA_Min]
      ,[Bus_ETD_Time]
      ,[Created_Datetime]
      ,[Direction]
      ,[ETA_Source]
      ,[GPS_Datetime]
) 
SELECT [Trx_Datetime]
      ,[Route_ID]
      ,[Stop_ID]
      ,[Stop_Segment_ID]
      ,[Bus_ID]
      ,[Bus_Segment_ID]
      ,[Destination]
      ,[Seq_No]
      ,[Bus_ETA_Min]
      ,[Bus_ETD_Time]
      ,[Created_Datetime]
      ,[Direction]
      ,[ETA_Source]
      ,[GPS_Datetime]
FROM [ETA].[dbo].[SAT];
DROP TABLE [ETA].[dbo].[SAT];


--DELETE [BSDR].[dbo].[AVL] WHERE ID>=58185;
--PROCEDURE END
