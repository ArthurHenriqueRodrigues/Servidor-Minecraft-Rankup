@echo off
setlocal
cd /d "%~dp0"
title BuildTools - Spigot 1.8.8

where java >nul 2>&1
if errorlevel 1 (
    echo Java 8 nao foi encontrado no PATH.
    pause
    exit /b 1
)

if not exist "BuildTools.jar" (
    echo Baixando BuildTools oficial...
    curl.exe -L --fail --retry 3 --retry-delay 2 -o "BuildTools.jar" "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
    if errorlevel 1 (
        echo Falha ao baixar o BuildTools.
        pause
        exit /b 1
    )
)

echo Compilando Spigot 1.8.8. Isso pode levar alguns minutos...
java -jar "BuildTools.jar" --rev 1.8.8
if errorlevel 1 (
    echo A compilacao falhou.
    pause
    exit /b 1
)

if exist "spigot-1.8.8.jar" (
    echo Spigot 1.8.8 compilado com sucesso.
) else (
    echo A compilacao terminou, mas o JAR esperado nao foi encontrado.
)
pause
endlocal