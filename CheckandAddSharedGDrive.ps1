# Released under GPL-3.0 license
$sharedDrives = gam show teamdrives name | ?{$_ -match "Shared Drive Name:"}
$starred = "true"
$sendnotification = 0
$notificationmsg = ""
# List the names of the shared drives
ForEach ($sharedDrive in $shareddrives) {
    $sharedDrive = $sharedDrive -replace [regex]::Escape("Shared Drive Name:"), ""
    $sharedDrive = $sharedDrive.Trim()
    Write-Host $shareddrive
    $tmpstring = $shareddrive
    $stringtomatch = "^" + [regex]::Escape($tmpstring) + "$"
    $matchresult = Select-String "$PSScriptRoot\currentshareddrives.txt" -Pattern $stringtomatch
    Write-Host $matchresult
    #Check drive list and create notification message for any missing drives.
    if ([string]::IsNullOrEmpty($matchresult)) {
        $sendnotification = 1
        $notificationmsg = $notificationmsg + [Environment]::NewLine + "New Shared Drive " + $shareddrive + " requires setup for RClone."
        #Add to current shared drive list
        $appendstr = [Environment]::NewLine + $sharedDrive
        Out-File -FilePath "$PSScriptRoot\currentshareddrives.txt" -InputObject $appendstr -Append -NoNewline
    }
}
if ($sendnotification -eq 1) {
     Write-Host $notificationmsg
     $EmailFrom = "<your gmail address>"
     # Powershell's emailer requires you to use an array of 
     # email addresses in the format of  John <user@example.com>
     # the <> must be included
     # if you do not then the email will fail
     $EmailToAddresses = @("Your Name <your google email address.>") 
     $Subject = "New SJ Shared Drives need to be setup" 
     $Body = [Environment]::NewLine + $notificationmsg
     $SMTPServer = "smtp.gmail.com"
     $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 587) 
     $SMTPClient.EnableSsl = $true 
     # Change the user name and password to that of your sending email account
     $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("<your Google email>", "<application password>"); 
     Foreach($EmailTo in $EmailToAddresses){
        $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
     }  
}
