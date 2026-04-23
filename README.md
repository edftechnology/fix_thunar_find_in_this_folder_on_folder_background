# Como instalar/configurar/usar o `bmon` no `Linux Ubuntu`

## Resumo

Guia direto para instalar o `bmon` no `Linux Ubuntu` pelo `Terminal Emulator`, com um caminho principal via `apt` e um caminho alternativo por compilação do código-fonte.

## _Abstract_

_A straightforward guide to install `bmon` on `Linux Ubuntu` through the `Terminal Emulator`, with a primary `apt`-based path and an optional source-build path._


## Descrição

### `bmon`

O `bmon` é uma ferramenta de linha de comando para monitorar largura de banda e estatísticas de rede em tempo real. Ele oferece interface interativa baseada em `ncurses` e também modos de saída em texto, úteis para depuração, observabilidade e automação.


## Pré-requisitos

- Permissão para usar `sudo`
- Repositórios `ubuntu` habilitados, preferencialmente incluindo `universe`
- Conexão com a internet para instalar pacotes
- `apt` funcional no sistema


## 1. Abrir o `Terminal Emulator`

1. Abrir o `Terminal Emulator`. Você pode fazer isso pressionando:

```bash
Ctrl + Alt + T
```


2. Certifique-se de que seu sistema esteja limpo e atualizado.

    2.1 Limpar o `cache` do gerenciador de pacotes `apt`. Especificamente, ele remove todos os arquivos de pacotes (`.deb`) baixados pelo `apt` e armazenados em `/var/cache/apt/archives/`. Digite o seguinte comando:
        
    ```bash
    sudo apt clean
    ```

    2.2 Remover pacotes `.deb` antigos ou duplicados do `cache` local. É útil para liberar espaço, pois remove apenas os pacotes que não podem mais ser baixados (ou seja, versões antigas de pacotes que foram atualizados). Digite o seguinte comando:

    ```bash
    sudo apt autoclean
    ```

    2.3 Remover pacotes que foram automaticamente instalados para satisfazer as dependências de outros pacotes e que não são mais necessários. Digite o seguinte comando:

    ```bash
    sudo apt autoremove -y
    ```

    2.4 Buscar as atualizações disponíveis para os pacotes que estão instalados em seu sistema. Digite o seguinte comando e pressione `Enter`:

    ```bash
    sudo apt update
    ```

    2.5 **Corrigir pacotes quebrados**: Isso atualizará a lista de pacotes disponíveis e tentará corrigir pacotes quebrados ou com dependências ausentes:

    ```bash
    sudo apt --fix-broken install
    ```

    2.6 Limpar o `cache` do gerenciador de pacotes `apt` novamente:

    ```bash
    sudo apt clean
    ```

    2.7 Para ver a lista de pacotes a serem atualizados, digite o seguinte comando e pressione `Enter`:

    ```bash
    sudo apt list --upgradable
    ```

    2.8 Realmente atualizar os pacotes instalados para as suas versões mais recentes, com base na última vez que você executou `sudo apt update`. Digite o seguinte comando e pressione `Enter`:

    ```bash
    sudo apt full-upgrade -y
    ```


## 3. Instalar o `bmon` via `apt`

Na maioria dos casos, a forma mais simples e portátil de instalar o `bmon` no `Ubuntu` é usar o pacote disponível nos repositórios da distribuição.

1. Garantir que o repositório `universe` esteja habilitado:

    ```bash
    sudo add-apt-repository universe
    sudo apt update
    ```

2. Instalar o `bmon`:

    ```bash
    sudo apt install -y bmon
    ```

3. Confirmar que o binário foi instalado corretamente:

    ```bash
    bmon --help
    ```


## 4. Executar o `bmon`

1. Depois da instalação, você pode iniciar o monitoramento com o comando:

    ```bash
    bmon
    ```

2. Se quiser monitorar uma _interface_ específica, como `eth0`, use:

    ```bash
    bmon -p eth0
    ```

3. Para listar opções disponíveis e modos de saída:

    ```bash
    bmon --help
    ```


## 5. (Opcional) Instalar o `bmon` compilando o código-fonte

Esse caminho é útil quando você precisa seguir as instruções do projeto upstream ou quer compilar manualmente a ferramenta.

1. Instalar as dependências de compilação:

    ```bash
    sudo apt install -y \
        git \
        build-essential \
        make \
        pkg-config \
        dh-autoreconf \
        libconfuse-dev \
        libnl-3-dev \
        libnl-route-3-dev \
        libncurses-dev
    ```

2. Clonar o repositório oficial:

    ```bash
    git clone https://github.com/tgraf/bmon.git
    cd bmon
    ```

3. Gerar os arquivos de configuração, compilar e instalar:

    ```bash
    ./autogen.sh
    ./configure
    make
    sudo make install
    ```

4. Testar a instalação:

    ```bash
    bmon
    ```


## 2. Como ver o `bmon` mostrando sua velocidade real

1. Abra dois terminais.

    - **`Terminal 1`**:

    ```bash
    bmon -p wlp2s0
    ```

    ou

    ```bash
    bmon -p enp0s31f6
    ```

    - **`Terminal 2`**: Baixe algo grande:

    ```bash
    wget http://speedtest.tele2.net/100MB.zip
    ```

    ou

    ```bash
    curl -O http://speedtest.tele2.net/100MB.zip
    ```

    Agora o `bmon` vai mostrar algo como:

    ```bash
    RX: 20 MB/s
    ```

## Compatibilidade

- O pacote `bmon` está disponível nos repositórios do `Ubuntu`, inclusive em ambientes baseados em `Jammy`.
- O método via `apt` é o mais indicado para instalações comuns no `Linux Ubuntu`.
- A compilação manual é uma alternativa quando você precisa seguir o _upstream_ ou validar dependências de desenvolvimento.


## Licença

Este repositório inclui o arquivo `LICENSE.txt`.

## Contato e suporte

Para dúvidas ou problemas, consulte o repositório oficial do `bmon` e a documentação da sua versão do `Linux Ubuntu`.


## Referências

[1] OPENAI. ***Instalar o `bmon` no `linux ubuntu` pelo `terminal emulator`***. Disponível em: <https://chatgpt.com/c/69b700b3-b03c-8326-84e4-309f7e577240>. ChatGPT. Acessado em: 15/03/2026.

[2] TGRAF. ***bmon - Bandwidth Monitor***. Disponível em: <https://github.com/tgraf/bmon>. Acessado em: 15/03/2026.

[3] UBUNTU DEVELOPERS. ***Package: bmon***. Disponível no metadado do pacote `apt` do `Ubuntu` e na página do pacote mantida pelo projeto `Linux Ubuntu`. Acessado em: 15/03/2026.

