set NDIR=%date:~6%%date:~3,2%%date:~0,2%_01
rem set NDIR=%date:~10%%date:~4,2%%date:~7,2%_01
set NSUB="D:\Itacsystem\TMCFILES\ARCHIVE\FLATFILES"

d:
cd  %NSUB%
md  %NDIR%
move  *.txt  %NDIR%
"C:\Program Files\7-Zip\7z.exe"  a  -t7z %NDIR%.7z  %NDIR%  -mx9  -mmt
rd /S /Q %NDIR%

set NSUB="D:\Itacsystem\TMCFILES\FAILED"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%