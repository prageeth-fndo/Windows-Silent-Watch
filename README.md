# 🖥️ Windows Silent Watch

This project automates the process of capturing screenshots from a Windows computer at fixed intervals and uploading them to a Google Drive folder. It uses PowerShell for logic, NirCmd for capturing, FFmpeg for video encoding, and rclone for cloud uploads. The solution runs silently in the background using VBScript wrappers and auto-starts via Windows Registry.

---

## 📦 Features

- 🔁 Takes full-screen screenshots of all screens using NirCmd
- 🎞️ Converts screenshots to MP4 video using FFmpeg
- ☁️ Uploads videos to Google Drive with rclone
- 🛠️ Automatically resets screenshot counter after each upload
- 👤 Silent background execution via VBScript
- 🕓 Scheduled upload at predefined timeslots

---

## 📁 Files in the Repo

| File                 | Description |
|----------------------|-------------|
| `ScreenCapture.ps1`  | PowerShell script to continuously capture screenshots |
| `Uploader.ps1`       | PowerShell script to convert screenshots to video and upload to Drive |
| `ScreenCapture.vbs`  | VBS wrapper for silent execution of `screencapture.ps1` |
| `Uploader.vbs`       | VBS wrapper for silent execution of `uploader.ps1` |
| `Autorun.reg` | Registry file to auto-run both scripts at login |

---

## 🔧 Requirements

- **[NirCmd](https://www.nirsoft.net/utils/nircmd.html)** – For capturing screenshots
- **[FFmpeg](https://ffmpeg.org/)** – For encoding screenshots into video
- **[rclone](https://rclone.org/)** – For uploading files to Google Drive
- **PowerShell** – Pre-installed on Windows

> Paths used in scripts:
> - NirCmd: `C:\WSW\nircmd\nircmd.exe`
> - FFmpeg: `C:\WSW\ffmpeg\bin\ffmpeg.exe`
> - rclone: `C:\WSW\rclone\rclone.exe`
> - Screenshot folder: `C:\WSW\img\`

---

## 🛠️ Setup Instructions

1. **Install NirCmd, FFmpeg, and rclone**  
   Place them in the correct folders as per the paths above.

2. **Configure rclone for Google Drive**  
   Follow rclone’s [Google Drive setup guide](https://rclone.org/drive/) to create a remote named `gdrive`.

3. **Edit Paths if Needed**  
   If your tools are in a different location, update the paths in the `.ps1` and `.vbs` files.

4. **Enable Auto-Start at Login**  
   - Double-click `Autorun.reg` to add the VBScript entries to the registry.
   - Alternatively, use Task Scheduler to trigger the VBS scripts at login.

5. **Manual Test Run**  
   - Run `ScreenCapture.vbs` to start taking screenshots silently.
   - Run `Uploader.vbs` to trigger the upload logic (at 4AM, 12PM or 8PM).

---

## 🧩 How It Works

- `ScreenCapture.ps1` captures a screenshot every 30 seconds using NirCmd and stores them as `img0001.png`, `img0002.png`, etc., in `C:\WSW\img\`.
- `Uploader.ps1` runs continuously and, at 04:00, 12:00 or 20:00, generates a video (15 fps) using FFmpeg and uploads it to Google Drive using rclone.
- After a successful upload, it deletes all screenshots and resets the counter.

---

## ⚠️ Disclaimer

This tool is intended for **educational and administrative purposes** only. Please ensure you have permission before using it on any system. Unauthorized use may violate privacy laws or policies.

---
