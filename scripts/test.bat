set NDIR=%date:~10%%date:~4,2%%date:~7,2%_01
set NSUB=sub
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
"C:\Program Files (x86)\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%