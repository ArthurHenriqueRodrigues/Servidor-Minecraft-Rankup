$ErrorActionPreference = 'Stop'
$plugins = Join-Path $PSScriptRoot 'plugins'
$destination = Join-Path $plugins 'MineResetLite.jar'

New-Item -ItemType Directory -Force -Path $plugins | Out-Null
if ((Test-Path $destination) -and ((Get-Item $destination).Length -gt 50000)) {
    Write-Host 'MineResetLite ja esta instalado.' -ForegroundColor Yellow
    exit 0
}

Write-Host 'Baixando MineResetLite 0.4.8 oficial para Spigot 1.8.x...' -ForegroundColor Cyan
try {
    Invoke-WebRequest -UseBasicParsing -Uri 'https://www.spigotmc.org/resources/mineresetlite.5773/download?version=134820' -OutFile $destination
} catch {
    Remove-Item $destination -Force -ErrorAction SilentlyContinue
    Write-Host 'O SpigotMC bloqueou o download automatico (Cloudflare).' -ForegroundColor Yellow
    Write-Host 'Baixe manualmente em: https://www.spigotmc.org/resources/mineresetlite.5773/' -ForegroundColor Yellow
    Write-Host 'Arquivo: MineResetLite 0.4.8. Coloque o JAR baixado em plugins\\MineResetLite.jar.' -ForegroundColor Yellow
    exit 2
}
if ((Get-Item $destination).Length -lt 50000) {
    Remove-Item $destination -Force
    throw 'Download invalido ou incompleto.'
}
Write-Host 'MineResetLite instalado. Sera carregado no proximo restart.' -ForegroundColor Green
