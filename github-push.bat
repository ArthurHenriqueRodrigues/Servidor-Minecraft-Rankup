@echo off
setlocal
cd /d "%~dp0"

echo Verificando Git...
where git >nul 2>&1
if errorlevel 1 (
    echo Git nao foi encontrado no PATH.
    pause
    exit /b 1
)

if not exist ".git" (
    git init
    if errorlevel 1 goto :error
)

echo.
echo Arquivos que serao incluidos:
git status --short

echo.
git add .
if errorlevel 1 goto :error

git diff --cached --quiet
if not errorlevel 1 (
    echo Nenhuma alteracao para enviar.
    goto :end
)

git commit -m "Atualiza servidor RankUp Prison 1.8.8"
if errorlevel 1 goto :error

for /f "delims=" %%R in ('git config --get remote.origin.url 2^>nul') do set "REMOTE=%%R"
if not defined REMOTE (
    echo.
    set /p REMOTE=Informe a URL HTTPS do repositorio GitHub: 
    if not defined REMOTE goto :error
    git remote add origin "%REMOTE%"
    if errorlevel 1 goto :error
)

git branch -M main
git push -u origin main
if errorlevel 1 goto :error

echo.
echo Envio concluido.
goto :end

:error
echo.
echo O envio falhou. Verifique a mensagem acima.
pause
exit /b 1

:end
echo.
pause
endlocal
