@echo off
set NDIR=%date:~10,4%%date:~4,2%%date:~7,2%_01
set NSUB="D:\Itac.Service\ItacBEAlarm Service\Log"
set NAGE=-7

d:
cd  %NSUB%
md  %NDIR%
move  *.txt  %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe"  a  -t7z %NDIR%.7z  %NDIR%  -mx9  -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBECam Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEDRS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEET Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEHIS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBELCS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBESTJ Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEVDS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEVMS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEVSL Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItacBEWDS Service\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueReader*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"

set NSUB="D:\Itac.Service\ItramasTMCWS\Log"
cd %NSUB%
md %NDIR%
move *.txt %NDIR%
move ..\QueueWriter*.txt %NDIR%
"C:\Program Files\7-Zip\7z.exe" a -t7z %NDIR%.7z %NDIR% -mx9 -mmt
rd /S /Q %NDIR%
forfiles -p %NSUB% -m *.7z -d %NAGE% -c "cmd /c del @path"