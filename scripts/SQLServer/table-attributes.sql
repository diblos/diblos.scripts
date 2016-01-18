SELECT CAST(p.rows AS float)
FROM sys.tables AS tbl
INNER JOIN sys.indexes AS idx ON idx.object_id = tbl.object_id and idx.index_id < 2
INNER JOIN sys.partitions AS p ON p.object_id=CAST(tbl.object_id AS int)
AND p.index_id=idx.index_id
WHERE ((tbl.name=N'avl_data_hist_08'
AND SCHEMA_NAME(tbl.schema_id)='dbo'));

SELECT SUM (row_count)
FROM sys.dm_db_partition_stats
WHERE object_id=OBJECT_ID('avl_data_hist_08')   
AND (index_id=0 or index_id=1);

SELECT      T.name TableName,i.Rows NumberOfRows
FROM        sys.tables T
JOIN        sys.sysindexes I ON T.OBJECT_ID = I.ID
WHERE       indid IN (0,1)
ORDER BY    i.Rows DESC,T.name ;

-------------------------------------------------------
CREATE TABLE #RowCountsAndSizes (TableName NVARCHAR(128),rows CHAR(11),     
       reserved VARCHAR(18),data VARCHAR(18),index_size VARCHAR(18),
       unused VARCHAR(18))

EXEC       sp_MSForEachTable 'INSERT INTO #RowCountsAndSizes EXEC sp_spaceused ''?'' '

SELECT     TableName,CONVERT(bigint,rows) AS NumberOfRows,
           CONVERT(bigint,left(reserved,len(reserved)-3)) AS SizeinKB
FROM       #RowCountsAndSizes
ORDER BY   NumberOfRows DESC,SizeinKB DESC,TableName

DROP TABLE #RowCountsAndSizes 
-------------------------------------------------------
SELECT avg_fragmentation_in_percent, fragment_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('avl_data_hist_08'), NULL, NULL, 'LIMITED')
GO
-------------------------------------------------------