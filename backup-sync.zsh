#!/bin/zsh
# ======================================================
# Backup-Sync Script für System-Konfigurationen
# 
# Dieses Skript sichert und synchronisiert Konfigurationsdateien in das Git-Repository
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

# Prüfen, ob das Zielverzeichnis existiert
if [[ ! -d "$CONFIG_REPO" ]]; then
  error "Das Konfigurationsverzeichnis $CONFIG_REPO existiert nicht!"
  exit 1
fi

log "Starte Backup-Synchronisierung am $TIMESTAMP"

# ================ Homebrew Pakete sichern ================
log "Sichere Homebrew-Pakete..."

# Prüfe, ob mas installiert ist
if ! command -v mas &>/dev/null; then
  log "Mac App Store CLI (mas) ist nicht installiert."
  log "Mac App Store Apps werden nicht im Brewfile gesichert."
  log "Installiere mas mit 'brew install mas', um Mac App Store Apps zu sichern."
  
  # Erstelle ein Brewfile mit allen installierten Paketen außer VS Code Erweiterungen
  brew bundle dump --force --file="$CONFIG_REPO/Brewfile" --describe --no-vscode
  success "Homebrew-Pakete in Brewfile gesichert."
else
  # Erstelle ein Brewfile mit allen installierten Paketen inkl. Mac App Store Apps
  log "Sichere auch Mac App Store Apps mit mas..."
  
  # Prüfe, ob der Benutzer im Mac App Store angemeldet ist
  # Hinweis: mas account funktioniert auf neueren macOS-Versionen nicht mehr zuverlässig
  # Daher nehmen wir an, dass der Benutzer angemeldet ist, wenn mas installiert ist
  
  # Versuche, eine beliebige Mac App Store App zu prüfen, um zu sehen, ob wir Zugriff haben
  mas_working=0
  mas list &>/dev/null && mas_working=1
  
  if [[ $mas_working -eq 0 ]]; then
    warn "Kann nicht auf Mac App Store Apps zugreifen."
    warn "Du bist möglicherweise nicht im Mac App Store angemeldet oder mas hat keine ausreichenden Berechtigungen."
    log "Mac App Store Apps können bei der Wiederherstellung nur installiert werden, wenn du angemeldet bist."
    log "Melde dich im Mac App Store an und führe das Skript erneut aus, um auch Apps zu sichern."
    
    # Erstelle ein Brewfile mit allen installierten Paketen außer VS Code Erweiterungen
    brew bundle dump --force --file="$CONFIG_REPO/Brewfile" --describe --no-vscode
    
    # Lösche mas-Einträge, falls vorhanden - diese würden bei der Wiederherstellung Fehler verursachen
    if grep -q "^mas " "$CONFIG_REPO/Brewfile"; then
      log "Entferne Mac App Store Einträge aus dem Brewfile, da kein Zugriff besteht..."
      grep -v "^mas " "$CONFIG_REPO/Brewfile" > "$CONFIG_REPO/Brewfile.tmp"
      mv "$CONFIG_REPO/Brewfile.tmp" "$CONFIG_REPO/Brewfile"
    fi
    
    success "Homebrew-Pakete (ohne Mac App Store Apps) in Brewfile gesichert."
  else
    # Erstelle ein vollständiges Brewfile mit Mac App Store Apps
    brew bundle dump --force --file="$CONFIG_REPO/Brewfile" --describe --no-vscode
    success "Homebrew-Pakete und Mac App Store Apps in Brewfile gesichert."
  fi
fi

# ================ Dotfiles sichern ================
log "Sichere Dotfiles..."

# .config Verzeichnis
if [[ -d "$HOME/.config" ]]; then
  mkdir -p "$CONFIG_REPO/config"
  rsync -av --delete "$HOME/.config/" "$CONFIG_REPO/config/" \
    --exclude ".DS_Store" \
    --exclude "*.log" \
    --exclude "*/cache/*" \
    --exclude "*/Cache/*" \
    --exclude "*/tmp/*"
  success ".config Verzeichnis gesichert."
else
  warn ".config Verzeichnis nicht gefunden."
fi

# .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
  cp "$HOME/.zshrc" "$CONFIG_REPO/zshrc"
  success ".zshrc gesichert."
else
  warn ".zshrc nicht gefunden."
fi

# .tmux.conf
if [[ -f "$HOME/.tmux.conf" ]]; then
  cp "$HOME/.tmux.conf" "$CONFIG_REPO/tmux.conf"
  success ".tmux.conf gesichert."
else
  warn ".tmux.conf nicht gefunden."
fi

# .tmux Verzeichnis
if [[ -d "$HOME/.tmux" ]]; then
  mkdir -p "$CONFIG_REPO/tmux"
  rsync -av --delete "$HOME/.tmux/" "$CONFIG_REPO/tmux/" \
    --exclude ".DS_Store" \
    --exclude "*.log" \
    --exclude "plugins/*/node_modules"
  success ".tmux Verzeichnis gesichert."
else
  warn ".tmux Verzeichnis nicht gefunden."
fi

# .vim Verzeichnis
if [[ -d "$HOME/.vim" ]]; then
  mkdir -p "$CONFIG_REPO/vim"
  rsync -av --delete "$HOME/.vim/" "$CONFIG_REPO/vim/" \
    --exclude ".DS_Store" \
    --exclude "*.log" \
    --exclude "*/undo/*" \
    --exclude "*/swap/*" \
    --exclude "*/backup/*" \
    --exclude "*/plugged/*"
  success ".vim Verzeichnis gesichert."
else
  warn ".vim Verzeichnis nicht gefunden."
fi

# ================ App-Einstellungen sichern ================
log "Sichere App-Einstellungen..."

# iTerm2 Einstellungen
log "Sichere iTerm2-Einstellungen..."
if [[ -d "$HOME/.iterm2" ]]; then
  rsync -av --delete "$HOME/.iterm2/" "$APP_SETTINGS/iTerm2/iterm2-folder/"
  success "iTerm2 Verzeichnis gesichert."
else
  warn ".iterm2 Verzeichnis nicht gefunden."
fi

# iTerm2 Plist
if [[ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]]; then
  cp "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$APP_SETTINGS/iTerm2/"
  success "iTerm2 Preferences-Datei gesichert."
else
  warn "iTerm2 Preferences-Datei nicht gefunden."
fi

# Midnight Commander Einstellungen
log "Sichere Midnight Commander-Einstellungen..."
if [[ -d "$HOME/.config/mc" ]]; then
  # MC ist bereits im .config gesichert, erstelle einen Symlink oder Kopie falls gewünscht
  if [[ ! -L "$APP_SETTINGS/MC/mc" ]]; then
    ln -sf "$CONFIG_REPO/config/mc" "$APP_SETTINGS/MC/mc"
  fi
  success "Midnight Commander-Einstellungen gesichert (Symlink zum .config/mc)."
else
  warn "Midnight Commander-Konfiguration nicht gefunden."
fi



# Alfred Einstellungen
log "Sichere Alfred-Einstellungen..."
if [[ -d "$HOME/Library/Application Support/Alfred" ]]; then
  mkdir -p "$APP_SETTINGS/Alfred/alfred-folder"
  rsync -av --delete "$HOME/Library/Application Support/Alfred/" "$APP_SETTINGS/Alfred/alfred-folder/" \
    --exclude ".DS_Store" \
    --exclude "*.log" \
    --exclude "*/cache/*" \
    --exclude "*/Cache/*"
  success "Alfred Anwendungsdaten gesichert."
else
  warn "Alfred Anwendungsdaten nicht gefunden."
fi

# Alfred Preferences
if [[ -f "$HOME/Library/Preferences/com.runningwithcrayons.Alfred.plist" ]]; then
  cp "$HOME/Library/Preferences/com.runningwithcrayons.Alfred.plist" "$APP_SETTINGS/Alfred/"
  success "Alfred Preferences-Datei gesichert."
else
  warn "Alfred Preferences-Datei nicht gefunden."
fi

# ================ System-Einstellungen sichern ================
log "Sichere System-Einstellungen..."

# Erstelle Verzeichnis für System-Einstellungen
mkdir -p "$APP_SETTINGS/SystemPreferences"

# Liste wichtiger Domains für System-Einstellungen
DOMAINS=(
  ".GlobalPreferences"              # Globale Einstellungen
  "com.apple.dock"                 # Dock-Einstellungen
  "com.apple.finder"               # Finder-Einstellungen
  "com.apple.menuextra.clock"      # Menüleisten-Uhr
  "com.apple.screensaver"          # Bildschirmschoner
  "com.apple.screencapture"        # Screenshot-Einstellungen
  "com.apple.AppleMultitouchTrackpad" # Trackpad
  "com.apple.driver.AppleBluetoothMultitouch.trackpad" # Bluetooth Trackpad
  "com.apple.systempreferences"    # System Preferences
  "com.apple.spaces"              # Spaces/Mission Control
  "com.apple.dashboard"           # Dashboard
  "com.apple.spotlight"           # Spotlight
  "com.apple.sound"               # Sound-Einstellungen
  "com.apple.TimeMachine"         # Time Machine
  "com.apple.keyboard"            # Tastatur-Einstellungen
  "com.apple.mouse"               # Maus-Einstellungen
)

# Sichere jede Domain in eine separate Datei
for domain in "${DOMAINS[@]}"; do
  output_file="$APP_SETTINGS/SystemPreferences/${domain//./\_}.plist"
  log "Sichere $domain..."
  if defaults export "$domain" "$output_file" 2>/dev/null; then
    success "$domain Einstellungen gesichert."
  else
    warn "Konnte $domain Einstellungen nicht sichern."
  fi
done
# ================ Git Status ================
log "Status des Konfigurations-Repositories:"
cd "$CONFIG_REPO"
if ! git status &>/dev/null; then
  log "Initialisiere Git-Repository..."
  git init
  git add .
  git commit -m "Initiales Backup: $TIMESTAMP"
  
  # Remote hinzufügen
  log "Füge Remote-Repository hinzu: $REMOTE_URL"
  if git remote add origin "$REMOTE_URL"; then
    success "Remote-Repository erfolgreich hinzugefügt."
  else
    warn "Fehler beim Hinzufügen des Remote-Repositories."
  fi
  
  success "Git-Repository initialisiert und erste Sicherung erstellt."
else
  # Prüfen, ob Remote bereits existiert, sonst hinzufügen
  if ! git remote | grep -q "origin"; then
    log "Füge Remote-Repository hinzu: $REMOTE_URL"
    if git remote add origin "$REMOTE_URL"; then
      success "Remote-Repository erfolgreich hinzugefügt."
    else
      warn "Fehler beim Hinzufügen des Remote-Repositories."
    fi
  else
    # Remote existiert bereits, aktualisiere die URL
    log "Aktualisiere Remote-Repository URL zu: $REMOTE_URL"
    if git remote set-url origin "$REMOTE_URL"; then
      success "Remote-Repository URL erfolgreich aktualisiert."
    else
      warn "Fehler beim Aktualisieren der Remote-Repository URL."
    fi
  fi

  git status -s
  echo
  
  # Automatisch Änderungen sichern
  log "Sichere Änderungen im Repository..."
  git add .
  
  # Prüfen ob es Änderungen gibt, die committet werden müssen
  if git diff --cached --quiet; then
    log "Keine Änderungen zum Sichern gefunden."
  else
    git commit -m "Backup: $TIMESTAMP"
    success "Änderungen erfolgreich gesichert."
    
    # Push falls ein Remote existiert
    if [[ -n "$(git remote)" ]]; then
      log "Übertrage Änderungen zum Remote-Repository..."
      # Mit --set-upstream für den ersten Push
      if git push --set-upstream origin $(git branch --show-current); then
        success "Änderungen erfolgreich zum Remote-Repository übertragen."
      else
        warn "Übertragung zum Remote-Repository fehlgeschlagen."
      fi
    fi
  fi
fi

success "Backup-Synchronisierung abgeschlossen!" 