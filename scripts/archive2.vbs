rem Setup Variables...
set zcmd="c:\program files\7-zip\7z" a -t7z -r -mx=7 -ssw -mtc=on
set backupdir=C:\_backups\2burn
set tempdir=C:\_backups\temp
rem date format YYYY_MM_DD
set mydate=%date:~10,4%_%date:~4,2%_%date:~7,2%
set rc=c:\robocopy.exe

rem Make Directories...
md %backupdir%\%mydate%
if exist %tempdir% rd %tempdir% /s /q
if not exist %tempdir% md %tempdir%

rem Copy changed files...
%rc% \\server1\source\path %tempdir%\temp\path *.* /s /z /copy:dat /maxage:1 /r:5 /w:5     /log:%backupdir%\%mydate%\log.txt /np

rem Compress changed files...
if exist %tempdir%\temp\path %zcmd% %backupdir%\%mydate%\backup1.7z %tempdir%\temp\path\*.*

rem Remove temp directory...
rd %tempdir%\temp\path\ /q /s

rem copy compressed file and log to offsite server...
%rc% /copy:dat /e /z /r:5 /w:5 %backupdir%\%mydate%  "\\remote_server\share\backup_path\%mydate%"


rem email changed files log from offsite server...
rem C:\blat\blat262\full\blat -subject "BATCH: backup1 inc backup for %mydate%." -bodyf "\\remote_server\share\backup_path\%mydate%\log.txt" -server \\mailserver -f AccountToSendTo -tf c:\ListOfAdmins2Email.txt -u Username -pw Pa$$w0rd
