$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$plugins = Join-Path $root 'plugins'
$temp = Join-Path $root 'tab-download-temp'
$tabDir = Join-Path $plugins 'TAB'

if (Get-CimInstance Win32_Process -Filter "name='java.exe'" | Where-Object { $_.CommandLine -match 'spigot.*\.jar' }) {
	throw 'Servidor Java detectado. Execute stop no console antes de instalar ou trocar o TAB.'
}

New-Item -ItemType Directory -Force -Path $plugins | Out-Null
Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $temp | Out-Null

Write-Host 'Baixando TAB 5.5.0 oficial para compatibilidade ampla com Minecraft 1.8...' -ForegroundColor Cyan
$tabJar = Join-Path $temp 'TAB.v5.5.0.jar'
Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/NEZNAMY/TAB/releases/download/5.5.0/TAB.v5.5.0.jar' -OutFile $tabJar
if ((Get-Item $tabJar).Length -lt 1000000) { throw 'Download do TAB invalido ou incompleto.' }

Get-ChildItem -LiteralPath $plugins -Filter 'TAB*.jar' -File -ErrorAction SilentlyContinue | Remove-Item -Force
Copy-Item -LiteralPath $tabJar -Destination (Join-Path $plugins 'TAB.jar') -Force
Remove-Item $temp -Recurse -Force

New-Item -ItemType Directory -Force -Path $tabDir | Out-Null
Copy-Item -LiteralPath (Join-Path $root 'TAB-CONFIG.yml') -Destination (Join-Path $tabDir 'config.yml') -Force
Write-Host 'TAB.jar instalado. A configuracao sera carregada no proximo restart.' -ForegroundColor Green
