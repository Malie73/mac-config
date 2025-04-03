#!/bin/zsh
# ======================================================
# Wiederherstellungs-Script für System-Konfigurationen
# 
# Dieses Skript stellt gesicherte Konfigurationsdateien und Anwendungen wieder her
# Autor: marko
# ======================================================

# Farbdefinitionen für schönere Ausgaben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Konfiguration
CONFIG_REPO="$HOME/git/config"
APP_SETTINGS="$CONFIG_REPO/App_Settings"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Remote-Repository-Konfiguration
REMOTE_URL="git@github.com:Malie73/mac-config.git"

# Hilfsfunktion für Ausgaben
log() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
  read "response?$1 [y/N] "
  case "$response" in
    [yY][eE][sS]|[yY]) 
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Prüfen, ob das Repository existiert
if [[ ! -d "$CONFIG_REPO" ]]; then
  log "Das Konfigurationsverzeichnis $CONFIG_REPO existiert nicht!"
  
  if confirm "Möchtest du das Repository von GitHub klonen?"; then
    log "Erstelle Zielverzeichnis..."
    mkdir -p "$(dirname "$CONFIG_REPO")"
    
    log "Klone Repository von $REMOTE_URL..."
    if git clone "$REMOTE_URL" "$CONFIG_REPO"; then
      success "Repository erfolgreich geklont."
    else
      error "Fehler beim Klonen des Repositories. Überprüfe die Verbindung und Berechtigungen."
      exit 1
    fi
  else
    error "Abbruch der Wiederherstellung, da das Repository nicht existiert."
    exit 1
  fi
fi

log "Starte Wiederherstellung am $TIMESTAMP"

# ================ Homebrew installieren ================
if ! command -v brew &> /dev/null; then
  log "Homebrew ist nicht installiert. Installiere Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  
  # Füge Homebrew zum PATH hinzu (für M1 Macs)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  
  success "Homebrew installiert."
else
  log "Homebrew ist bereits installiert."
fi

# ================ Homebrew Pakete installieren ================
if confirm "Möchtest du Homebrew-Pakete installieren?"; then
  # Aktualisiere Homebrew
  log "Aktualisiere Homebrew..."
  brew update

  # Installiere Pakete aus dem Brewfile
  if [[ -f "$CONFIG_REPO/Brewfile" ]]; then
    log "Installiere Pakete aus dem Brewfile..."
    
    # Installiere alle Pakete mit einem Befehl
    brew bundle install --file="$CONFIG_REPO/Brewfile" --no-upgrade
    success "Homebrew-Paketinstallation abgeschlossen."
    
    # Hinweis zu VS Code Erweiterungen
    if grep -q "vscode" "$CONFIG_REPO/Brewfile"; then
      warn "VS Code Erweiterungen werden nicht von brew bundle installiert."
      log "Du kannst VS Code Erweiterungen manuell installieren."
    fi
  else
    warn "Kein Brewfile gefunden. Überspringe Homebrew-Paketinstallation."
  fi
fi

# ================ Dotfiles wiederherstellen ================
if confirm "Möchtest du Dotfiles wiederherstellen?"; then
  log "Stelle Dotfiles wieder her..."
  
  # .config Verzeichnis
  if [[ -d "$CONFIG_REPO/config" ]]; then
    log "Stelle .config Verzeichnis wieder her..."
    # Lösche vorhandenes Verzeichnis komplett, wenn es existiert
    if [[ -d "$HOME/.config" ]]; then
      log "Lösche vorhandenes .config Verzeichnis..."
      rm -rf "$HOME/.config"
    fi
    mkdir -p "$HOME/.config"
    rsync -av --delete --force "$CONFIG_REPO/config/" "$HOME/.config/"
    success ".config Verzeichnis wiederhergestellt."
  else
    warn ".config Verzeichnis nicht im Backup gefunden."
  fi
  
  # .zshrc
  if [[ -f "$CONFIG_REPO/zshrc" ]]; then
    log "Stelle .zshrc wieder her..."
    # Lösche vorhandene Datei, wenn sie existiert
    if [[ -f "$HOME/.zshrc" ]]; then
      log "Lösche vorhandene .zshrc Datei..."
      rm -f "$HOME/.zshrc"
    fi
    cp -f "$CONFIG_REPO/zshrc" "$HOME/.zshrc"
    success ".zshrc wiederhergestellt."
  else
    warn ".zshrc nicht im Backup gefunden."
  fi
  
  # .tmux.conf
  if [[ -f "$CONFIG_REPO/tmux.conf" ]]; then
    log "Stelle .tmux.conf wieder her..."
    # Lösche vorhandene Datei, wenn sie existiert
    if [[ -f "$HOME/.tmux.conf" ]]; then
      log "Lösche vorhandene .tmux.conf Datei..."
      rm -f "$HOME/.tmux.conf"
    fi
    cp -f "$CONFIG_REPO/tmux.conf" "$HOME/.tmux.conf"
    success ".tmux.conf wiederhergestellt."
  else
    warn ".tmux.conf nicht im Backup gefunden."
  fi
  
  # .tmux Verzeichnis
  if [[ -d "$CONFIG_REPO/tmux" ]]; then
    log "Stelle .tmux Verzeichnis wieder her..."
    # Lösche vorhandenes Verzeichnis komplett, wenn es existiert
    if [[ -d "$HOME/.tmux" ]]; then
      log "Lösche vorhandenes .tmux Verzeichnis..."
      rm -rf "$HOME/.tmux"
    fi
    mkdir -p "$HOME/.tmux"
    rsync -av --delete --force "$CONFIG_REPO/tmux/" "$HOME/.tmux/"
    success ".tmux Verzeichnis wiederhergestellt."
  else
    warn ".tmux Verzeichnis nicht im Backup gefunden."
  fi
  
  # .vim Verzeichnis
  if [[ -d "$CONFIG_REPO/vim" ]]; then
    log "Stelle .vim Verzeichnis wieder her..."
    # Lösche vorhandenes Verzeichnis komplett, wenn es existiert
    if [[ -d "$HOME/.vim" ]]; then
      log "Lösche vorhandenes .vim Verzeichnis..."
      rm -rf "$HOME/.vim"
    fi
    mkdir -p "$HOME/.vim"
    rsync -av --delete --force "$CONFIG_REPO/vim/" "$HOME/.vim/"
    success ".vim Verzeichnis wiederhergestellt."
  else
    warn ".vim Verzeichnis nicht im Backup gefunden."
  fi
fi

# ================ App-Einstellungen wiederherstellen ================
if confirm "Möchtest du App-Einstellungen wiederherstellen?"; then
  # iTerm2 Einstellungen
  if [[ -d "$APP_SETTINGS/iTerm2/iterm2-folder" ]]; then
    log "Stelle iTerm2 Einstellungen wieder her..."
    # Lösche vorhandenes Verzeichnis komplett, wenn es existiert
    if [[ -d "$HOME/.iterm2" ]]; then
      log "Lösche vorhandenes .iterm2 Verzeichnis..."
      rm -rf "$HOME/.iterm2"
    fi
    mkdir -p "$HOME/.iterm2"
    rsync -av --delete --force "$APP_SETTINGS/iTerm2/iterm2-folder/" "$HOME/.iterm2/"
    success "iTerm2 Verzeichnis wiederhergestellt."
  else
    warn "iTerm2 Einstellungen nicht im Backup gefunden."
  fi
  
  # iTerm2 Plist
  if [[ -f "$APP_SETTINGS/iTerm2/com.googlecode.iterm2.plist" ]]; then
    log "Stelle iTerm2 Preferences wieder her..."
    # Schließe iTerm2, falls es läuft
    osascript -e 'tell application "iTerm" to quit' &>/dev/null || true
    sleep 1
    
    # Lösche vorhandene Datei, wenn sie existiert
    if [[ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]]; then
      log "Lösche vorhandene iTerm2 Preferences Datei..."
      rm -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
    fi
    cp -f "$APP_SETTINGS/iTerm2/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/"
    # Lade Einstellungen neu (nur für macOS)
    defaults read com.googlecode.iterm2 &>/dev/null
    
    success "iTerm2 Preferences wiederhergestellt."
  else
    warn "iTerm2 Preferences nicht im Backup gefunden."
  fi
  
  # Alfred Einstellungen
  if [[ -d "$APP_SETTINGS/Alfred" ]]; then
    log "Stelle Alfred Einstellungen wieder her..."
    
    # Schließe Alfred, falls es läuft
    osascript -e 'tell application "Alfred" to quit' &>/dev/null || true
    sleep 1
    
    # Einstellungen wiederherstellen
    if [[ -d "$APP_SETTINGS/Alfred/alfred-folder" ]]; then
      log "Stelle Alfred Anwendungsdaten wieder her..."
      # Lösche vorhandenes Verzeichnis komplett, wenn es existiert
      if [[ -d "$HOME/Library/Application Support/Alfred" ]]; then
        log "Lösche vorhandenes Alfred Verzeichnis..."
        rm -rf "$HOME/Library/Application Support/Alfred"
      fi
      mkdir -p "$HOME/Library/Application Support/Alfred"
      rsync -av --delete --force "$APP_SETTINGS/Alfred/alfred-folder/" "$HOME/Library/Application Support/Alfred/"
      success "Alfred Anwendungsdaten wiederhergestellt."
    fi
    
    # Preferences wiederherstellen
    if [[ -f "$APP_SETTINGS/Alfred/com.runningwithcrayons.Alfred.plist" ]]; then
      log "Stelle Alfred Preferences wieder her..."
      # Lösche vorhandene Datei, wenn sie existiert
      if [[ -f "$HOME/Library/Preferences/com.runningwithcrayons.Alfred.plist" ]]; then
        log "Lösche vorhandene Alfred Preferences Datei..."
        rm -f "$HOME/Library/Preferences/com.runningwithcrayons.Alfred.plist"
      fi
      cp -f "$APP_SETTINGS/Alfred/com.runningwithcrayons.Alfred.plist" "$HOME/Library/Preferences/"
      # Lade Einstellungen neu
      defaults read com.runningwithcrayons.Alfred &>/dev/null
      success "Alfred Preferences wiederhergestellt."
    fi
  else
    warn "Alfred Einstellungen nicht im Backup gefunden."
  fi
  
  # Midnight Commander Skins
  if [[ -f "$CONFIG_REPO/config/mc/skins/julia256-fix.ini" ]]; then
    log "Stelle Midnight Commander Skin wieder her..."
    
    # Finde das MC-Skins-Verzeichnis von Homebrew
    MC_SKINS_DIR=$(find /opt/homebrew/Cellar/midnight-commander -type d -name "skins" 2>/dev/null | head -n 1)
    
    if [[ -n "$MC_SKINS_DIR" ]]; then
      # Kopiere das Skin
      cp -f "$CONFIG_REPO/config/mc/skins/julia256-fix.ini" "$MC_SKINS_DIR/julia256-fix.ini"
      success "Midnight Commander Skin wiederhergestellt."
    else
      warn "Midnight Commander Skins-Verzeichnis nicht gefunden. Überspringe Skin-Wiederherstellung."
    fi
  else
    warn "Midnight Commander Skin nicht im Backup gefunden."
  fi
  
  # Midnight Commander Einstellungen wurden bereits mit .config wiederhergestellt
  if [[ -d "$HOME/.config/mc" ]]; then
    success "Midnight Commander Einstellungen wurden mit .config wiederhergestellt."
  else
    warn "Midnight Commander Einstellungen konnten nicht wiederhergestellt werden."
  fi
fi
# ================ System-Einstellungen wiederherstellen ================
if confirm "Möchtest du System-Einstellungen wiederherstellen?"; then
  log "Stelle System-Einstellungen wieder her..."
  
  if [[ -d "$APP_SETTINGS/SystemPreferences" ]]; then
    # Liste der gesicherten Domains
    for plist in "$APP_SETTINGS/SystemPreferences"/*.plist; do
      if [[ -f "$plist" ]]; then
        domain=$(basename "$plist" .plist)
        domain=${domain//_/.}  # Ersetze _ wieder durch .
        
        log "Stelle $domain Einstellungen wieder her..."
        if defaults import "$domain" "$plist" 2>/dev/null; then
          success "$domain Einstellungen wiederhergestellt."
        else
          warn "Konnte $domain Einstellungen nicht wiederherstellen."
        fi
      fi
    done
    
    # Lade die Änderungen neu
    log "Lade Änderungen neu..."
    killall Finder Dock SystemUIServer 2>/dev/null
    success "System-Einstellungen wiederhergestellt."
  else
    warn "Keine gesicherten System-Einstellungen gefunden."
  fi
fi
# ================ Abschluss ================
success "Wiederherstellung abgeschlossen!"
log "Hinweis: Einige Änderungen werden erst nach einem Neustart der betroffenen Anwendungen oder des Systems wirksam."
log "Du solltest deinen Computer neu starten, um alle Änderungen zu aktivieren."

if confirm "Möchtest du jetzt neu starten?"; then
  log "Starte Computer neu..."
  sudo shutdown -r now
else
  log "Kein Neustart. Bitte starte deinen Computer später manuell neu."
fi 