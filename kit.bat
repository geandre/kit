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
if /i "%1"=="configure" goto kitconfig
if /i "%1"=="salve" goto kitsalvar
if /i "%1"=="publique" goto kitpublicar
if /i "%1"=="limpe" goto kitlimpar

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
    echo    kit -v                 Exibe a versao do Kit.
    echo    kit -h                 Exibe a ajuda do Kit.
    echo    kit configure          Configura o GIT para gerenciar o seu projeto.
    echo    kit salve              Salva as mudancas do codigo no github.
    echo    kit publique           Publica as mudancas no github pages.
    echo    kit limpe              Remove a pasta do computador mas nao altera o repositorio no github.
    echo    kit limpe /s           Igual ao limpe mas nao pergunta nada.
    goto endsuccess

:: Print logo
:printlogo
    echo ##  ##  ######  ######
    echo ## ##     ##      ##  
    echo ####      ##      ##  
    echo ## ##     ##      ##  
    echo ##  ##  ######    ##  
    echo.
    echo v1.0
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
    echo Digite o seu nome de usuário do Github
    set /p username=:
    echo.
    echo Digite a sua senha do Github
    set /p password=:
    echo.
    echo Preparando o ambiente...
    rmdir c:\wd /s /q >nul
    mkdir c:\wd >nul
    chdir c:\wd >nul
    echo Configurando o GIT...
    if "%name%" NEQ "" git config --global --unset-all user.name  >nul
    if "%name%" NEQ "" git config --global --add user.name "%name%"  >nul
    if "%email%" NEQ "" git config --global --unset-all user.email  >nul
    if "%email%" NEQ "" git config --global --add user.email "%email%"  >nul
    if "%username%" NEQ "" (
        if "%password%" NEQ "" cmdkey /generic:git:https://github.com /user:%username% /pass:%password%
    )
    git clone %repo% %dirname%
    chdir c:\wd\%dirname% >nul
    git branch
    goto endsuccess;

:: Comando salve
:kitsalvar
    git add *
    git commit -m "%DATE% %TIME%"
    git push origin master
    goto endsuccess;

:: Comando publique
:kitpublicar
    git branch -D gh-pages
    git branch gh-pages
    git checkout gh-pages
    git push origin gh-pages
    git checkout master
    goto endsuccess;

:: Comando limpe
:kitlimpar
    if /i "%2" NEQ "/s" (
        echo Atencao! Esse comando vai apagar todo o conteudo da pasta e as altercoes que nao estiverem
        echo salvas serao perdidas. Tenha certeza de encerrar todos os aplicativos que usam essa pasta
        echo antes de executar a limpeza.
        echo Tem certeza que deseja prosseguir? [s/N]
        set /p sure=:
    ) else (
        set sure=s
    )
    if /i "%sure%" EQU "s" (
        echo Removendo o conteudo do computador...
        chdir c:\ >nul
        rmdir c:\wd /s /q
        echo Limpeza concluida!
    ) else (
        echo Limpeza cancelada!
    )
    goto endsuccess;