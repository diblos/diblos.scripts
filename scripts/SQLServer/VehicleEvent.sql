SELECT a.Bus_ID, 
                	a.Trigger_Datetime as dtDate, 
                	a.Alarm_Type + CASE WHEN a.Alarm_Type = 'SPEEDING' THEN ' - ' + CAST(a.Speed as char(3)) + 'km/h' ELSE '' END 
                				 + CASE WHEN a.Alarm_Type = 'IDLE' THEN ' - ' + CAST(Off_Route_Time as char(3)) + 'min.' ELSE '' END 
                		as eEvent, 
                  DATEDIFF(minute, a.Trigger_Datetime, a.Resolved_Datetime) as eDuration, 
                  c.description as Route_Desc, a.Driver_Id, 
                (SELECT  TOP 1 Vehicle_Plate_No 
                            From Bus_Profile b WITH (nolock) 
                            WHERE b.Bus_ID = a.Bus_ID 
                            ORDER BY ID DESC) Bus_Reg_No 
                FROM Bus_Alarm_Hist a, Route_Profile c with (nolock) 
                --WHERE a.Trigger_Datetime BETWEEN '2015-10-01 00:45:03.000' AND '2015-10-01 06:45:03.000'
                WHERE a.Trigger_Datetime BETWEEN '2016-03-01 00:45:03.000' AND '2016-03-01 23:00:03.000'
                AND a.Route_ID = c.Route_ID 
                AND a.Direction = c.Direction 
                AND a.Alarm_Type NOT IN ('REVERSE')
                 --#DEPOT #ROUTE 
                 
                 and a.Bus_ID='T098'
                 
                 ORDER BY a.Route_Id, a.Bus_Id, dtDate ASC