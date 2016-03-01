SELECT LONGITUDE,LATITUDE FROM AVL_Data_Hist_08 WITH (NOLOCK) 
WHERE (BUS_REGISTRATION_NO = 'WPX5486' OR BUS_ID = 'V064') 
AND gps_datetime BETWEEN '2015-08-01 00:00:00.000' AND '2015-08-01 23:00:00.000' 
ORDER BY GPS_DATETIME

select distinct tracker_id from AVL_Data_Hist_08 with (nolock)
where (BUS_REGISTRATION_NO = 'WPX5486' OR BUS_ID = 'V064')

select top 1 tracker_id from AVL_Data_Hist_08 with (nolock)
where (BUS_REGISTRATION_NO = 'WPX5486' OR BUS_ID = 'V064')

select * from Bus_Profile where (vehicle_plate_NO = 'WPX5486' OR BUS_ID = 'V064')

select vehicle_plate_NO from Bus_Profile where vehicle_plate_NO = 'WPX5486'