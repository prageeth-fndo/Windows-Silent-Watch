# Set the path to the directory where screenshots are stored
$imgPath = "C:\WSW\img"

# Path to the FFmpeg executable for video creation
$ffmpeg = "C:\WSW\ffmpeg\bin\ffmpeg.exe"

# Path to the rclone executable for uploading to Google Drive
$rclone = "C:\WSW\rclone\rclone.exe"

# Hashtable to track if a video has already been created for a specific hour on the current day
$lastRunDate = @{}

# Infinite loop to constantly monitor time and trigger the upload process at specific hours
while ($true) {
    # Get the current date and time
    $now = Get-Date
    $currentHour = $now.Hour
    $currentMinute = $now.Minute

    # Define the hours (4AM, 12PM, 8PM) when the script should create and upload the video
    $runHours = @(4, 12, 20)

    # Check if current time matches a scheduled upload hour and video for that hour hasn't already been created today
    if ($runHours -contains $currentHour -and $currentMinute -eq 0 -and $lastRunDate["$currentHour"] -ne $now.Date) {
        
        # Create the output filename using current date and hour (e.g., 2025-07-15_04.mp4)
        $outputFile = $now.ToString("yyyy-MM-dd_HH") + ".mp4"
        $outputPath = Join-Path $imgPath $outputFile

        # Get all screenshot files in the directory and sort them by name
        $images = Get-ChildItem -Path $imgPath -Filter "img*.png" | Sort-Object Name

        # Check if there are any screenshots to process
        if ($images.Count -eq 0) {
            Write-Host "No screenshots found to create a video. Skipping..."
        } else {
            Write-Host "Creating video from screenshots..."

            # Run FFmpeg to convert the screenshots into a video (15 fps, H.264 encoding, yuv420p format)
            Start-Process -NoNewWindow -Wait -FilePath $ffmpeg -ArgumentList @(
                "-framerate", "15",
                "-i", "$imgPath\img%04d.png",
                "-c:v", "libx264",
                "-pix_fmt", "yuv420p",
                "$outputPath"
            )

            # Verify the video was created successfully
            if (-not (Test-Path $outputPath)) {
                Write-Error "Video was not created. Skipping upload."
            } else {
                Write-Host "Uploading video to Google Drive..."

                # Use rclone to copy the video to the 'gdrive' remote
                Start-Process -NoNewWindow -Wait -FilePath $rclone -ArgumentList @(
                    "copy", "-P",
                    "$outputPath",
                    "gdrive:"
                )

                Write-Host "Cleaning up old screenshots and video..."

                # Delete all old screenshots
                Get-ChildItem -Path $imgPath -Filter "img*.png" | Remove-Item -Force

                # Delete the uploaded video
                Remove-Item -Path $outputPath -Force

                # Reset the screenshot counter to 1
                $counterFile = Join-Path $imgPath "counter.txt"
                Set-Content -Path $counterFile -Value "1"
            }
        }

        # Mark this hour as completed for today to avoid re-processing
        $lastRunDate["$currentHour"] = $now.Date

        # Sleep for a minute to avoid duplicate runs within the same minute
        Start-Sleep -Seconds 60
    } else {
        # Check again in 30 seconds
        Start-Sleep -Seconds 30
    }
}
