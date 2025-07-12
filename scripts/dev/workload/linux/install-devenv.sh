#!/usr/bin/env bash
# =========================================
#  💻 Developer Environment Installer
# =========================================
# SYNOPSIS:
#   Installs all components for a complete developer environment on Linux or macOS.
# USAGE:
#   ./install-devenv.sh [--rider] [--podman] [--help]
# DESCRIPTION:
#   By default, installs Visual Studio Code and Docker Desktop.
#   Use --rider to install JetBrains Rider.
#   Use --podman to install Podman and Podman Desktop instead of Docker Desktop.
# EXAMPLES:
#   ./install-devenv.sh
#   ./install-devenv.sh --rider
#   ./install-devenv.sh --podman
#   ./install-devenv.sh --rider --podman
#   ./install-devenv.sh --help
# =========================================

# === COLORS & EMOJI ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
CHECK='✅'
CROSS='❌'
INFO='ℹ️'
WARN='⚠️'
HAMMER='🔧'
LAPTOP='💻'

set -e

show_help() {
cat << EOF
${CYAN}${LAPTOP}  DEVELOPER ENVIRONMENT INSTALLATION  ${NC}

${INFO} ${BLUE}USAGE:${NC}
    ./install-devenv.sh [--rider] [--podman]

${INFO} ${BLUE}DESCRIPTION:${NC}
    Installs all components for a complete developer environment on Linux or macOS.
    By default, installs Visual Studio Code and Docker Desktop.
    Use --rider to install JetBrains Rider.
    Use --podman to install Podman and Podman Desktop instead of Docker Desktop.

${INFO} ${BLUE}PARAMETERS:${NC}
    --rider     Installs JetBrains Rider (optional).
    --podman    Installs Podman and Podman Desktop instead of Docker Desktop (optional).
    --help      Show this help message.

${INFO} ${BLUE}EXAMPLES:${NC}
    ./install-devenv.sh
    ./install-devenv.sh --rider
    ./install-devenv.sh --podman
    ./install-devenv.sh --rider --podman
EOF
}

# Header colorato
printf "${CYAN}${LAPTOP}  Avvio installazione ambiente di sviluppo...${NC}\n"

# Check for sudo/root
if [[ "$EUID" -ne 0 ]]; then
  printf "${RED}${CROSS} Devi eseguire questo script come root o con sudo.${NC}\n"
  exit 1
fi

# Parse arguments
RIDER=0
PODMAN=0

for arg in "$@"; do
  case $arg in
    --rider)
      RIDER=1
      shift
      ;;
    --podman)
      PODMAN=1
      shift
      ;;
    --help)
      printf "${CYAN}${INFO} Showing help...${NC}\n"
      show_help
      exit 0
      ;;
    *)
      printf "${YELLOW}${WARN} Unknown argument: $arg${NC}\n"
      ;;
  esac
done

# Detect OS
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
  PLATFORM="mac"
elif [[ "$OS" == "Linux" ]]; then
  PLATFORM="linux"
else
  printf "${RED}${CROSS} OS non supportato: $OS${NC}\n"
  exit 1
fi

install_package_linux() {
  PKG="$1"
  printf "${BLUE}${HAMMER} Installazione $PKG su Linux...${NC}\n"
  if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y "$PKG"
  elif command -v dnf &>/dev/null; then
    dnf install -y "$PKG"
  elif command -v yum &>/dev/null; then
    yum install -y "$PKG"
  elif command -v pacman &>/dev/null; then
    pacman -Sy --noconfirm "$PKG"
  else
    printf "${RED}${CROSS} Nessun package manager supportato trovato.${NC}\n"
    exit 1
  fi
}

install_package_mac() {
  PKG="$1"
  printf "${BLUE}${HAMMER} Installazione $PKG su macOS...${NC}\n"
  if ! command -v brew &>/dev/null; then
    printf "${YELLOW}${WARN} Homebrew non trovato. Installazione Homebrew...${NC}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install --cask "$PKG" || brew install "$PKG"
}

install_app() {
  APP="$1"
  if [[ "$PLATFORM" == "linux" ]]; then
    install_package_linux "$APP"
  elif [[ "$PLATFORM" == "mac" ]]; then
    install_package_mac "$APP"
  fi
  printf "${GREEN}${CHECK} $APP installato!${NC}\n"
}

# Install core tools
install_app git
install_app code # Visual Studio Code
install_app powershell

# Azure CLI
if [[ "$PLATFORM" == "linux" ]]; then
  if ! command -v az &>/dev/null; then
    printf "${BLUE}${HAMMER} Installazione Azure CLI...${NC}\n"
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    printf "${GREEN}${CHECK} Azure CLI installato!${NC}\n"
  else
    printf "${GREEN}${CHECK} Azure CLI già presente.${NC}\n"
  fi
elif [[ "$PLATFORM" == "mac" ]]; then
  install_app azure-cli
fi

# Azure Functions Core Tools
if [[ "$PLATFORM" == "linux" ]]; then
  if ! command -v func &>/dev/null; then
    printf "${BLUE}${HAMMER} Installazione Azure Functions Core Tools...${NC}\n"
    npm install -g azure-functions-core-tools@4 --unsafe-perm true
    printf "${GREEN}${CHECK} Azure Functions Core Tools installato!${NC}\n"
  else
    printf "${GREEN}${CHECK} Azure Functions Core Tools già presente.${NC}\n"
  fi
elif [[ "$PLATFORM" == "mac" ]]; then
  brew tap azure/functions
  brew install azure-functions-core-tools@4
fi

# Git Extensions (Linux only, via snap if available)
if [[ "$PLATFORM" == "linux" ]]; then
  if command -v snap &>/dev/null; then
    snap install git-extensions
  fi
fi

# Terminal
if [[ "$PLATFORM" == "mac" ]]; then
  # iTerm2 as alternative terminal
  install_app iterm2
fi

# Editor/IDE
if [[ "$RIDER" -eq 1 ]]; then
  if [[ "$PLATFORM" == "linux" ]]; then
    snap install rider --classic || true
  elif [[ "$PLATFORM" == "mac" ]]; then
    install_app rider
  fi
fi

# Container engine
if [[ "$PODMAN" -eq 1 ]]; then
  install_app podman
  if [[ "$PLATFORM" == "mac" ]]; then
    install_app podman-desktop
  elif [[ "$PLATFORM" == "linux" ]]; then
    if command -v snap &>/dev/null; then
      snap install podman-desktop --classic
    fi
  fi
else
  if [[ "$PLATFORM" == "mac" ]]; then
    install_app docker
  elif [[ "$PLATFORM" == "linux" ]]; then
    install_package_linux docker.io
    systemctl enable --now docker || true
  fi
fi

# Install .NET SDK (latest LTS)
if [[ "$PLATFORM" == "linux" ]]; then
  if ! command -v dotnet &>/dev/null; then
    printf "${BLUE}${HAMMER} Installazione .NET SDK...${NC}\n"
    if command -v apt-get &>/dev/null; then
      wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
      dpkg -i packages-microsoft-prod.deb
      rm packages-microsoft-prod.deb
      apt-get update
      apt-get install -y apt-transport-https
      apt-get update
      apt-get install -y dotnet-sdk-8.0
    elif command -v dnf &>/dev/null; then
      dnf install -y dotnet-sdk-8.0
    elif command -v yum &>/dev/null; then
      yum install -y dotnet-sdk-8.0
    elif command -v pacman &>/dev/null; then
      pacman -Sy --noconfirm dotnet-sdk
    fi
    printf "${GREEN}${CHECK} .NET SDK installato!${NC}\n"
  else
    printf "${GREEN}${CHECK} .NET SDK già presente.${NC}\n"
  fi
elif [[ "$PLATFORM" == "mac" ]]; then
  install_app dotnet-sdk
fi

# Configure VS Code extensions for .NET development
if command -v code &>/dev/null; then
    code --install-extension ms-dotnettools.csharp --force
    code --install-extension ms-dotnettools.csdevkit --force
    code --install-extension ms-dotnettools.vscode-dotnet-pack --force
    code --install-extension ms-azuretools.vscode-azurefunctions --force
    code --install-extension ms-azuretools.vscode-azurecli --force
    code --install-extension ms-vscode.azure-account --force
    code --install-extension ms-vscode.powershell --force
    code --install-extension ms-vscode-remote.remote-wsl --force
    code --install-extension ms-vscode.remote-containers --force
    code --install-extension ms-vscode.docker --force
    code --install-extension eamodio.gitlens --force
    code --install-extension github.vscode-pull-request-github --force
    code --install-extension ms-vsliveshare.vsliveshare --force
    code --install-extension ms-vscode.test-adapter-converter --force
    code --install-extension jmrog.vscode-nuget-package-manager --force
    code --install-extension ms-python.python --force
    code --install-extension ms-toolsai.jupyter --force
fi

printf "${GREEN}✅ Installazione ambiente di sviluppo completata.${NC}\n"
