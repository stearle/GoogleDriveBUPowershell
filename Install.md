These are instructions for a local incremental backup of your Google Drive Files.
The include a backup system for Google specific files such as gdoc or gsheet written in powershell as most backup systems cannot download these files.  This process uses Duplicati, but any other incremental backup system should work as long as it can rotate full backups.  
  
  + Requirements:
    - A drive with enough free space to hold at least 7 incremental backups of your Google Drive Files
  
    - Install GAM7 or higher 
      + Download: https://github.com/GAM-team/GAM/releases/download/v7.09.05/gam-7.09.05-windows-arm64.msi
      + Install Instructions: https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#windows
      + Make sure the user you use for GAM is a Manager of all the shared drives you wish to backup  
  
    - Install Google Drive for desktop: https://support.google.com/a/users/answer/13022292?hl=en
      + Install Google Drive for desktop as the user you wish to carry out the backups
      + Set Google Drive for desktop to have all files available offline.  Once again make sure you have enough space on your drive to hold all of the files  
  
    - Install Duplicati as a Windows Service: https://docs.duplicati.com/getting-started/installation
      + Make sure you change the service to run as the user you wish to carry out the backups or the Google Drive letter won't show up as a source.
      + Create a backup for your Google Drive

  + Create a directory on a drive where there is enough space to download the Google specific files.  i.e. your backup drive
  
  + Copy Findgooglefiles.ps1 to the directory you created
  
  + In the directory you created, make a new directory called GoogleSpecificToBU
  
  + Make sure you add this folder to your Duplicati backup
  
  + Set a task to run Findgooglefiles.ps1 before your Duplicati backup runs
  
  You should now have a scheduled backup of your Google Drive Files



