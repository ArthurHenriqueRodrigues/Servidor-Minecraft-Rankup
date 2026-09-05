$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$serverWorld = Join-Path $root 'world'
$temp = Join-Path $root 'world-install-temp'

Write-Host 'Instalador de mapa Prison para Spigot 1.8.8' -ForegroundColor Cyan
Write-Host 'O servidor deve estar parado antes de continuar.'

$javaServers = Get-CimInstance Win32_Process -Filter "name='java.exe'" | Where-Object { $_.CommandLine -match 'spigot.*\.jar' }
if ($javaServers) {
    throw 'Servidor Java detectado. Execute stop no console e rode este instalador novamente.'
}

$zip = Read-Host 'Arraste o arquivo ZIP do mapa para esta janela e pressione Enter'
$zip = $zip.Trim().Trim('"')
if (-not (Test-Path -LiteralPath $zip -PathType Leaf)) {
    throw "Arquivo ZIP nao encontrado: $zip"
}
if ([IO.Path]::GetExtension($zip).ToLowerInvariant() -ne '.zip') {
    throw 'O arquivo informado nao e ZIP.'
}

Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $temp | Out-Null
Expand-Archive -LiteralPath $zip -DestinationPath $temp -Force

$level = Get-ChildItem -LiteralPath $temp -Filter 'level.dat' -File -Recurse | Select-Object -First 1
if (-not $level) {
    throw 'O ZIP nao contem um mundo Minecraft com level.dat.'
}
$sourceWorld = $level.Directory.FullName
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $root "world-backup-$stamp"

if (Test-Path $serverWorld) {
    Rename-Item -LiteralPath $serverWorld -NewName (Split-Path $backup -Leaf)
}
Move-Item -LiteralPath $sourceWorld -Destination $serverWorld
Remove-Item $temp -Recurse -Force

Write-Host "Mapa instalado em: $serverWorld" -ForegroundColor Green
Write-Host "Backup do mundo anterior: $backup" -ForegroundColor Yellow
Write-Host 'Inicie o servidor com start-server.bat.'
