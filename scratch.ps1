$sharedDrives = gam show teamdrives name | ?{$_ -match "Shared Drive Name:"}
ForEach ($sharedDrive in $sharedDrives) {
    $sharedDrive = $sharedDrive -replace [regex]::Escape("Shared Drive Name:"), ""
    Write-Host $sharedDrive
}
