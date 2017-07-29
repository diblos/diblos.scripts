@echo off
SET curpath=%~dp0
SET PROG="%curpath%MassLogicService.exe"

SET FIRSTPART=%WINDIR%\Microsoft.NET\Framework\v
echo %FIRSTPART%
SET SECONDPART=\InstallUtil.exe
SET DOTNETVER=4.0.30319
echo %FIRSTPART%%DOTNETVER%%SECONDPART%
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
SET DOTNETVER=3.5
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
SET DOTNETVER=3.0
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
SET DOTNETVER=2.0.50727
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
SET DOTNETVER=1.1.4322
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
SET DOTNETVER=1.0.3705
IF EXIST %FIRSTPART%%DOTNETVER%%SECONDPART% GOTO install
GOTO fail
:install
ECHO Found .NET Framework version %DOTNETVER%
ECHO Un Installing service %PROG%
%FIRSTPART%%DOTNETVER%%SECONDPART% /u %PROG%
GOTO end
:fail
echo FAILURE -- Could not find .NET Framework install :param_error
:end
ECHO DONE!!!
Pause
