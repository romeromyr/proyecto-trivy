# mitigate-windows.ps1
# Script de mitigación post-ataque para Windows Server
# Ejecutar como Administrador

Write-Host "=== AQUA-SHIELD: Mitigación de Vulnerabilidades Windows ===" -ForegroundColor Cyan

# 1. SMB Hardening
Write-Host "[1/6] Endureciendo SMB..." -ForegroundColor Yellow
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue
Set-SmbServerConfiguration -RequireSMBSigning $true -Force -ErrorAction SilentlyContinue
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -ErrorAction SilentlyContinue
Write-Host "      SMB1 deshabilitado, SMB signing requerido." -ForegroundColor Green

# 2. Unquoted Service Path Fix
Write-Host "[2/6] Corrigiendo Unquoted Service Paths..." -ForegroundColor Yellow
$Services = Get-WmiObject Win32_Service | Where-Object { 
    $_.PathName -and 
    $_.PathName -notmatch '^"' -and 
    $_.PathName -match ' ' -and 
    $_.PathName -notmatch '\s.*\' 
}
foreach ($Svc in $Services) {
    $NewPath = '"' + $Svc.PathName + '"'
    Write-Host "      Corrigiendo: $($Svc.Name) -> $NewPath" -ForegroundColor Gray
    sc config "$($Svc.Name)" binPath= $NewPath | Out-Null
}
Write-Host "      Service paths corregidas." -ForegroundColor Green

# 3. RDP Hardening
Write-Host "[3/6] Endureciendo RDP..." -ForegroundColor Yellow
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 -Force
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "MinEncryptionLevel" -Value 3 -Force
Write-Host "      NLA habilitado, encryption nivel alto." -ForegroundColor Green

# 4. Firewall Rules
Write-Host "[4/6] Configurando firewall..." -ForegroundColor Yellow
New-NetFirewallRule -DisplayName "RDP-Lab-Only" -Direction Inbound -Protocol TCP -LocalPort 3389 -RemoteAddress 192.168.56.0/24 -Action Allow -Enabled True -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Block-SMB-External" -Direction Inbound -Protocol TCP -LocalPort 445 -RemoteAddress Internet -Action Block -Enabled True -ErrorAction SilentlyContinue
Write-Host "      Firewall rules aplicadas." -ForegroundColor Green

# 5. Password Policy
Write-Host "[5/6] Configurando política de contraseñas..." -ForegroundColor Yellow
net accounts /minpwlen:14 /maxpwage:30 /minpwage:1 /uniquepw:5 | Out-Null
Write-Host "      Política de contraseñas aplicada (14 chars min)." -ForegroundColor Green

# 6. Audit Policy
Write-Host "[6/6] Habilitando auditoría avanzada..." -ForegroundColor Yellow
auditpol /set /subcategory:"Logon" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable /failure:enable | Out-Null
Write-Host "      Auditoría habilitada." -ForegroundColor Green

Write-Host "=== Mitigación completada. Reiniciar recomendado. ===" -ForegroundColor Green
