@echo off

:: Check if git is ready to work
WHERE git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo O GIT nao esta instalado.
    echo Para baixar acesse: git-scm.com/download/win
    goto enderror
)

if /i "%1"=="-h" goto printhelp
if /i "%1"=="-v" goto printlogo
if /i "%1"=="" goto printlogo
if /i "%1"=="config" goto kitconfig
if /i "%1"=="salvar" goto kitsalvar

:: End with success
:endsuccess
    exit /b 0

:: End with error
:enderror
    echo.
    echo Pressione qualquer tecla para sair...
    pause >nul
    exit /b 1

:: Print help
:printhelp
    echo Ajuda do kit
    echo Comandos basicos
    echo    kit -v                 Exibe a versao do Kit
    echo    kit -h                 Exibe a ajuda do Kit
    echo    kit config             Configura o GIT para gerenciar o seu projeto
    goto endsuccess

:: Print logo
:printlogo
    echo ##  ##  ######  ######
    echo ## ##     ##      ##  
    echo ####      ##      ##  
    echo ## ##     ##      ##  
    echo ##  ##  ######    ##  
    echo.
    echo v0.1.0
    goto endsuccess

:: Comando config
:kitconfig
    echo Digite seu nome e seu primeiro sobrenome ex: Geandre Miranda
    set /p name=:
    echo.
    echo Digite seu melhor email ex: aluno_dedicado@gmail.com
    set /p email=:
    echo.
    echo Cole o link do projeto ex: https://github.com/geandre/wdsenac.git
    set /p repo=:
    echo.
    echo Digite o nome da pasta ex: site-1
    set /p dirname=:
    echo.
    echo Preparando o ambiente
    rmdir c:\wd /s /q >nul
    mkdir c:\wd >nul
    chdir c:\wd >nul
    git config --global --unset-all user.name  >nul
    git config --global --unset-all user.email  >nul
    git config --global --add user.name "%name%"  >nul
    git config --global --add user.email "%email%"  >nul
    git clone %repo% %dirname%
    chdir c:\wd\%dirname% >nul
    git branch
    goto endsuccess;

:: Comando salvar
:kitsalvar
    git add *
    git commit -m "%DATE% %TIME%"
    goto endsuccess;