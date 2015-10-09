Set oCn = CreateObject("ADODB.Connection")
Set oRs = CreateObject("ADODB.Recordset")

 ConnectionString = "DRIVER={MySQL ODBC 3.51 Driver};SERVER=mysqlserver.mydomain.com;" & _
         "DATABASE=testdatabase;" & _
                 "USER=user;" & _
                         "PASSWORD=userpassword;" & _
                                 "OPTION=3;"
                                 'For a weird reason you can not put the DRIVER option on a seperate line.
                                 'SERVER: should be the hostname of your mysql server (localhost is a common value)
                                 'DATABASE: The name of the database you want to get information from
                                 'USER&PASSWORD: err.. :)
                                 'OPTION: See the mysql documentation on the odbc driver for information on options
                                 '    It is a bitmask. Which means if you want option 1 & 2 you put 3.
                                 '    If you would like to have options 1, 2 and 8 you put '11'.

                                  oCn.open(ConnectionString)
                                  'Open your connection

                                   oRs.Open "Select * from your_table", oCn
                                   'Select all elements in the table

                                    for each item in oRs.fields
                                        wscript.echo item.name & " = " & item.value
                                            'Cycle through all items and output the value
                                            next
                                            oRs.close()
                                            oCn.close()
                                            'Close all connections 
