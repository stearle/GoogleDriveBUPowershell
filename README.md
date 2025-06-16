Released under GPL-3.0 license  

# $\texttt{\color{green}{Google Drive Local Backup}}$

These are instructions for a local incremental backup of your Google Shared Drive Files on Windows.
Some organizations want a "Belt and Suspenders" approach to Cloud Files. This can also protect against deletion of files by disgruntled employees. It can also simplify transitioning to another Cloud service.
As most backup systems cannot download Google specific files such as gdoc or gsheet I have included a script written in powershell to handle this. This process uses Duplicati to handle the incremental backups and retention, but any other incremental backup system should work as long as it can rotate full backups.  

$\textsf{\color{red}{THIS CANNOT BACKUP ALL OF YOUR USERS "MyDrive" Files, only "Shared Drives"}}$
  
## $\textsf{\color{green}{Requirements}}$
- A Google Workspace user who has "Super Admin" rights, referred to hereafter as "backup user"
- A drive with enough free space to hold at least 7 incremental backups of your Google Drive Files
- Install GAM7 or higher 
  * Download: https://github.com/GAM-team/GAM/releases/download/v7.09.05/gam-7.09.05-windows-arm64.msi
  * Install Instructions: https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#windows
  * Make sure the backup user you use for GAM is a Manager of all the shared drives you wish to backup. This can be done through the Google Workspace Admin Console.  
  
- Install Google Drive for desktop: https://support.google.com/a/users/answer/13022292?hl=en
  * Install Google Drive for desktop as the user you wish to carry out the backups.
  * Set Google Drive for desktop to have all files available offline.  Once again make sure you have enough space on your drive to hold all of the files.  I suggest using a separate drive and setting Google Drive for desktop cache to use this drive as your boot drive may not be large enough.  
  
- Install Duplicati as a Windows Service: https://docs.duplicati.com/getting-started/installation
  * Make sure you change the service to run as the user you wish to carry out the backups as or the Google Drive letter won't show up as a source.
  * Create a backup for your Google Drive by selecting "Shared Drives" under your Google Drive letter as a source. Do not run yet.  

## $\textsf{\color{green}{Instructions}}$
  + Create a directory on a drive where there is enough space to download the Google specific files.  i.e. your backup drive
  
  + Copy Findgooglefiles.ps1 to the directory you created and change any instance of
    ```
    <your gmail address>
    ```
    To your email address. Something like
    ```
    joe.brown@gmail.com
    ```
  + From a Powershell prompt run the following:
    ```
    set-ExecutionPolicy -ExecutionPolicy unrestricted -Scope currentuser
    ```
  + In the directory you created, make a new directory called GoogleSpecificToBU. This folder is a temporary holder of the current gdoc, gsheet, etc.. files.  Duplicati takes care of the incremental aspect of the backup.
  
  + Make sure you add this folder to your Duplicati backup, but don't run it yet.
  
  + Run Findgooglefiles.ps1 in order to backup your gdoc, gsheet files to the "GoogleSpecificToBU" folder.
  
  + Wait until Google Drive for Desktop is fully synced, then run your Duplicati backup.
  
  + Set a task to run Findgooglefiles.ps1 before your Duplicati backup runs it's scheduled backup.  I suggest a daily schedule.  

You should now have a scheduled backup of your Google Shared Drive Files :)  

## $\textsf{\color{green}{New Shared Drives Notifications}}$  
Users will create new Shared Drives without notifying you. In order to be aware of these drives and make your backup user a Manager of new drives follow these instructions:
+ Activate 2 factor security in Google for your backup user and create an application password called GoogleDrives. Note or copy this password to a convenient location so you can use it later.
+ Copy "CheckandAddSharedGDrive.ps1" and "currentdrives.txt" to the same directory you created for the backups
+ In "CheckandAddSharedGDrive.ps1" change
  ```
  $EmailToAddresses = @("Your Name <your google email address.>")
  ```
  To something like
  ```
  $EmailToAddresses = @("Joe Brown  <joe.brown@gmail.com>")
  ```
  Using your backup user's email address and name. Leave the <> around your email address as this is the format required by Powershell's email module.  

  Change
  ```
  $EmailFrom = "<your gmail address>"
  ```
  To something like
  ```
  $EmailFrom = "joe.brown@gmail.com"
  ```  
   
  Change
  ```
  $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("<your Google email>", "<application password>");
  ```
  To something like
  ```
  $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("joe.brown@gmail.com", "sdklsdhffouiyh");
  ```
  Using your backup user's email address and the application password you created.  
  
+ Run "CheckandAddSharedGDrive.ps1". The first run it will populate currentdrives.txt and send you emails of all the Shared Drives it has found. $\textsf{\color{red}{You will want to check this list against your current list to make sure your backup user is a manager of all of the drives.}}$
+ The next run will only send you notifications of any new drives not in currentdrives.txt.  You should add your backup user as a Manger to those drives.  

Now Findgooglefiles.ps1 will be able to backup all of your Shared Drive gdoc and gsheet files.  






