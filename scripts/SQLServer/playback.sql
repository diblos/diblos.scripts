 SELECT LONGITUDE,LATITUDE FROM AVL_Data_Hist_08 WITH (NOLOCK)  WHERE (BUS_ID = 'W1048S' )  AND gps_datetime BETWEEN '01-Aug-2015 6:00 AM' AND '01-Aug-2015 10:00 AM'  ORDER BY GPS_DATETIME
 
 SELECT LONGITUDE,LATITUDE FROM AVL_Data_Hist_01 WITH (NOLOCK)  WHERE (BUS_REGISTRATION_NO = 'WA2947M' OR BUS_ID = 'WA2947M')  AND gps_datetime BETWEEN '26-Jan-2016 6:00 AM' AND '26-Jan-2016 10:00 AM'  ORDER BY GPS_DATETIME