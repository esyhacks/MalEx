@echo off
title MalEx (Portable)
set is_minimized=1
set logfile="%tmp%\malex.log"
echo ----- Logging start ----- >%logfile%
echo(
echo          ~~~ Malware Execution Automation Script [Portable v1.1] ~~~          
echo                   (c) Anonymous VX22. All Rights reserved.                 
echo(
echo(


echo %date%   %time%  - Requesting administrator rights... >>%logfile%
if not "%1"=="adm" ( powershell -command "start-process -verb runas -filepath '%0' 'adm'"
exit /b )
echo %date%   %time%  - Acquired Administrator priviledges. >>%logfile%


cd /d "%~dp0"
set "curdir=%~dp0"
echo %date%   %time%  - Current working directory: >>%logfile%
echo                            '%curdir%' >>%logfile%
echo( >>%logfile%


setlocal enableextensions
set count=0
for %%x in (*.exe) do set /a count+=1
if %count% equ 0 goto :emt else goto :prompt


:prompt
echo %count% samples about to execute.
set /p ask=Continue? (Y/N) 
if /i %ask% equ Y goto :exec
if /i %ask% equ YES goto :exec
if /i %ask% equ N goto :endtwo
if /i %ask% equ NO goto :endtwo
echo Invalid input
:pu
pause > nul
goto :pu


:exec
set counttwo=0
for %%a in (*.exe) do set /a counttwo+=1
if %counttwo% equ 0 goto :emt else goto :exectwo


:exectwo
echo %date%   %time%  - Creating a list of files to execute...  >>%logfile%
echo( >>%logfile%
for %%c in (*.exe) do ( echo                            %%c >>%logfile% )
echo( >>%logfile%
echo(
echo          ===== Executing =====          
echo(
echo %date%   %time%  - Execution started. >>%logfile%
echo  STATUS    SAMPLE PROCESSED
echo  -------   -------------------------------------------------- 
echo(
set countthr=0
set countfou=0
setlocal enabledelayedexpansion
for %%f in (*.exe) do ( 
    set fn=%%f
    start %%f 2>nul && echo  MISSED    !fn:~0,50! && set /a countfou+=1 || echo  BLOCKED   !fn:~0,50! && set /a countthr+=1 
)
echo %date%   %time%  - Job finished. >>%logfile%


echo(
set /a countfiv= %countthr% + %countfou%
echo  Test Results -----------------------------------------------
echo(
echo   Malware samples processed: %countfiv%
echo   Malware samples blocked: %countthr%
echo   Malware samples missed: %countfou%
for /f "delims=" %%d in ('powershell -command "[math]::round(%countthr%/%countfiv%*100,2)"') do set "pct=%%d" 2>nul
echo   Proactive detection: %pct%%%
echo(
echo   Testing completed successfully.


:prompttwo
echo(
echo      A.stop started processes
echo      B.open event log
echo      C.test again
echo      D.exit
echo      E.reboot system
echo(
echo What would you like to do next? (Select option A,B,C,D or E)
set /p asktwo=Your input: 
if /i %asktwo% equ A goto :kill
if /i %asktwo% equ B goto :log
if /i %asktwo% equ C goto :exec
if /i %asktwo% equ D goto :end
if /i %asktwo% equ E goto :rbt
echo Invalid input
:pu
pause > nul
goto :pu


:promptthr
echo(
echo      A.test again
echo      B.open event log
echo      C.exit
echo      D.reboot system
echo(
echo What would you like to do next? (Select option A,B,C or D)
set /p askthr=Your input: 
if /i %askthr% equ A goto :exec
if /i %askthr% equ B goto :log
if /i %askthr% equ C goto :end
if /i %askthr% equ D goto :rbt
echo Invalid input
:pu
pause > nul
goto :pu


:promptfou
echo(
echo      A.stop started processes
echo      B.test again
echo      C.exit
echo      D.reboot system
echo(
echo What would you like to do next? (Select option A,B,C or D)
set /p askfou=Your input: 
if /i %askfou% equ A goto :kill
if /i %askfou% equ B goto :exec
if /i %askfou% equ C goto :end
if /i %askfou% equ D goto :rbt
echo Invalid input
:pu
pause > nul
goto :pu


:emt
echo %date%   %time%  - Malware files were probably removed. No files to execute. >>%logfile%
echo(
echo   No files to execute!
echo   ...exiting...
timeout /t 2 /nobreak > nul
goto :end


:kill
echo %date%   %time%  - Process termination started. >>%logfile%
echo(
echo          ===== Killing Tasks =====          
echo(
for %%b in (*.exe) do ( 
    set fn=%%b
    taskkill /F /T /IM %%b >nul 2>&1 && echo  TERMINATED:   !fn:~0,50! 
)
echo %date%   %time%  - Job finished. >>%logfile%
echo(
echo   Stopping process(es) complete.
goto :promptthr


:log
start notepad "%tmp%\malex.log"
goto :promptfou


:rbt
echo %date%   %time%  - System reboot requested.>>%logfile%
shutdown /r /t 0 2>>%logfile%


:endtwo
echo %date%   %time%  - User cancelled the operation.>>%logfile%
goto :end


:end
echo -----  Logging end  ----- >>%logfile%
endlocal
exit