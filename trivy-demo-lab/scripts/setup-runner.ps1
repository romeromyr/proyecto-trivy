# setup-runner.ps1
# Script para configurar el GitHub Actions Self-Hosted Runner en Windows
# Ejecutar como Administrador

$RunnerVersion = "2.317.0"
$RunnerDir = "C:\actions-runner"
$RepoUrl = Read-Host "Ingresa la URL de tu repo (ej: https://github.com/TU_USUARIO/trivy-demo-lab)"
$Token = Read-Host "Ingresa el token de configuración del runner (desde GitHub Settings -> Actions -> Runners)"

Write-Host "=== Configuración de GitHub Actions Runner ===" -ForegroundColor Cyan
Write-Host "Repositorio: $RepoUrl"

# Crear directorio
if (-not (Test-Path $RunnerDir)) {
    New-Item -ItemType Directory -Path $RunnerDir | Out-Null
}
Set-Location $RunnerDir

# Descargar runner
$ZipFile = "actions-runner-win-x64-$RunnerVersion.zip"
if (-not (Test-Path $ZipFile)) {
    Write-Host "Descargando runner..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$RunnerVersion/$ZipFile" -OutFile $ZipFile
}

# Extraer
Write-Host "Extrayendo..." -ForegroundColor Yellow
Expand-Archive -Path $ZipFile -DestinationPath . -Force

# Configurar
Write-Host "Configurando runner..." -ForegroundColor Yellow
.\config.cmd --url $RepoUrl --token $Token --name "windows-lab-runner" --labels "self-hosted,windows,lab" --runasservice

Write-Host "=== Configuración completada ===" -ForegroundColor Green
Write-Host "Para iniciar el runner manualmente, ejecuta: .\run.cmd"
Write-Host "Para instalar como servicio, ejecuta: .\svc.cmd install"
