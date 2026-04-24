# Como configurar/instalar/usar o `Find in this folder` no fundo branco da pasta do `Thunar` no `Linux Ubuntu`

## Resumo

Neste documento estão contidos os principais comandos e configurações para corrigir a ação `Find in this folder` no `Thunar`, fazendo com que ela também apareça ao clicar com o botão direito no fundo branco da pasta no `Linux Ubuntu`.

## _Abstract_

_This document contains the main commands and settings to fix the `Find in this folder` action in `Thunar`, making it appear when right-clicking on the blank area of the current folder in `Linux Ubuntu`._


## Descrição [2]

### `shell`

Um `shell` é uma interface de linha de comando que permite aos usuários interagir com um sistema operacional por meio de comandos de texto. Ele atua como uma camada intermediária entre o usuário e o núcleo do sistema, facilitando a execução de programas, manipulação de arquivos e configuração do sistema. Os exemplos incluem o `Bash`, `Zsh` e `PowerShell`.

### `thunar`

`Thunar` é um gerenciador de arquivos leve e eficiente projetado para ambientes de desktop baseados no `Xfce`. Ele suporta ações personalizadas no menu de contexto, permitindo adicionar comandos que aparecem conforme o tipo de seleção e o contexto da pasta atual.

### `catfish`

`Catfish` é uma ferramenta gráfica de busca de arquivos do ecossistema `Xfce`. Neste ajuste, ele é usado como comando da ação personalizada `Find in this folder`, limitando a pesquisa ao diretório atual aberto no `Thunar`.


## 1. Como configurar/instalar/usar o `Find in this folder` no fundo branco da pasta do `Thunar` no `Linux Ubuntu` [1]

Para configurar/instalar/usar o `Find in this folder` no fundo branco da pasta do `Thunar` no `Linux Ubuntu`, você pode seguir estes passos:

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


## 1.1 Código completo para configurar/instalar/usar

Para configurar/instalar/usar o `Find in this folder` no `Linux Ubuntu` sem precisar digitar linha por linha, você pode seguir estas etapas:

1. Abrir o `Terminal Emulator`. Você pode fazer isso pressionando:

    ```bash
    Ctrl + Alt + T
    ```

2. Digite o seguinte comando e pressione `Enter`:

    ```bash
    sudo apt install -y catfish
    mkdir -p "$HOME/.config/Thunar"
    python3 - <<'PY'
    from pathlib import Path
    import xml.etree.ElementTree as ET

    uca_path = Path.home() / ".config/Thunar/uca.xml"
    if uca_path.exists():
        root = ET.fromstring(uca_path.read_text(encoding="utf-8"))
    else:
        root = ET.Element("actions")

    target_name = "Find in this folder"
    target_command = 'catfish --path="%f"'

    def next_unique_id(actions_root):
        existing = {action.findtext("unique-id", "") for action in actions_root.findall("action")}
        for index in range(1, 1000):
            candidate = f"{index}-{index}"
            if candidate not in existing:
                return candidate
        return "1000-1000"

    selected_action = None
    for action in root.findall("action"):
        if action.findtext("name", "") == target_name or action.findtext("command", "") == target_command:
            selected_action = action
            break

    unique_id = selected_action.findtext("unique-id", "") if selected_action is not None else next_unique_id(root)

    if selected_action is None:
        selected_action = ET.SubElement(root, "action")
    else:
        for child in list(selected_action):
            selected_action.remove(child)

    for tag, value in (
        ("icon", "system-search"),
        ("name", target_name),
        ("unique-id", unique_id),
        ("command", target_command),
        ("description", "Search for files in the current folder"),
        ("patterns", "*"),
    ):
        element = ET.SubElement(selected_action, tag)
        element.text = value

    ET.SubElement(selected_action, "startup-notify")
    ET.SubElement(selected_action, "directories")

    ET.indent(root, space="\t")
    xml_content = ET.tostring(root, encoding="unicode")
    uca_path.write_text('<?xml version="1.0" encoding="UTF-8"?>\n' + xml_content, encoding="utf-8")
    PY
    thunar -q 2>/dev/null || true
    ```


## 2. Como corrigir manualmente no `Thunar`

Se você preferir ajustar pela interface gráfica, configure a ação personalizada abaixo em `Edit` > `Configure custom actions...`:

1. Clique em `+` para criar uma nova ação.

2. Preencha os campos principais com os seguintes valores:

    **Nome:** `Find in this folder`

    **Descrição:** `Search for files in the current folder`

    **Comando:** `catfish --path="%f"`

    **Ícone:** `system-search`

3. Na aba de condições de aparência, marque apenas `Diretórios`.

4. Salve a ação personalizada e feche o `Thunar`.

5. Abra o `Thunar` novamente e clique com o botão direito no fundo branco de uma pasta para validar se `Find in this folder` passou a aparecer no menu de contexto.


## Referências

[1] OPENAI. **Corrigir o `find in this folder` do `thunar` no fundo branco da pasta**. Disponível em: <https://chatgpt.com/g/g-p-6980caf949648191ad6acfcdbe590f9e-instalar/c/69eab10f-0054-83e9-b421-4d5456cae9fc>. ChatGPT. Acessado em: 23/04/2026.

[2] XFCE DEVELOPMENT TEAM. **Thunar - custom actions**. Disponível em: <https://docs.xfce.org/xfce/thunar/custom-actions>. Acessado em: 23/04/2026.

[3] XFCE DEVELOPMENT TEAM. **Catfish - introduction**. Disponível em: <https://docs.xfce.org/apps/catfish/introduction>. Acessado em: 23/04/2026.

