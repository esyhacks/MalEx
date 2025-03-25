REM Use at your own risk. The author hold no liability for any damage caused by malware.

@echo off
title MalEx
setlocal enableextensions 
setlocal enabledelayedexpansion


set logfile="%temp%\MalEx\events.log"
set urlfile="%temp%\MalEx\urls.txt"
set urlfile2="%temp%\MalEx\test.txt"
set vbsfile="%temp%\MalEx\admin.vbs"
set vbsfile2="%temp%\MalEx\chkurl.vbs"
set vbsfile3="%temp%\MalEx\anim.vbs"
set vbsfile4="%temp%\MalEx\download.vbs"
set helpfile="%temp%\MalEx\help.txt"


if not exist "%temp%\MalEx" (
    mkdir "%temp%\MalEx"
)

if exist %logfile% (
    del %logfile%
)

call :logger "Logging start ----------"

echo.
echo           ~~~ Malware Execution Automation Script [Version 1.40] ~~~          
echo                    (c) Anonymous VX22. All rights reserved.                 
echo.
echo.

call :logger "Requesting administrator rights..."

net session >nul 2>&1

if %errorlevel% neq 0 (
    (
        echo Set UAC = CreateObject^("Shell.Application"^)
        echo UAC.ShellExecute "%~0", "", "", "runas", 1
        echo.
        echo Set UAC = Nothing

    ) > %vbsfile%

    %vbsfile%
    del %vbsfile%

    exit /b
)

call :logger "Acquired administrator privileges."

echo  Select the test type.
echo  Enter ? for help.
echo.
echo      A. Malware
echo      B. Anti-Phishing
echo.

set /p input=Your input: 

if /i "%input%" equ "A" (
  goto :malware_test

) else if /i "%input%" equ "B" (
  goto :anti-phishing_test

) else if /i "%input%" equ "HELP" (
  goto :help

) else if "%input%" equ "?" (
  goto :help

) else (
  goto :invalid

)


:malware_test

call :logger "Malware test selected."

echo.
echo MALWARE TEST --------------------------------------------------
echo.

cd /d "%~dp0"

set "currentdir=%~dp0"

for %%i in ( "%currentdir%\.." ) do (
    set "parentdir=%%~fi"
)

set "sourcedir=%parentdir%\Malicious\All"

cd /d "%sourcedir%" 2>nul

if %errorlevel% neq 0 (
    goto :emptydir
)

call :logger "Target directory detected."

set /a count=0
set "extensions= *.exe *.bat *.cmd *.com *.msi *.vbs *.js *.ps1"

for %%f in ( %extensions% ) do (
    set /a count+=1
)

if %count% equ 0 (
  goto :empty
) else (
  goto :continue
)


:continue

echo  Which malware category you wish to proceed?
echo  (Select option A,B,C,D or E)
echo.
echo      A. Ransomware
echo      B. Trojan
echo      C. Virus
echo      D. Worm
echo      E. All
echo.

set /p input2=Your input: 

if /i "%input2%" equ "A" (

  set "family=Ransomware"
  goto :import

) else if /i "%input2%" equ "B" (

  set "family=Trojan"
  goto :import

) else if /i "%input2%" equ "C" (

  set "family=Virus"
  goto :import

) else if /i "%input2%" equ "D" (

  set "family=Worm"
  goto :import

) else if /i "%input2%" equ "E" (

  goto :all

) else (

  goto :invalid

)


:import

call :logger "%family% category selected. Importing files to the destination directory..."

echo.

if not exist %family%.*.exe (
    if not exist %family%.*.bat (
        if not exist %family%.*.cmd (
            if not exist %family%.*.com (
                if not exist %family%.*.msi (
                    if not exist %family%.*.vbs (
                        if not exist %family%.*.js (
                            if not exist %family%.*.ps1 (
                                goto :emptycategory
                            )
                        )
                    )
                )
            )
        )
    )
)

set "destinationdir=%parentdir%\Malicious\Classified\%family%"

if not exist "%destinationdir%" (
    mkdir "%destinationdir%"
)

set "extensions2= %family%.*.exe %family%.*.bat %family%.*.cmd %family%.*.com %family%.*.msi %family%.*.vbs %family%.*.js %family%.*.ps1"

for %%f in ( %extensions2% ) do (
    move /y "%%f" "%destinationdir%" >nul 2>&1
)

call :logger "Import completed."

cd /d "%destinationdir%" 2>nul

set /a count=0
set "category=%extensions2%"

for %%f in ( %extensions2% ) do (
    set /a count+=1
)

echo   %count% %family% samples imported.
goto :continue2


:all

call :logger "All category selected."

echo.
echo   %count% malware samples found.

set "category=%extensions%"
goto :continue2


:continue2

echo   MalEx is ready to execute. Continue? (Y/N)
echo.

set /p input3=Your input: 

if /i "%input3%" equ "Y" (
  goto :continue3

) else if /i "%input3%" equ "YES" (
  goto :continue3

) else if /i "%input3%" equ "N" (
  goto :cancel

) else if /i "%input3%" equ "NO" (
  goto :cancel

) else (
  goto :invalid

)


:continue3

set /a count0=0

for %%f in ( %category% ) do (
    set /a count0+=1
)

if %count0% equ 0 (
  goto :empty
) else (
  goto :continue4
)


:continue4

call :logger "Execution started."
call :logger "Timer.on"

cls

echo.
echo          ===== Executing =====          
echo.
echo  STATUS    SAMPLE PROCESSED
echo  -------   --------------------------------------------------
echo.

set /a count=0
set /a count2=0

for %%f in ( %category% ) do (

    set "filename=%%~nxf"
    set "truncated=!filename:~0,47!"

    if "!filename:~50!" equ "" (
        set "truncated=!filename!"

    ) else (
        set "truncated=!truncated!..."

    )

    call :logger "Executing: %%f"

    start "" "%%f" 2>nul

    if !errorlevel! equ 0 (
        call :logger "Result: Missed"

        echo  MISSED    !truncated!
        set /a count2+=1

    ) else (
        call :logger "Result: Blocked"

        echo  BLOCKED   !truncated!
        set /a count+=1

    )

    set /a "progress=(!count! + !count2!) * 100 / %count0%"
    set /a "filled=(!count! + !count2!) * 50 / %count0%"
    set /a "blank=50 - !filled!"

    set "filledbar="

    for /l %%a in (1,1,!filled!) do (
        set "filledbar=!filledbar!="
    )

    set "blankbar="

    for /l %%a in (1,1,!blank!) do (
        set "blankbar=!blankbar! "
    )

    echo  Progress:
    echo  [!filledbar!!blankbar!] !progress!%%
    echo.

)

echo.

call :logger "Job finished."
call :logger "Timer.off"

echo.

set /a count3= %count% + %count2%

echo  Test Results --------------------------------------------------
echo.
echo   Malware samples processed: %count3%
echo   Malware samples blocked: %count%
echo   Malware samples missed: %count2%

set "pct=0.00"
set /a "pct=(count * 10000) / count3"
set "pct=!pct:~0,-2!.!pct:~-2!"

if !pct! gtr 0 (
  echo   Proactive detection: !pct!%%
) else (
  echo   Proactive detection: 0.00%%
)

echo.
echo   Testing completed successfully.
echo.
echo      A.stop started processes
echo      B.open event log
echo      C.test again
echo      D.exit
echo      E.reboot system
echo.
echo What would you like to do next? (Select option A,B,C,D or E)

set /p input4=Your input: 

if /i "%input4%" equ "A" (
  goto :kill

) else if /i "%input4%" equ "B" (
  goto :log

) else if /i "%input4%" equ "C" (
  goto :continue3

) else if /i "%input4%" equ "D" (
  goto :end

) else if /i "%input4%" equ "E" (
  goto :reboot

) else (
  goto :invalid

)


:emptydir

call :logger "Target directory is missing or inaccessible."

echo   Target directory is missing.
echo   ...exiting...

timeout /t 2 >nul
goto :end


:emptycategory

call :logger "No Files to import on selected category from the target directory."

echo   Selected category is empty.
echo   Please choose a different one next time.

timeout /t 2 >nul
goto :end


:empty

call :logger "Malware files were probably removed. No files to execute."

echo   No files to execute!
echo   ...exiting...

timeout /t 2 >nul
goto :end


:kill

call :logger "Process termination started."
call :logger "Timer.on"

cls

echo.
echo          ===== Killing Tasks =====          
echo.
echo  STATUS    SAMPLE PROCESSED
echo  -------   --------------------------------------------------
echo.

set "category2=*.exe, *.com, *.msi, *.vbs"
set /a count0=0
set /a count=0
set /a count2=0

for %%f in ( %category2% ) do (
    set /a count0+=1
)

for %%f in ( %category2% ) do (

    set "filename=%%~nxf"
    set "truncated=!filename:~0,47!"

    if "!filename:~50!" equ "" (
        set "truncated=!filename!"

    ) else (
        set "truncated=!truncated!..."

    )

    call :logger "Terminating: %%f"

    taskkill /F /T /IM "%%f" >nul 2>&1

    if errorlevel 1 (
        call :logger "Result: Failed"

        echo  FAILED    !truncated!
        set /a count2+=1

    ) else (
        call :logger "Result: Successful"

        echo  SUCCESS   !truncated!
        set /a count+=1

    )

    set /a "progress=(!count! + !count2!) * 100 / %count0%"
    set /a "filled=(!count! + !count2!) * 50 / %count0%"
    set /a "blank=50 - !filled!"

    set "filledbar="

    for /l %%a in (1,1,!filled!) do (
        set "filledbar=!filledbar!="
    )

    set "blankbar="

    for /l %%a in (1,1,!blank!) do (
        set "blankbar=!blankbar! "
    )

    echo  Progress:
    echo  [!filledbar!!blankbar!] !progress!%%
    echo.

)

echo.

call :logger "Job finished."
call :logger "Timer.off"

echo.
echo Stopping process(es) complete.

pause
goto :end


:reboot

call :logger "Restarting system..."

shutdown /r /t 5
goto :end


:anti-phishing_test

call :logger "Anti-Phishing test selected."

echo.
echo ANTI-PHISHING TEST --------------------------------------------------
echo.


call :logger "Checking IE installation..."

set "IEPath=%ProgramFiles%\Internet Explorer\iexplore.exe"

if not exist "%IEPath%" (

   call :logger "Internet Explorer is not installed on this system. Please install Internet Explorer & try again."

   echo Internet Explorer is missing!
   echo   ...exiting...

   timeout /t 2 >nul
   goto :end

) else (

    call :logger "Internet Explorer is installed on the system."

)


echo Internet is required for this test.
echo Continue? (Y/N)
echo.

set /p input5=Your input: 

if /i "%input5%" equ "Y" (
  goto :continue5

) else if /i "%input5%" equ "YES" (
  goto :continue5

) else if /i "%input5%" equ "N" (
  goto :cancel

) else if /i "%input5%" equ "NO" (
  goto :cancel

) else (
  goto :invalid

)


:continue5

call :logger "User continued the test, Checking online status..."

set "server=google.co.uk"

ping -n 4 %server% >nul 2>&1

if %errorlevel% equ 0 (
  goto :online
) else (
  goto :offline
)


:online

call :logger "Online status confirmed."

echo.
echo      Checking online status ............... OKAY

call :logger "Downloading a list of Phishing URLs..."

if exist %urlfile% (
    del %urlfile%
)

(

    echo On Error Resume Next
    echo Set objXMLHTTP = CreateObject^("MSXML2.ServerXMLHTTP"^)
    echo.
    echo objXMLHTTP.Open "GET", "https://tinyurl.com/MalExPhi", False
    echo objXMLHTTP.Send
    echo.
    echo If objXMLHTTP.Status ^<^> 200 Then
    echo.
    echo     Set objXMLHTTP = Nothing
    echo     WScript.Quit^(1^)
    echo.
    echo Else
    echo.
    echo     Set objADOStream = CreateObject^("ADODB.Stream"^)
    echo.
    echo     objADOStream.Type = 1
    echo     objADOStream.Open
    echo     objADOStream.Write objXMLHTTP.ResponseBody
    echo     objADOStream.SaveToFile "%temp%\MalEx\urls.txt"
    echo     objADOStream.Close
    echo.
    echo     Set objXMLHTTP = Nothing
    echo     WScript.Quit^(0^)
    echo.
    echo End If

) > %vbsfile4%

%vbsfile4%

if %errorlevel% equ 1 (
    del %vbsfile4%
    goto :error

) else (
    del %vbsfile4%
    call :logger "URL list download successful."

)

echo      Downloading a URL list ............... OKAY

call :logger "Calculating the URL count..."

for /f %%a in ('type %urlfile% ^| find /i /c "http"') do (
    set urls=%%a
)

echo      Processing URL list .................. OKAY
echo.

call :logger "%urls% URLs were found."

echo %urls% phishing URLs found.
echo How many URLs you wish to process?
echo.

set /p input6=Your input: 

for /f "delims=0123456789" %%a in ( "%input6%" ) do (
    goto :invalid
)

for /f "tokens=* delims=0" %%a in ( "%input6%" ) do (
    set input6=%%a
)

if "%input6%" equ "" (
  goto :cancel

) else if %input6% leq %urls% (
  goto :continue6

) else (
  goto :invalid

)


:continue6

call :logger "User selected %input6% URLs to process."

if exist %urlfile2% (
    del %urlfile2%
)

set /a count=0

for /f "usebackq eol= delims=" %%a in ( %urlfile% ) do (

    if "!count!" equ "%input6%" (
        goto :continue7
    )

    echo %%a>> %urlfile2%
    set /a count+=1

)


:continue7

call :logger "Now connecting to URLs..."
call :logger "Timer.on"

cls

echo.
echo          ===== Connecting =====       
echo.
echo  STATUS    URL PROCESSED
echo  -------   -------------------------------------------------- 
echo.

(

    echo Set objShell = CreateObject^("WScript.Shell"^)
    echo Set objIE = CreateObject^("InternetExplorer.Application"^)
    echo.
    echo objIE.Visible = False
    echo objIE.Silent = True
    echo.
    echo.
    echo objIE.Navigate "https://tinyurl.com/MalExChk"
    echo.
    echo.
    echo Do While objIE.Busy Or objIE.ReadyState ^<^> 4
    echo     WScript.Sleep 100
    echo Loop
    echo.
    echo.
    echo title = objIE.Document.Title
    echo.
    echo Set objFSO = CreateObject^("Scripting.FileSystemObject"^)
    echo.
    echo.
    echo logFilePath = "%temp%\MalEx\Events.log"
    echo Set logFile = objFSO.OpenTextFile^(logFilePath, 8, True^)
    echo.
    echo.
    echo Sub Logger^(LogEvent^)
    echo     currentDate = Year^(Date^) ^& "-" ^& Right^("0" ^& Month^(Date^), 2^) ^& "-" ^& Right^("0" ^& Day^(Date^), 2^)
    echo     currentTime = TimeValue^(Now^)
    echo     hourValue = Hour^(currentTime^)
    echo.
    echo     If hourValue = 0 Then
    echo         hourValue = 12
    echo     ElseIf hourValue ^> 12 Then
    echo         hourValue = hourValue - 12
    echo     End If
    echo.
    echo     formattedTime = Right^("0" ^& hourValue, 2^) ^& ":" ^& Right^("0" ^& Minute^(currentTime^), 2^) ^& ":" ^& Right^("0" ^& Second^(currentTime^), 2^)
    echo.
    echo     If Hour^(currentTime^) ^< 12 Then
    echo         ampm = "AM"
    echo     Else
    echo         ampm = "PM"
    echo     End If
    echo.
    echo     dateTimeString = currentDate ^& "  " ^& formattedTime ^& " " ^& ampm
    echo.
    echo     logFile.WriteLine dateTimeString ^& " - " ^& LogEvent
    echo End Sub
    echo.
    echo.
    echo If title = "Feature Settings Check - Phishing Page - AMTSO" Then
    echo.
    echo     Logger "Checking Anti-Virus capability..."
    echo     Logger "Anti-Phishing feature of your Anti-Virus solution is not enabled or misconfigured."
    echo.
    echo     WScript.Echo "  Anti-Virus solution is not supported^!"
    echo     WScript.Echo "  ...exiting..."
    echo     WScript.Echo
    echo     WScript.Echo "  Testing interrupted."
    echo.
    echo.
    echo     logFile.Close
    echo     objIE.Quit
    echo.
    echo.
    echo     Set objFSO = Nothing
    echo     WScript.Sleep 2000
    echo     WScript.Quit
    echo.
    echo.
    echo Else
    echo.
    echo.
    echo     Logger "Checking Anti-Virus capability..."
    echo     Logger "Anti-Phishing feature of your Anti-Virus solution is functioning properly."
    echo.
    echo.
    echo     title2 = objIE.Document.Title
    echo.
    echo     filePath = "%temp%\MalEx\test.txt"
    echo     Set linksFile = objFSO.OpenTextFile^(filePath^)
    echo.
    echo     blockedCount = 0
    echo     missedCount = 0
    echo.
    echo.
    echo     Sub DisplayProgressBar^(percentage^)
    echo         barLength = Int^(^(percentage / 100^) * 50^)
    echo         progressBar = String^(barLength, "="^) ^& String^(50 - barLength, " "^)
    echo.
    echo         WScript.Echo " Progress:"
    echo         WScript.Echo " [" ^& progressBar ^& "] " ^& percentage ^& "%%"
    echo     End Sub
    echo.
    echo.
    echo     Do While Not linksFile.AtEndOfStream
    echo         URL = linksFile.ReadLine^(^)
    echo.
    echo         If Len^(URL^) ^> 50 Then
    echo             truncURL = Left^(URL, 47^) ^& "..."
    echo         Else
    echo             truncURL = URL
    echo         End If
    echo.
    echo         Logger "Connecting: " ^& URL
    echo         objIE.Navigate URL
    echo.
    echo         intTimeout = 30000
    echo.
    echo         dtStart = Now
    echo.
    echo         Do While objIE.Busy Or objIE.ReadyState ^<^> 4
    echo             WScript.Sleep 100
    echo.
    echo             dtNow = Now
    echo             intElapsedTime = DateDiff^("s", dtStart, dtNow^) * 1000
    echo             If intElapsedTime ^>= intTimeout Then Exit Do
    echo         Loop
    echo.
    echo.
    echo         title3 = objIE.Document.Title
    echo.
    echo         If InStr^(title3, title2^) ^> 0 Then
    echo.
    echo             Logger "Result: Blocked"
    echo             WScript.Echo " BLOCKED   " ^& truncURL
    echo             blockedCount = blockedCount + 1
    echo.
    echo         Else
    echo.
    echo             Logger "Result: Missed"
    echo             WScript.Echo " MISSED    " ^& truncURL
    echo             missedCount = missedCount + 1
    echo.
    echo         End If
    echo.
    echo.
    echo         totalURLs = %input6%
    echo         percentage = Int^(^(^(blockedCount + missedCount^) / totalURLs^) * 100^)
    echo.
    echo         DisplayProgressBar percentage
    echo         WScript.Echo
    echo     Loop
    echo.
    echo.
    echo     linksFile.Close
    echo     logFile.Close
    echo     objIE.Quit
    echo.
    echo.
    echo End If
    echo.
    echo.
    echo     blockedPercentage = FormatNumber^(^(blockedCount / totalURLs^) * 100, 2^)
    echo.
    echo     WScript.Echo 
    echo     WScript.Echo " Test Results --------------------------------------------------"
    echo     WScript.Echo
    echo     WScript.Echo "  Phishing URLs processed: " ^& totalURLs
    echo     WScript.Echo "  Phishing URLs blocked: " ^& blockedCount
    echo     WScript.Echo "  Phishing URLs missed: " ^& missedCount
    echo     WScript.Echo "  Proactive detection: " ^& blockedPercentage ^& "%%"
    echo     WScript.Echo
    echo     WScript.Echo "  Testing completed successfully."
    echo.
    echo.
    echo Set objFSO = Nothing
    echo WScript.Quit

) > %vbsfile2%

cscript //nologo %vbsfile2%
del %vbsfile2% %urlfile2%

echo.

call :logger "Job finished."
call :logger "Timer.off"

echo.
echo      A.open URL list
echo      B.open event log
echo      C.exit
echo.
echo What would you like to do next? (Select option A,B or C)

set /p input7=Your input: 

if /i "%input7%" equ "A" (
  goto :list

) else if /i "%input7%" equ "B" (
  goto :log

) else if /i "%input7%" equ "C" (
  goto :end

) else (
  goto :invalid

)


:list

echo.
start notepad %urlfile%

pause
goto :end


:log

echo.
start notepad %logfile%

pause
goto :end


:offline

call :logger "Network disconnected & couldn't connect to a server."

echo.
echo   You're offline. Check your connection ^& try again.
echo   Would you like to retry? (Y/N)
echo.

set /p input8=Your input: 

if /i "%input8%" equ "Y" (
  goto :continue5

) else if /i "%input8%" equ "YES" (
  goto :continue5

) else if /i "%input8%" equ "N" (
  goto :cancel

) else if /i "%input8%" equ "NO" (
  goto :cancel

) else (
  goto :invalid

)


:error

call :logger "An unexpected error occured while attempting to download a list of Phishing URLs. Check your internet connection or temporarily pause Anti-Virus solution installed on your system & try again."

echo.
echo   An unexpected error occured during the download.
echo   Would you like to retry? (Y/N)
echo.

set /p input9=Your input: 

if /i "%input9%" equ "Y" (
  goto :continue5

) else if /i "%input9%" equ "YES" (
  goto :continue5

) else if /i "%input9%" equ "N" (
  goto :cancel

) else if /i "%input9%" equ "NO" (
  goto :cancel

) else (
  goto :invalid

)


:invalid

echo Invalid input

timeout /t 2 >nul 
goto :end


:cancel

call :logger "User cancelled the operation."
goto :end


:help

call :logger "Launched help pane."

cls

(

    echo.
    echo.
    echo.
    echo                                          $$$
    echo                                       ^| $$$$
    echo       / $$$       $$$                  ^| $$$   / $$$$$$$$$$$$$
    echo       ^| $$$$$   $$$$$                  ^| $$$   ^| $$$$$$$$$$$$$
    echo       ^| $$$$$$ $$$$$$     $$$$$$$ $$   ^| $$$   ^| $$$_________/  \ $$$    $$$
    echo       ^| $$$ $$$$  $$$    $$$$$$$$$$$   ^| $$$   ^| $$$$$$$$$$      \ $$$  $$$
    echo       ^| $$$\ $$ / $$$   $$$ ___  $$$   ^| $$$   ^| $$$$$$$$$$       ^| $$$$$$
    echo       ^| $$$ \__/^| $$$   $$$    \ $$$   ^| $$$   ^| $$$______/       ^| $$$$$$
    echo       ^| $$$     ^| $$$  \ $$$$$$$$$$$   ^| $$$   ^| $$$$$$$$$$$$$   / $$$\ $$$
    echo       ^| $$$     ^| $$$   \  $$$$$$ $$  ^| $$$$$  ^| $$$$$$$$$$$$$  / $$$  \ $$$
    echo       ^|___/     ^|___/    \______/^|__^| ^|_____^|  ^|_____________/ /____/   \___\
    echo.
    echo.
    echo.
    echo.
    echo About:
    echo.
    echo MalEx is a command-line script designed for automating malware execution tests and conducting anti-phishing tests. It provides an interface to select the desired test type and execute the corresponding operations. MalEx is a powerful tool for anyone who interested in Anti-Virus testings as well as security professionals to evaluate the effectiveness of Anti-Virus products.
    echo.
    echo MalEx is compatible with Windows 11/10/8 and also older systems. However, some features may not be avaliable on modern systems ^(i.e., Anti-Phishing test relies on Internet Explorer that's depreciated^). In such scenarios, a manual installation is required to continue.
    echo.
    echo Usage:
    echo.
    echo -Run the script by double-clicking on the batch file.
    echo -Follow the on-screen instructions to choose the test type.
    echo -Based on the selected test type, MalEx will import malware files or download phishing URLs.
    echo -MalEx will execute the tests and provide detailed logs and results.
    echo.
    echo Features:
    echo.
    echo -Malware Execution Test: Allows you to import and execute malware samples of specific categories, such as ransomware, trojans, viruses, and worms. You have to put all the samples in a specific directory and rename them in a syntax in order to process them.
    echo.
    echo i.e., The source directory is "C:\SomePath\Malicious\All". MalEx must be stored in "C:\SomePath\SomeFolder". When you choose a specific Malware family, MalEx will import the files from source directory to a destination directory such as "C:\SomePath\Malicious\Classified\Trojan\Trojan.abc.exe" and executes them accordingly. If "All" category selected, MalEx will execute files directly from the source directory, regardless of the file name or category.
    echo.
    echo -Anti-Phishing Test: Downloads a list of phishing URLs and opens each URL in a hidden IE window with the aim of replicating a real-world situation. After it finishes loading, MalEx matches the webpage title with a title that's blocked by the Anti-Virus. It's a simple and effective method to trigger an Anti-Virus for a Phishing test.
    echo.
    echo note: Please turn off Microsoft Defender SmartScreen for Internet Explorer as it interferes with MalEx. Navigate to Internet Explorer ^> Settings ^> Safety and turn the feature off.
    echo.
    echo -Detailed logging: All events and test results are logged in the "events.log" file located in the temporary directory.
    echo.
    echo -Process termination: Provides the option to terminate any running processes related to the executed malware samples.
    echo.
    echo -Event log viewer: Opens the event log file in notepad for easy inspection.
    echo.
    echo -System reboot: Offers the ability to reboot the system after completing the tests.
    echo.
    echo Disclaimer:
    echo.
    echo MalEx is solely intended for educational purposes only. It is strongly recommended to conduct any test in a Virtual Machine isolated from the host and meticulously verify security measures before proceeding.
    echo.
    echo All MalEx commands run with administrative privileges to avoid frequent UAC warnings ^(especially in Malware test^). As a result, malware will execute with highest privileges allowing them to perform a critical damage to your data. So use this script AT YOUR OWN RISK. The author hold no responsibility for any damage or data-theft caused by its usage.

) > %helpfile%

(

    echo Set objFSO = CreateObject^("Scripting.FileSystemObject"^)
    echo Set objFile = objFSO.OpenTextFile^(%helpfile%, 1^)
    echo.
    echo lineCount = 0
    echo.
    echo.
    echo Do Until objFile.AtEndOfStream Or lineCount ^>= 18
    echo     strLine = objFile.ReadLine^(^)
    echo.
    echo     WScript.Sleep 50
    echo.
    echo     If lineCount ^< 18 Then
    echo         WScript.Echo strLine
    echo.
    echo     End If
    echo.
    echo     lineCount = lineCount + 1
    echo Loop
    echo.
    echo.
    echo Do Until objFile.AtEndOfStream
    echo     strCharacter = objFile.Read^(1^)
    echo.
    echo     WScript.Sleep 10
    echo.
    echo     If lineCount ^>= 18 Then
    echo         WScript.StdOut.Write strCharacter
    echo.
    echo     End If
    echo.
    echo     lineCount = lineCount + 1
    echo Loop
    echo.
    echo.
    echo objFile.Close
    echo Set objFile = Nothing
    echo Set objFSO = Nothing

) > %vbsfile3%

cscript //nologo %vbsfile3%
del %vbsfile3%

echo.
echo.

pause
goto :end


:end

call :logger "Logging end ------------"

endlocal
exit


:logger

set "event=%~1"

for /f "tokens=2 delims==" %%b in ('wmic os get localdatetime /value ^| more') do (
    set "datetime=%%b"
    set "datetime=!datetime:~0,14!"
)

set "year=!datetime:~0,4!"
set "month=!datetime:~4,2!"
set "day=!datetime:~6,2!"
set "hour=!datetime:~8,2!"
set "minute=!datetime:~10,2!"
set "second=!datetime:~12,2!"

if "!event!" equ "Timer.on" (

    set /a "starthour=hour"
    set /a "startminute=minute"
    set /a "startsecond=second"

    set /a "starttime=(starthour*3600)+(startminute*60)+startsecond"

) else if "!event!" equ "Timer.off" (

    set /a "endhour=hour"
    set /a "endminute=minute"
    set /a "endsecond=second"

    set /a "endtime=(endhour*3600)+(endminute*60)+endsecond"

    if !starttime! gtr !endtime! (
        set /a "endtime+=86400"
    )

    set /a "elapsedseconds=endtime - starttime"
    set /a "elapsedhours=elapsedseconds / 3600"
    set /a "elapsedseconds%%=3600"
    set /a "elapsedminutes=elapsedseconds / 60"
    set /a "elapsedseconds%%=60"

    if !elapsedhours! equ 0 (
        if !elapsedminutes! equ 0 (
            echo  Elapsed time: !elapsedseconds! second^(s^).
        ) else (
            echo  Elapsed time: !elapsedminutes! minute^(s^) and !elapsedseconds! second^(s^).
        )
    ) else (
        echo  Elapsed time: !elapsedhours! hour^(s^), !elapsedminutes! minute^(s^) and !elapsedseconds! second^(s^).
    )

) else (

    if !hour! lss 12 (
        set "ampm=AM"
    ) else (
        set "ampm=PM"
    )

    if !hour! equ 0 (
        set "hour=12"
    ) else if !hour! gtr 12 (
        set /a "hour-=12"
        if !hour! lss 10 (
            set "hour=0!hour!"
        )
    )

    set "formatteddt=!year!-!month!-!day!  !hour!:!minute!:!second! !ampm!"
    echo !formatteddt! - !event!>> %logfile%
)

exit /b