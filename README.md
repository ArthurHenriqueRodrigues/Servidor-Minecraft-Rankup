# Servidor Minecraft RankUp Prison 1.8.8

Servidor local baseado em Spigot 1.8.8, Java 8 x64, EssentialsX, Vault, LuckPerms, PlaceholderAPI, TAB e MineResetLite.

## O que fica no GitHub

Este repositorio guarda configuracoes, scripts e documentacao. Mundos, logs, JARs, caches e dados de jogadores ficam fora do GitHub por tamanho, privacidade e seguranca. Consulte `.gitignore`.

## Requisitos

- Windows
- Java 8 x64
- Spigot 1.8.8 compilado pelo BuildTools
- Git

## Primeiro uso

1. Clone o repositorio.
2. Compile ou coloque localmente o `spigot-1.8.8.jar`.
3. Baixe os plugins pelas fontes oficiais.
4. Aceite o EULA somente depois de le-lo, usando `eula=true` localmente.
5. Execute `start-server.bat`.

## Scripts

- `build-spigot-1.8.8.bat`: compila Spigot com BuildTools.
- `start-server.bat`: inicia o servidor com 2 GB iniciais e 4 GB maximos.
- `install-tab.bat`: instala TAB 5.5.0.
- `install-mines.bat`: tenta instalar MineResetLite; o SpigotMC pode exigir download manual.
- `install-worldedit-worldguard.bat`: instala JARs Bukkit fornecidos pelo usuario e valida o conteudo.

## Configuracoes

- `RANKS.yml`: tabela de ranks e minas.
- `ECONOMIA.yml`: tabela economica.
- `TAB-CONFIG.yml`: layout do TAB e scoreboard.
- `CONFIGURAR-CARGOS.txt`: grupos LuckPerms.
- `CRIAR-MINAS.txt`: comandos MineResetLite.
- `PROTEGER-AREAS-WORLDGUARD.txt`: comandos de protecao.

## GitHub

Crie um repositorio vazio no GitHub e use o script `github-push.bat`, ou execute manualmente:

```bat
git init
git add .
git status
git commit -m "Configura servidor RankUp Prison 1.8.8"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git push -u origin main
```

O GitHub pedira autenticacao. Para HTTPS, use o GitHub CLI (`gh auth login`) ou um Personal Access Token, nunca uma senha escrita em arquivos.

## Atualizar depois

```bat
git add .
git commit -m "Atualiza configuracao do servidor"
git push
```

## Restaurar um mundo

Mundos nao ficam neste repositorio. Pare o servidor, faca backup da pasta `world` atual, extraia o mapa desejado com o nome `world` e inicie novamente.
