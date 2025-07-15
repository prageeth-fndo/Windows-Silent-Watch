Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -nologo -noprofile -executionpolicy bypass -file ""C:\WSW\ScreenCapture.ps1""", 0, False
