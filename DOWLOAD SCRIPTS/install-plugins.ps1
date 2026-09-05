$ErrorActionPreference = 'Stop'
$plugins = Join-Path $PSScriptRoot 'plugins'
New-Item -ItemType Directory -Force -Path $plugins | Out-Null

$downloads = @(
    @{ Name = 'EssentialsX-2.19.7.jar'; Url = 'https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsX-2.19.7.jar' },
    @{ Name = 'EssentialsXSpawn-2.19.7.jar'; Url = 'https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsXSpawn-2.19.7.jar' },
    @{ Name = 'Vault.jar'; Url = 'https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar' },
    @{ Name = 'LuckPerms-Bukkit-5.4.145.jar'; Url = 'https://download.luckperms.net/1556/bukkit/loader/LuckPerms-Bukkit-5.4.145.jar' },
    @{ Name = 'PlaceholderAPI-2.10.10.jar'; Url = 'https://github.com/PlaceholderAPI/PlaceholderAPI/releases/download/2.10.10/PlaceholderAPI-2.10.10.jar' }
)

Write-Host 'Instalador de plugins base para Spigot 1.8.8' -ForegroundColor Cyan
Write-Host 'Os JARs serao carregados no proximo restart do servidor.'

$javaServers = Get-CimInstance Win32_Process -Filter "name='java.exe'" | Where-Object { $_.CommandLine -match 'spigot.*\.jar' }
if ($javaServers) {
    Write-Warning 'O servidor parece estar ligado. Nao feche o processo automaticamente; os plugins serao ativados no proximo restart.'
}

foreach ($item in $downloads) {
    $destination = Join-Path $plugins $item.Name
    if ($item.Name -like 'LuckPerms-Bukkit-*.jar' -and (Get-ChildItem $plugins -Filter 'LuckPerms-Bukkit-*.jar' -File -ErrorAction SilentlyContinue)) {
        Write-Host 'Ja existe uma versao do LuckPerms; mantendo o JAR atual.' -ForegroundColor DarkYellow
        continue
    }
    if ((Test-Path $destination) -and ((Get-Item $destination).Length -ge 10000)) {
        Write-Host "Ja existe: $($item.Name)" -ForegroundColor DarkYellow
        continue
    }

    Remove-Item $destination -Force -ErrorAction SilentlyContinue

    Write-Host "Baixando $($item.Name)..."
    $installed = $false
    1..3 | ForEach-Object {
        $attempt = $_
        if ($installed) { return }
        try {
            Invoke-WebRequest -UseBasicParsing -Uri $item.Url -OutFile $destination
            if ((Get-Item $destination).Length -lt 10000) {
                throw 'arquivo muito pequeno'
            }
            $installed = $true
            Write-Host "Instalado: $($item.Name)" -ForegroundColor Green
        } catch {
            Remove-Item $destination -Force -ErrorAction SilentlyContinue
            if ($attempt -eq 3) {
                Write-Warning "Falha ao baixar $($item.Name): $($_.Exception.Message)"
            }
        }
    }
}

Write-Host ''
Write-Host 'Plugins base instalados.' -ForegroundColor Green
Write-Host 'Ainda faltam plugins especificos de RankUp, minas, economia de minas e prestigio.' -ForegroundColor Yellow
Write-Host 'Eles devem ser escolhidos conforme a configuracao desejada e a compatibilidade exata com 1.8.8.' -ForegroundColor Yellow