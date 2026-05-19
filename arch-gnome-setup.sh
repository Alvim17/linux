#!/bin/bash
# ==============================================================================
# Arch Linux + GNOME - Script de pós-instalação
# ==============================================================================
#
# Uso:
#   1. Revise o script inteiro antes de rodar
#   2. Comente (com #) seções que não quiser
#   3. Torne executável: chmod +x arch-gnome-setup.sh
#   4. Execute: ./arch-gnome-setup.sh
#
# NÃO rode com sudo. O script chama sudo onde necessário.
# ==============================================================================
 
set -e  # Para na primeira falha
 
# Cores pra output legível
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color
 
log() {
    echo -e "${GREEN}==>${NC} $1"
}

section() {
    echo ""
    echo -e "${YELLOW}==============================================================${NC}"
    echo -e "${YELLOW}  $1${NC}"
    echo -e "${YELLOW}==============================================================${NC}"
}
 
# ==============================================================================
# VERIFICAÇÕES INICIAIS
# ==============================================================================
section "Verificações iniciais"
 
if [ "$EUID" -eq 0 ]; then
    echo "ERRO: Não rode esse script como root/sudo."
    echo "Rode como seu usuário normal. O script chama sudo onde precisa."
    exit 1
fi
 
if ! command -v pacman &>/dev/null; then
    echo "ERRO: pacman não encontrado. Esse script é só pra Arch Linux."
    exit 1
fi
 
log "Atualizando sistema antes de começar..."
sudo pacman -Syu --noconfirm
 
# ==============================================================================
# PACOTES OFICIAIS (pacman)
# ==============================================================================
section "Instalando pacotes oficiais"
 
PACMAN_PACKAGES=(
    aws-cli                        # CLI oficial da AWS para interagir com serviços cloud
    baobab                         # analisador gráfico de uso de espaço em disco do GNOME
    base                           # grupo de pacotes essenciais do sistema Arch
    base-devel                     # ferramentas de compilação (gcc, make, etc.)
    decibels                       # player de áudio simples do GNOME
    discord                        # cliente de chat e voz para comunidades
    docker                         # plataforma de containers para isolar e executar aplicações
    docker-compose                 # orquestra múltiplos containers Docker via arquivo YAML
    dotnet-sdk-6.0                 # SDK do .NET 6 para desenvolvimento C#/F#
    efibootmgr                     # gerencia entradas de boot UEFI
    evince                         # visualizador de documentos (PDF etc.) simples do GNOME
    extension-manager              # gerenciador gráfico de extensões do GNOME Shell
    fastfetch                      # exibe informações do sistema no terminal (substituto do neofetch)
    flameshot                      # ferramenta de captura de tela com anotações
    gdm                            # gerenciador de login gráfico do GNOME
    git                            # sistema de controle de versão distribuído
    gnome-backgrounds              # papéis de parede padrão do GNOME
    gnome-calculator               # calculadora do GNOME
    gnome-calendar                 # agenda/calendário do GNOME
    gnome-characters               # visualizador de caracteres Unicode do GNOME
    gnome-clocks                   # app de relógio, alarme e temporizador do GNOME
    gnome-color-manager            # gerenciamento de perfis de cores de monitores
    gnome-control-center           # painel de configurações do GNOME
    gnome-font-viewer              # visualizador de fontes do GNOME
    gnome-keyring                  # cofre de senhas e chaves criptográficas do GNOME
    gnome-logs                     # visualizador de logs do sistema (journald) do GNOME
    gnome-menus                    # implementação da especificação de menus freedesktop para o GNOME
    gnome-session                  # gerenciador de sessão do GNOME
    gnome-settings-daemon          # daemon que aplica configurações do GNOME em segundo plano
    gnome-shell                    # interface gráfica principal do GNOME
    gnome-system-monitor           # monitor de processos e recursos do sistema do GNOME
    gnome-terminal                 # emulador de terminal do GNOME
    gnome-text-editor              # editor de texto simples do GNOME
    gnome-tweaks                   # ajustes avançados da interface do GNOME
    gnome-weather                  # app de previsão do tempo do GNOME
    gparted                        # editor gráfico de partições de disco
    grilo-plugins                  # plugins de fontes de mídia para apps GNOME (músicas, fotos, etc.)
    #grub-btrfs                     # adiciona snapshots Btrfs ao menu do GRUB
    gst-plugin-pipewire            # plugin GStreamer para integração com PipeWire
    gst-thumbnailers               # gera miniaturas de vídeo/áudio no gerenciador de arquivos
    gvfs                           # sistema de arquivos virtual para o GNOME (monta dispositivos remotos)
    gvfs-afc                       # suporte a dispositivos Apple (iPhone/iPad) no GVFS
    gvfs-dnssd                     # suporte a compartilhamentos DNS-SD/mDNS (Bonjour) no GVFS
    gvfs-goa                       # integração com contas online do GNOME no GVFS
    gvfs-gphoto2                   # suporte a câmeras digitais via GPhoto2 no GVFS
    gvfs-mtp                       # suporte a dispositivos MTP (Android) no GVFS
    gvfs-nfs                       # suporte a compartilhamentos NFS no GVFS
    gvfs-onedrive                  # suporte ao OneDrive da Microsoft no GVFS
    gvfs-smb                       # suporte a compartilhamentos Samba/Windows (SMB) no GVFS
    gvfs-wsdd                      # descoberta de dispositivos Windows via WS-Discovery no GVFS
    htop                           # monitor de processos interativo no terminal
    inotify-tools                  # utilitários para monitorar eventos do sistema de arquivos (inotifywait)
    intellij-idea-community-edition # IDE para Java/Kotlin da JetBrains (versão gratuita)
    libreoffice-fresh              # suite de escritório open source (versão mais recente)
    loupe                          # visualizador de imagens simples do GNOME
    nano                           # editor de texto simples no terminal
    nautilus                       # gerenciador de arquivos gráfico do GNOME
    networkmanager-openvpn         # plugin OpenVPN para o NetworkManager
    os-prober                      # detecta outros sistemas operacionais para adicionar ao GRUB
    python-pip                     # gerenciador de pacotes Python
    showtime                       # player de vídeo simples do GNOME
    snap-pac                       # cria snapshots Btrfs automaticamente antes/depois de operações pacman
    snapshot                       # app de câmera (webcam) do GNOME
    spotify-launcher               # lançador que instala e atualiza o cliente oficial do Spotify
    sushi                          # pré-visualização rápida de arquivos no Nautilus (tecla Espaço)
    tecla                          # visualizador do mapa de teclado do GNOME
    xdg-desktop-portal-gnome       # portal XDG para integração de apps Flatpak/sandbox com o GNOME
    xdg-user-dirs-gtk              # cria e gerencia pastas padrão do usuário (Downloads, Documentos, etc.)
    xdg-utils                      # utilitários para integração de apps com o ambiente desktop
    zip                            # compactador e descompactador de arquivos ZIP
)
 
log "Instalando: ${PACMAN_PACKAGES[*]}"
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
 
# ==============================================================================
# INSTALAR YAY (AUR helper) SE AINDA NÃO TEM
# ==============================================================================
section "Configurando AUR helper (yay)"
 
if ! command -v yay &>/dev/null; then
    log "Instalando yay..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf /tmp/yay
else
    log "yay já está instalado"
fi
 
# ==============================================================================
# PACOTES AUR (yay)
# ==============================================================================
section "Instalando pacotes do AUR"
 
AUR_PACKAGES=(
    claude-code              # CLI oficial da Anthropic para usar o Claude no terminal
    #envycontrol              # gerencia o modo da GPU NVIDIA/Intel (hybrid, integrated, nvidia)
    google-chrome            # navegador web do Google (pacote oficial)
    slack-desktop            # cliente de comunicação corporativa Slack
    visual-studio-code-bin   # editor de código da Microsoft (pacote oficial)
)
 
log "Instalando do AUR: ${AUR_PACKAGES[*]}"
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
 
# ==============================================================================
# FIM
# ==============================================================================
section "Fim"
log "Setup concluído. Faça logout/login para aplicar todas as modificações."