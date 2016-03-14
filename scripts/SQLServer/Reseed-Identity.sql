--dbcc checkident ('avl_raw',reseed,0)
--dbcc checkident ('cbts_raw',reseed,0)

SELECT *
INTO CustomersBackup2013
FROM Customers;