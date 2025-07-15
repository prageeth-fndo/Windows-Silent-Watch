Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -nologo -noprofile -executionpolicy bypass -file ""C:\WSW\Uploader.ps1""", 0, False
