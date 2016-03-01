  select top 1000 a.id from
  (select id  FROM [AVL].[dbo].[AVL_Raw]) A,
  (select min(id)as [min],(min(id)+30)as [max] FROM [AVL].[dbo].[AVL_Raw]) B
  where a.ID between b.min and b.max 
  
  delete from [AVL].[dbo].[AVL_Raw]
  where id in 
  (select top 1000 a.id from
  (select id  FROM [AVL].[dbo].[AVL_Raw]) A,
  (select min(id)as [min],(min(id)+30)as [max] FROM [AVL].[dbo].[AVL_Raw]) B
  where a.ID between b.min and b.max )
  
  -------------------------------------------------------------------------------
   delete from [AVL].[dbo].[AVL_Raw]
  where id in 
  (select a.id from
  (select id  FROM [AVL].[dbo].[AVL_Raw]) A,
  (select min(id)as [min],(min(id)+100000)as [max] FROM [AVL].[dbo].[AVL_Raw]) B
  where a.ID between b.min and b.max );
  select  min([Received_Datetime])as [earlier date]  FROM [AVL].[dbo].[AVL_Raw];
  