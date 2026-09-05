@echo off
cd /d "%~dp0"
if not exist plugins-disabled mkdir plugins-disabled
if exist "plugins\worldedit-bukkit-6.1.5.jar" move /Y "plugins\worldedit-bukkit-6.1.5.jar" "plugins-disabled\worldedit-bukkit-6.1.5.jar"
if exist "plugins\worldguard-legacy-6.1.2.jar" move /Y "plugins\worldguard-legacy-6.1.2.jar" "plugins-disabled\worldguard-legacy-6.1.2.jar"
echo JARs incompletos movidos para plugins-disabled.
echo Eles foram preservados e nao serao carregados pelo servidor.
pause
