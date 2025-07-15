# Define the path where screenshots will be saved
$savePath = "C:\WSW\img"

# Define the path to the NirCmd executable
$nircmdPath = "C:\WSW\nircmd\nircmd.exe"

# Time interval between each screenshot (in seconds)
$intervalSeconds = 30

# Path to a counter file used to keep track of screenshot file numbering
$counterFile = Join-Path $savePath "counter.txt"

# Check if NirCmd is available at the given path
if (-not (Test-Path $nircmdPath)) {
    Write-Error "NirCmd not found at: $nircmdPath"
    exit 1
}

# Create the screenshot save directory if it doesn't exist
if (-not (Test-Path $savePath)) {
    New-Item -ItemType Directory -Path $savePath | Out-Null
}

# Initialize the counter file with a value of 1 if it doesn't exist
if (-not (Test-Path $counterFile)) {
    Set-Content -Path $counterFile -Value "1"
}

# Read the current counter value from the file
$counter = [int](Get-Content $counterFile)

# Infinite loop to continuously take screenshots
while ($true) {
    # Format the filename using a 4-digit padded counter (e.g., img0001.png)
    $filename = "img{0:D4}.png" -f $counter
    $filepath = Join-Path $savePath $filename

    # Attempt to take a screenshot and save it to the specified path
    try {
        Start-Process -FilePath $nircmdPath -ArgumentList "savescreenshotfull", "`"$filepath`"" -NoNewWindow -Wait
    }
    catch {
        Write-Error "Screenshot failed: $_"
    }

    # Increment the counter after each screenshot
    $counter++

    # Save the updated counter value back to the file
    Set-Content -Path $counterFile -Value $counter

    # Wait for the specified interval before taking the next screenshot
    Start-Sleep -Seconds $intervalSeconds
}
