$sharedDrives = gam user <your gmail address> show teamdrives name | ?{$_ -match "Shared Drive Name:"}
$rootFolder = $PSScriptRoot + "GoogleSpecificToBU"
FindGoForEach ($sharedDrive in $shareddrives) {
    $sharedDrive = $sharedDrive -replace [regex]::Escape("Shared Drive Name:"), ""
    $sharedDrive = $sharedDrive.Trim()
    Write-Host $sharedDrive
    $googleFiles = gam user <your gmail address> print filelist select teamdrive $sharedDrive showmimetype "gdoc,gsheet,gpresentation,gdrawing,gform" showownedby any id title filepath
    $googleFileCount = 0
    $googleFileArr = @()
    ForEach ($googleFileString in $googleFiles) {
        If ($googleFileCount -eq 0) {
            $googleFileCount++
        }
        Else {
            #Write-Host $googleFileString
            $googleFileArr = $googleFileString | ConvertFrom-String -Delimiter "," -PropertyNames owner, id, name, paths, path0
            #Write-Host $googleFileArr.id
            $targetDir = $rootFolder + "\" + $googleFileArr.path0
            $targetDir = $targetDir.ToString()
            $lastSlashIndex = $targetDir.LastIndexOf("/")
            $targetDir = $targetDir.Substring(0,$lastSlashIndex)
            $targetDir = $targetDir.Replace("`/","`\")
            $targetDir = $targetDir.Trim()
            $targetDir = $targetDir.Replace(' ','_')
            $targetDir = $targetDir.Replace('.','_')
            $targetFilename = $googleFileArr.name.ToString()
            $targetFilename = $targetFilename.Replace(' ','_')
            $targetFilename = $targetFilename.Replace('.', '_')
            $targetFilename = $targetFilename.Trim()
            Write-Host "Target Dir: " $targetDir
            Write-Host "Target Filename: " $targetFilename
            $targetPathExists = $targetDir | Test-Path
            If ($targetPathExists -eq $false) {
                mkdir $targetDir
            }
            gam user <your gmail address> get drivefile id $googleFileArr.id targetfolder $targetDir targetname $targetFilename overwrite true
        }
    }
    Write-Host "`r`n"
}
