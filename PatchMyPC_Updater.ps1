# Check if the process 'FSviewer.exe' is running
$process = Get-Process -Name 'FSviewer' -ErrorAction SilentlyContinue

if ($process) {
    # Write-Host "Process 'FSviewer.exe' is running. Stopping the process..."
    Stop-Process -Name 'FSviewer' -Force
} else {
    Write-Host "Process 'FSviewer.exe' is not running. Continuing with the script..."
}

# Rest of your script below
# Define variables
$targetFolder = "C:\Temp"
$sourceFileUrl = "https://example.com/freeupdater/PatchMyPC.exe"
$destinationFilePath = "$targetFolder\PatchMyPC.exe"
$dotnetScriptPath = "$targetFolder\DOTNET35.ps1"

# Check if the target folder exists, if not, create it
if (-not (Test-Path -Path $targetFolder -PathType Container)) {
    New-Item -Path $targetFolder -ItemType Directory | Out-Null
    Write-Output "Created folder: $targetFolder"
}

# Check if PatchMyPC.exe exists in the target folder, if not, download it
if (-not (Test-Path -Path $destinationFilePath -PathType Leaf)) {
    Invoke-WebRequest -Uri $sourceFileUrl -OutFile $destinationFilePath
    Write-Output "Downloaded PatchMyPC.exe to $targetFolder"
}

# Check if DOTNET35.ps1 exists in the target folder, if so, delete it
if (Test-Path -Path $dotnetScriptPath -PathType Leaf) {
    Remove-Item -Path $dotnetScriptPath -Force
    Write-Output "Deleted DOTNET35.ps1 from $targetFolder"
}

# Check again if PatchMyPC.exe exists in the target folder
if (Test-Path -Path $destinationFilePath -PathType Leaf) {
    # Run PatchMyPC.exe with /s for silent installation
    Start-Process -FilePath $destinationFilePath -ArgumentList "/s" -Wait
    Write-Output "PatchMyPC.exe has been executed silently."
} else {
    Write-Output "PatchMyPC.exe was not found in $targetFolder."
}
