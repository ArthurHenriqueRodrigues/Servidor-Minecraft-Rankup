@echo off
setlocal
title Spigot 1.8.8 - RankUp

cd /d "%~dp0"

where java >nul 2>&1
if errorlevel 1 (
    echo Java nao foi encontrado no PATH. Instale o Java 8 x64 e tente novamente.
    pause
    exit /b 1
)

set "SERVER_JAR=spigot-1.8.8.jar"
if not exist "%SERVER_JAR%" (
    echo O Spigot 1.8.8 ainda nao foi compilado.
    echo Execute build-spigot-1.8.8.bat antes de iniciar o servidor.
    pause
    exit /b 1
)

if not exist "eula.txt" (
    echo eula.txt nao foi encontrado. Execute o servidor uma vez para gera-lo.
    pause
    exit /b 1
)

findstr /i /r /c:"^eula=true$" "eula.txt" >nul
if errorlevel 1 (
    echo Edite eula.txt e troque eula=false por eula=true apos ler o EULA oficial.
    pause
    exit /b 1
)

echo Iniciando Spigot com 2 GB iniciais e 4 GB maximos...
java -Xms2G -Xmx4G -XX:+UseG1GC -XX:+UseStringDeduplication -jar "%SERVER_JAR%" nogui

echo.
echo Servidor encerrado. Pressione qualquer tecla para fechar.
pause
endlocal