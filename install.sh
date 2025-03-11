#!/bin/bash

APP_NAME="cursor"  # Nome base do aplicativo
APPIMAGE_NAME="cursor.AppImage"  # Nome do arquivo AppImage esperado
ICON_NAME="cursor.png"  # Nome do ícone esperado
DESKTOP_FILE="cursor.desktop"  # Nome do arquivo .desktop esperado
APP_LAUNCHER_NAME="cursor_launcher.sh"

# Diretórios de instalação
APP_DIR="$HOME/Applications/cursor"
ICON_DEST="/usr/share/icons/hicolor/256x256/apps"
DESKTOP_DEST="/usr/share/applications"

# Criar a pasta Applications no diretório home, se não existir
if [ ! -d "$APP_DIR" ]; then
    echo "Criando diretório $APP_DIR..."
    mkdir -p "$APP_DIR"
fi

# Verificar se o libfuse2 está instalado, caso contrário, instalar
if ! dpkg -s libfuse2 &>/dev/null; then
    echo "O pacote libfuse2 não está instalado. Requer permissões sudo para instalar."
    sudo apt update && sudo apt install -y libfuse2
fi

# Mover o AppImage para a pasta Applications e torná-lo executável
if [ -f "$APPIMAGE_NAME" ]; then
    echo "Movendo $APPIMAGE_NAME para $APP_DIR..."
    rsync -av "$APPIMAGE_NAME" "$APP_DIR"
    chmod +x "$APP_DIR/$APPIMAGE_NAME"
else
    echo "Arquivo $APPIMAGE_NAME não encontrado!"
fi

# Mover o launcher para a pasta Applications e torná-lo executável
if [ -f "$APP_LAUNCHER_NAME" ]; then
    echo "Movendo $APP_LAUNCHER_NAME para $APP_DIR..."
    rsync -av "$APP_LAUNCHER_NAME" "$APP_DIR"
    chmod +x "$APP_DIR/$APP_LAUNCHER_NAME"
else
    echo "Arquivo $APP_LAUNCHER_NAME não encontrado!"
fi

# Mover o ícone para a pasta de ícones do sistema
if [ -f "$ICON_NAME" ]; then
    echo "Movendo ícone para $ICON_DEST..."
    sudo mkdir -p "$ICON_DEST"
    rsync -av "$ICON_NAME" "$ICON_DEST"
else
    echo "Ícone $ICON_NAME não encontrado!"
fi

# Mover o arquivo .desktop para /usr/share/applications/
if [ -f "$DESKTOP_FILE" ]; then
    echo "Movendo arquivo .desktop para $DESKTOP_DEST..."
    sudo install -m 644 "$DESKTOP_FILE" "$DESKTOP_DEST"
else
    echo "Arquivo $DESKTOP_FILE não encontrado!"
fi

# Atualizar cache de ícones e atalhos
echo "Atualizando cache de ícones e atalhos..."
sudo update-desktop-database
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor

sudo ln -sfn "$APP_DIR/$APP_LAUNCHER_NAME" /usr/local/bin/cursor

echo "Instalação concluída!"
