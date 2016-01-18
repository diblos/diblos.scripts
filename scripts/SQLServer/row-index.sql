select ROW_NUMBER() OVER(ORDER BY bus_id DESC) AS Row, bus_id  from Bus_Profile 
