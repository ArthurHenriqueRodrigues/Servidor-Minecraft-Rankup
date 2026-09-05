$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$plugins = Join-Path $root 'plugins'
$disabled = Join-Path $root 'plugins-disabled'
$temp = Join-Path $root 'worldedit-install-temp'

if (Get-CimInstance Win32_Process -Filter "name='java.exe'" | Where-Object { $_.CommandLine -match 'spigot.*\.jar' }) {
    throw 'Servidor Java detectado. Execute stop no console antes de instalar os plugins.'
}

function Read-JarEntry($jarPath, $entryName) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($jarPath)
    try {
        $entry = $archive.GetEntry($entryName)
        if (-not $entry) { return $null }
        $reader = New-Object IO.StreamReader($entry.Open())
        try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
    } finally { $archive.Dispose() }
}

function Has-JarEntry($jarPath, $entryName) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($jarPath)
    try { return $null -ne $archive.GetEntry($entryName) } finally { $archive.Dispose() }
}

New-Item -ItemType Directory -Force -Path $disabled | Out-Null
Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $temp | Out-Null

Write-Host 'Baixe os JARs pelas paginas oficiais do CurseForge:' -ForegroundColor Cyan
Write-Host 'WorldEdit: https://www.curseforge.com/minecraft/bukkit-plugins/worldedit/files/all'
Write-Host 'WorldGuard: https://www.curseforge.com/minecraft/bukkit-plugins/worldguard/files/all'
Write-Host 'Para MC 1.8, escolha WorldEdit 6.x e WorldGuard 6.1.2 ou 6.2.'

$worldEdit = (Read-Host 'Caminho do JAR WorldEdit Bukkit').Trim().Trim('"')
$worldGuard = (Read-Host 'Caminho do JAR WorldGuard Bukkit').Trim().Trim('"')
foreach ($path in @($worldEdit, $worldGuard)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Arquivo nao encontrado: $path" }
}

$wePlugin = Read-JarEntry $worldEdit 'plugin.yml'
$wgPlugin = Read-JarEntry $worldGuard 'plugin.yml'
if (($wePlugin -notmatch '(?m)^name:\s*WorldEdit\s*$') -or -not (Has-JarEntry $worldEdit 'com/sk89q/worldedit/extension/platform/Platform.class')) {
    throw 'O primeiro arquivo nao parece ser o WorldEdit Bukkit completo. Nao instalado.'
}
if (($wgPlugin -notmatch '(?m)^name:\s*WorldGuard\s*$') -or -not (Has-JarEntry $worldGuard 'com/sk89q/worldguard/bukkit/WorldGuardPlugin.class')) {
    throw 'O segundo arquivo nao parece ser o WorldGuard Bukkit completo. Nao instalado.'
}

foreach ($old in @('worldedit-bukkit-6.1.5.jar','worldguard-legacy-6.1.2.jar','WorldEdit.jar','WorldGuard.jar')) {
    $oldPath = Join-Path $plugins $old
    if (Test-Path $oldPath) { Move-Item $oldPath (Join-Path $disabled $old) -Force }
}
Copy-Item $worldEdit (Join-Path $plugins 'WorldEdit.jar') -Force
Copy-Item $worldGuard (Join-Path $plugins 'WorldGuard.jar') -Force
Remove-Item $temp -Recurse -Force
Write-Host 'WorldEdit e WorldGuard instalados. Inicie com start-server.bat e teste //wand e /rg list.' -ForegroundColor Green
